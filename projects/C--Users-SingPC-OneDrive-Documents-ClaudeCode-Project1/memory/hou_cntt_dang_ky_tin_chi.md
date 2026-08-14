---
name: hou_cntt_dang_ky_tin_chi
description: Tính năng ĐĂNG KÝ/ĐIỀU CHỈNH TÍN CHỈ hou-cntt — quy trình giáo vụ Giả lập xếp lớp → SV điều chỉnh → chốt; kèm học phí dự kiến
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-14T03:36:12.826Z
---

Tính năng LỚN đang xây (bắt đầu 2026-08-14): **đăng ký/điều chỉnh tín chỉ** sau khi Xếp lớp. Code ở hou-cntt (D:\dev\hou-cntt). Subtab "Đăng ký tín chỉ" trong Sinh viên/Học vụ (SPA); giáo vụ ở web-admin tab Xếp lớp.

## Quy trình (đã chốt với user)
2 nguồn đăng ký (`dang_ky_hoc_ky.nguon`): `import` (từ hệ thống trường) | `gia_lap` (xếp lớp FithouOne) | `sv_them` | `gv_them`.
Đợt điều chỉnh (`dk_dot`) qua trạng thái: **chuan_bi → gia_lap → dong → chot**.
1. **Chuẩn bị**: giáo vụ chạy Xếp lớp. Lớp ĐÃ CÓ: chỉ *bổ sung* SV (chỉ chặn sức chứa PHÒNG, không ràng buộc tiên quyết); mỗi SV thêm có nút **Hủy** (giáo vụ gỡ) + nút **Thêm** tay (tìm tên/mã trong SV đủ ĐK track, **CHO vượt sĩ số** khi thêm tay). Lớp ĐỀ XUẤT mở: giáo vụ sửa danh sách SV + **nhập GV** + **duyệt mở** (hoặc không, vì phải bố trí GV).
2. **Giả lập Xếp lớp** (nút): ghi thành lịch KHÔNG chính thức; GV/SV khoa xem lịch thấy bản giả lập. Option **chọn khóa** (mặc định tất cả; chỉ hiện khóa còn SV chưa tốt nghiệp — `dang_ky_tc.khoa_active()`). Đặt **cửa sổ thời gian** điều chỉnh ở đây.
3. **SV điều chỉnh** (trong cửa sổ): thấy 2 nhóm (đã đăng ký vs bổ sung, phân biệt màu nhẹ); **Hủy** 1 môn đã có (ghi lý do → tạo yêu cầu, GIỮ ghế tới khi giáo vụ duyệt) / **Thêm** (đủ ĐK: chưa vượt TC_TOI_DA=23, trong track, không vướng tiên quyết, lớp có mở trong tổng lớp thực+giả lập, CÒN SLOT — thành công ngay, chiếm ghế atomic) / **Xác nhận đăng ký** (nhập lại mật khẩu → xác thực qua luồng đăng nhập). Đăng nhập mà có học phần bổ sung → banner nhắc vào xác nhận.
4. **Chốt**: hết giờ, giáo vụ duyệt/từ chối yêu cầu SV (lý do dropdown/tự gõ), quyết mở lớp mới (nếu tụt <30), chốt → giả lập thành chính thức; **Xuất Excel** (danh sách xếp lớp cuối để GV cập nhật lên hệ thống trường). Kết quả gửi từng SV (dùng hệ Thông báo).

## Quyết định đã chốt
- Sức chứa: theo phòng (P51/P52=80, còn lại 48/55), gộp lớp học ghép chung 1 sức chứa, giáo vụ sửa tay được. Thêm tay của giáo vụ CHO vượt.
- Hủy của SV: chờ duyệt, GIỮ ghế. Thêm của SV: thành công ngay, giáo vụ vẫn gỡ được ở bước chốt.
- Trần TC/kỳ: TC_TOI_DA=23 (xep_lop). "Giáo vụ" = admin_role ∈ {admin, giaovu}.
- Xác nhận SV bằng nhập lại mật khẩu (xác thực qua auth hiện có). Thông báo qua ThongBao + banner SPA.
- Chống tranh chấp sĩ số: transaction + `SELECT ... FOR UPDATE` khóa dòng lop_tin_chi → đếm số ĐK thực → nếu < suc_chua thì INSERT (unique mssv+ma_lop_tc). Khóa theo từng lớp. LƯU Ý backend `-w 1`.

## Học phí dự kiến (Pha 2) — nguồn CHÍNH THỨC
Dữ liệu ở **thẻ FITHOU AI** DB `fit_hou_cms` bảng `fithou_ai_knowledge` (cập nhật hằng năm) — **cần ĐỒNG BỘ sang hou_cntt** (grant SELECT cross-DB + nút "Đồng bộ học phí" cho admin). Thẻ id 41 = ĐH chính quy CNTT 2026-2027, `value_json`={hoc_phan_chuyen_mon:782000, hoc_phan_dai_cuong:658000, don_vi:VND/tin_chi}. (id 42 thường xuyên, 43 thạc sĩ.)
**Phân loại (user chốt CHÍNH XÁC):** mức **658k CHỈ cho 10 môn có tên**: 5 lý luận chính trị (Triết Mác-Lênin, Kinh tế chính trị ML, CNXH khoa học, Tư tưởng HCM, Lịch sử Đảng), 3 anh văn (Tiếng Anh 1/2/3), Pháp luật đại cương, Tin học đại cương. **Tất cả còn lại 782k** (KHÔNG phải cả khối đại cương — khối còn có Toán/Lý…). Học phí dự kiến = Σ(TC×mức); hạn đóng = ngày bắt đầu kỳ + 21 ngày. Ngày bắt đầu kỳ + đơn giá đồng bộ vào `dk_dot`.

## Đã làm (2026-08-14)
Pha 1 nền: `backend/app/services/dang_ky_tc.py` (`ensure_tables`, `khoa_active`, `dot_hien_tai`). Bảng đã tạo trên prod: `dk_dot`, `dk_yeu_cau`, `dk_xac_nhan`; cột `dang_ky_hoc_ky.nguon/trang_thai/tao_luc`, `lop_tin_chi.suc_chua/trang_thai`. Kỳ sống hiện tại: 2026-2027 HKI. Chia 3 pha: (1) giáo vụ Giả lập, (2) trang SV + học phí, (3) chốt + Excel + gửi kết quả. Liên quan [[hou_cntt_ren_luyen_warnings]] [[fithou_ai_knowledge_cards]] [[hou_cntt_dang_ky_lich_su]].
