---
name: hou-cntt-block-credit-model
description: "Mô hình tính TC theo khối kiến thức hou-cntt (khối chuyên ngành 'chọn 1 khối' + Tự chọn) — nguyên tắc & bug NONE"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-11T11:24:05.671Z
---

**NGUYÊN TẮC (giáo vụ chốt 2026-08-11):** Môn chuyên ngành + môn tự chọn đều là "tự chọn". SV thuộc chuyên ngành nào thì khối **"Chọn 1 khối" (K6.CN)** CHỈ tính môn **định hướng đúng track** của SV; môn định hướng của **track KHÁC** và môn **tự do (ma_cn='NONE')** → **dồn sang khối "Tự chọn" (TC)**.

**BUG đã sửa (graduation.py):** chuyên ngành `NONE` ("Không theo chuyên ngành") có **id thật** (vd id=4, ctdt 1) chứ không NULL. Code cũ `_tc_khoi` lấy MAX-theo-track với logic chia sẻ `None in cns` → NONE biến thành **1 track riêng**, MAX chọn nhầm → đếm SAI (đồng thời **giấu** SV chưa hoàn tất chuyên ngành nào). Vd 22A1001D0268(SE) hiện 11 (đúng 10); 22A1001D0368(MT) hiện 8 (đúng: 8/10 **thiếu thật** vì thiếu "Lý thuyết thiết kế giao diện người dùng").

**ĐẶC THÙ "CNTT KHÔNG PHÂN CHUYÊN NGÀNH" (track NONE) — QUAN TRỌNG:** NONE là 1 LỰA CHỌN chuyên ngành thật, yêu cầu = **4 môn**: 1 môn cố định (Nhập Môn CNPM, `nhom_tu_chon` NULL) + **mỗi CẶP chọn 1** trong 3 nhóm `nhom_tu_chon` (CN.NONE.G1 Web|Mobile; G2 Lý thuyết TKGDND|Quản trị Linux; G3 An ninh mạng|Thiết kế đồ họa) = 10 TC. Cột **`ctdt_hoc_phan.nhom_tu_chon`** mã hóa các cặp này.

**MÔ HÌNH (`block_credits` + `_cn_patterns`):** khối K6.CN `dat = MAX` hoàn tất trong {track SE, MT, NS (gộp môn định hướng của track = 10), gói NONE (cố định + mỗi cặp chọn 1)}. `du = dat>=10`. Môn ĐẠT KHÔNG thuộc pattern THẮNG → `spill` → cộng khối TC (khử trùng hid). `_FW_CN` trả `cn.ma_cn`+`nhom_tu_chon`; `_fw_by_block` gom set `(ma_cn,nhom)`. `_cn_patterns` trả `(dat, used_hids, label)`. `cheo=True` → gộp mọi môn (nới). `block_courses` khớp pattern thắng: khối CN chỉ hiện môn trong pattern + `da_dat_ngoai_track`; khối TC gộp spillover (`tu_chuyen_nganh`); trả `pattern_chuyen_nganh` (SE/MT/NS/NONE) để UI hiện "Xét đủ khối theo:". Web app.js?v=23 + app 0.1.4+5.

**HỆ QUẢ (đã kiểm chứng):** SV rải nhiều track mà thỏa gói NONE giờ **ĐỦ đúng** qua pattern NONE (vd 22A1001D0034/0109). SV không hoàn tất track nào LẪN NONE mới thiếu thật (vd 22A1001D0368 thiếu "Lý thuyết TK GDND"). Khóa 2022: 71 đủ (MT34/SE30/NS4/NONE3), chỉ 1 SV "đủ tổng nhưng CN thiếu". **CẢNH BÁO còn treo:** `chuyen_nganh_du_doan` (db/08) KHÔNG dự đoán NONE → SV thắng qua NONE vẫn hiện nhãn "dự đoán MT/SE" ở header (lệch); block vẫn đúng. Nên nâng dự đoán nhận NONE sau. Liên quan [[hou_cntt_xet_tot_nghiep_import]] [[hou_cntt_ren_luyen_warnings]] [[hou_cntt_grade_import_scale_bug]].
