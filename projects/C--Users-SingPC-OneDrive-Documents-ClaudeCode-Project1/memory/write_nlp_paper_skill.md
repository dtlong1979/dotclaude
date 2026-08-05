---
name: write-nlp-paper-skill
description: "Skill viết bài báo Q1 NLP/AI theo từng phần (abstract→conclusion), grounding bài thật + tuned cho tiếng Việt/low-resource"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 10f52cab-5b52-4c22-8c8e-667442039952
  modified: 2026-08-05T16:00:14.075Z
---

Skill **`write-nlp-paper`** ở `~/.claude/skills/write-nlp-paper/` (user-level, sync đa máy qua dotclaude) — hướng dẫn viết/soát TỪNG PHẦN bài báo Q1 AI/NLP tiếng Anh.

- `SKILL.md` = điểm vào: 7 nguyên tắc trùm, thẻ tiếng Việt/ít tài nguyên, kill-list lỗi non-native, thứ tự viết, lưu ý tra cứu.
- `references/01..07-*.md` = phân tích từng phần (moves, sentence frames EN, thì/giọng, reviewer red flag, lỗi non-native, checklist, ví dụ trước→sau). Do 7 subagent `researcher` chạy song song, mỗi agent grounding bằng ví dụ THẬT từ ACL/EMNLP/arXiv (PhoBERT, ViSoBERT, HANS, Gururangan, EURO-5K…).
- `references/GUIDELINE.md` = tổng hợp xuyên phần: dòng chảy tu từ toàn bài, **ma trận chống-trùng-lặp** (cùng phát hiện, 4 giọng), bảng thì/giọng, kỷ luật thống kê, playbook tiếng Việt, checklist nộp 1 trang.
- `references/08-journal-submission-requirements.md` = chiều TUÂN THỦ NỘP BÀI (bổ sung, rút từ audit 50 tạp chí AI/NLP/IT): họ nhà xuất bản, Highlights/Data-Availability/Declarations, **vị trí khai AI khác nhau theo NXB**, ẩn danh, cover letter, reference style, LaTeX style-file, triết lý duyệt **novelty vs soundness**, desk-reject kill-list, lưu ý TALLIP/NEJLT cho tiếng Việt. Raw audit 10 batch ở `journal-guidelines/agent-01..10-*.md`.
- **Bài học tra cứu (đã dùng):** site publisher chặn WebFetch (ScienceDirect/ACM/Cell/PeerJ 403, Cambridge 429, computer.org JS, cis.ieee.org 418; nature/springer redirect cookie IDP) → dùng WebSearch trích + trang policy chung; Springer vượt bằng idp.springer.com/authorize→code. Toàn văn section NLP: arxiv.org/html hoặc ar5iv.labs.arxiv.org, KHÔNG .pdf/aclanthology landing.

Bản gốc (trước khi copy vào skill) còn ở `Project1/paper-writing-guideline/`. Tuned theo trục novelty của chương trình surface-reliance: **Latin + dấu thanh** (KHÔNG "đơn lập"). Bổ trợ [[emotion_anchors_paper]], [[ai_detector_vn_study]]; khác `write-abstract` (chỉ abstract) và `strengthen-review-paper` (bài review, không thực nghiệm).
