---
name: ai_detector_vn_study
description: nghiên cứu thực nghiệm đo tỷ lệ báo nhầm (false positive) của AI detector trên abstract học thuật tiếng Việt người-viết-100% pre-ChatGPT
metadata: 
  node_type: memory
  type: project
  originSessionId: 340da358-a15c-4ff9-9b26-ede1caad9e6d
---

Bài báo NCKH thực nghiệm: đo **false positive rate** của các công cụ phát hiện văn bản AI trên abstract học thuật **tiếng Việt** do người viết 100%, công bố **năm ≤ 2021** (chắc chắn pre-ChatGPT). Mọi nhãn "AI" = báo nhầm.

Quyết định thiết kế (khởi tạo 2026-07-15):
- Chỉ dùng **abstract** (không dùng cả bài) → vừa quota tool free, đồng nhất độ dài. Abstract cô đặc/khuôn mẫu nên hay bị gắn oan AI — chính là điểm bán bài.
- Nguồn dữ liệu: **VJOL** (vjol.info.vn) qua **OAI-PMH** (hợp lệ, máy đọc; web UI bị WAF chặn "999 No Hacking"). Metadata `lang` KHÔNG tin được → phát hiện tiếng Việt bằng mật độ ký tự có dấu.
- Góc mới để đăng (Q3/Q4 hoặc tạp chí trong nước): tập trung **tiếng Việt** (đa số nghiên cứu detector là tiếng Anh) + confusion matrix đầy đủ (thêm corpus sinh bằng GPT) + hàm ý chính sách liêm chính học thuật VN.

Code: `ClaudeCode/Project1/ai-detector-vn/` — harvest_vjol.py (OAI-PMH, stdlib), detector_run.py (adapter: sapling/gptzero/dry, key qua secrets.json), analyze.py (FPR + Wilson CI + Fleiss-style đồng thuận). Đã có 110 abstract sạch trong data/abstracts.jsonl. Pipeline chạy thông (dry-run OK).

Trạng thái 2026-07-15: pilot chờ user tự lấy **API key free Sapling + GPTZero** (điền vào secrets.json) để ra số thật. Hạn chế: dữ liệu đang dồn 1 tạp chí (Mỏ–Địa chất), cần đa dạng nguồn khi chạy chính thức.

Liên quan: [[fake_news_slr_paper]], [[emotion_anchors_paper]] (cùng phong cách bài thực nghiệm tự chạy CPU của user).
