---
name: fithou-audit-central
description: "Kho nhật ký (audit) TẬP TRUNG dùng chung cho cả FithouOne — DB `audit` riêng, danh mục thao tác, ghi bất đồng bộ"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-17T06:13:41.526Z
---

Hợp nhất nhật ký thao tác 3 phân hệ FithouOne về **1 kho PostgreSQL riêng** thay vì mỗi phân hệ một chỗ (hou-cntt `nhat_ky_app`, workload SQLite `system_logs`, website `fithou_admin_logs`). Quyết định vì "3 phân hệ nhưng thực chất 1 hệ thống" + chịu ~2000 SV (POST dồn lúc mở đăng ký) — xem [[fithou_server_infra]], [[hou_cntt_app_audit_log]].

**Kho:** cùng instance `fithouone-postgres-1`, **DB `audit`** riêng (pool tách, không giành connection nghiệp vụ). Bảng `audit_log(id, ts, phan_he, action_code, action_label, actor_id, actor_name, actor_role, target, ip, status, meta JSONB)`. Role **`audit_writer` chỉ INSERT/SELECT** (log bất biến, không sửa/xoá). `AUDIT_DATABASE_URL` trong `fithouone-deploy/.env`, truyền vào service `hou-cntt-api` qua compose.

**3 nguyên tắc (theo yêu cầu user):** (1) chỉ log thao tác trong DANH MỤC (bước CHỐT/xác nhận), bỏ bước tạm/giả lập + GET + polling; (2) hiển thị `action_label` (nhãn thao tác VN) không phải câu lệnh — method/path chỉ để trong `meta`; (3) ghi **bất đồng bộ** (hàng đợi + thread nền batch) để không chặn event loop (hou-cntt gunicorn -w 1) lúc cao điểm; hàng đợi đầy thì bỏ bớt (fire-and-forget).

**Code:** `hou-cntt/backend/app/services/audit_central.py` (engine + queue + worker + `_CATALOG` 42 regex thao tác + `log()`/`log_request()`/`match()`). Middleware `main.py::_nhat_ky_app` **dual-write**: giữ `nhat_ky_app` cũ + gọi `audit_central.log_request`. Login ghi tường minh trong `auth.py`. Workload: `app.py::_audit_central()` đẩy fire-and-forget qua `_houcntt_internal("/audit",...)` → endpoint mới `hou-cntt internal.py POST /api/internal/audit` (guard `_check_svc` service-token), phan_he='workload'.

**Không audit:** từng tin nhắn/chat (chỉ thu-hồi + broadcast); logout SV (token client-side). **Điểm danh:** log per-SV checkin + `diemdanh.gv` per buổi (cần meta thời gian — Phase 5).

**Điểm danh chi tiết:** handler `attendance.py::checkin` + `giang_vien.py::gv_set/gv_qr/gv_batch` gắn `request.state.audit_meta`/`audit_target` (lớp/mssv/loại/phương thức); middleware nhặt vào `meta` qua `audit_central.log_request(extra_meta, target_override)`. Chi tiết đầy đủ vẫn ở bảng nghiệp vụ `DiemDanh` (có timestamp).

**Trạng thái (2026-08-17):** Phase 1-5 XONG & verified prod. Màn `/admin/nhat-ky` (web-admin app.js v104) đọc kho trung tâm + lọc phan_he. Đã di trú 1958 lịch sử ĐĂNG NHẬP (action_code auth.login/_fail, meta.legacy=true); KHÔNG kéo blanket-noise cũ sang (giữ nguyên trong `nhat_ky_app` như lưu trữ). **CÒN NỢ:** tắt dual-write cũ (bỏ `audit.ghi` blanket trong middleware `main.py::_nhat_ky_app`) — CHỜ user xác nhận màn mới ổn rồi mới tắt (để rollback). hou-cntt & workload sửa TRỰC TIẾP trên server (không git). Backup `*.bak_audit_*`, `*.bak_dd_*` trên server.
