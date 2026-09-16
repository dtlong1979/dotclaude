# Sổ kinh nghiệm — data-analyst
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.
- **Khi** ước lượng prevalence của hiện tượng hiếm (π < 1e-3) bằng classifier → cân nhắc bỏ Rogan-Gladen; dùng high-recall screen + đọc tay TOÀN BỘ dương tính + ước recall bằng seeding mẫu nhân tạo · vì ở π=1e-4 cần Sp ≥ 0.99991 mới PPV 50%, R-G có thể ra âm và CI bị chi phối bởi cỡ validation set · độ tin: cao · 2026-09-16
