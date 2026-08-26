---
name: hou_cntt_cas_password
description: "Đổi/quên mật khẩu HOU CAS qua cổng hou-cntt; ĐÃ verify tài khoản thật + BẬT (CAS_PWD_ENABLED=true) + UI app/web-admin/workload live"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-18T10:11:40.203Z
---

Làm chức năng đổi/quên MK cho tài khoản **HOU CAS** (trước đây bị ẩn + chỉ hướng dẫn liên hệ). Liên quan [[password_cas_vs_local]].

**API HOU (IT cấp qua Postman CORE.postman_collection):**
- Auth: HOU CORE OAuth2 `core.hou.edu.vn/mdm/rest/v2/oauth/token` (Basic client:secret — SECRET THẬT nhưng YẾU).
- MK: CAS `cas.hou.edu.vn/cassync` — `POST /users/check-password`, `POST /users/change-password` (body `{uniid,password,isAuthenticated:true}`), `GET /private-api/users/register-reset-password?email=`, `GET /private-api/users/reset-password?email=&code=`.
- **CAS MỞ TOANG: không giới hạn IP, không rate-limit, không chính sách MK, change-password chỉ tin cờ isAuthenticated** → ai gọi được là đổi MK bất kỳ. IT xác nhận không sửa CAS → siết ở APP. Khuyến nghị IT chặn IP cassync chỉ cho server (lớp chặn mạnh nhất, CHƯA làm).

**Đã làm (deploy, CỜ `cas_pwd_enabled=False` MẶC ĐỊNH TẮT):**
- `core/config.py`: cas_pwd_enabled, cas_sync_url, pwd_gateway_token.
- `services/cas_pwd.py`: 4 hàm gọi CAS + **chính sách MK MẠNH** (≥10 + đủ 4 nhóm + chặn MK phổ biến + khác MK cũ, thống nhất workload) + rate-limit in-memory (`rate_ok`/`rate_clear`).
- `api/routes/pwd.py` (đăng ký main.py, prefix /api): `POST /me/change-password` (xác thực MK cũ qua **CORE** — đường đã chạy — rồi đặt MK mới qua CAS), `POST /auth/forgot/start` (email→mssv), `POST /auth/forgot/verify`. Audit qua logging (chưa có bảng audit ở hou-cntt).
- `models.py`: map `SinhVien.email` (cột có sẵn schema.sql, ORM trước không map).

**ĐÃ VERIFY bằng tài khoản thật dtlong2 (2026-07-31) + BẬT + UI live:**
- Định dạng CAS thật: check→`{"status":"SUCCESS","message":"MATCH"|"NOT_MATCH"}`; change→`SUCCESS`+"Updated password for <uniid>."; register-reset→`FOUND`/không tìm thấy; verify-reset→`VALID`/`Code không hợp lệ`/`Code bị quá hạn`. Parser cas_pwd.py khớp đúng (verify-reset: từ chối message lỗi đã biết, còn lại=hợp lệ). Đổi MK e2e qua endpoint mình OK (sai MK cũ→400, MK yếu→400), khôi phục về Fithou@123.
- **BẬT**: CAS_PWD_ENABLED="true" + PWD_GATEWAY_TOKEN (mặc định fithou-pwd-gw-2026) ở env hou-cntt-api + workload (compose).
- **UI**: app (`features/auth/password_screens.dart` — ChangePasswordScreen ở menu tài khoản 2 shell; ForgotPasswordScreen ở login); web-admin (app.js modal openChangePw/openForgotPw, header + link login, ?v=8); workload (POST /doi-mat-khau: is_sso→`_cas_pwd_call('/change')` qua cổng; template change_password.html cho CAS thấy form). Website Directus không phải CAS → giữ OTP riêng.
- Gateway nội bộ pwd.py: `/internal/pwd/change` (nhận EMAIL→resolve uniid), `/forgot/start|verify` (header X-Pwd-Gateway-Token). Public: `/me/change-password`(JWT), `/auth/forgot/start|verify`.
- 26 cán bộ email nạp vào `cas_canbo.email` (từ workload, map ma_cb→tk_cas qua canbo_cas_map). `_resolve_uniid`: sinh_vien.email→mssv, cas_canbo.email→tk_cas.
- **BỎ tự-nhập username** (không an toàn: change-password CAS tách rời mã reset → có thể chiếm tài khoản). Email lạ→liên hệ htsv.
- **CÒN NỢ**: quên MK trên workload web cho CAS (dùng OTP, khác luồng link local) — tạm cán bộ dùng app/web-admin. IT chặn IP cassync (lỗ gốc).

**ADMIN RESET MK CAS cho SV (2026-08-18):** màn "Quản lý Tài khoản" (web-admin) TÁCH 2 nhóm — 🔑 **Tài khoản tự tạo** (local) phía trên + 🔗 **HOU CAS** phía dưới (mỗi nhóm 1 bảng, CAS có phân trang `accCas`); `_accRow()` render chung. sso giờ nhận CẢ `!core` LẪN `!cas`. Thêm endpoint `POST /admin/accounts/{username}/reset-cas` (`_only_admin`, audit `taikhoan.reset_cas`): chỉ TK **CAS + vai_tro=SV** (username=MSSV=uniid), gọi `cas_pwd.cas_change_password`, gated bởi `cas_pwd_enabled` (đang TRUE). Nút "🔑 Đặt lại MK CAS" hiện trong khung Sửa của TK CAS-SV (admin). app.js?v=115. Phân bố prod: 1142 CAS-SV + 24 CAS-GV (!core), 12 local. (KHÔNG test reset thật — đổi MK CAS thật của SV.)

**Chặn/nợ TRƯỚC khi bật cờ (đã xử lý):**
- **Tài khoản TEST của IT** để verify: check-password trả gì; change-password format thành công; **cách CAS ràng buộc email↔uniid** ở reset (nếu không ràng buộc → lỗ chiếm tài khoản).
- **Email nguồn tin cậy:** chỉ SV có (`sinh_vien.email`, nếu đã populate). **CÁN BỘ/GV KHÔNG có email** ở hou-cntt (CORE không trả email) → quên MK cán bộ hiện CHẶN, hướng dẫn htsv.cntt@hou.edu.vn. Có thể bắc cầu uniid→ma_cb(cas_canbo)→workload.users.email sau.
- **UI chưa nối**: màn đổi MK (app + web-admin), màn quên MK (login). workload/website vẫn reset LOCAL riêng (chỉ auth_source=local); nối CAS qua cổng hou-cntt (pwd_gateway_token) sau.
- Chính sách MK sẵn có: workload security.py `validate_password` (≥10 + 4 nhóm, không chặn common). website reset chỉ ≥10 ký tự.
