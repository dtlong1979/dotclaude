---
name: fithou-tai-khoan-test
description: "Các tài khoản test trên hou-cntt production — cái nào ĐƯỢC GIỮ, đừng gỡ"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 991648e5-4e5f-43c6-94f4-bc490d8d61e7
  modified: 2026-08-26T04:11:57.871Z
---

Trên hou-cntt production có vài tài khoản tên kiểu test/demo. **KHÔNG tự ý gỡ** — hỏi trước.

- **`svdemo`** (gắn `mssv=26A1001D0011`, có mật khẩu cục bộ) — **tài khoản của chính user** để đăng nhập kiểm chứng tình trạng sinh viên. **GIỮ.** Tôi đã gỡ nhầm 26/08/2026 rồi phải khôi phục.
- `sv.review.play`, `gv.review.play` (+ hồ sơ `TEST000001` "Sinh viên Thử nghiệm (Play Review)") — cặp tài khoản duyệt Google Play, ghi chú "KHÔNG XOÁ". **GIỮ.** Đừng đặt `is_active=false` cho TEST000001: `_mssv_dang_hoc` sẽ chặn mọi thao tác ghi và trả 403 "bảo lưu/thôi học", người duyệt app dễ đánh trượt.
- `admin_test`, `giaovu_test`, `vanphong_test`, `gv_test`, `giangvien_test`, `gvdemo` — tài khoản test cấp quản trị, **chưa hỏi user**, chưa xử lý.
- `sv_test` — đã gỡ 26/08/2026 theo yêu cầu user (nó gắn nhầm vào MSSV thật 21A100100036 Đào Gia Bảo).

**Why:** user dùng chính tài khoản sinh viên thật để kiểm tra giao diện SV; thấy "tài khoản test gắn vào SV thật" mà tưởng là rác rồi gỡ là cắt mất công cụ làm việc của user.

**How to apply:** phát hiện tài khoản tên test/demo trên production → BÁO, không gỡ. Chỉ gỡ khi user nói rõ tên tài khoản đó.
