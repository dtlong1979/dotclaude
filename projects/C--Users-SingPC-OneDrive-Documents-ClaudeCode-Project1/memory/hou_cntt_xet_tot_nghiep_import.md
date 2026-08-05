---
name: hou_cntt_xet_tot_nghiep_import
description: Tính năng xét tốt nghiệp qua import điểm tổng hợp (hou-cntt admin) — MỞ RỘNG feature graduation sẵn có; đang làm dở
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-05T06:22:38.587Z
---

Bổ sung **xét điều kiện tốt nghiệp qua import file "điểm tổng hợp"** cho hou-cntt admin. Liên quan [[hou_cntt_ren_luyen_warnings]] [[hou_cntt_app]].

**QUAN TRỌNG — feature graduation ĐÃ CÓ SẴN, chỉ MỞ RỘNG (không làm lại):**
- CTĐT: bảng `ctdt`, `khoi_kien_thuc`, `chuyen_nganh`, `ctdt_hoc_phan` (join "HP nào bắt buộc/tự chọn của CTĐT nào"), `hoc_phan`. 3 CTĐT: `CNTT.2022.CN`(CU_NHAN,khóa≥2021,126TC), `CNTT.2022.KS`(KY_SU,≥2021,150), `CNTT.2019.KS`(KY_SU,≥2015,141).
- Điểm: `ket_qua_hoc_phan`(mssv,hoc_phan_id,ma_hp_goc,hoc_ky,diem_he4,diem_so,diem_chu,so_tc,dat; UNIQUE(mssv,hoc_phan_id)); đạt=diem_he4≥1.0. TC tích lũy tính on-the-fly SUM(so_tc WHERE dat).
- Engine: `services/tot_nghiep.py::du_dieu_kien(db,mssv,ctdt_id)` = đủ tổng TC (ctdt.tong_tc_tot_nghiep) + đủ TC từng khối; `graduation.py::block_credits/block_courses`. Web-admin tab "Tốt nghiệp" `pageTotNghiep` (app.js:988). Importer `DIEM` (grades.py) = ĐÚNG cấu trúc bảng điểm rộng nhưng 1 sheet + bỏ SV lạ.
- `sinh_vien.ctdt_id` **NULL khi chưa rõ bậc** (khóa 2022 chờ danh sách CN/KS) → import file này CHÍNH LÀ nguồn gán loại hình. `chuyen_nganh_du_doan` (SQL `db/08_chuyennganh_dudoan.sql`: SV lấy chuyên ngành có nhiều TC nhất trong ctdt của mình) — chạy lại sau import.

**Quyết định user chốt:** mở rộng feature hiện có; cập nhật điểm = **giữ bản cao hơn** (theo hệ4); SV chưa có → **tự tạo + dự đoán loại hình (KS≥140TC/CN<140) & chuyên ngành**.

**ĐÃ LÀM (Giai đoạn 1a — validated):** `backend/app/services/importer/bang_diem.py::extract(sheets)` — hàm THUẦN (không DB), đa sheet, tái dùng `grades._courses`, tìm cột theo NHÃN (vị trí lệch giữa sheet), giữ điểm cao nhất, dự đoán loại hình. Test file thật `D:\Downloads\tông TL (long).xlsx`: 51 SV, 72 HP, KS24/CN27, bỏ đúng HTCTDT+tich luy. (Test offline stub sqlalchemy vì Python local không có; chạy thật trong Docker.)

**ĐÃ XONG & DEPLOY (Steps 1-4, verify trên prod):**
- `services/xet_tot_nghiep.py`: `preview/apply/thong_ke`. apply: khớp `ma_hp`→hoc_phan (exact→theo tên), upsert ket_qua_hoc_phan **keep-max** (ON CONFLICT WHERE new he4 > old), TẠO sinh_vien mới + `_ctdt_for(khóa,loại)` (≥2021 CN→2022.CN / KS→2022.KS; ≤2020→2019.KS), gán ctdt_id cho SV NULL, cập nhật tbc, chạy `_recompute_spec` (SQL db/08 scope theo mssv).
- `thong_ke(db,khoa)`: đủ/chưa đủ theo loại hình × chuyên ngành + **gợi ý chéo** (gọi `du_dieu_kien` với ctdt loại kia cùng khóa; đủ ở loại khác → "Nên xét <loại>"/"Đủ cả 2").
- Routes `api/routes/tot_nghiep.py` (GIAOVU/ADMIN): `POST /tot-nghiep/bang-diem/preview|apply` (multipart), `GET /tot-nghiep/thong-ke?khoa=`.
- web-admin `pageTotNghiep`: 2 card mới — "Import điểm tổng hợp toàn khóa" (bdPreview/bdApply) + "Thống kê xét tốt nghiệp theo khóa" (tkLoad/tkRender, link chi tiết `stuDetail` sẵn có = YC4). index.html **app.js?v=10**.
- **Verify prod:** preview file thật = 51 SV, **72/72 HP khớp 100%**, SV đều đã có. thong_ke khóa 2022 = 255 SV, CN đủ95/chưa106, KS đủ7/chưa47, 2 gợi ý chéo. **CHƯA apply file mẫu lên prod** (để user tự bấm Ghi trong UI).

**ĐÃ SIẾT THEO QUY CHẾ (1818) — `services/quy_che_tn.py::xet()`, app.js?v=11:**
- **Điều kiện CỨNG (quyết định đủ/chưa)**: qua HẾT môn BẮT BUỘC (ctdt_hoc_phan loai_hp=BAT_BUOC, tinh_vao_tong_tc=TRUE, hp.ma_tam=FALSE, common+chuyên ngành) → `no_bat_buoc[]`; đủ TC từng khối; đủ TỔNG TC (chỉ cộng HP tinh_vao_tong_tc=TRUE, dedup). `du_dieu_kien` giờ delegate sang `quy_che_tn.xet` (lấy chuyên ngành/khóa/GPA của SV).
- **CẢNH BÁO tự xác nhận (KHÔNG chặn; thiếu dữ liệu→để trống+cảnh báo)**: GPA<gpa_min (ctdt.gpa_toi_thieu hoặc 2.0); GDTC/GDQP (HP điều kiện tinh_vao_tong_tc=FALSE — hiện CTĐT seed CHƯA có nên báo "chưa khai báo"); thời gian đào tạo (chuẩn CN4/KS5 + 2, cảnh báo khi vượt); điểm rèn luyện (AVG diem_ren_luyen<50 hoặc chưa có dữ liệu). `xep_loai_du_kien` theo GPA thang4 (XS≥3.6/G≥3.2/K≥2.5/TB≥2.0).
- UI thong_ke thêm cột Xếp loại + Cảnh báo; `du` chặt hơn (nợ bắt buộc → chưa đủ). Verify prod khóa 2022: SV nợ 6 môn BB → chưa đủ; SV đủ → xếp loại Khá.
- **NGƯỠNG cần user xác nhận đúng QC1818**: GPA_MIN=2.0, bands, NAM_TOI_DA_THEM=2 (ở đầu quy_che_tn.py).
- **Hạ bậc xếp loại ĐÃ LÀM**: parser `bang_diem._parse_tich_luy` đọc sheet "tich luy" cột "Tổng số TC học lại/thi lại" → cột mới `sinh_vien.so_tc_hoc_lai/so_tc_thi_lai` (migration `db/26_hoc_lai.sql`, ALTER ADD IF NOT EXISTS, đã áp prod). `quy_che_tn.xet(...,so_tc_hoc_lai)`: TN Giỏi/Xuất sắc + TC học lại > 5%×tong_tc_tot_nghiep → cảnh báo "có thể hạ xuống <bậc>". Verify: parser lấy 40 SV có TC học lại; test SV Giỏi 12TC/126 → cảnh báo hạ Khá. (Cột chỉ dùng raw SQL, KHÔNG map ORM để tránh lỗi query-all.)
- **ĐỐI KHỚP MỀM môn (khóa ≤21 CTĐT 2019 lệch tên/mã), app.js?v=15**: `services/mon_khop.py` — `chuan_hoa()` bỏ dấu + giãn VIẾT TẮT chuyên ngành (cndpt→công nghệ đa phương tiện, cnpm, attt, httt…); `satisfied_names()` nới NHÓM TƯƠNG ĐƯƠNG lý luận chính trị cũ↔mới (có "đường lối cách mạng"/"nguyên lý cơ bản" → coi đủ 5 môn mới). Áp vào: `quy_che_tn._mon_bb_chua_dat` (môn bắt buộc chưa đạt), `graduation.block_credits` + `tc_tich_luy` (ĐẾM TÍN CHỈ khối+tổng theo học phần KHUNG đã "thỏa" khớp mã HOẶC tên/tương đương, thay vì JOIN mã cứng — nên môn đổi mã/tên vẫn được cộng), `block_courses` (chưa học), `hoc_ngoai_khung` (môn đã đạt ngoài khung = nghi học thừa, hiện ở chi tiết SV). Verify: CNĐPT khớp; SV 18A…038 khối chính trị hết báo thiếu (137/141, còn thiếu thật); khóa 2022 CN đủ 95→107 (phục hồi false-neg), KS giữ nguyên. Bảng viết tắt/tương đương MỞ RỘNG được trong mon_khop.py.
- **NHÓM IMPORT (batch) — xem/xuất riêng, app.js?v=13**: mỗi apply tạo `xet_tn_batch`+`xet_tn_batch_sv` (migration `db/27`, áp prod). `_xet_nhom(db,rows)` cache CTĐT KS/CN theo từng khóa (chạy nhóm nhiều khóa) dùng chung cho `thong_ke(khoa)`+`thong_ke_batch(id)`; `list_batches`; `export_batch_xlsx(id,dieu_kien=du/chua/all)` (openpyxl). Routes `/tot-nghiep/batches`, `/batch/{id}/thong-ke`, `/batch/{id}/export?dieu_kien=`. Web-admin: sau import tự hiện thống kê nhóm + 3 nút Xuất Excel ở `#bd_batch`, dropdown `#bd_batchpick` xem lại nhóm cũ, `downloadFile()` fetch kèm token→blob. Kết quả tính LẠI từ điểm hiện tại → import lại không sai lệch, chỉ thêm batch. Verify prod OK (xlsx PK header).
