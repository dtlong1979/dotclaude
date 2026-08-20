---
name: workload_hou_cntt_teaching_bridge
description: "Liên thông lịch giảng + lớp CVHT từ hou-cntt sang workload (cache theo kỳ); Tầng 1 (panel) + Tầng 2 (tự ghi nhật ký, báo nghỉ) đã deploy; Tầng 3 (định mức) chưa làm"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-20T18:29:20.143Z
---

Liên thông **nhiệm vụ giảng dạy** hou-cntt → workload cho nhóm giảng viên (tổ bộ môn), vì lịch giảng + số lớp cố vấn học tập cũng là nhiệm vụ cần đối chiếu với công việc được giao. Xem [[workload_redesign]], [[app_workload_bridge]], [[hou_cntt_lich_giang_import]], [[fithouone_coordination_hub]].

**Kiến trúc CHỐT (user chốt 2026-08-21):** KHÔNG đọc trực tiếp DB bên kia (workload=SQLite, hou-cntt=PostgreSQL — 2 engine/2 container, không có bảng chung). Dữ liệu giảng dạy/CVHT **tĩnh cả học kỳ** → **cache sang bảng riêng bên workload, đồng bộ THƯA** (nút thủ công + sau này bắn tín hiệu khi TKB đổi + cron ngày tùy chọn); đọc lúc mở trang là LOCAL.

**Khóa nối SẠCH (không cần ánh xạ):** workload `users.ma_cb` == hou-cntt `lich_hoc.ma_gv` == `co_van_lop.username_cv` (đều dạng CH0xxx). 26/26 cán bộ workload đã có ma_cb.

**Nguồn dữ liệu hou-cntt:** `lich_hoc` (thu/ca_hoc/tu_tiet-den_tiet/tu_tuan-den_tuan/tu_ngay-den_ngay/ma_phong/ma_gv/ma_lop_tc) JOIN `lop_tin_chi` (ten_hp/ma_hp/hoc_ky/nam_hoc); `co_van_lop` (username_cv→lop). thu: 2=T2..8=CN.

**Đã build + DEPLOY (Tầng 1):**
- **hou-cntt** `backend/app/api/routes/internal.py`: endpoint `POST /api/internal/gv-nhiem-vu` (bảo vệ `_check_svc` = service token dùng chung X-Workload-Service-Token), nhận `{ma_cbs:[...]}` → trả `{lich_giang:{ma_cb:[...]}, cvht:{ma_cb:[...]}}`. Additive/read-only, student portal không ảnh hưởng. **LƯU Ý: server `/home/fitadm/code/fithouone/hou-cntt` ĐI TRƯỚC bản local D:\dev\hou-cntt** (server có thêm endpoint `/audit` audit-central mà local chưa có) → sửa file phải KÉO bản server về, chèn, đẩy lại; KHÔNG scp đè bản local. Deploy: `docker compose --env-file .env up -d --build --no-deps hou-cntt-api`.
- **workload** `db.py`: 3 bảng `gv_lich_giang`, `gv_cvht`, `gv_sync_meta`. `app.py`: `_fetch_gv_nhiem_vu()`, `sync_gv_nhiem_vu(conn)` (xóa+nạp toàn bộ, upsert meta), `gv_nhiem_vu_of(conn,ma_cb)` (đọc lịch ĐANG HIỆU LỰC: hôm nay trong [tu_ngay,den_ngay], gom theo thứ + list CVHT + last_synced), route `POST /gv/dong-bo` (admin), panel gắn ở home `/`. `hom_nay.html`: section "Nhiệm vụ giảng dạy" (nút "Đồng bộ từ hệ đào tạo" cho admin). `style.css`: .gv-day/.gv-slot/.gv-cvht/.gv-synced (xanh brand, dark-aware).
- **Verify prod:** sync thật kéo **106 buổi giảng + 69 lớp CVHT** cho 26 cán bộ. VD CH0162 (Lê Hữu Dũng): 8 buổi hiệu lực + CVHT 2210A06..., có slot "T2 Tối tiết 9-12 Lập trình Web nâng cao P32" — khớp buổi **Tối** vừa thêm.

**Đã build + DEPLOY (Tầng 2):** user chốt lại mô hình — **KHÔNG có nút "Đã dạy"**: có lịch + không báo nghỉ = đương nhiên đã dạy; **thời lượng LUÔN cả buổi** (nhiều lớp cùng buổi vẫn chỉ 1 "cả buổi", không cộng quá 4h/buổi). Chỉ thao tác **Báo nghỉ / Hủy báo nghỉ** từng lớp.
- `db.py`: thêm cột `gv_lich_giang.tuan_kieu` (migration `_addcol`) + bảng `gv_nghi(ma_cb,ngay,ma_lop_tc,buoi,ly_do)`.
- hou-cntt endpoint bổ sung trả `tuan_kieu` (deploy lần 2).
- `app.py`: `teaching_on(conn,ma_cb,day)` (khớp thứ=isoweekday+1, trong [tu_ngay,den_ngay], tuần chẵn/lẻ, trừ báo nghỉ) + `materialize_teaching()` (mỗi buổi có ≥1 lớp đã dạy → 1 dòng activity_logs source='giang_day' muc_tg='ca_buoi'; buổi nghỉ hết → xóa) + route `POST /log/gv-nghi` (action nghi|day). `/log` render: materialize khi ngày còn sửa được + bỏ qua source giang_day ở vòng touch-picker.
- `log.html`: mục "Giảng dạy hôm nay" (gom theo buổi, tag "Đã dạy · cả buổi" / "Đã báo nghỉ", nút Báo nghỉ). `style.css`: .gv-jrow/.gv-nghi/.gv-tag-day...
- **Verify prod:** CH0162 ngày T5 20/08 buổi Sáng tự thành "Giảng dạy: Lập trình Web nâng cao · cả buổi (4h)"; báo nghỉ → mất; hủy → khôi phục. ca_hoc Sáng/Chiều/Tối→sang/chieu/toi. Backup `*.bak_gv2_*`.

**LƯU Ý:** materialize chạy khi GV MỞ /log ngày đó (idempotent). GV không mở /log thì ngày đó chưa có dòng giảng dạy — phủ đầy đủ để tính định mức là việc của **Tầng 3**.

**CÒN LÀM (Tầng 3 — chưa duyệt chi tiết):** quy số tiết + số lớp CVHT thành ĐỊNH MỨC nhiệm vụ để đối chiếu công việc/đánh giá; + sweep tự materialize giảng dạy cho mọi ngày (không phụ thuộc GV mở /log); + ngòi nổ tự đồng bộ khi giáo vụ sửa TKB bên hou-cntt.

**Backup:** hou-cntt `internal.py.bak_gv_*`, workload `app.py.bak_gv_* / db.py.bak_gv_*`.
