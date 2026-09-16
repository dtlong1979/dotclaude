# Sổ kinh nghiệm — security-specialist
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.
- **Khi** đề xuất phòng thủ prompt injection cho hệ LLM-as-judge/evaluator → kiểm tra trước ranh giới "lệnh vs dữ liệu" có TỒN TẠI không; nếu payload nằm trong chính nội dung phải chấm thì delimiter/spotlighting/StruQ và IFC/capability-confinement không áp dụng được về cấu trúc → hướng sang evidence-grounding/information bottleneck · vì phản xạ "injection → spotlighting" từng khiến cả mục phòng thủ vô giá trị · độ tin: cao · 2026-09-16
