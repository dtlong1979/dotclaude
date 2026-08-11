---
name: hou-cntt-block-credit-model
description: "Mô hình tính TC theo khối kiến thức hou-cntt (khối chuyên ngành 'chọn 1 khối' + Tự chọn) — nguyên tắc & bug NONE"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-11T10:36:33.386Z
---

**NGUYÊN TẮC (giáo vụ chốt 2026-08-11):** Môn chuyên ngành + môn tự chọn đều là "tự chọn". SV thuộc chuyên ngành nào thì khối **"Chọn 1 khối" (K6.CN)** CHỈ tính môn **định hướng đúng track** của SV; môn định hướng của **track KHÁC** và môn **tự do (ma_cn='NONE')** → **dồn sang khối "Tự chọn" (TC)**.

**BUG đã sửa (graduation.py):** chuyên ngành `NONE` ("Không theo chuyên ngành") có **id thật** (vd id=4, ctdt 1) chứ không NULL. Code cũ `_tc_khoi` lấy MAX-theo-track với logic chia sẻ `None in cns` → NONE biến thành **1 track riêng**, MAX chọn nhầm → đếm SAI (đồng thời **giấu** SV chưa hoàn tất chuyên ngành nào). Vd 22A1001D0268(SE) hiện 11 (đúng 10); 22A1001D0368(MT) hiện 8 (đúng: 8/10 **thiếu thật** vì thiếu "Lý thuyết thiết kế giao diện người dùng").

**MÔ HÌNH MỚI (`block_credits`):** dùng `chuyen_nganh_du_doan` của SV (`_declared_ma`). Khối CN: `dat = Σ TC môn ĐẠT có declared ∈ ma_cn`; môn ĐẠT khác track/tự do → `spill` → cộng vào khối TC (khử trùng theo hid). `_FW_CN` trả `cn.ma_cn` (SE/MT/NS/NONE), `_fw_by_block` gom set ma_cn. `cheo=True` hoặc SV chưa rõ CN → gộp mọi môn (nới). `block_courses` drill-down khớp: khối CN chỉ hiện môn đúng track + `da_dat_ngoai_track` (môn track khác, ghi "tính sang Tự chọn"); khối TC gộp thêm spillover (cờ `tu_chuyen_nganh`). Web app.js?v=22 + app graduation_section.dart đã render nhóm mới.

**HỆ QUẢ (đã kiểm chứng):** nhiều SV rải đều nhiều track mà không hoàn tất track nào giờ hiện **CN thiếu ĐÚNG** (vd 22A1001D0034/0109: mỗi track 5 TC, tổng ≥129 nhưng không track nào đủ 10). Đây là ca "đủ tổng TC nhưng chưa xong chuyên ngành" — cần bổ sung môn track. Liên quan [[hou_cntt_xet_tot_nghiep_import]] [[hou_cntt_ren_luyen_warnings]] [[hou_cntt_grade_import_scale_bug]].
