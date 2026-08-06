---
name: write-nlp-method-results
description: >-
  How to write the METHODS and RESULTS/EXPERIMENTS of an empirical IT / computer-science paper (AI, NLP, ML, IR,
   software engineering, security) in English for Q1 journals. Methods: reproducibility-first — data and preproc
  essing, model, training details (seeds, hardware, model selection), fair baselines, metrics with a reason, eth
  ics/data statements. Results: present WHAT not WHY, mean and standard deviation over seeds, significance tests
  , points vs percent, honest reporting of losses, ablations and error analysis, table-text consistency. Include
  s English sentence frames, tense and voice, reviewer red flags, non-native-English fixes. Extra-tuned for Viet
  namese/low-resource data (word segmentation, diacritics, Unicode NFC, annotation and inter-annotator agreement
  ). Pair with the write-nlp-paper master. Use when drafting or reviewing the methods, experimental setup, resul
  ts, or experiments. Triggers: 'viet phan methods', 'lam results manh hon', 'reproducibility', 'significance te
  st', 'ablation'.
---

# IT/CS paper — Methods + Results/Experiments

Skill con của [[write-nlp-paper]]. Lo **hai phần**: Methods và Results/Experiments (lõi thực nghiệm). Đọc reference
TRƯỚC khi viết; nạp thêm **master** cho 8 nguyên tắc + thẻ tiếng Việt dùng chung.

- Methods / Approach → `references/04-methods.md`
- Results / Experiments → `references/05-results.md`

## Quy luật cốt lõi (rút gọn)

**Methods (kim chỉ nam: TÁI LẬP ĐƯỢC)**
- Viết như thể bạn vắng mặt: reviewer + code + data dựng lại được kết quả. "suitable/standard/tuned appropriately" = lỗ hổng.
- Tiểu mục: Problem formulation → Data & preprocessing → Model → Training (optimizer, LR, batch, **seed**, phần
  cứng, model-selection) → Setup → **Baselines công bằng** → **Metrics có lý do** → Ethics/data statement.
- Phân biệt **"we propose"** (đóng góp) vs mô tả setup (Adam/LR không phải "propose"); thì: past cho việc đã làm, present cho mô tả mô hình.
- Tiếng Việt: tách từ + **mức token**; dấu thanh; **Unicode NFC/NFD**; emoji/teencode; annotation + **IAA (κ)** (báo κ dù thấp).

**Results (TRÌNH BÀY, không diễn giải sâu)**
- Results = *WHAT*; *WHY/SO-WHAT* để Discussion. Câu nào có thể sai dù bảng đúng → là diễn giải, đẩy đi.
- Mỗi "tốt hơn" cần: tốt hơn **ai** + **bao nhiêu** (points, absolute/relative) + **significance test** (p/CI).
- **mean±std ≥3–5 seed**; dataset nhỏ → **bootstrap CI**. "significant" chỉ khi CÓ test; hiệu số % là **points**.
- So sánh **cùng điều kiện** và nói rõ; **trung thực báo cả chỗ thua**; ablation + error analysis; số văn = số bảng, bold đúng ô.
- Tránh over-claim "SOTA" khi chỉ hơn baseline yếu.

Chi tiết + sentence frames + ví dụ trước→sau: xem hai file reference.
