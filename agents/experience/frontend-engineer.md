# Sổ kinh nghiệm — frontend-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

- **Khi** một tính năng chạy ở HAI chế độ kết xuất (trang công khai / trình soạn, có JS / không JS, máy chủ / trình duyệt) → viết phép kiểm cho cả hai chế độ ngay từ đầu, đừng suy ra chế độ kia từ chế độ đã kiểm · vì đã tái phát tám lần trong một dự án: JS của mọi khối chưa từng chạy ở trang công khai vì mọi bộ kiểm đều chạy trong trình soạn; và prop responsive được kiểm lúc lưu nhưng không ai đọc lúc kết xuất, nên một trong mười yêu cầu hay gặp nhất của khách chưa bao giờ chạy · độ tin: cao · 2026-09-09
