---
name: hou-cntt-dang-ky-giu-cho-loadtest
description: Đăng ký tín chỉ hou-cntt chốt mô hình GIỮ CHỖ TTL 10 phút + kế hoạch load-test tìm điểm chết → đề xuất snapshot/circuit-breaker
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-14T13:58:26.084Z
---

**Đăng ký tín chỉ SV (hou-cntt) — mô hình ghế đã CHỐT: "giữ tạm có hạn (TTL) 10 phút".**
- Tạm thêm 1 lớp = GIỮ GHẾ ngay (bảng `dk_giu_cho(mssv,ma_lop_tc,het_han,tao_luc)`, atomic FOR UPDATE, đếm ghế = đăng ký thật + giữ-chỗ còn hạn). TTL = **10 phút** (hằng `GIU_CHO_PHUT`).
- Hủy lớp tạm = nhả ghế ngay (không hỏi lý do). Quá 10 phút chưa Xác nhận = **tự hủy** (lazy cleanup `het_han < now()`), client đếm ngược rồi tự gỡ khỏi UI + cập nhật Tổng TC/học phí + báo "đã tự hủy, thêm lại nếu muốn".
- **Xác nhận** = chốt HIỆN TRẠNG đang giữ (mật khẩu) → chuyển giữ-chỗ→đăng ký thật, KHÔNG tranh ghế lại; báo kết quả thành công cuối. Banner: "Mỗi học phần khi thêm sẽ được tạm giữ chỗ cho bạn trong 10 phút, hết 10 phút sẽ tự hủy và cần thao tác lại."
- Route: `/me/dang-ky/giu-cho`, `/me/dang-ky/nha-cho`, `/me/dang-ky/xac-nhan` (bỏ tham số `them` client), `/me/dang-ky` trả thêm `giu_cho`.

**Kế hoạch hiệu năng (user chốt "làm 1 trước"):** thêm INDEX (ket_qua_hoc_phan(mssv), dang_ky_hoc_ky(mssv/ma_lop_tc), ctdt_hoc_phan(ctdt_id), lop_tin_chi(nam_hoc,hoc_ky), lich_hoc(ma_lop_tc), dk_giu_cho) → **load-test tự tăng dần**: bắt đầu 300 CCU, mỗi lần +100, bắn endpoint đọc nặng (mint token test, chạy localhost trên server) tới khi GÃY → tìm điểm chết + nút cổ chai. Sau đó đề xuất: **PA1 snapshot** (bảng tổng hợp per-SV refresh theo sự kiện, test lại) hoặc **PA2 circuit-breaker** (đủ CCU thì từ chối người mới bằng 503 thay vì lỗi không xác định).

**Đã vá trước đó (nền tảng cho việc này):** "đã đạt/tiên quyết" khớp theo TÊN chuẩn hóa (helper `mon_khop.passed_failed_bac_cau`) vì 1 môn có nhiều hoc_phan_id; `graduation.block_credits`/`block_courses` tôn trọng chuyên ngành ĐÃ GÁN (không auto-max pattern). Xem [[hou_cntt_dang_ky_tin_chi]].
