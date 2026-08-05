---
name: hou_cntt_xet_tot_nghiep_import
description: Tính năng xét tốt nghiệp qua import điểm tổng hợp (hou-cntt admin) — MỞ RỘNG feature graduation sẵn có; đang làm dở
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-05T03:30:43.811Z
---

Bổ sung **xét điều kiện tốt nghiệp qua import file "điểm tổng hợp"** cho hou-cntt admin. Liên quan [[hou_cntt_ren_luyen_warnings]] [[hou_cntt_app]].

**QUAN TRỌNG — feature graduation ĐÃ CÓ SẴN, chỉ MỞ RỘNG (không làm lại):**
- CTĐT: bảng `ctdt`, `khoi_kien_thuc`, `chuyen_nganh`, `ctdt_hoc_phan` (join "HP nào bắt buộc/tự chọn của CTĐT nào"), `hoc_phan`. 3 CTĐT: `CNTT.2022.CN`(CU_NHAN,khóa≥2021,126TC), `CNTT.2022.KS`(KY_SU,≥2021,150), `CNTT.2019.KS`(KY_SU,≥2015,141).
- Điểm: `ket_qua_hoc_phan`(mssv,hoc_phan_id,ma_hp_goc,hoc_ky,diem_he4,diem_so,diem_chu,so_tc,dat; UNIQUE(mssv,hoc_phan_id)); đạt=diem_he4≥1.0. TC tích lũy tính on-the-fly SUM(so_tc WHERE dat).
- Engine: `services/tot_nghiep.py::du_dieu_kien(db,mssv,ctdt_id)` = đủ tổng TC (ctdt.tong_tc_tot_nghiep) + đủ TC từng khối; `graduation.py::block_credits/block_courses`. Web-admin tab "Tốt nghiệp" `pageTotNghiep` (app.js:988). Importer `DIEM` (grades.py) = ĐÚNG cấu trúc bảng điểm rộng nhưng 1 sheet + bỏ SV lạ.
- `sinh_vien.ctdt_id` **NULL khi chưa rõ bậc** (khóa 2022 chờ danh sách CN/KS) → import file này CHÍNH LÀ nguồn gán loại hình. `chuyen_nganh_du_doan` (SQL `db/08_chuyennganh_dudoan.sql`: SV lấy chuyên ngành có nhiều TC nhất trong ctdt của mình) — chạy lại sau import.

**Quyết định user chốt:** mở rộng feature hiện có; cập nhật điểm = **giữ bản cao hơn** (theo hệ4); SV chưa có → **tự tạo + dự đoán loại hình (KS≥140TC/CN<140) & chuyên ngành**.

**ĐÃ LÀM (Giai đoạn 1a — validated):** `backend/app/services/importer/bang_diem.py::extract(sheets)` — hàm THUẦN (không DB), đa sheet, tái dùng `grades._courses`, tìm cột theo NHÃN (vị trí lệch giữa sheet), giữ điểm cao nhất, dự đoán loại hình. Test file thật `D:\Downloads\tông TL (long).xlsx`: 51 SV, 72 HP, KS24/CN27, bỏ đúng HTCTDT+tich luy. (Test offline stub sqlalchemy vì Python local không có; chạy thật trong Docker.)

**CÒN LÀM:**
1. Service preview/apply: khớp `ma_hp_goc`→hoc_phan (exact → bỏ đuôi .NN → theo tên; báo chưa khớp), upsert ket_qua_hoc_phan keep-max, TẠO sinh_vien mới (map (khóa,loại)→ctdt: ≥2021 CN→2022.CN, ≥2021 KS→2022.KS, ≤2020→2019.KS) + gán ctdt_id cho SV đang NULL, cập nhật tbc, rồi chạy SQL dự đoán chuyên ngành.
2. Route ở `api/routes/tot_nghiep.py` (guard GIAOVU/ADMIN): `/tot-nghiep/bang-diem/preview` + `/apply` (multipart).
3. **Gợi ý chéo**: gọi `du_dieu_kien` với CẢ ctdt KS lẫn CN cùng khóa → nếu đủ ĐK theo loại khác loại đang gán thì gợi ý (dữ liệu có thể sai). **Thống kê** đủ/chưa đủ theo chuyên ngành × loại hình.
4. Web-admin: panel "Import điểm tổng hợp" + bảng thống kê trong tab Tốt nghiệp; chi tiết tận dụng `hoc_tap.chi_tiet`+`block_courses` sẵn có.
5. Deploy (rebuild hou-cntt-api) + test với file thật.
