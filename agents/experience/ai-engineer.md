# Sổ kinh nghiệm — ai-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.
- **Khi** thiết kế A/B đo tác động của can thiệp văn bản lên LLM-as-judge → thêm placebo arm (câu trung tính, khớp độ dài, cùng vị trí), RANDOMIZE thứ tự thực thi các call theo thời gian, và log `cache_read_tokens` · vì verbosity bias, drift model theo thời gian và prompt-cache hit tương quan với vị trí chèn đều tạo "hiệu ứng" giả không gỡ được sau khi chạy · độ tin: cao · 2026-09-16
