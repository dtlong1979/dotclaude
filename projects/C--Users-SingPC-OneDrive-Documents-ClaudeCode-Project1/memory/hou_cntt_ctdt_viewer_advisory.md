---
name: hou-cntt-ctdt-viewer-advisory
description: "hou-cntt: màn Xem CTĐT (tham khảo chuyên ngành) + cảnh báo TƯ VẤN (thời gian TN, đăng ký TC)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-11T13:10:29.929Z
---

**XEM CTĐT** (`ctdt_view.py` + web `openCTDT`/app `ctdt_screen.dart`): SV/GV xem toàn bộ môn của 1 chuyên ngành/hệ chia theo khối, đánh dấu môn đã tích lũy (đối khớp mềm), mỗi môn hiện TC · điểm chữ (xanh biển #0277BD) · thang4 (teal #00897B) · thang10 (cam #E65100), list dọc căn cột. Khối chuyên ngành: track SE/MT/NS liệt kê môn định hướng; gói NONE hiện "chọn 1 trong 2" theo `ctdt_hoc_phan.nhom_tu_chon`. **Lọc nút theo khóa:** ctdt 3 (khóa ≤2020, KS-141TC) chỉ thấy 4 nút KS-141; ctdt 1/2 (khóa 21+) thấy 6 nút CTĐT 2022. `OPTIONS` 10 nút gom 3 nhóm. Endpoint: `/admin/students/{mssv}/ctdt?ctdt_id=&cn=` + `/me/ctdt` (tùy chọn param → `default_for`). Web nút "📖 Xem CTĐT" ở chi tiết SV; app nút "Xem CTĐT" ở lưới Tiện ích dashboard.

**CẢNH BÁO TƯ VẤN** (`warnings.py`, `muc='tu_van'` — hiển thị KHÁC cảnh báo quy chế nền vàng/đỏ: **nền xanh #E3F2FD, icon 🎓**): (1) **đăng ký TC/kỳ ngoài [2/3, 3/2] chuẩn** — chuẩn 15 TC/kỳ (CTĐT 2022) → cảnh báo nếu <10 hoặc >23; MIỄN cảnh báo "quá ít" nếu TC còn lại < mức tối thiểu (vd chỉ còn khóa luận). (2) **không kịp tốt nghiệp**: thời gian tối đa CN2022=6 năm, KS2022=7.5, CTĐT2019=8; tối đa 50 TC/năm → cảnh báo nếu `TC còn lại > số năm còn lại × 50` hoặc đã quá hạn. Có ở cả `warnings_for` (chi tiết SV, có `chi_tiet`) lẫn `all_flagged` (list, tiền tố 🎓). LƯU Ý: cảnh báo "quá hạn còn N TC" là THẬT (vd SV thiếu môn chuyên ngành bắt buộc trượt) — không phải nhiễu; phần tên "Lý luận" đã alias trong `mon_khop`. Màn Cảnh báo web: mỗi dòng bấm được → mở chi tiết SV. App: `_WarningCard` style theo `muc`. Liên quan [[hou_cntt_ren_luyen_warnings]] [[hou_cntt_block_credit_model]].
