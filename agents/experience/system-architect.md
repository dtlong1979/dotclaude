# Sổ kinh nghiệm — system-architect
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

<!-- Chưa có bài học. Chỉ thêm sau khi user đồng ý — xem C:/Users/SingPC/.claude/agents/LEARNING.md -->

> **Khi** phải quyết rebuild-vs-refactor cho app mobile/client bị cho là "không bám kịp backend/web" → ĐO nợ dữ liệu trước bằng số cụ thể (đếm model có `fromJson`; đếm số lần truy cập `Map`/index động; đếm dòng file lớn nhất) rồi mới chấm điểm có trọng số · vì "không bám kịp" thường là bài toán TỐC ĐỘ + HỢP ĐỒNG API (thiếu tầng model → web đổi field là vỡ lúc chạy), refactor thêm tầng data/repo chữa được mà rebuild thì ném đi phần đắt & đang đúng (auth/refresh, WS, FCM, design system) — ở ca FithouOne 2026-08: 0 model / 910 Map động → refactor 51/60 vs rebuild 31/60 · độ tin: vừa-cao · 2026-08-26
