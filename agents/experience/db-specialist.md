# Sổ kinh nghiệm — db-specialist
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

> **Khi** cần dữ liệu mẫu cho một thực thể/bảng mới trong hệ có tầng ghi riêng (API, service, form request) → tạo bằng **chính đường ghi đó**, đừng viết seeder ghi thẳng `DB::table()`/`INSERT` · vì seeder bỏ qua validation, normalize và chuẩn hoá nên tạo được dữ liệu mà đường thật không cho phép, đồng thời che mất chính lỗi cần phát hiện; đi đường thật còn lộ luôn lỗi có sẵn ở tầng ghi · cao · 2026-09-08

> **Khi** một hệ **suy** cột và ràng buộc CSDL từ lược đồ khai báo (`unique:`, `normalize`, `max`) → chạy `SHOW CREATE TABLE` sau khi sinh và đối chiếu **từng** ràng buộc, đừng tin lược đồ đã thành ràng buộc thật · vì quy tắc kiểu `unique` thường chỉ sinh validation tầng ứng dụng còn bảng chỉ có chỉ mục thường, và cột chuẩn hoá hay bị cắt cứng độ dài trong khi trường nguồn dài hơn — hậu quả chỉ hiện ở đường ghi không qua ứng dụng, tức muộn và đắt · cao · 2026-09-08
