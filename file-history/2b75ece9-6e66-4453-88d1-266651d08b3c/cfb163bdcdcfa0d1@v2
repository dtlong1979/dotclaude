---
name: it-journal-tracker
description: Danh mục tạp chí ngành CNTT/AI có tính khả thi cao để nộp bài, kèm theo dõi tình trạng nộp (chưa nộp, đang phản biện, đã đăng, bị từ chối, số bài, ngày nộp). Dùng khi cần chọn tạp chí để nộp một bài mới, tra phí đăng và thời gian phản biện, cập nhật kết quả sau khi nộp/nhận phản hồi, hoặc bổ sung một tạp chí mới vào danh mục.
---

# Danh mục và theo dõi tạp chí CNTT/AI

Dữ liệu nằm ở `du-lieu/tap-chi.csv` (UTF-8, phân tách bằng dấu phẩy, mở được bằng Excel).
Mỗi dòng là một tạp chí. Đọc tệp này trước khi trả lời bất kỳ câu hỏi nào về tạp chí.

## Khi người dùng hỏi "nộp bài này ở đâu"

1. Đọc `du-lieu/tap-chi.csv`.
2. Hỏi hoặc suy ra 3 điều: **chủ đề bài**, **mức ưu tiên** (cần nhanh / cần hạng cao / không trả phí), **hạn nộp nếu có**.
3. Lọc theo `pham_vi`, rồi xếp theo tiêu chí ưu tiên:
   - Cần nhanh: xếp theo `thoi_gian_thuc_te` tăng dần.
   - Không muốn trả phí: chọn `mo_hinh` là `hybrid` (đăng thường miễn phí) hoặc `free`.
   - Cần Q1: lọc `hang` = Q1.
4. Trả lời 3–5 lựa chọn, mỗi lựa chọn nêu: hạng, thời gian thực tế, phí, độ khó, và tình trạng nộp bài hiện có (tránh gợi ý nơi vừa bị từ chối cùng một bài).

## Khi có thay đổi tình trạng

Cập nhật đúng dòng trong CSV, không tạo dòng mới:

| Sự việc | Cập nhật |
|---|---|
| Nộp một bài | `trang_thai` = `Đang phản biện`; `so_bai_da_nop` +1; `ngay_nop_gan_nhat` = ngày nộp; ghi tên bài vào `bai_dang_xu_ly` |
| Được chấp nhận | `so_accept` +1; `trang_thai` = `Đã đăng`; xóa tên bài khỏi `bai_dang_xu_ly`; ghi thời gian thực tế vào `thoi_gian_thuc_te` và `nguon_thoi_gian` = `tự trải nghiệm` |
| Bị từ chối | `so_reject` +1; `trang_thai` = `Đã nộp, chưa đăng`; xóa khỏi `bai_dang_xu_ly`; ghi lý do vào `ghi_chu` |
| Rút bài | `so_bai_da_nop` giữ nguyên, ghi rõ ở `ghi_chu` |

Luôn đặt `cap_nhat` = ngày hôm nay (YYYY-MM-DD) cho dòng vừa sửa.

Giá trị hợp lệ của `trang_thai`: `Chưa nộp`, `Đang phản biện`, `Đã đăng`, `Đã nộp, chưa đăng`.
Giá trị hợp lệ của `do_kho`: `Thấp`, `Vừa`, `Cao`.

## Khi bổ sung một tạp chí mới

Tra và điền đủ các cột. Ba thông tin hay sai nếu chỉ dựa vào trí nhớ, phải kiểm tra trên web tại thời điểm bổ sung:

- **Phí đăng**: lấy từ trang chính thức của nhà xuất bản, không lấy từ trang tổng hợp thứ ba. Ghi rõ năm khảo giá trong `ghi_chu`.
- **Hạng Q**: theo SJR năm gần nhất; ghi kèm năm.
- **Mô hình**: `hybrid` (đăng thường miễn phí, chỉ trả phí nếu chọn mở), `gold` (bắt buộc trả phí), `free` (không thu phí).

Ưu tiên vào danh mục những tạp chí có ít nhất một trong các đặc điểm: đã có người quen công bố được, phản biện dưới 6 tháng, hoặc không thu phí.

## Lưu ý khi tư vấn

- Phí niêm yết thay đổi hằng năm; luôn nhắc người dùng kiểm tra lại trước khi nộp.
- Elsevier áp giá theo thu nhập quốc gia cho tạp chí mở hoàn toàn, nên mức thực trả của tác giả Việt Nam thường thấp hơn bảng niêm yết.
- Với tạp chí `hybrid`, nếu không chọn xuất bản mở thì **không mất phí**. Đây là đường đi rẻ nhất để có bài Q1.
- Cột `thoi_gian_thuc_te` ghi số liệu quan sát được (từ bài thật), đáng tin hơn thời gian nhà xuất bản công bố. Khi dùng số liệu này, nói rõ nguồn ở cột `nguon_thoi_gian`.
- Không suy đoán hạng Q hay phí khi cột đang để trống; tra lại rồi mới trả lời.
