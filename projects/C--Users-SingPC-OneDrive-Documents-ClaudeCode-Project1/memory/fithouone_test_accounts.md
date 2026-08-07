---
name: fithouone-test-accounts
description: Danh sách tài khoản/dữ liệu TEST trên server pilot hou-cntt cần XÓA trước khi go-live
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-07T13:33:56.113Z
---

Tài khoản test tạo trong quá trình dựng pilot hou-cntt (DB `hou_cntt` trên sscfit). **XÓA hết trước khi go-live.** Mật khẩu tất cả: `Test@2026`.

**TÀI KHOẢN PLAY REVIEW (2026-08-06) — GIỮ LẠI, KHÔNG xóa như đám trên:** để điền mục "App access" của Google Play (reviewer đăng nhập). Tạo trong `hou_cntt.tai_khoan`, hash pbkdf2_sha256, mật khẩu chung `Fithou#Review2026`:
- `sv.review.play` — vai_tro SV, gắn sinh_vien `TEST000001` (Cử nhân 2022, lớp TEST-REVIEW, ghi_chu "KHONG XOA").
- `gv.review.play` — vai_tro GV. **2026-08-07:** gán `ma_cb='GVTEST'` để liên kết chat/thông báo với SV test. Kèm các bản ghi TEST cần XÓA trước go-live: `can_bo` ma_cb=`GVTEST`; `lop_tin_chi` ma_lop_tc=`TEST-LOPTC` (ma_gv=GVTEST); `dang_ky_hoc_ky` (TEST000001 ↔ TEST-LOPTC); `lich_hoc` của TEST-LOPTC; hội thoại `hoi_thoai.ma_tham_chieu='TEST-LOPTC'` (id 281) + thành viên. Sinh nhóm chat bằng `chat.sync_lop_tc(SessionLocal())` trong container `fithouone-hou-cntt-api-1`. GV test KHÔNG bật workload (giữ GV thường; app tự ẩn nút Công việc, không bị chặn).
Đã verify login qua API nội bộ: HTTP 200, đúng vai_tro, có token. Tạo bằng script python trong container `docker exec ... fithouone-hou-cntt-api-1 python -` dùng `app.core.security.hash_password`. Package name app: `vn.edu.hou.fit.fithouone`.

- Vai trò web-admin test: `admin_test`, `giaovu_test`, `vanphong_test` (đều vai_tro=GV + admin_role tương ứng), `sv_test` (SV, mssv 21A100100036), `gv_test` (GV).
- **`giangvien_test`** — vai trò web `giangvien` (mới), gán ma_cb=CH0159 (mượn 3 lớp CVHT của chính Đinh Tuấn Long: 2110A05, 2110A05KS, 2510A01 = 68 SV) để test scoping. Xóa cả bản ghi này.
- 3 SV lớp 2110A01 (username=MSSV): 21A100100002, 21A100100005, 21A100100025.

Vai trò `giangvien` (bổ sung 2026-07-27): GV web chỉ thấy DS SV lớp mình CVHT, gửi TB + giao nhiệm vụ tới lớp mình dạy/CVHT, chat. Chặn 403 mọi chức năng quản trị khác. Code ở [[fithouone_deploy]] — deps.require_full_admin, admin.py `_gv_scope`, nhiem_vu.py `_gv_own`. KHÔNG đổi hành vi admin/giáo vụ/văn phòng cũ.
