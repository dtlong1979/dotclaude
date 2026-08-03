---
name: fithouone-test-accounts
description: Danh sách tài khoản/dữ liệu TEST trên server pilot hou-cntt cần XÓA trước khi go-live
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-27T13:33:42.602Z
---

Tài khoản test tạo trong quá trình dựng pilot hou-cntt (DB `hou_cntt` trên sscfit). **XÓA hết trước khi go-live.** Mật khẩu tất cả: `Test@2026`.

- Vai trò web-admin test: `admin_test`, `giaovu_test`, `vanphong_test` (đều vai_tro=GV + admin_role tương ứng), `sv_test` (SV, mssv 21A100100036), `gv_test` (GV).
- **`giangvien_test`** — vai trò web `giangvien` (mới), gán ma_cb=CH0159 (mượn 3 lớp CVHT của chính Đinh Tuấn Long: 2110A05, 2110A05KS, 2510A01 = 68 SV) để test scoping. Xóa cả bản ghi này.
- 3 SV lớp 2110A01 (username=MSSV): 21A100100002, 21A100100005, 21A100100025.

Vai trò `giangvien` (bổ sung 2026-07-27): GV web chỉ thấy DS SV lớp mình CVHT, gửi TB + giao nhiệm vụ tới lớp mình dạy/CVHT, chat. Chặn 403 mọi chức năng quản trị khác. Code ở [[fithouone_deploy]] — deps.require_full_admin, admin.py `_gv_scope`, nhiem_vu.py `_gv_own`. KHÔNG đổi hành vi admin/giáo vụ/văn phòng cũ.
