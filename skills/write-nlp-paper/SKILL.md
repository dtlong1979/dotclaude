---
name: write-nlp-paper
description: >-
  DEFAULT craft + submission guide for ANY empirical IT / computer-science research paper in English
  (AI, NLP, ML, data mining, information retrieval, software engineering, networking, security, HCI,
  systems, and related IT fields) — apply it by default whenever the user writes, structures, revises,
  tightens, or reviews an IT/CS paper, not only NLP/AI ones. Section-by-section: how each part (abstract,
  introduction, related work, methods, results, discussion, conclusion) is actually written in top venues
  (ACL/EMNLP/NAACL/TACL and Q1 journals across IEEE/ACM/Elsevier/Springer/Nature), with real
  rhetorical-move patterns, English sentence frames, tense/voice conventions, statistics discipline,
  reviewer red flags, and a built-in kill-list of non-native-English mistakes. Field-general in its
  section craft, statistics, English kill-list, and submission compliance; some worked examples are
  NLP/Vietnamese-flavored but the principles transfer to all IT subfields, and it is extra-tuned for
  Vietnamese / low-resource-language authors. Use when drafting, structuring, revising, or reviewing ANY
  section of an IT/CS paper, when deciding what a section should contain or in what order to write, when a
  draft "reads translated" or "reads like a list", when responding to reviewers, or when checking a paper
  for basic mistakes before submission. Triggers even without the word "paper": "viết phần phương pháp",
  "làm phần results mạnh hơn", "cấu trúc related work", "bài của em đọc như dịch máy", "hạ over-claim
  trong discussion", "checklist nộp Q1", "viết bài báo IT/khoa học máy tính", "how do I write the methods
  section", "make my results section stronger", "structure my intro", "reviewer says my related work is
  just a list". For the abstract ALONE, write-abstract is more specialized; for literature-review/survey
  papers (not empirical), use strengthen-review-paper.
  Also covers journal SUBMISSION COMPLIANCE (author-guideline requirements) — abstract/length limits,
  Highlights, Data Availability Statement, code-sharing policy, CRediT/declarations block, where to
  disclose AI/LLM use, anonymization, cover letters, reference style, LaTeX style-files, and novelty-vs-
  soundness acceptance philosophy — so use it too when choosing a target journal, preparing a paper for
  submission, avoiding desk-reject, or asking "what does journal X require", "cần khai dùng AI ở đâu",
  "chọn tạp chí nào cho bài này", "checklist trước khi nộp", "vì sao bị desk-reject".
---

# Write an IT/CS Q1 paper — section by section

> **Phạm vi mặc định:** đây là guide MẶC ĐỊNH cho **mọi bài báo thực nghiệm chuyên ngành IT/khoa học máy tính**
> (AI, NLP, ML, khai phá dữ liệu, IR, kỹ nghệ phần mềm, mạng, an ninh, HCI, hệ thống…), không chỉ NLP/AI. Phần
> **văn phong từng phần, kỷ luật thống kê, kill-list lỗi tiếng Anh, và tuân thủ nộp bài (file 08)** đúng cho mọi
> tiểu ngành IT. Một số **ví dụ minh hoạ** mang màu NLP/tiếng Việt, nhưng **nguyên tắc & mẫu câu chuyển giao được**;
> khi viết bài ngoài NLP, giữ nguyên khung/quy tắc và thay ví dụ cho khớp tiểu ngành.

Kỹ năng này giúp viết/soát **từng phần** của một bài báo IT/CS thực nghiệm nhắm tạp chí Q1 hoặc hội nghị top
(ACL/EMNLP/NAACL/TACL, IEEE/ACM Transactions, Elsevier/Springer/Nature). Bài đích viết **tiếng Anh**; giải thích
tiếng Việt, mẫu câu tiếng Anh. Nội dung
được chưng cất từ ví dụ THẬT trong ~35 bài mở (PhoBERT, ViSoBERT, ViHSD, HANS, Gururangan, DetectGPT, XLM-R,
Joshi, EURO-5K, FormosanBench…) + lý thuyết genre-analysis (Swales CARS, Hyland). Tuned riêng cho tác giả
người Việt / nghiên cứu ít tài nguyên.

## Cách dùng (workflow)

1. **Xác định việc.** Người dùng đang viết/soát phần nào? (abstract / introduction / related work / methods /
   results / discussion / conclusion), hay hỏi về cấu trúc/thứ tự/lỗi toàn bài?
2. **Đọc reference tương ứng TRƯỚC khi viết** — đừng viết từ trí nhớ. Mỗi file có 9 mục: moves, cấu trúc,
   sentence frames (EN), quy ước thì/giọng, reviewer thưởng/red flag, lỗi non-native, lưu ý tiếng Việt,
   checklist, và ví dụ **trước→sau**.
   - Abstract → `references/01-abstract.md`
   - Introduction → `references/02-introduction.md`
   - Related Work / Background → `references/03-related-work.md`
   - Methods / Approach → `references/04-methods.md`
   - Results / Experiments → `references/05-results.md`
   - Discussion → `references/06-discussion.md`
   - Conclusion / Future Work → `references/07-conclusion.md`
   - **Yêu cầu nộp bài & chính sách tạp chí** (format, Highlights, Data Availability, declarations, khai AI,
     ẩn danh, cover letter, reference style, chọn venue, chống desk-reject) → `references/08-journal-submission-requirements.md`
3. **Việc toàn bài** (mạch xuyên phần, chống trùng lặp, thứ tự viết, checklist nộp) → đọc `references/GUIDELINE.md`.
4. **Viết/sửa** bằng cách áp **sentence frames** trong file (điền số/nội dung thật của người dùng), tôn trọng
   quy ước thì/giọng, rồi **đối chiếu checklist** của phần đó.
5. **Luôn liêm chính số liệu:** không bịa con số hay trích dẫn. Con số phải khớp giữa các phần và đã kiểm soát
   confound; trích dẫn phải fetch xác minh toàn văn (xem "Lưu ý tra cứu" cuối file).

Nếu người dùng đưa một draft, **chẩn đoán theo checklist + red-flag của phần đó** rồi sửa cụ thể (viết lại câu),
không nhận xét chung chung. Ưu tiên chỉ ra và sửa 3–5 lỗi nặng nhất trước.

## Bảy nguyên tắc trùm (thuộc lòng, áp cho mọi phần)

1. **Một sợi chỉ:** RQ/gap (Intro) → hứa trong *contributions* → giao trong Results → diễn giải trong
   Discussion → chốt trong Conclusion. **Mỗi contribution map 1–1 tới một kết quả.** Hứa mà không giao = reject.
2. **Đúng phần nói đúng việc:** Results = *WHAT* (số, không diễn giải sâu); Discussion = *WHY/SO-WHAT*;
   Conclusion = thông điệp + hướng đi (KHÔNG số/kết quả mới).
3. **Cùng một phát hiện, bốn giọng khác nhau** ở Abstract (1 số đắt) / Results (số + stats) / Discussion
   (cơ chế + so sánh) / Conclusion (thông điệp, không số). Câu nào dán được sang phần khác nguyên si → viết lại.
4. **Số & thống kê là bắt buộc Q1:** mean±std ≥3–5 seed; mọi "tốt hơn" cần *baseline có tên + bao nhiêu points
   (absolute/relative) + significance test (p/CI)*; "significant" chỉ khi ĐÃ test; hiệu số % gọi là **points**;
   số văn = số bảng. Dataset nhỏ → **bootstrap CI** bắt buộc.
5. **Booster cho quan sát, hedge cho giải thích.** Tương quan ≠ nhân quả (chưa đối chứng → *associated with*).
   Không tuyệt đối hoá (*first/novel/solves/proves/SOTA*) khi chưa kiểm chứng. Không chồng hedge.
6. **Viết thẳng, để số liệu tự nói:** cắt câu meta/tự-biện-hộ/sáo rỗng và mở bài vũ trụ ("With the rapid
   development of AI…", "Since the dawn of…").
7. **Thì & giọng nhất quán:** việc mình đã làm → past; mô tả mô hình/định nghĩa & "bảng shows" → present; dòng
   nghiên cứu (Related Work) → present perfect; hướng tương lai → *will* + base verb. Quy trình → passive;
   quyết định/đóng góp → "we" chủ động.
8. **Văn phong ≠ tuân thủ nộp bài:** một bài viết chuẩn 01–07 vẫn desk-reject nếu sai style-file, thiếu
   Highlights/Data-Availability/Declarations, khai AI sai chỗ, vượt giới hạn, hoặc over-claim ở tạp chí xét
   *soundness* (PLOS/PeerJ/Sci Reports/IEEE Access/Frontiers/TMLR). Sau khi viết xong, **chạy "compliance pass"**
   theo `references/08-journal-submission-requirements.md` §14 đối chiếu tạp chí đích. **Con số cụ thể của mỗi
   tạp chí PHẢI xác minh ở trang Guide-for-Authors gốc** (publisher chặn crawl — xem §15 của file 08).

## Thẻ tiếng Việt / ít tài nguyên (áp khi bài là về/bằng tiếng Việt)

- **Novelty = trục loại hình học: chữ Latin + DẤU THANH.** KHÔNG lead bằng "đơn lập/isolating" (tiếng Trung
  cũng đơn lập). Dấu thanh là surface cue để matched-deletion/counterfactual khai thác.
- **"Stress test" cho một tuyên bố tổng quát, KHÔNG "case study địa phương".** Low-resource là động lực, không
  phải lời xin lỗi (dùng số người dùng làm bằng chứng tầm quan trọng).
- **Phát hành artifact** (data/benchmark/code cho VN) = đòn bẩy chấp nhận.
- **Cảnh giác "multilingual"** — chưa chắc có tiếng Việt; fetch xác minh trước khi dựa vào.
- **Methods phải tự-giải-thích cho reviewer quốc tế:** tách từ (VnCoreNLP/RDRSegmenter) + mức token; dấu thanh
  (giữ/chuẩn hoá); **Unicode NFC/NFD**; emoji/teencode; code-switching. Annotation → số annotator + **IAA (κ)**
  + guideline (báo κ dù thấp).
- **"First / no prior work"** chỉ sau khi tra ACL Anthology + arXiv cs.CL + VLSP/VJOL, luôn kèm "to the best of
  our knowledge". Đừng biến baseline yếu thành SOTA giả (đưa cả mBERT/XLM-R mạnh).
- **Future work "mở rộng ngôn ngữ"** chỉ có giá trị khi gắn giả thuyết ngôn ngữ học + nhấn tính tái dùng của
  *phương pháp*, không phải "more data".

## Kill-list lỗi tiếng Anh non-native (rà một lượt riêng)

Mạo từ a/an/the; V-ing sau giới từ; danh từ không đếm được (*research*, *the literature*, *work* — không
"researches/literatures/related works"); *will* + base verb; comma splice; collocation (*conduct an experiment*,
*obtain results*); *outperforms X* (no "than"), *superior to X*; dấu chấm thập phân (85.3); *prove/obviously* →
*suggest/indicate*; thuật ngữ nhất quán. **Mẹo:** viết ý bằng tiếng Việt trước → diễn đạt lại bằng frame tiếng
Anh, KHÔNG dịch từng chữ; đọc to để bắt câu sai.

## Thứ tự viết khuyến nghị

Methods → Results → Introduction → Related Work → Discussion → Conclusion → **Abstract cuối cùng**. (Viết phần
"hứa" sau phần "giao" để không hứa hão.)

## Lưu ý tra cứu (khi cần trích bài thật để grounding/so sánh)

Để lấy **toàn văn** một section của bài NLP: fetch bản HTML `https://arxiv.org/html/<id>` hoặc
`https://ar5iv.labs.arxiv.org/abs/<id>`. **KHÔNG** fetch `.pdf` (trả binary) và **KHÔNG** dựa vào trang
`aclanthology.org/<id>/` hay `arxiv.org/abs/<id>` (chỉ có abstract). WebFetch đôi khi *tóm tắt* thay vì trả
nguyên văn — yêu cầu "extract verbatim, do not paraphrase" và chỉ coi là nguyên văn phần trong ngoặc kép đã
đối chiếu. Trước khi đưa trích dẫn vào bản thảo cuối, verify lại từ PDF chính thức.
