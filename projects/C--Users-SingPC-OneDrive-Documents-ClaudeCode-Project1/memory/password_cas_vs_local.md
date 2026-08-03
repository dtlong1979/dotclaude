---
name: password-cas-vs-local
description: "Đổi/quên mật khẩu: tách tài khoản HOU CAS (SSO) vs local back-safe ở các phân hệ FithouOne"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-30T03:31:26.168Z
---

Vấn đề: hầu hết tài khoản đăng nhập bằng **HOU CAS/CORE** (mật khẩu do Trường quản lý tập trung) — chỉ vài tài khoản **back-safe** (hệ thống tự sinh) mới tự quản mật khẩu. Nên chức năng đổi/quên mật khẩu chỉ được áp cho tài khoản local. Xem [[workload-app]], [[hou-cntt-paths]], [[app-workload-bridge]].

**Hiện trạng từng phân hệ (rà 2026-07-30):**
- **hou-cntt web-admin** (`web-admin/app.js`): ĐÃ ĐÚNG — cờ `sso` (= `tai_khoan.mat_khau_hash=='!core'`), chỉ cho reset/xóa MK tài khoản "Tự tạo", có tag HOU CAS/Tự tạo.
- **hou-cntt app + backend**: KHÔNG có chức năng đổi/quên MK → không hỏng (SV/cán bộ nhập MK CAS xác thực qua CORE).
- **website (Fithou/Directus)**: tài khoản Directus **tự quản** (email + OTP, KHÔNG phải CAS) → đổi/quên MK vẫn đúng, **giữ nguyên** (user chốt).
- **workload**: TRƯỚC ĐÂY sai — `/doi-mat-khau` + `/quen-mat-khau` tác động lên `password_hash` nội bộ mà cán bộ CAS không dùng (login local-first → trượt → rơi sang CORE). ĐÃ SỬA (dưới).

**Giải pháp workload (đã build + verify TestClient):**
- Thêm cột `users.auth_source` ('core'|'local', mặc định 'core'; SCHEMA + migration `_addcol` trong `db.py init_db`).
- **Tự nhận diện khi đăng nhập** (`/login` trong app.py): xác thực qua CORE→set 'core', qua mật khẩu nội bộ→set 'local' (đặt TRƯỚC redirect must_change_pw).
- Helper `is_sso(user)` (thiếu cột → coi 'core' cho an toàn). Hằng `SSO_SUPPORT_EMAIL='htsv.cntt@hou.edu.vn'` (chưa có link cổng CAS — user chờ phản hồi CNTT xem tích hợp được không; tạm hiện hướng dẫn liên hệ email này).
- Chặn `/doi-mat-khau` (GET hiện thông báo CAS thay form, POST redirect không đổi) + `/quen-mat-khau` (chỉ tạo token reset khi `not is_sso`, vẫn trả thông điệp chung tránh dò email) cho tài khoản 'core'. Ẩn menu "Đổi mật khẩu" trong `base.html` khi `auth_source=='core'`. `forgot.html`/`change_password.html` có ghi chú CAS.
- **Admin chỉnh tay**: route `/users/toggle-auth-source` + nút trong `templates/users.html` (menu ⋯) + tag "HOU CAS"/"Nội bộ"; chuyển sang 'local' thì set must_change_pw=1. Nút gửi lại MK (✉) ẩn với tài khoản 'core'.
- Verify: login local→auth_source='local'+form hiện; giả 'core'→form ẩn+thông báo CAS; POST đổi MK 'core' bị chặn (hash không đổi). Migration cột chạy khi init_db.

**Gói chung đợt deploy** với [[app-workload-bridge]] (workload API + push notification). Chưa deploy.
