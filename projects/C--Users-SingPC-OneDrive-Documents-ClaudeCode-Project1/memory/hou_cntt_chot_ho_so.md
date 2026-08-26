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
- **Chốt hàng loạt 26/08/2026** (`theo_du_doan`): Khoa duyệt theo đúng chuyên ngành máy suy ra — 279 SV K24 trở về trước. Sau đó `cn_doan = 0` (không còn em nào ở dạng máy đoán), `cn_chot = 1039`. RANH GIỚI đã áp: SV **đã tốt nghiệp** mà `NONE` thì chốt NONE (học xong không theo chuyên ngành nào = kết quả thật); SV **đang học** mà `NONE` thì KHÔNG chốt (chưa học môn chuyên ngành nào, chốt là đóng cửa lựa chọn của em). **K25/K26 cũng CHỐT `NONE`** (nguồn `quy_dinh_khoa`, 617 em): năm nhất–năm hai là Cử nhân CNTT chưa phân chuyên ngành theo LỘ TRÌNH, là quy tắc chứ không phải chỗ trống chờ đoán; sang năm ba chọn chuyên ngành thì chốt đè lên qua đề xuất/xác nhận. `sv_moi` và `xet_tot_nghiep.apply` nay chốt cả hệ lẫn CN='NONE' cho SV mới. Sau đó K24 chốt hết `NONE` (48 em). Với K21–K23, quy tắc user chọn là track **ít môn thừa tự chọn nhất** (môn đã đạt thuộc track khác bị dồn sang khối Tự chọn = học thừa). **BẪY: `NONE` LÀ MỘT TRACK THẬT trong khối "Chuyên ngành (chọn 1 khối)"**, không phải "chưa chọn" — và nó MƯỢN MÔN từ cả 3 hướng kia (CTĐT 1: NONE có 7 môn = 1 định hướng Nhập Môn CNPM + 3 nhóm G1/G2/G3 mỗi nhóm 2 môn lấy từ SE/MT/NS), đúng tinh thần "Cử nhân CNTT học rộng". Lần đầu tôi lọc `ma_cn <> 'NONE'` nên loại mất lựa chọn này và chốt NHẦM 1 em (22A1001D0352 → NS trong khi NONE thừa 0 TC). Tính lại đủ 4 track: **NONE thắng cả 21/21 em** (em học rải nhiều hướng thì NONE hấp thụ được nhiều nhất; em chưa học môn nào thì hoà, và NONE là trạng thái mặc định của lộ trình nên thắng hoà). **KẾT QUẢ CUỐI: 1725/1725 chốt, `cn_doan = 0`, `cn_trong = 0`, mâu thuẫn 0.**

**CAS TỰ NỐI TÀI KHOẢN — không cần tạo trước**: `api/routes/cas.py` auto-provision khi SV đăng nhập lần đầu và gán `mssv` nếu HỒ SƠ SV ĐÃ TỒN TẠI, kèm nhánh vá tài khoản cũ còn `mssv IS NULL`. Điều kiện: hồ sơ phải có TRƯỚC (lý do 23A1001D0409 đăng nhập 17/8 mà mssv NULL). 246/1725 SV chưa có tài khoản = chưa từng đăng nhập, bình thường. Đã gỡ tài khoản test `sv_test` (gắn nhầm vào MSSV thật 21A100100036). CÒN SÓT: hồ sơ `TEST000001` "Sinh viên Thử nghiệm (Play Review)" là SV đang hoạt động K22, ghi_chu KHÔNG XOÁ (tài khoản duyệt Google Play) — đang bị đếm vào mọi thống kê SV.

**CAS TỰ NỐI TÀI KHOẢN — không cần tạo trước**: `api/routes/cas.py` auto-provision khi SV đăng nhập lần đầu và gán `mssv` nếu HỒ SƠ SV ĐÃ TỒN TẠI, kèm nhánh vá tài khoản cũ còn `mssv IS NULL`. Điều kiện: hồ sơ phải có TRƯỚC (đó là lý do 23A1001D0409 đăng nhập 17/8 mà mssv NULL — lúc đó chưa có hồ sơ). 246/1725 SV chưa có tài khoản = chưa từng đăng nhập, bình thường. Đã gỡ tài khoản test `sv_test` (gắn nhầm vào MSSV thật 21A100100036).
- **Bất biến**: đã chốt thì `chuyen_nganh_du_doan` / `ctdt_id` (chỗ mọi màn hình đọc) luôn BẰNG giá trị chốt → code cũ tự đúng. `chot_ho_so.mau_thuan(db)` phải luôn rỗng.
- `KHOA_CN_MAC_DINH = 2025`: K25+ vào học đều Cử nhân CNTT → chốt hệ ngay khi import, chuyên ngành để trống.

**Đường ghi bắt buộc đi qua `chot_cn()` / `chot_he()`**: `ctdt_de_xuat.sv_xac_nhan_cn`, `ctdt_de_xuat.xu_ly`, `admin.set_student_ctdt`, `importer/sv_moi._after_apply`.

**Đường suy đoán bị rào**: `xet_tot_nghiep._SPEC_SQL` và `db/08_chuyennganh_dudoan.sql` thêm `AND chuyen_nganh_id IS NULL`.

**`xet_tot_nghiep.re_du_doan_loai_hinh` ĐÃ XOÁ HẲN** (26/08/2026, theo yêu cầu user — nó ghi đè `ctdt_id` toàn bộ SV, lần chạy thử cuối định đổi 72 em; không có route/nút nào gọi nó, chỉ là mã chết gọi được từ script).

**Loại hình CN/KS chỉ đặt MỘT LẦN**, khi hồ sơ chưa có `ctdt_id`. Thứ tự trong `xet_tot_nghiep.apply._ctdt_cua()`: cột loại hình trong file → **MẶC ĐỊNH Cử nhân CNTT** (`chot_ho_so.he_mac_dinh(db, khoa)`, tra theo khóa chứ không gán cứng id) → chỉ đoán bằng `_du_doan_loai_hinh` khi là SV BỊ SÓT của khóa cũ (khóa < 2025 VÀ đã có `tc_dat`). SV mới vào → chốt luôn nguồn `quy_dinh_khoa`. `importer/sv_moi` cũng dùng `he_mac_dinh` (lớp đuôi KS → CTĐT 2) và chốt hệ cho mọi SV mới nhập.

Đã chạy thử 4 tình huống end-to-end (monkeypatch `extract` + vô hiệu `db.commit` rồi rollback — LƯU Ý `apply()` tự commit nhiều lần bên trong nên rollback suông KHÔNG cứu được): K26 không ghi loại→CN+chốt; K22 150TC→KS; K22 30TC→CN; SV đã có loại hình→giữ nguyên.

**Xem ở đâu**: API `GET /api/admin/ho-so/chot`; giao diện ở cuối trang Báo cáo tổng hợp + nhãn "(đã chốt — nguồn)" / "(dự đoán)" cạnh hệ & chuyên ngành trong hồ sơ SV.

Liên quan: [[hou_cntt_block_credit_model]], [[hou_cntt_ctdt_viewer_advisory]], [[hou_cntt_app]]

**Banner "rà soát chuyên ngành" trên trang chủ cổng SV** (`web-sv/index.html` → `xacNhanCnBannerHTML`, gọi ở renderer trang chủ dòng ~1078, KHÔNG phải màn CTĐT — bấm banner mới nhảy sang tab ctdt). Điều kiện do `ctdt_de_xuat.sv_can_xac_nhan_cn` quyết. Đã sửa 26/08/2026 vì trước đó hiện SAI cho 717 em:
- chỉ tìm bản xác nhận **trong đợt hiện tại** → mỗi lần mở đợt mới là hỏi lại 364 em đã xác nhận đợt trước dù CN không đổi. Nay lấy lần SV **tự** xác nhận gần nhất ở BẤT KỲ đợt nào (`dot_id <> 0`, `ORDER BY thoi_diem DESC`).
- không loại SV **đã tốt nghiệp** → 232 em đã ra trường vẫn bị nhắc. Nay thêm điều kiện `duyet_tot_nghiep.trang_thai <> 'DA_DUYET'`.
- `dot_id = 0` là bản do GIÁO VỤ ghi khi duyệt, KHÔNG tính là SV tự xác nhận.
Kết quả: 717 → **165 em** (112 em thực sự đang học, 44 em nghi bỏ học, 64 em chưa có tài khoản). K25/K26 không bị hỏi (`_yeu_cau_xac_nhan_cn`: chỉ khóa ≤ 2024).

**`TEST000001` GIỮ NGUYÊN `is_active=true`**: `_mssv_dang_hoc` trong `api/routes/sv_me.py` chặn MỌI thao tác ghi (đăng ký, xác nhận, đề xuất) khi `is_active=false` và trả 403 "bạn đang ở diện bảo lưu/thôi học" — người duyệt Google Play gặp lỗi đó dễ đánh trượt app. Đổi lấy việc bớt 1/1725 dòng khỏi thống kê là không đáng.
