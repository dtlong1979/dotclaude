---
name: care-fusion-in-monitor
description: "Hướng đang cân nhắc — dùng CARE-Fusion (text+emoji) phân loại bình luận trong HOU Sentiment Monitor, thay Gemini"
metadata: 
  node_type: memory
  type: project
  originSessionId: 098983c5-111d-4c37-8f4b-0192c1ed7235
---

Đề xuất (đang cân nhắc, chưa chốt — nêu ra 2026-06-28) cho [[hou_sentiment_monitor]]: thay bộ phân loại Gemini bằng **CARE-Fusion** (xem [[care_fusion_project]]) cho **bình luận**.

**Lý do:** mô hình 2 luồng "tiêu đề + nội dung" ở Chương 3 báo cáo NCKH không hợp với bình luận (chỉ text + emoji, không tiêu đề). CARE-Fusion là *fusion text + affective markers (emoji/emoticon)* — đúng bài toán; marker rỗng được Router tự xử như chế độ chỉ-văn-bản.

**Định hướng kiến trúc:**
- Báo cáo: bài viết → mô hình 2 luồng (giữ); bình luận → CARE-Fusion (động cơ chủ lực vì bài viết đã chốt chỉ tích cực/trung tính).
- Ánh xạ nhãn 6→3: positive/interest→Tích cực; sadness/anger/fear→Tiêu cực; neutral→Trung tính.
- Train offline trên Colab/Kaggle (GPU) → checkpoint + resources (q_table, đồ thị PMI, marker2id); inference chạy CPU được (~1.5–2GB RAM). VnCoreNLP→pyvi để bỏ Java.
- Triển khai khuyến nghị: **microservice CARE-Fusion riêng** (`POST /classify`), monitor gọi qua API. Điểm cắm trong code: thêm engine `care_fusion` vào `classify_text()` (đã có sẵn nhánh heuristic/llm/phobert trả `SentimentResult`).

**Chưa làm:** F1 phải lấy từ lần chạy protocol đầy đủ (chưa điền số vào báo cáo). Code CARE-Fusion ở `D:\dev\care-fusion-sentiment-detection-vi` (đã có `engine.predict()`, model 6 lớp).
