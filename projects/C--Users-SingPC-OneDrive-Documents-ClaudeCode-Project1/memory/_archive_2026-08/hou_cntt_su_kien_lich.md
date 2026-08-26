---
name: hou-cntt-su-kien-lich
description: Buổi riêng của Khoa trên lịch hou-cntt (gặp mặt/sinh hoạt/hội thảo) — có GV, phòng, SV nhưng KHÔNG sinh đăng ký tín chỉ
metadata:
  type: project
---

Tính năng thêm 26/08/2026: tạo **buổi đơn lẻ** đặt thẳng lên lịch giảng dạy (vd gặp mặt tân sinh viên K26 ngày 3–5/9).

**Vì sao không dùng `lop_tin_chi`**: buổi gặp mặt cũng có GV + phòng + SV, nhưng nếu tạo thành lớp tín chỉ thì chảy ngay vào học phí, tổng TC đăng ký, trần TC, xét tốt nghiệp và file xuất sang Trường — mà Trường không có lớp nào như vậy để nhận.

**Bảng** (`backend/app/services/su_kien_lich.py`):
- `su_kien_lich(id, tieu_de, loai, ngay, ca, tu_tiet, den_tiet, gio_bd, gio_kt, ma_phong, ma_gv, ghi_chu, trang_thai, tao_boi, tao_luc)` — `loai` ∈ GAP_MAT|HOI_THAO|THI|KHAC. `gio_bd` là giờ Khoa công bố dạng '7h45' chỉ để hiển thị; `ca`/tiết mới dùng dò trùng.
- `su_kien_lich_tv(su_kien_id, loai_tv, gia_tri)` — `loai_tv` ∈ **LOP_QL** (cả lớp quản lý) | **MSSV** (nhóm SV chọn riêng). GIỮ NGUYÊN DẠNG KHAI BÁO, không bung sẵn ra danh sách SV: lớp còn biến động.

**API** (`_full` = admin/giáo vụ/văn phòng): `GET|POST /api/admin/su-kien-lich`, `POST|DELETE /su-kien-lich/{id}`, `GET /su-kien-lich/kiem-tra` (dò trùng phòng/GV/lịch học SV — CẢNH BÁO chứ không chặn), `GET /su-kien-lich/{id}/sinh-vien`.

**Hiện ở đâu**: chèn thẳng vào ô lưới Lịch học kỳ của web-admin (viền tím nét đứt, nhãn BUỔI RIÊNG) + bảng quản lý dưới lưới; `/me/schedule` trả nhánh `su_kien` riêng (KHÔNG trộn vào `lop`); `/giang-vien/lich-giang` trả `su_kien` của GV phụ trách.

**BẪY ĐÃ DÍNH**: `ensure_tables` kiểu lười mà KHÔNG `db.commit()` → 6 phút sau khi deploy, lịch của SV trả 500 `relation "su_kien_lich" does not exist`. Đã vá: ensure_tables commit DDL ngay, VÀ hai nhánh đọc của SV/GV bọc try/except + rollback — thời khóa biểu là thứ dùng hằng ngày, không được vỡ vì tính năng phụ.

Liên quan: [[hou_cntt_lich_giang_import]], [[hou_cntt_app]]
