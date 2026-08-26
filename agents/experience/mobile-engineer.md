# Sổ kinh nghiệm — mobile-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

- **Khi** thêm plugin đọc/chọn tệp trong Flutter (vd file_picker) → đảm bảo compileSdk ≥ 36, nếu không build sẽ lỗi. · vì đã dính khi làm tính năng đính kèm tệp · độ tin: cao · 2026-08-03

> **Khi** tạo file Dart mới mà mở đầu bằng doc-comment `///` mô tả CẢ FILE (không gắn class/hàm nào ngay dưới) → dùng `//` cho khối đó, hoặc thêm directive `library;` ngay dưới doc-comment · vì `flutter analyze` báo `dangling_library_doc_comments` (info-lint) → khi yêu cầu là "analyze sạch / No issues found" thì info-lint này thành CHẶN · độ tin: cao · 2026-08-26

> **Khi** tách god file Dart bằng `library`/`part`/`part of` để giữ truy cập private xuyên file → đặt directive đúng thứ tự Dart: `library` → `import` → `part` (library PHẢI đứng TRƯỚC import, không phải chỉ trước part) · vì đặt `library` sau import báo `library_directive_not_first` → chặn "analyze sạch" · độ tin: cao · 2026-08-26

> **Khi** di trú UI Flutter sang design-system, gặp `Card` bọc `ExpansionTile`/`ListTile` → KHÔNG ép sang `AppCard` (AppCard tự chèn padding → phá layout tile; `Card` vốn lấy màu/viền từ `cardTheme` nên KHÔNG phải "màu cứng" cần đổi). Chỉ chuyển `Card`+`Padding`+`Column` → `AppCard` (nhớ bỏ 1 lớp `)` khi gỡ `Padding`) · vì thay máy móc dễ vỡ bố cục tile · độ tin: trung bình-cao · 2026-08-26

> **Khi** lấy ký tự đầu chuỗi ở Dart bằng `(x ?? '?').characters.first` (hay `.first`/`[0]`) → nhớ `??` CHỈ chặn null, KHÔNG chặn chuỗi RỖNG; `''` qua `??` rồi `.characters.first` ném `StateError: No element`. Phải kiểm `isEmpty` riêng: `s.isEmpty ? '?' : s.characters.first` · vì crash avatar khi ho_ten='' · độ tin: cao · 2026-08-27
