---
name: fithou-ai-key-config
description: "Khóa OpenAI của Fithou Website nhập ở /quan-tri/cau-hinh-ai (lưu DB), không còn hardcode env"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-29T02:26:49.089Z
---

Fithou Website: khóa API OpenAI (cho trợ lý AI, hỗ trợ viết bài, tạo ảnh) nhập tại **`/quan-tri/cau-hinh-ai`** (chỉ system_admin), lưu trong Directus singleton **`fithou_ai_config`** (openai_api_key/openai_model/openai_image_model). Có nút **Kiểm tra khóa** gọi thử OpenAI để biết khóa sống/hết quota/hết tiền.

Cơ chế: `lib/fithou-ai-config.ts` → `getOpenAiKey()` (cache 30s, ưu tiên DB, fallback `process.env.OPENAI_API_KEY`). Mọi nơi dùng key đã chuyển sang gọi runtime (KHÔNG còn hằng module `process.env.OPENAI_API_KEY`): 3 route editor AI (`ai/compose|image|improve`), `lib/fithou-ai.ts` (askFithouAi/callOpenAi/ocr*/embed*), `lib/fithou-ai-v2.ts` (polishWithOpenAi). Route quản lý: `app/api/fithou-ai/config` (GET masked, POST save|test).

⚠ Prod TRƯỚC ĐÂY hoàn toàn CHƯA có key nào (container + .env đều trống) → mọi tính năng AI báo "Chưa cấu hình". Không phải hết tiền — chỉ là chưa nhập. Giờ chỉ cần vào trang cấu hình dán khóa + Test. Xem [[fithou-website-local]], [[fithou-directus-branding-tz]].
