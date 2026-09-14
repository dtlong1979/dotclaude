---
name: write-nlp-paper
description: >-
  Default master coordinator for writing any empirical IT / computer-science paper (AI, NLP, ML, data mining, IR
  , software engineering, security, HCI, systems) in English for Q1 journals; apply by default for any IT/CS pap
  er. Holds cross-cutting essentials: the whole-paper through-line, the abstract, statistics discipline, hedging
   vs booster, a non-native-English mistake kill-list, the Vietnamese/low-resource playbook, writing order, and 
  journal submission compliance (Highlights, Data Availability, CRediT/declarations, where to disclose AI use, r
  eference styles, novelty-vs-soundness, desk-reject list). Routes to companions write-nlp-intro-related, write-
  nlp-method-results, write-nlp-discussion-conclusion. Use for any IT/CS paper task, writing the abstract, choos
  ing a venue, or checking a paper before submission. Triggers: 'viet bai IT', 'viet abstract', 'checklist nop Q
  1', 'cau truc bai bao', 'bai doc nhu dich may', 'chon tap chi', 'submission compliance', 'ra soat van phong',
  'giam dau hieu AI', 'bo em dash', 'soat truoc khi nop'.
---

# Write an IT/CS Q1 paper — MASTER coordinator

> **Phạm vi mặc định:** guide MẶC ĐỊNH cho **mọi bài báo thực nghiệm chuyên ngành IT/khoa học máy tính** (AI,
> NLP, ML, khai phá dữ liệu, IR, kỹ nghệ phần mềm, mạng, an ninh, HCI, hệ thống…), không chỉ NLP/AI. Văn phong
> từng phần, kỷ luật thống kê, kill-list lỗi tiếng Anh, tuân thủ nộp bài đúng cho mọi tiểu ngành IT; ví dụ minh
> hoạ mang màu NLP/tiếng Việt nhưng nguyên tắc & mẫu câu chuyển giao được (thay ví dụ cho khớp tiểu ngành).

File này giữ phần **dùng chung cho toàn bài**; ba skill con lo chi tiết từng cụm phần. Giải thích tiếng Việt,
mẫu câu tiếng Anh. Chưng cất từ ~35 bài mở (PhoBERT, ViSoBERT, HANS, Gururangan, DetectGPT, XLM-R, EURO-5K…) +
genre-analysis (Swales CARS, Hyland) + audit 50 tạp chí (yêu cầu nộp bài).

## Định tuyến — đang viết phần nào thì nạp thêm skill con nào

| Đang viết / soát | Nạp thêm skill | Reference |
|---|---|---|
| Introduction · Related work | **write-nlp-intro-related** | 02, 03 |
| Methods · Results/Experiments | **write-nlp-method-results** | 04, 05 |
| Discussion · Conclusion | **write-nlp-discussion-conclusion** | 06, 07 |
| Abstract · yêu cầu nộp bài · mạch toàn bài | *(ở master này)* | 01, 08, GUIDELINE |

- Abstract → `references/01-abstract.md` (viết CUỐI, nén cả bài)
- Yêu cầu nộp bài & chính sách tạp chí → `references/08-journal-submission-requirements.md`
- Mạch xuyên phần, ma trận chống trùng lặp, checklist nộp → `references/GUIDELINE.md`
- **Lượt rà văn phong người viết (BẮT BUỘC mỗi lần sửa và trước khi nộp)** → `references/09-human-style-pass.md`

Trong Claude Code: gọi `Skill` để nạp skill con. Trong chat: nêu việc (vd "viết phần methods") — skill con tự bật, master cấp nền.

## Tám nguyên tắc trùm (áp cho mọi phần)

1. **Một sợi chỉ:** RQ/gap (Intro) → hứa trong *contributions* → giao trong Results → diễn giải trong Discussion
   → chốt trong Conclusion. **Mỗi contribution map 1–1 tới một kết quả.** Hứa mà không giao = reject.
2. **Đúng phần nói đúng việc:** Results = *WHAT* (số, không diễn giải sâu); Discussion = *WHY/SO-WHAT*;
   Conclusion = thông điệp + hướng đi (KHÔNG số/kết quả mới).
3. **Cùng một phát hiện, bốn giọng** ở Abstract (1 số đắt) / Results (số + stats) / Discussion (cơ chế + so sánh)
   / Conclusion (thông điệp, không số). Câu nào dán sang phần khác nguyên si → viết lại.
4. **Số & thống kê bắt buộc Q1:** mean±std ≥3–5 seed; mọi "tốt hơn" cần *baseline có tên + bao nhiêu points
   (absolute/relative) + significance test (p/CI)*; "significant" chỉ khi ĐÃ test; hiệu số % gọi là **points**;
   số văn = số bảng. Dataset nhỏ → **bootstrap CI**.
5. **Booster cho quan sát, hedge cho giải thích.** Tương quan ≠ nhân quả (chưa đối chứng → *associated with*).
   Không tuyệt đối hoá (*first/novel/solves/proves/SOTA*) khi chưa kiểm chứng.
6. **Viết thẳng, để số liệu tự nói:** cắt câu meta/tự-biện-hộ/sáo rỗng; bỏ mở bài vũ trụ ("With the rapid
   development of AI…").
7. **Thì & giọng:** việc đã làm → past; mô tả mô hình & "bảng shows" → present; dòng nghiên cứu → present perfect;
   hướng tới → *will*+base verb. Quy trình → passive; quyết định/đóng góp → "we" chủ động.
8. **Văn phong ≠ tuân thủ nộp bài:** bài viết chuẩn vẫn desk-reject nếu sai style-file, thiếu Highlights/
   Data-Availability/Declarations, khai AI sai chỗ, vượt giới hạn, hoặc over-claim ở tạp chí *soundness* (PLOS/
   PeerJ/Sci Reports/IEEE Access/Frontiers/TMLR). Sau khi viết, chạy "compliance pass" theo `08` đối chiếu tạp chí đích.

## Lượt rà văn phong người viết — BẮT BUỘC, lần nào cũng chạy

Người dùng yêu cầu (2026-09): sau **mỗi** lần viết hoặc sửa bài, và luôn trước khi nộp, rà theo
`references/09-human-style-pass.md`, kể cả khi không được nhắc. Tóm tắt:
1. **Không nhãn in đậm đầu đoạn** (`\textbf{Label.} …` hay `**Label.** …`, cả trong `\item`): viết đoạn thường, câu đầu nêu chủ đề;
   cần tiêu đề thì dùng dòng tiêu đề riêng.
2. **Bỏ em dash** (`---`) trừ khi không thay được.
3. **Bỏ câu lộ "mùi" đánh bóng:** đối xứng "not X but Y / rather than" dày đặc, đếm tròn ("three things…"), câu
   khẩu hiệu ngắn ("Selection matters."), châm ngôn, ẩn dụ và nhân hoá ("fusion is worth", "survived", "consumes"),
   câu meta kể quá trình.
4. **Không để dấu vết công cụ hay quy trình** ("search summaries", "machine check", "raster tables could not be
   read"): viết theo kiểm chứng và tiêu chí khoa học.
5. **Chỉ báo kết quả lần chạy cuối**, không nhắc chạy lại hay không tất định; môi trường ghi trong README của repo.
6. **Không lặp số chính** ở mọi phần; mỗi khẳng định đúng bằng chứng (nguồn gốc "reported", nhân quả "consistent
   with", thống kê nêu đủ các phép kiểm định, mệnh đề toán đủ điều kiện, không gán quan điểm sai cho bài trích).
7. **Đồng bộ toàn bài** sau mỗi lần đổi định nghĩa hay thuật ngữ (grep mọi chỗ, cả chú thích, nhãn trục, keywords).

## Thẻ tiếng Việt / ít tài nguyên

- **Novelty = trục loại hình học: chữ Latin + DẤU THANH** (KHÔNG "đơn lập" — tiếng Trung cũng đơn lập).
- **"Stress test" cho tuyên bố tổng quát, không "case study địa phương";** low-resource là động lực, không phải lời xin lỗi.
- **Phát hành artifact** (data/benchmark/code VN) = đòn bẩy; **cảnh giác "multilingual"** chưa chắc có tiếng Việt.
- **Methods tự-giải-thích cho reviewer quốc tế:** tách từ (VnCoreNLP) + mức token; dấu thanh; **NFC/NFD**;
  emoji/teencode; annotation + **IAA (κ)**. **"First"** chỉ sau khi tra ACL/arXiv/VLSP + "to the best of our knowledge".

## Kill-list lỗi tiếng Anh non-native (rà một lượt riêng)

Mạo từ a/an/the; V-ing sau giới từ; danh từ không đếm (*research/the literature/work* — không "researches/related
works"); *will*+base verb; comma splice; *outperforms X* (no "than"); dấu chấm thập phân (85.3); *prove/obviously*
→ *suggest/indicate*. Mẹo: viết ý tiếng Việt trước → dùng frame tiếng Anh, không dịch từng chữ; đọc to để bắt câu sai.

## Thứ tự viết khuyến nghị

Methods → Results → Introduction → Related work → Discussion → Conclusion → **Abstract cuối**. Viết phần "hứa"
(Intro/Abstract) sau phần "giao" (Methods/Results) để không hứa hão. Mạch toàn bài + checklist: `references/GUIDELINE.md`.
