---
name: hou-cntt-grade-import-scale-bug
description: "Bug import điểm hou-cntt — thiếu cột \"thang 4\" làm dat=False hàng loạt (SV nợ oan); đã vá scale-aware"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-11T07:57:31.247Z
---

**LỖI (2026-08-10):** Rất nhiều SV hiện "nợ hết học phần / 0 TC" ở màn tốt nghiệp DÙ có GPA thật — **KHÔNG mất dữ liệu**, mà cột `ket_qua_hoc_phan.dat` (đạt/không) bị tính sai hàng loạt.

**Gốc rễ:** Import bảng điểm (`app/services/importer/grades.py` DIEM + `bang_diem.py` "tổng hợp") đặt `dat = (he4 is not None and he4 >= PASS_HE4)` (PASS_HE4=1.0). Khi **nguồn THIẾU cột "thang 4"** (`_courses` không thấy label "thang 4" ở dòng 7 → `c4=None` → `he4=None`) thì **dat=False cho MỌI môn**; đồng thời điểm **thang-4 bị đọc vào `diem_so`** (cột he10, do `c10` default về anchor). → điểm D/C/B (1.0–3.9) = đã đạt bị đánh trượt.

**graduation.py CHỈ tin cột `dat`** (không tự tính lại) → cả màn tốt nghiệp/tiến độ sai theo.

**Cách nhận diện:** `avg(diem_so) ≈ sinh_vien.tbc_he4` và `max(diem_so) ≤ 4.0` ⇒ `diem_so` thực chất là **thang 4**. Toàn hệ ~1243 SV nợ-hết (1219 có GPA≥1 = sai).

**ĐÃ XỬ LÝ:**
1. Vá code (đứt điểm): thêm `tinh_dat(he4, he10)` + `he4_hieu_luc(he4, he10)` trong grades.py, dùng ở cả grades.py & bang_diem.py. Logic: có he4 → đạt he4≥1.0; thiếu he4 → suy thang từ điểm: **≤4 là thang-4 (đạt≥1.0), >4 là thang-10 (đạt≥4.0)** + backfill diem_he4. Đã deploy hou-cntt-api.
2. Vá data tạm: recompute `dat=(diem_so>=1.0)` + `diem_he4=diem_so` cho 1211 SV thang-4 an toàn (khớp GPA). Backup: bảng `ket_qua_hoc_phan_bak_20260810`.

**LƯU Ý KHI RE-IMPORT:** giờ import đã tự xử lý nguồn thiếu cột "thang 4". Nhưng tốt nhất **bảng điểm nguồn nên có nhãn cột rõ "thang 4"/"thang 10"** ở dòng 7 để map chuẩn. Đạt = hệ 4 ≥ 1.0. Liên quan [[hou_cntt_xet_tot_nghiep_import]] [[hou_cntt_app]].
