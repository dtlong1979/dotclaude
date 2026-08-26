---
name: hou-cntt-chot-ho-so
description: "Lớp \"đã chốt\" cho hệ đào tạo & chuyên ngành SV ở hou-cntt — quyết định phải lưu tách khỏi dự đoán, suy đoán cấm ghi đè"
metadata: 
  node_type: memory
  type: project
  originSessionId: 991648e5-4e5f-43c6-94f4-bc490d8d61e7
  modified: 2026-08-26T01:13:29.442Z
---

hou-cntt trước 26/08/2026 chỉ có MỘT cột `sinh_vien.chuyen_nganh_du_doan` cho cả quyết định lẫn phỏng đoán: máy suy từ bảng điểm, SV bấm Xác nhận, giáo vụ duyệt đề xuất — tất cả ghi vào đó. Cột `sinh_vien.chuyen_nganh_id` được khai báo trong `models.py` nhưng KHÔNG code nào đọc/ghi (mọi `chuyen_nganh_id` khác trong repo là của `ctdt_hoc_phan`). Hậu quả thật: chạy lại phép đoán là đè mất chuyên ngành đã duyệt, 23 hồ sơ SV bị sai không dấu vết.

**Cấu trúc mới** (`backend/app/services/chot_ho_so.py`):
- `sinh_vien.chuyen_nganh_id` = CHỐT chuyên ngành + `cn_chot_luc` / `cn_chot_nguon`
- `sinh_vien.ctdt_id_chot` = CHỐT hệ + `he_chot_luc` / `he_chot_nguon`
- Nguồn chốt: `sv_xac_nhan` | `giao_vu_duyet` | `giao_vu_dat` | `quy_dinh_khoa`
- **Bất biến**: đã chốt thì `chuyen_nganh_du_doan` / `ctdt_id` (chỗ mọi màn hình đọc) luôn BẰNG giá trị chốt → code cũ tự đúng. `chot_ho_so.mau_thuan(db)` phải luôn rỗng.
- `KHOA_CN_MAC_DINH = 2025`: K25+ vào học đều Cử nhân CNTT → chốt hệ ngay khi import, chuyên ngành để trống.

**Đường ghi bắt buộc đi qua `chot_cn()` / `chot_he()`**: `ctdt_de_xuat.sv_xac_nhan_cn`, `ctdt_de_xuat.xu_ly`, `admin.set_student_ctdt`, `importer/sv_moi._after_apply`.

**Đường suy đoán bị rào** (`AND chuyen_nganh_id IS NULL` / `AND ctdt_id_chot IS NULL`): `xet_tot_nghiep._SPEC_SQL`, `xet_tot_nghiep.re_du_doan_loai_hinh`, `db/08_chuyennganh_dudoan.sql`.

**Xem ở đâu**: API `GET /api/admin/ho-so/chot`; giao diện ở cuối trang Báo cáo tổng hợp + nhãn "(đã chốt — nguồn)" / "(dự đoán)" cạnh hệ & chuyên ngành trong hồ sơ SV.

Liên quan: [[hou_cntt_block_credit_model]], [[hou_cntt_ctdt_viewer_advisory]], [[hou_cntt_app]]
