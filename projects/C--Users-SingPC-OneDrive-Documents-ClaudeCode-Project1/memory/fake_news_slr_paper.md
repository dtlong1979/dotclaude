---
name: fake-news-slr-paper
description: "Bài SLR \"Content- and Context-Based Fake News Detection\" nộp tạp chí JCTA; đã tái lập bằng corpus thật kiểm chứng"
metadata: 
  node_type: memory
  type: project
  originSessionId: 18f83c04-f297-4f5f-b3b8-70edb47e6bf4
  modified: 2026-08-07T07:28:47.049Z
---

Bài báo systematic literature review của user (Dinh Tuan Long, Le Ngoc An, Dinh Thai Duong — HOU + VNU) về phát hiện tin giả, nộp tạp chí **JCTA** (Journal of Computing Theories and Applications). Template gốc ở `D:\Downloads\JCTA_Template.docx` (yêu cầu ≥60 tài liệu cho review, abstract ≤300 từ, style `*_JCTA`).

**Lịch sử xử lý (2026-07-13):**
1. Bản 1 — sửa theo góp ý reviewer + đổi tiêu đề sang "Content- and Context-Based" (mở rộng scope để hợp thức GNN): `D:\Downloads\Fake_News_Detection_SLR_JCTA_revised.docx`.
2. Bản 2 (chính) — **tái lập nghiêm túc bằng dữ liệu thật**: `D:\Downloads\Fake_News_Detection_SLR_JCTA_reconstructed.docx` + gói repo `D:\Downloads\fake-news-slr-supplementary\` (corpus 43 nghiên cứu verified, script analyze.py, 6 hình tự vẽ).

**Phương pháp trung thực đã dùng (quan trọng):** thay vì bịa PRISMA funnel + gộp mean±SD, dùng **corpus liệt kê + sàng lọc verifiability** — 50 ứng viên → 43 verified (mỗi số kiểm chứng với nguồn gốc) → 40 core. KHÔNG chuyển đổi metric, KHÔNG pool; chỉ so sánh trong cùng (dataset, task). Mọi bảng/hình sinh từ corpus qua analyze.py.

**Các con số THẬT (sau khi thêm [15] và xếp lại [11]→Multimodal):** corpus **44 nghiên cứu / 41 core**; family share Transformer 31.7% / Multimodal 26.8% / LLM 22.0% / Graph 14.6% / Traditional 4.9%. LLM accuracy 48.6–89% (median ~73%, KHÔNG phải 87.5%). **GPT-4 trên LIAR-binary = 68.2% (không phải 95.3%)** — đính chính lớn nhất. Multimodal trên Weibo 82.4–91.8% (matched).

**Nâng cấp thành "conceptual review" (theo editor, 14 mục):** đổi tiêu đề → "A Structured, Verifiability-Focused Review…"; thêm khung 4 trục Evidence-Time-Adaptation-Objective (Fig1) + bảng so sánh 9 survey (Table1) + bảng trade-off + bảng cause-effect gaps + bảng risk-of-bias matrix; 6 RQ phân tích; trends viết lại thành 5 stage tiến hóa; thêm 5.4 Mechanisms + phân biệt reported/validated/transferable; priorities; bài học low-resource. Build dùng **auto-numbering token {T:label}/{F:label}** (TABLE_ORDER/FIG_ORDER trong build_docx). 74 refs (thêm survey [70]-[74] + PRISMA2020 [69]). 12 bảng, 7 hình.

**Tiêu đề chốt:** "A Verifiability-Focused Review of Content- and Context-Based Fake News Detection Methods" (bỏ "Systematic Literature Review"). File docx đổi tên khớp tiêu đề. Có **thư phản hồi editor**: `D:\Downloads\Response-to-Editor - Fake News Detection Review.docx` (make_response.py). Bảng rộng (Table 1 survey, Table 9 trade-off) để **landscape** (build_docx có _make_sectpr/_add_sect_para). LƯU Ý build: token {T}/{F} phải đồng bộ giữa body files VÀ cleanups.py (đổi số bảng/hình → phải chạy lại token-convert trên cleanups, nếu không REPL/NUM mất tác dụng).

**Đã audit 68 tài liệu (3-agent):** sửa ~13 lỗi trích dẫn + thay 1 tài liệu bịa [47] (→ Rama Moorthy et al., Sci Reports 2025); thêm DOI/link cho tất cả. File docx hiện tại của user: "A Systematic Literature Review of Content- and Con-text-Based Fake News Detection Methods - JCTA.docx" (đã port email/funding/GenAI-declaration của user). Supplementary zip: corpus.csv (44, có DOI+authors chuẩn), results.csv, analyze.py, country_map.csv, dataset_map.csv, README.

**Vòng phản biện 2 reviewer (2026-08-07):** tiêu đề hiện tại **"Beyond Reported Accuracy: A Verifiability-Focused, Multi-Axis Review of Content- and Context-Based Fake News Detection"** (file `D:\Downloads\Beyond Reported Accuracy A Verifiability-Focused...docx`, có backup `...- JCTA (backup before search-method).docx`). Reviewer A (Resubmit) đòi tính **auditable/tái lập**; Reviewer B (minor + 2 sơ đồ). User chọn **purposive minh bạch** (KHÔNG bịa funnel/ngày). Đã làm: §3.1-3.2 thêm ngày tìm **July–Aug 2026** + Boolean query + snowballing + dedup + 2 giai đoạn screening (I1-I4/E1-E4) + provenance 51 ứng viên + disclaimer share≠ước lượng ngành; §3.3 thêm **hierarchy chọn metric H1-H5**; đổi hết "matched"→"within-benchmark", "validated performance"→"source-verified reported performance", bỏ Weibo "architectural progress", hạ nhân-quả→evidence-consistent; **§6.5 Threats to Validity** mới (6.1-6.6); **Figure 2** nâng thành workflow giao thức, thêm **Figure 8** chuỗi yếu tố (Fig1-8). **Chấm risk-of-bias TỪNG nghiên cứu** (6 agent researcher đọc nguồn) → `risk_of_bias.csv` (44×24, 9 tiêu chí low/some/high/unclear + evidence); Table 3 = phân bố per-study trên 41 core (external_validation high=23/41, statistical high=14, result_selection high=15). **Verification: 35/44 confirmed at source, 9 paywalled flagged reported-but-unconfirmed** (S05,S07,S12,S15,S19,S24,S30,S33,S34) → abstract/contributions đã calibrate. **Sửa số liệu do đọc lại nguồn:** S39 AUC 0.8348 (ablation NC)→**0.8589** (best InfOp 90% split); S20 task binary→**multiclass** (87% là 6-way); S08 làm rõ 99.36 là best-of-many trên 1 mẫu ~20k; S12 mismatch (WELFake ~0.99 chứ không ISOT ~97%) → flag+loại khỏi within-benchmark. Family shares & accuracy ranges KHÔNG đổi. Supplement zip thêm `excluded.csv`(7) + `risk_of_bias.csv` + corpus.csv 24 cột; README viết lại. Thư phản hồi mới: `D:\Downloads\Response to Reviewers - Fake News Detection Review.docx` (point-by-point A1-A8 + B1-B6, mỗi mục có "Resulting scientific point"). Scripts round này ở scratchpad: edit_p4.py, insert_p2p3.py, make_figs.py, embed_figs.py, edit_backmatter.py, merge_build.py, update_36.py, make_excluded.py, make_response2.py. Skill mới `~/.claude/skills/strengthen-review-paper` đúc kết 5 câu hỏi editor.

Build bằng python-docx (không có LibreOffice/pandoc trên máy → verify bằng introspection). Scratchpad session: `...\18f83c04-...\scratchpad\` (content.py, body*.py, build_docx.py, analyze.py, corpus_batch_[A-E].json).

Liên quan: [[hou_cntt_app]] (cùng người dùng HOU CNTT).
