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
- Nguồn chốt: `sv_xac_nhan` | `giao_vu_duyet` | `giao_vu_dat` | `quy_dinh_khoa` | `theo_du_doan`
- **Chốt hàng loạt 26/08/2026** (`theo_du_doan`): Khoa duyệt theo đúng chuyên ngành máy suy ra — 279 SV K24 trở về trước. Sau đó `cn_doan = 0` (không còn em nào ở dạng máy đoán), `cn_chot = 1039`. RANH GIỚI đã áp: SV **đã tốt nghiệp** mà `NONE` thì chốt NONE (học xong không theo chuyên ngành nào = kết quả thật); SV **đang học** mà `NONE` thì KHÔNG chốt (chưa học môn chuyên ngành nào, chốt là đóng cửa lựa chọn của em). Còn 686 chưa chốt = 617 K25/K26 + 69 em K21–K24 đang học chưa suy được gì.
- **Bất biến**: đã chốt thì `chuyen_nganh_du_doan` / `ctdt_id` (chỗ mọi màn hình đọc) luôn BẰNG giá trị chốt → code cũ tự đúng. `chot_ho_so.mau_thuan(db)` phải luôn rỗng.
- `KHOA_CN_MAC_DINH = 2025`: K25+ vào học đều Cử nhân CNTT → chốt hệ ngay khi import, chuyên ngành để trống.

**Đường ghi bắt buộc đi qua `chot_cn()` / `chot_he()`**: `ctdt_de_xuat.sv_xac_nhan_cn`, `ctdt_de_xuat.xu_ly`, `admin.set_student_ctdt`, `importer/sv_moi._after_apply`.

**Đường suy đoán bị rào**: `xet_tot_nghiep._SPEC_SQL` và `db/08_chuyennganh_dudoan.sql` thêm `AND chuyen_nganh_id IS NULL`.

**`xet_tot_nghiep.re_du_doan_loai_hinh` ĐÃ XOÁ HẲN** (26/08/2026, theo yêu cầu user — nó ghi đè `ctdt_id` toàn bộ SV, lần chạy thử cuối định đổi 72 em; không có route/nút nào gọi nó, chỉ là mã chết gọi được từ script).

**Loại hình CN/KS chỉ đặt MỘT LẦN**, khi hồ sơ chưa có `ctdt_id`. Thứ tự trong `xet_tot_nghiep.apply._ctdt_cua()`: cột loại hình trong file → **MẶC ĐỊNH Cử nhân CNTT** (`chot_ho_so.he_mac_dinh(db, khoa)`, tra theo khóa chứ không gán cứng id) → chỉ đoán bằng `_du_doan_loai_hinh` khi là SV BỊ SÓT của khóa cũ (khóa < 2025 VÀ đã có `tc_dat`). SV mới vào → chốt luôn nguồn `quy_dinh_khoa`. `importer/sv_moi` cũng dùng `he_mac_dinh` (lớp đuôi KS → CTĐT 2) và chốt hệ cho mọi SV mới nhập.

Đã chạy thử 4 tình huống end-to-end (monkeypatch `extract` + vô hiệu `db.commit` rồi rollback — LƯU Ý `apply()` tự commit nhiều lần bên trong nên rollback suông KHÔNG cứu được): K26 không ghi loại→CN+chốt; K22 150TC→KS; K22 30TC→CN; SV đã có loại hình→giữ nguyên.

**Xem ở đâu**: API `GET /api/admin/ho-so/chot`; giao diện ở cuối trang Báo cáo tổng hợp + nhãn "(đã chốt — nguồn)" / "(dự đoán)" cạnh hệ & chuyên ngành trong hồ sơ SV.

Liên quan: [[hou_cntt_block_credit_model]], [[hou_cntt_ctdt_viewer_advisory]], [[hou_cntt_app]]
