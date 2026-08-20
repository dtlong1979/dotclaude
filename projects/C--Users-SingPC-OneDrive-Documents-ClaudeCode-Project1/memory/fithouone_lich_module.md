---
name: fithouone_lich_module
description: "Module Lịch âm/dương + nghỉ lễ FithouOne: bảng lich_ngay nhập từ file tĩnh 2015-2035, cache RAM tra O(1)"
metadata:
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-20T05:51:09.626Z
---

**Lịch âm/dương + nghỉ lễ** cho FithouOne. Chốt kiến trúc: **dữ liệu TĨNH** (file "Lịch Vạn Sự" user tự sinh) → KHÔNG master-Postgres+API-sync; mỗi app nhập CÙNG file vào DB mình + **nạp cache RAM tra O(1)**. Đổi âm↔dương KHÔNG dùng công thức runtime — tra bảng đã nhập (công thức chỉ để SINH file).

- **File nguồn**: `C:\Users\SingPC\OneDrive\Documents\Lich_Van_Su_2015-2035.xlsx` — 2 sheet (Dương lịch / Âm lịch), sheet Dương 22 cột: `Ngày dương(DD/MM/YYYY)·Thứ·Ngày/Tháng/Năm ÂL·Nhuận·Tên tháng ÂL·Can chi ngày/tháng/năm·Con giáp·Tiết khí·Đánh giá·Điểm·Sao ngày·Trực·Nhị thập bát tú·Giờ hoàng đạo·Thần sát tốt/xấu·Nghỉ lễ (chính thức)·Ngày lễ/kỷ niệm`. 7306 ngày (2015-01-01→2035-01-01), 205 ngày tháng nhuận, **201 ngày nghỉ lễ**. Nhãn nghỉ lễ: Tết DL, 30 Tết, Mùng 1/2/3 Tết, Giỗ Tổ, 30/4, 1/5, 2/9, Ngày Văn hóa.
- **workload ĐÃ LÀM (2026-08-20)**: bảng `lich_ngay` (SQLite, PK `ngay` YYYY-MM-DD, 22 cột) trong `db.py` SCHEMA. Đã nhập 7306 dòng. `app.py`: `_lich_load()` cache dict + `lich_of(ngay)` + global + **API `GET /api/lich?d=YYYY-MM-DD`** (auth, trả am_ngay/am_thang/nhuan/thu/nghi_le/cuoi_tuan). Màn Tạo việc: JS `initDuePicker.showLich()` fetch API khi đổi Hạn → hiện **âm lịch + cảnh báo NGHỈ LỄ (đỏ)/cuối tuần**. Cache lazy 1 lần/tiến trình (workload -w 1); import đè thì restart container để nạp lại.
- **Tái nhập**: parser `wl/src/` (openpyxl→JSON `lich.json`) + `import_lich.py` (`INSERT OR REPLACE`, docker cp vào container chạy). Backup `db.py.bak_lich_* app.py.bak_lich_*`.
- **CÒN LẠI (phối hợp)**: hou-cntt (Postgres, bảng cùng shape) + mobile (Dart) nhập CÙNG file khi cần; nghỉ bù công bố hằng năm → user sinh lại file, import đè. Xem [[fithouone_coordination_hub]] DECISIONS.
