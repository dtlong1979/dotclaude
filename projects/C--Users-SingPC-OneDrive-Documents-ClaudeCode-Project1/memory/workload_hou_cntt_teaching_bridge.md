---
name: workload_hou_cntt_teaching_bridge
description: "Liên thông lịch giảng + lớp CVHT từ hou-cntt sang workload (cache theo kỳ); Tầng 1 (panel) đã deploy, Tầng 2 (gợi ý nhật ký) đang làm"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-20T18:16:25.745Z
---

Liên thông **nhiệm vụ giảng dạy** hou-cntt → workload cho nhóm giảng viên (tổ bộ môn), vì lịch giảng + số lớp cố vấn học tập cũng là nhiệm vụ cần đối chiếu với công việc được giao. Xem [[workload_redesign]], [[app_workload_bridge]], [[hou_cntt_lich_giang_import]], [[fithouone_coordination_hub]].

**Kiến trúc CHỐT (user chốt 2026-08-21):** KHÔNG đọc trực tiếp DB bên kia (workload=SQLite, hou-cntt=PostgreSQL — 2 engine/2 container, không có bảng chung). Dữ liệu giảng dạy/CVHT **tĩnh cả học kỳ** → **cache sang bảng riêng bên workload, đồng bộ THƯA** (nút thủ công + sau này bắn tín hiệu khi TKB đổi + cron ngày tùy chọn); đọc lúc mở trang là LOCAL.

**Khóa nối SẠCH (không cần ánh xạ):** workload `users.ma_cb` == hou-cntt `lich_hoc.ma_gv` == `co_van_lop.username_cv` (đều dạng CH0xxx). 26/26 cán bộ workload đã có ma_cb.

**Nguồn dữ liệu hou-cntt:** `lich_hoc` (thu/ca_hoc/tu_tiet-den_tiet/tu_tuan-den_tuan/tu_ngay-den_ngay/ma_phong/ma_gv/ma_lop_tc) JOIN `lop_tin_chi` (ten_hp/ma_hp/hoc_ky/nam_hoc); `co_van_lop` (username_cv→lop). thu: 2=T2..8=CN.

**Đã build + DEPLOY (Tầng 1):**
- **hou-cntt** `backend/app/api/routes/internal.py`: endpoint `POST /api/internal/gv-nhiem-vu` (bảo vệ `_check_svc` = service token dùng chung X-Workload-Service-Token), nhận `{ma_cbs:[...]}` → trả `{lich_giang:{ma_cb:[...]}, cvht:{ma_cb:[...]}}`. Additive/read-only, student portal không ảnh hưởng. **LƯU Ý: server `/home/fitadm/code/fithouone/hou-cntt` ĐI TRƯỚC bản local D:\dev\hou-cntt** (server có thêm endpoint `/audit` audit-central mà local chưa có) → sửa file phải KÉO bản server về, chèn, đẩy lại; KHÔNG scp đè bản local. Deploy: `docker compose --env-file .env up -d --build --no-deps hou-cntt-api`.
- **workload** `db.py`: 3 bảng `gv_lich_giang`, `gv_cvht`, `gv_sync_meta`. `app.py`: `_fetch_gv_nhiem_vu()`, `sync_gv_nhiem_vu(conn)` (xóa+nạp toàn bộ, upsert meta), `gv_nhiem_vu_of(conn,ma_cb)` (đọc lịch ĐANG HIỆU LỰC: hôm nay trong [tu_ngay,den_ngay], gom theo thứ + list CVHT + last_synced), route `POST /gv/dong-bo` (admin), panel gắn ở home `/`. `hom_nay.html`: section "Nhiệm vụ giảng dạy" (nút "Đồng bộ từ hệ đào tạo" cho admin). `style.css`: .gv-day/.gv-slot/.gv-cvht/.gv-synced (xanh brand, dark-aware).
- **Verify prod:** sync thật kéo **106 buổi giảng + 69 lớp CVHT** cho 26 cán bộ. VD CH0162 (Lê Hữu Dũng): 8 buổi hiệu lực + CVHT 2210A06..., có slot "T2 Tối tiết 9-12 Lập trình Web nâng cao P32" — khớp buổi **Tối** vừa thêm.

**CÒN LÀM (Tầng 2 — user đã duyệt "Tầng 1+2 luôn"):** ở `/log`, buổi có tiết dạy → tự gợi ý mục *"Giảng dạy: <ten_hp> lớp <ma_lop_tc>"*, chạm 1 nút xác nhận đã dạy → ghi nhật ký giờ theo số tiết (khớp buổi Tối). **Tầng 3 (sau, chưa duyệt chi tiết):** quy số tiết + số lớp CVHT thành định mức nhiệm vụ để đối chiếu công việc/đánh giá.

**Backup:** hou-cntt `internal.py.bak_gv_*`, workload `app.py.bak_gv_* / db.py.bak_gv_*`.
