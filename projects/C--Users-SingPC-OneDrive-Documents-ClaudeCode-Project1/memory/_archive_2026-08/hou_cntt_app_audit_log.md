---
name: hou-cntt-app-audit-log
description: "Nhật ký thao tác app hou-cntt (ai đăng nhập & làm gì) — backend + web-admin tab, chỉ admin"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-09T17:22:09.201Z
---

Tính năng **Nhật ký thao tác app** (2026-08-10) ở hou-cntt: ghi **đăng nhập** (thành công/thất bại, kèm thiết bị) + **mọi thao tác thay đổi** (POST/PUT/PATCH/DELETE); bỏ GET cho đỡ nhiễu.

- **Bảng** `nhat_ky_app` (Postgres hou_cntt): thoi_diem(timestamptz), username, ho_ten, vai_tro, ip, thiet_bi, method, path, hanh_dong, ket_qua. Model `NhatKyApp` trong models.py. ⚠️ **BẪY:** tạo bảng phải để **OWNER = `hou_cntt`** (user app kết nối) — nếu tạo bằng `fit_hou` sẽ "permission denied" thầm lặng. Sửa: `ALTER TABLE ... OWNER TO hou_cntt; ALTER SEQUENCE ..._id_seq OWNER TO hou_cntt`.
- **Ghi:** service `app/services/audit.py` (`ghi()`, `client_ip()` đọc X-Forwarded-For, `nhan()` nhãn hành động). Login ghi trong `auth.py` (có thiết bị). Thao tác khác ghi ở **middleware `_nhat_ky_app`** trong `main.py` (giải mã Bearer token lấy username+role).
- **Xem:** endpoint `GET /api/admin/nhat-ky` (dependencies=`_only_admin` — CHỈ admin), lọc q/username/method/ngay/only_login, trả giờ VN (`AT TIME ZONE 'Asia/Ho_Chi_Minh'`). Web-admin: tab **"Nhật ký"** (trong ADMIN_ONLY_TABS, `pageNhatKy`), app.js?v=19.
- IP thật hiển thị được là nhờ Zentyal đã bỏ SNAT port-forward 443/80 (xem [[fithou_server_infra]]).

Deploy: sửa local `D:\dev\hou-cntt\{backend,web-admin}` (khớp server) → scp lên `/home/fitadm/code/fithouone/hou-cntt/` → rebuild `hou-cntt-api` (phục vụ cả API lẫn web-admin tĩnh ở `/admin`). Liên quan [[hou_cntt_app]] [[fithouone_deploy]].
