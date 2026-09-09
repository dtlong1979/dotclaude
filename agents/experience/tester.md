# Sổ kinh nghiệm — tester
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

- **Khi** sắp dựa vào một cổng/bộ kiểm ĐANG XANH để kết luận "chỗ này đúng" → làm hỏng đúng cái mà nó khẳng định rồi xem nó có đỏ không; không đỏ nghĩa là nó đang khẳng định chính cái lỗi · vì đã gặp hai lần trong một dự án: một nhánh kiểm fixture chỉ khẳng định `mong đợi ⊆ nhận được` nên một lỗi 422 giả nằm trong cả 27 fixture mà cổng vẫn 51/51 xanh; và một cổng xanh khẳng định đúng cái bug điền sai kiểu mặc định làm 500 cả trang · độ tin: cao · 2026-09-09
- **Khi** sắp bật một cổng/lint viết bằng mẫu chính quy → chạy thử nó trên TOÀN BỘ hiện vật đang có trước khi bật, và thêm ranh giới từ vào mẫu · vì mẫu trần khớp chuỗi con và kêu oan: `success` khớp nhầm `successMode`, `number_format(` bắt oan chỗ in độ mờ chứ không in tiền, số điện thoại nằm trong `d="…"` của SVG, tên gói `lucide-static@1.43.0` bị nhận là địa chỉ thư — bảy lần trong một dự án · độ tin: cao · 2026-09-09
