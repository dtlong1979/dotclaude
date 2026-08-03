# Sổ kinh nghiệm — wp-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

- **Khi** đóng gói ZIP plugin/theme để giải nén trên **Linux** → dùng PHP ZipArchive (dấu `/`), KHÔNG dùng PowerShell Compress-Archive (dấu `\` làm hỏng giải nén trên Linux); lưu ý heredoc Bash nuốt dấu `\`. · vì đã dính lỗi giải nén thật · độ tin: cao · 2026-08-03
