---
name: hou_cntt_lich_giang_import
description: "HOU-CNTT nhập TKB + nối GV: chỉ sheet Full, GV theo buổi (LT/TH), bảng mã cas_canbo"
metadata: 
  node_type: memory
  type: project
  originSessionId: 098983c5-111d-4c37-8f4b-0192c1ed7235
  modified: 2026-08-10T06:36:25.838Z
---

Nhập Thời khóa biểu (importer `schedule.py`, format LICH) + lịch giảng của GV ở hou-cntt (D:\dev\hou-cntt, deploy `~/code/fithouone/fithouone-deploy`, container `fithouone-hou-cntt-api-1`, DB `fithouone-postgres-1`).

**Quy tắc nhập TKB (đã chốt):** chỉ lấy sheet tên chứa "Full" (HKI_Full); BỎ lớp không có GV (`Ma_giao_vien` = #N/A/rỗng); khử trùng buổi; **đối chiếu TÊN để sửa mã GV sai** (mã không có trong `can_bo` nhưng tên "Giáo viên" — hàng tiêu đề phụ, row 3 — khớp DUY NHẤT 1 cán bộ thì dùng mã đó); tự thêm GV thiếu vào `can_bo`; DỌN lớp cùng kỳ không thuộc Full (xóa buổi; xóa lớp nếu 0 đăng ký). Kết quả kỳ I 2026-2027: 110 lớp / 132 buổi.

**Lớp dạy ghép (lý thuyết + thực hành = 2 GV khác nhau):** đã thêm cột `lich_hoc.ma_gv` (GV theo TỪNG BUỔI). `lop_tin_chi.ma_gv` chỉ là GV đầu tiên (nhãn/fallback). `diem_danh_gv.lich_giang/lop_cua_gv/_so_huu` + dashboard `dac_biet` (giang_vien.py) đã sửa để nhận GV theo buổi qua `COALESCE(h.ma_gv, l.ma_gv)` / `EXISTS(lich_hoc.ma_gv=cb)`. Mỗi GV chỉ thấy buổi mình dạy.

**Nối cán bộ khi đăng nhập:** bảng `cas_canbo(tk_cas→ma_cb, ho_ten, don_vi)` là "bảng mã ánh xạ" (nạp từ HR `Danh sách cán bộ...xls`, cột TKCAS). `core_auth._lookup_canbo` tra bảng này. ĐÃ vá `cas.py` callback: khi GV đăng nhập CAS-ticket lần đầu (username không phải mã SV dạng số) → tạo TK vai trò GV + gán `ma_cb` từ cas_canbo (trước đây để trống → lịch giảng rỗng). Không tạo sẵn tai_khoan; để CAS tự sinh khi đăng nhập lần đầu. Chỉ 26 cán bộ dùng workload; còn lại đăng nhập app đều vào vai trò GV.

**Mã bị gán nhầm trong file TKB 2026.08:** CH0148 = Trương Tiến Tùng (đúng TG5712, CAS tttung); TG5663 = Bùi Anh Tuấn (đúng KG0528, CAS batuan). Trần Tiến Dũng: (B)=CH0170/ttdung, (C)=CH0411/ttdung2. 10 GV thỉnh giảng ngoài HR (Ngô Quốc Tạo, Đào Thanh Tĩnh…) không có tài khoản CAS — ADMIN vẫn xem được lịch.

**Hiển thị THEO TUẦN:** `lich_giang` (GV) và `/me/schedule` (SV) chỉ trả buổi THỰC SỰ diễn ra trong tuần chứa tham số `ngay` (mặc định tuần hiện tại) — buổi chưa tới/đã hết ngày học thì ẩn. Điều kiện `_TRONG_TUAN`: `date_trunc('week', ngay)::date + (thu-2)` phải nằm trong `[tu_ngay, den_ngay]`. Endpoint nhận `?ngay=YYYY-MM-DD` để điều hướng tuần; trả thêm `tuan{tu_ngay,den_ngay}`. Frontend Flutter (`mobile/`, màn `schedule_screen.dart` dùng `/me/schedule`) chưa có nút chuyển tuần — backend default tuần hiện tại đã đủ ẩn buổi chưa tới; muốn chuyển tuần phải build lại APK.

**Import KHÔNG PHÁ / không trùng (lần import sau):** đồng bộ `lich_hoc` theo khóa tự nhiên `(thu, ca_hoc, tu_tiet, ma_gv)` — chỉ CẬP NHẬT buổi khác + THÊM buổi mới cho lớp CÓ trong file; KHÔNG xóa buổi/lớp nào, KHÔNG tạo trùng. `ma_gv` đã BỎ khỏi `FormatSpec.cot` (framework không quản) để `_after_apply` đặt mã chuẩn, tránh báo "capnhat" giả. BẪY tên trùng: `_resolve_gv` suy mã theo tên chỉ khi tên DUY NHẤT; "Bùi Anh Tuấn" có TG3001 (người khác) nên KHÔNG suy được TG5663→KG0528 → dùng dict `_MA_GV_SUA={TG5663:KG0528, CH0148:TG5712}` trong schedule.py (bổ sung khi gặp mã nhầm mới). Đã verify nhập lại 2 lần: 0 thêm/0 sửa/0 trùng.

**Chính sách NGÀY BẮT ĐẦU theo khóa:** file TKB để ngày bắt đầu chung (10/08) không đúng thực tế; dict `_KHOA_START` trong schedule.py chỉnh: buổi sớm nhất của khóa rơi vào ngày cấu hình, cả khối dời theo độ lệch cố định (giữ số tuần). Đã đặt `K26 -> 2026-09-07` (SV năm nhất bắt đầu sau tuần đầu tháng 9; +28 ngày). Áp trong `_after_apply` (bước 2b) nên import lại KHÔNG lùi về tháng 8 (đã verify idempotent). Đã dời prod 32 buổi K26 (backup `lich_hoc_bak_k26_20260810`). CẬP NHẬT dict này mỗi kỳ.

**CÒN TREO (chờ dữ liệu):** user muốn XÓA các lớp 0 SV (chưa chính thức), nhưng hiện `dang_ky_hoc_ky` chỉ có 1 dòng → đăng ký học phần SV CHƯA nhập, mọi lớp đều 0 SV. Nếu xóa ngay sẽ mất sạch 110 lớp. Đã chốt: TẠM CHƯA LÀM GÌ, chờ user cấp file đăng ký học phần (SV↔ma_lop_tc) → nhập (format REGIST, registration.py) → rồi mới dọn lớp còn 0 SV.

Backup trước khi sửa prod: `lop_tin_chi_bak_20260810`, `lich_hoc_bak_20260810` (349 gốc), `lich_hoc_bak2_20260810` (233). Liên quan [[hou_cntt_app]], [[hou_cntt_xet_tot_nghiep_import]], [[password_cas_vs_local]].
