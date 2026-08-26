---
name: hou-cntt-su-kien-lich
description: "Buổi riêng của Khoa trên lịch hou-cntt (gặp mặt/sinh hoạt/hội thảo) — có GV, phòng, SV nhưng KHÔNG sinh đăng ký tín chỉ"
metadata: 
  node_type: memory
  type: project
  originSessionId: 991648e5-4e5f-43c6-94f4-bc490d8d61e7
  modified: 2026-08-26T03:42:59.577Z
---

Tính năng thêm 26/08/2026: tạo **buổi đơn lẻ** đặt thẳng lên lịch giảng dạy (vd gặp mặt tân sinh viên K26 ngày 3–5/9).

**Vì sao không dùng `lop_tin_chi`**: buổi gặp mặt cũng có GV + phòng + SV, nhưng nếu tạo thành lớp tín chỉ thì chảy ngay vào học phí, tổng TC đăng ký, trần TC, xét tốt nghiệp và file xuất sang Trường — mà Trường không có lớp nào như vậy để nhận.

**Bảng** (`backend/app/services/su_kien_lich.py`):
- `su_kien_lich(id, tieu_de, loai, ngay, ca, tu_tiet, den_tiet, gio_bd, gio_kt, ma_phong, ma_gv, ghi_chu, trang_thai, tao_boi, tao_luc)` — `loai` ∈ GAP_MAT|HOI_THAO|THI|KHAC. `gio_bd` là giờ Khoa công bố dạng '7h45' chỉ để hiển thị; `ca`/tiết mới dùng dò trùng.
- `su_kien_lich_tv(su_kien_id, loai_tv, gia_tri)` — `loai_tv` ∈ **LOP_QL** (cả lớp quản lý) | **MSSV** (nhóm SV chọn riêng). GIỮ NGUYÊN DẠNG KHAI BÁO, không bung sẵn ra danh sách SV vì lớp còn biến động.

**API** (`_full` = admin/giáo vụ/văn phòng): `GET|POST /api/admin/su-kien-lich`, `POST|DELETE /su-kien-lich/{id}`, `GET /su-kien-lich/kiem-tra` (dò trùng phòng/GV/lịch học SV — CẢNH BÁO chứ không chặn), `GET /su-kien-lich/{id}/sinh-vien`.

**Hiện ở đâu**: web-admin chèn thẳng vào ô lưới Lịch học kỳ (viền tím nét đứt, nhãn BUỔI RIÊNG) + bảng quản lý dưới lưới (app.js?v=187); **web-sv** trộn vào `grid` của `scheduleGridHTML` nên nằm đúng ô như buổi học, nhãn `KHOA TỔ CHỨC` + class `.su-kien` (cả lưới lẫn bản danh sách mobile); `/giang-vien/lich-giang` trả `su_kien` của GV phụ trách. API `/me/schedule` trả nhánh `su_kien` RIÊNG (không trộn vào `lop`) để không chỗ nào đếm nhầm thành môn học.

**Thông báo**: `admin._su_kien_bao_sv()` — mỗi lớp quản lý một `ThongBao(doi_tuong='LOP')`, nhóm MSSV riêng thì `DANH_SACH` + `thong_bao_muc_tieu`, kèm push FCM. Ô tick "Gửi thông báo cho sinh viên" trong hộp thoại tạo (mặc định bật, `bao_sv=1`); lỗi ở khâu báo không được làm hỏng lệnh tạo.

**BẪY ĐÃ DÍNH**: `ensure_tables` kiểu lười mà KHÔNG `db.commit()` → 6 phút sau khi deploy, lịch của SV trả 500 `relation "su_kien_lich" does not exist`. Đã vá: ensure_tables commit DDL ngay, VÀ hai nhánh đọc của SV/GV bọc try/except + rollback — thời khóa biểu là thứ dùng hằng ngày, không được vỡ vì tính năng phụ.

**Dữ liệu thật đã nạp 26/08/2026**: 15 buổi gặp mặt K26 ngày 3–5/9 (id 19–33) — 12 buổi gặp CVHT theo lớp + 3 buổi gặp mặt Khoa (gộp 2 lớp/buổi: 7h45 P51/P52, 9h15 P51). **BẢNG CỦA KHOA CÓ TRÙNG PHÒNG: 4/9 chiều P23 có cả 2610A04 và 2610A05** → đã nạp lịch nhưng GIỮ LẠI thông báo của 2 buổi đó (gửi 16 thay vì 18 thông báo), chờ Khoa sửa phòng rồi báo sau.

Liên quan: [[hou_cntt_lich_giang_import]], [[hou_cntt_app]]
