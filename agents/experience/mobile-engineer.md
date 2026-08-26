# Sổ kinh nghiệm — mobile-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

- **Khi** thêm plugin đọc/chọn tệp trong Flutter (vd file_picker) → đảm bảo compileSdk ≥ 36, nếu không build sẽ lỗi. · vì đã dính khi làm tính năng đính kèm tệp · độ tin: cao · 2026-08-03

> **Khi** tạo file Dart mới mà mở đầu bằng doc-comment `///` mô tả CẢ FILE (không gắn class/hàm nào ngay dưới) → dùng `//` cho khối đó, hoặc thêm directive `library;` ngay dưới doc-comment · vì `flutter analyze` báo `dangling_library_doc_comments` (info-lint) → khi yêu cầu là "analyze sạch / No issues found" thì info-lint này thành CHẶN · độ tin: cao · 2026-08-26
