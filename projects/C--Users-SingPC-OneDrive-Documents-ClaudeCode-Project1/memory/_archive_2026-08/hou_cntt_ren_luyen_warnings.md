---
name: hou_cntt_ren_luyen_warnings
description: "hou-cntt thêm điểm rèn luyện + cảnh báo học vụ chi tiết (môn nợ, ĐRL<50); đã deploy+nhập 6284 ô"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-05T08:45:58.887Z
---

Mở rộng cảnh báo học vụ hou-cntt (app + backend + web-admin). Liên quan [[hou_cntt_app]].

**Điểm rèn luyện (ĐRL):** bảng mới `diem_ren_luyen(mssv, ky, diem)` (db/25_diem_ren_luyen.sql, UNIQUE(mssv,ky)). Nguồn file HOU `grdDanhSachSinhVien` (D:\Downloads\RL\RL\18..25.xlsx = khóa 2018..2025), header ngang `Mã sinh viên | Họ và tên | Ngày sinh | Tên lớp | Kỳ thứ 1..N | Tổng điểm | Xếp loại | Kỷ luật`; cột "Kỳ thứ N" → ky=N, thang 100. Ô rỗng=bỏ, ô '0'=điểm 0 thật (tính vào TB).
- Import TÍCH HỢP vào khung importer: format `RENLUYEN` trong `services/importer/renluyen.py` + đăng ký REGISTRY (formats.py). Hiện ở phần Import admin (chọn định dạng → preview/apply/log). Đã nhập 8 file = 6284 ô, 1 SV khóa 19 bỏ (FK).
- Thang xếp loại (services/ren_luyen.py `xep_loai`): ≥90 Xuất sắc, ≥80 Tốt, ≥65 Khá, ≥50 Trung bình, ≥35 Yếu, <35 Kém.

**Cảnh báo (services/warnings.py):** thêm 2 loại — REN_LUYEN (kỳ <50, kèm chi_tiet từng kỳ), REN_LUYEN_TB (trung bình <50 = "cao", nguy cơ không đủ ĐK tốt nghiệp). NO_MON giờ kèm `chi_tiet` = danh sách môn nợ (ma_hp/ten_hp/so_tc). `warnings_for` trả dict có `chi_tiet`; `all_flagged` thêm ĐRL vào canh_bao strings.
- **MON_CHUA_QUA (thêm 2026-08-05, app.js?v=18):** NO_MON chỉ báo khi ≥3 môn (NO_MON_MIN) → SV đủ ĐK tốt nghiệp mà còn 1–2 môn F thì KHÔNG cảnh báo ở chi tiết. Sửa `warnings_for`: nếu 1–2 môn trượt → cảnh báo mức **"thap"** loại `MON_CHUA_QUA` ("Còn N môn chưa qua (điểm F/trượt)", kèm danh sách); ≥3 vẫn là NO_MON. CHỈ ở `warnings_for` (chi tiết SV), KHÔNG đụng `all_flagged` (danh sách — tránh flag hàng loạt). Web-admin: muc 'thap' = nền vàng #fff3cd chữ #8a6d00; bảng "Điểm chi tiết" tô nền đỏ nhạt + "Trượt (F)" đậm cho dòng dat=FALSE. Verify prod: 22A1001D0035 (đủ 100%, 1 F "Kỹ thuật đồ hoạ và thực tại ảo") nay có cảnh báo. Lưu ý: cảnh báo MON_CHUA_QUA ở `quy_che_tn.xet` (bảng thống kê tốt nghiệp) là CHỖ KHÁC, ≥1 môn — hai nơi độc lập.

**API:** SV `/me/ren-luyen`; GV/web-admin qua `hoc_tap.chi_tiet` thêm `canh_bao_full` (giữ `canh_bao` chuỗi cho tương thích) + `ren_luyen`.

**UI (đã deploy web-admin, app CHỜ build):** app dashboard SV `_WarningCard` (bung chi tiết) + `_RenLuyenCard`; `gv_student_detail` `_warnTiles`+`_renLuyenBox`; web-admin app.js chi tiết SV (cảnh báo bung + chip ĐRL màu). REN_LUYEN_MIN=50.

Áp migration: `docker compose exec -T postgres psql -U hou_cntt -d hou_cntt < db/25_...sql`. Import lại: copy xlsx vào container rồi `importer.apply(db, data, fn, "RENLUYEN", ...)`.
