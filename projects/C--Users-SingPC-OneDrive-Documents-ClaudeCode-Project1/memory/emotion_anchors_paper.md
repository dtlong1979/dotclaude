---
name: emotion-anchors-paper
description: "dự án NCKH tự động — bài báo \"lexical anchor reliance\" của emotion classifiers (matched-deletion), code + paper ở emotion-anchors/"
metadata: 
  node_type: memory
  type: project
  originSessionId: 60f73cd3-760f-47e5-acbb-93630219fc81
---

Dự án bài báo học thuật tự chạy (pipeline nhiều agent) về **lexical anchor reliance**: emotion classifier cổ điển (bag-of-words) phụ thuộc bao nhiêu vào một nhúm "anchor words", đo bằng **matched-deletion** (xoá anchor vs xoá từ non-anchor cùng tần suất) + document-bootstrap + permutation.

**Vị trí:** `C:\Users\SingPC\OneDrive\Documents\ClaudeCode\Project1\emotion-anchors` — git repo riêng, nhánh `anchor-reliance-study` (chưa push remote, chưa mở PR). Venv `.venv`, requirements pin cứng. Chạy CPU-only (Windows), Python 3.11.

**Dữ liệu (tải từ host gốc, không redistribute):** GoEmotions (google-research raw TSV), CARER/dair-ai emotion (HF parquet), ISEAR (github sinmaniphel), NRC EmoLex (mirror dinbav/LeXmo). Loader ở `experiments/data.py`, tải bằng `data/download.py`.

**Kết quả chính (mọi số truy về `experiments/RESULTS_DIGEST.md`, sinh từ `results_*.json`):** xoá ~20 anchor/lớp mất 40–75% macro-F1 trên-chance; xoá từ cùng tần suất gần như vô hại. Anchor-specific effect 0.16–0.34, CI loại 0. Bền qua m, subsample, EmoLex size-matched; retrain-không-anchor hồi phục rất ít. NB phụ thuộc anchor ít hơn linear (bền trong cùng representation). Emotion-vs-topic tuỳ corpus (ISEAR chủ yếu emotion words).

**Scope thật thà:** classical BoW + 1 frozen-transformer probe (run_09: DistilBERT mean-pooled + linear head, chạy THẬT trên CPU Windows với KMP_DUPLICATE_LIB_OK=TRUE ~15 phút). Probe cho anchor-specific effect nhỏ hơn BoW (0.22/0.18/0.14 vs 0.33/0.31/0.21) nhưng vẫn lớn+significant → contextual làm giảm chứ không thoát anchor reliance. Fine-tune ĐÃ CHẠY 5 SEED (user chạy colab_finetune_ablation.py trên Colab A100, seeds 0-4, results_10_transformer_finetune.json): fine-tuned là classifier tốt nhất (intact 0.61/0.89/0.65) NHƯNG anchor-specific vẫn ≈ BoW ở GoEmotions/CARER (0.325±0.002 / 0.324±0.007) và lớn ở ISEAR (0.167±0.005) → contextual mua độ chính xác chứ không thoát anchor lexicon. Std qua seed cực nhỏ (≤0.008) nên caveat "1 seed" đã bỏ. SCALING (results_11): thêm BERT-base + RoBERTa-base (5 seed) — model to hơn phân loại tốt hơn (RoBERTa intact 0.632/0.890/0.703, tốt nhất bài) nhưng anchor-specific gần như không đổi (GoEmo 0.325→0.310→0.300, CARER ~0.32, ISEAR ~0.16-0.18) → scale không thoát anchor. Table 14 trong §5.9. Repo GitHub private: github.com/dtlong1979/lexical-anchor-reliance (nhánh anchor-reliance-study), ĐÃ push đồng bộ. Đã làm sạch để publish: bỏ author/disclosure/dấu hiệu AI + phrasing môi trường (colab/sandbox) trong paper; strip hết comment+docstring trong code (behavior giữ nguyên, JSON byte-identical); xóa RESULTS_DIGEST.md/make_digest.py/check_paper_numbers.py; chỉ còn README+requirements làm docs. Còn lại: user điền author block. Table 13 có đủ 3 chế độ (BoW/frozen/finetuned). Đã qua ≥2 vòng review đối kháng (Sonnet) + convergence check. Lưu ý Colab: chỉ pip install transformers, ĐỪNG ghim sklearn/pandas cũ (gây numpy ABI break).

Master prompt yêu cầu: chạy thật mọi số, không bịa, trung thực scope, giọng người, tái lập được. Liên quan [[care_fusion_project]] (cũng là NCKH sentiment).
