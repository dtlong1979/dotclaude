---
name: hou_cntt_bao_luu_thoi_hoc
description: hou-cntt có 2 bảng sv_bao_luu/sv_thoi_hoc + cờ chung sinh_vien.is_active=false để loại SV khỏi MỌI xử lý
metadata: 
  node_type: memory
  type: project
  originSessionId: 991648e5-4e5f-43c6-94f4-bc490d8d61e7
  modified: 2026-08-20T00:53:26.061Z
---

hou-cntt (2026-08-19): SV bảo lưu / thôi học là **hồ sơ lưu trữ**, hai bảng riêng — `sv_bao_luu` (quay lại được, unique 1 dòng `ket_thuc_luc IS NULL`) và `sv_thoi_hoc` (mssv PK, cột `loai` = THOI_HOC | CHUYEN_KHOA | BUOC_THOI_HOC). Service `backend/app/services/sv_nghi_hoc.py`, tab web-admin "Bảo lưu / Thôi học".

**Why:** trường gửi Excel 2 sheet (Bảo lưu / Thôi học, chuyển khoa nằm lẫn trong sheet thôi học); hai diện có vòng đời khác nhau nên không gộp một bảng.

**How to apply:** cờ loại trừ dùng chung là **`sinh_vien.is_active`** (đã là quy ước sẵn của hệ, KHÔNG tạo cờ mới) — mọi chỗ liệt kê SV phải lọc `is_active`; `xep_lop.goi_y`/`de_xuat_mo_lop` tự cộng `_ngung_hoc(db)` vào `exclude`. Đánh dấu = xóa `dang_ky_hoc_ky` + dk_giu_cho/dk_yeu_cau/dk_xac_nhan/dk_nguyen_vong_lop, chụp vào `dang_ky_cu` jsonb; quay lại học KHÔNG khôi phục lịch cũ. Tài khoản đăng nhập giữ nguyên. Liên quan: [[hou_cntt_app]], [[hou_cntt_dang_ky_tin_chi]], [[fithouone_coordination_hub]].
