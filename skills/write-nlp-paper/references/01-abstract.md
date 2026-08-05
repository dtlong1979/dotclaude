# 01 — Abstract (Q1 NLP/AI, ngữ cảnh tác giả Việt / low-resource)

> Mục tiêu: viết một abstract tiếng Anh 150–250 từ, có cấu trúc 6 nước đi, số liệu tự nói,
> takeaway rõ, đóng góp không over-claim. Giải thích bằng tiếng Việt; **mẫu câu (frames) bằng tiếng Anh**.
> Mọi ví dụ trích dẫn ở cuối file là abstract THẬT (fetch xác minh), có ghi verbatim hay paraphrase.

---

## 1. Rhetorical moves của abstract (mô hình move/step)

Mô hình chuẩn (Hyland: Introduction–Purpose–Method–Product–Conclusion) hợp nhất với
khung 6 nước đi mà bài này dùng. Mỗi move trả lời MỘT câu hỏi:

| # | Move | Câu hỏi trả lời | Bắt buộc? |
|---|------|-----------------|-----------|
| M1 | **Problem / Context** | Vấn đề gì? Vì sao quan trọng? | Bắt buộc |
| M2 | **Gap / Limitation** | Hiện trạng thiếu/sai ở đâu? | Bắt buộc |
| M3 | **Approach / Design** | Bạn LÀM gì để giải quyết? | Bắt buộc |
| M4 | **Results (có số)** | Kết quả định lượng? | Bắt buộc |
| M5 | **Conclusion / Takeaway** | Nghĩa là gì? Câu chốt "so what"? | Bắt buộc |
| M6 | **Contribution / Impact / Release** | Đóng góp lâu dài, artifact phát hành | Nên có |

**Thứ tự điển hình:** M1 → M2 → M3 → M4 → M5 (→ M6). Đây là trật tự an toàn nhất cho reviewer.

**Biến thể hợp lệ (theo LOẠI bài):**
- **Bài "diagnostic/phê phán" (ĐÚNG loại project surface-reliance này):** M1+M2 gộp/đảo — mở bằng
  một *khẳng định phản trực giác* rồi mới nêu bằng chứng. Ví dụ thật: HANS mở bằng
  "*A machine learning system can score well ... by relying on heuristics that ... break*"
  (McCoy 2019) — đó là M1+M2 nén thành 1 câu.
- **Bài "resource/model" (PhoBERT, ViSoBERT):** M2 (gap) rất ngắn hoặc ẩn; nhấn M3 (cái ta build)
  + M4 (SOTA) + M6 (release). PhoBERT gần như bỏ M1 dài, vào thẳng M3.
- **Bài "position/survey" (Joshi 2020):** M4 số liệu có thể thay bằng "phát hiện định tính";
  M6 thành lời kêu gọi cộng đồng.
- Móc "**contrast turn**" — dùng *However / Yet / Despite* ở đầu M2 — là dấu hiệu abstract có cấu trúc.

---

## 2. Cấu trúc & độ dài điển hình

- **Tổng:** 150–250 từ (Q1 NLP thường 150–200; tránh > 250). Thường **6–9 câu**.
- **Phân bổ câu điển hình:**
  - M1 Problem: 1 câu (đôi khi 2).
  - M2 Gap: 1 câu.
  - M3 Approach: 1–2 câu (thường 2: một câu ý tưởng lớn, một câu chi tiết cách làm).
  - M4 Results: 1–2 câu — **nơi duy nhất bắt buộc có con số**.
  - M5 Conclusion: 1 câu.
  - M6 Contribution/release: 1 câu (thường "We release ...").
- **Không** chia mục, **không** ký hiệu toán, **không** trích dẫn [x] (ngoại lệ: so sánh model có tên +
  năm như "XLM-R (Conneau et al., 2020)" — chấp nhận được, xem PhoBERT).
- **Abstract có cấu trúc (structured, có nhãn Background/Methods/Results)**: chỉ dùng nếu venue yêu cầu
  (một số journal y-sinh/IP&M cho phép). Hội nghị *ACL/EMNLP/NAACL* → **luôn dùng dạng 1 đoạn liền mạch**.

---

## 3. Sentence frames (mẫu câu tiếng Anh) theo từng move

> Điền chỗ `[...]`. Chọn 1 frame/move, đừng nhồi hết.

### M1 — Problem / Context
- `[Task/decision system] is increasingly used for [application], where [why it matters].`
- `Recent [models/detectors] achieve strong results on [benchmark], yet it remains unclear whether they [truly do X].`
- *(kiểu diagnostic — mở phản trực giác):* `A [classifier/detector] can appear accurate while actually relying on [surface cue] rather than [content].`
- **Khi dùng:** câu đầu tiên. Với bài phê phán, ưu tiên frame thứ 3 để "hook" reviewer.

### M2 — Gap / Limitation
- `However, existing work on [X] focuses on [English / high-resource settings], leaving [Vietnamese / low-resource] largely unexamined.`
- `Prior evaluations report aggregate accuracy but do not test whether [model] is robust to [confound].`
- `It is not known to what extent [these gains] reflect [genuine understanding] versus [dataset artifacts].`
- **Khi dùng:** ngay sau M1; bắt đầu bằng *However/Yet/Despite* để đánh dấu bước ngoặt.

### M3 — Approach / Design
- `In this paper, we [propose / introduce / present] [method name], which [core idea in one clause].`
- `We [measure / test] this using [matched-deletion / counterfactual] on [N] examples across [k] datasets.`
- `To isolate [surface reliance], we construct [minimal pairs] that hold [content] fixed while varying [cue].`
- **Khi dùng:** 1–2 câu. Câu 1 = ý tưởng lớn; câu 2 = cơ chế đo cụ thể (rất quan trọng ở bài diagnostic).

### M4 — Results (có số)
- `We find that [model] retains [XX]% of its accuracy / drops by [XX] points when [cue is removed].`
- `[Method] achieves [XX.X] F1, outperforming [baseline] by [Y.Y] points ([relative %]).`
- `Across [k] settings, [effect] holds consistently, with [metric] ranging from [a] to [b].`
- **Khi dùng:** trái tim abstract. Tối thiểu MỘT con số cụ thể. Nêu **cả hướng lẫn độ lớn**
  (ví dụ "drops 18 points", không chỉ "drops significantly").

### M5 — Conclusion / Takeaway
- `These results indicate that [system] relies on [surface cue], suggesting that reported gains overstate [true competence].`
- `Our findings show that [current evaluation] can be [misleading] for [low-resource languages].`
- **Khi dùng:** đúng 1 câu "so what". Đây là câu người ta nhớ. Tránh lặp lại số liệu ở đây.

### M6 — Contribution / Impact / Release
- `We release [dataset / benchmark / code] to support future work on [X].`
- `Our benchmark provides a diagnostic tool for measuring [surface reliance] in [Vietnamese NLP].`
- **Khi dùng:** câu cuối. Với bài low-resource, phát hành artifact là điểm cộng lớn với reviewer.

---

## 4. Quy ước ngôn ngữ (thì, thể, hedging, thuật ngữ)

**Thì (tense):**
- M1 Problem: **hiện tại đơn** (sự thật chung) — *"Detectors are widely used..."*
- M3 Approach: **hiện tại đơn** hoặc **quá khứ**; chuẩn hiện đại dùng *"we propose / we construct"* (hiện tại).
- M4 Results: **hiện tại đơn** cho phát hiện (*"we find that..."*), quá khứ cho hành động đo (*"we measured"*).
- M5/M6: **hiện tại đơn**.

**Thể chủ động vs bị động:**
- **Ưu tiên chủ động + "we"** ở M3–M6: *"We introduce...", "We find..."*. NLP hiện đại chuộng "we".
- Bị động chỉ dùng khi tác nhân không quan trọng (*"Models were trained on..."*).
- **Đừng** viết "This paper proposes" quá nhiều lần — nhàm; xen "we".

**Hedging vs booster (cân bằng — chuẩn của user: không over-claim, cũng không tự thủ thừa):**
- Booster (đúng chỗ, ở kết quả chắc): *show, demonstrate, find, establish.*
- Hedge (khi suy luận vượt dữ liệu): *suggest, indicate, may, appears to, to the extent that.*
- **Quy tắc:** dùng **booster cho cái đo được** (M4), **hedge cho diễn giải** (M5).
  Ví dụ: "We *find* accuracy drops 18 points (đo được) ... this *suggests* reliance on surface cues (diễn giải)."
- Tránh over-claim tuyệt đối: *"the first ever", "solves", "proves"* — reviewer Q1 dị ứng. "First public ...
  for Vietnamese" thì OK nếu ĐÚNG (PhoBERT làm được vì kiểm chứng được).

**Thuật ngữ:**
- Định nghĩa hoặc bung viết tắt lần đầu nếu không phổ thông: *"large language model (LLM)"*.
  Nhưng trong abstract, viết tắt quá phổ biến (LLM, BERT, F1) không cần bung.
- Đặt tên method/benchmark bằng danh từ riêng viết hoa, dễ nhớ (HANS, Hatred...) — tăng khả năng được trích.
- Nhất quán một tên cho một khái niệm; đừng đổi "surface cue / shallow feature / superficial signal" lung tung.

---

## 5. Reviewer Q1 — THƯỞNG gì / RED FLAG gì

**Reviewer THƯỞNG (dấu hiệu abstract mạnh):**
- Có **con số cụ thể + baseline so sánh** ở M4 (không chỉ "improves performance").
- Một **takeaway phản trực giác/đáng nhớ** ở M5 (vd 67% NLI đoán đúng chỉ từ hypothesis).
- **Gap được nêu rõ và method khớp trực tiếp với gap** (không lệch).
- **Phát hành artifact** (dataset/benchmark/code) — đặc biệt với low-resource.
- **Phạm vi trung thực** — nói rõ ngôn ngữ/điều kiện đã test.

**RED FLAG (reviewer trừ điểm/nghi ngờ):**
- Abstract **không có một con số nào** (bài empirical mà mơ hồ → nghi kết quả yếu).
- **Over-claim:** "first", "novel", "state-of-the-art" mà không kiểm chứng/không đo.
- **Method mù mờ:** "using deep learning / advanced techniques" — không cho biết làm gì thật.
- **Gap–method lệch:** than thở gap A nhưng lại giải quyết B.
- **Nhồi background 3–4 câu**, kết quả 0.5 câu (mất cân đối).
- **Nhãn "multilingual" nhưng không nói có tiếng Việt/ngôn ngữ đích không** (reviewer sẽ soi — đây là
  red flag nội bộ của project: benchmark "đa ngữ" chưa chắc có VN).
- Câu chốt là lời hứa tương lai ("we plan to...") thay vì kết quả đã có.

---

## 6. Lỗi sơ đẳng của tác giả không phải bản ngữ / người Việt + cách sửa

1. **Thiếu/thừa mạo từ (a/an/the).**
   - Sai: *"We propose method for detect surface reliance."*
   - Sửa: *"We propose **a** method **for detecting** surface reliance."*
2. **Danh-động-từ sau giới từ.** Sau *for/of/by/without* dùng V-ing: *"for detecting", "without observing the premise"*.
3. **Chủ ngữ giả "It is + adj + that" lạm dụng / dịch nguyên "Nhằm..." "Với sự phát triển...".**
   - Bỏ mở bài sáo rỗng *"With the development of AI, ..."* — reviewer coi là filler. Vào thẳng vấn đề.
4. **Câu quá dài, nhiều mệnh đề nối bằng ","** (dịch trực tiếp cú pháp tiếng Việt).
   - Cắt thành 2 câu. Một ý một câu.
5. **Thì lộn xộn** — trộn quá khứ/hiện tại tùy tiện. Theo quy ước ở Mục 4.
6. **Lạm dụng booster** ("significantly", "greatly", "perfectly") không kèm số → nghe khoa trương.
7. **Sai collocation:** *"make an experiment"* → *"conduct/run an experiment"*; *"gain the result"* → *"obtain the result"*;
   *"do a research"* → *"conduct research"* (research không đếm được).
8. **"outperforms than" / "superior than"** → *"outperforms X"* (không "than"), *"superior to X"*.
9. **Số/đơn vị:** dùng dấu chấm thập phân tiếng Anh (**85.3**, không 85,3); "F1" viết hoa chữ F.
10. **Dịch máy nguyên khối** → đọc trôi nhưng "off". Cách sửa hiệu quả: viết ý bằng tiếng Việt trước
    (đúng với quy ước project), rồi diễn đạt lại bằng frame Anh ở Mục 3, KHÔNG dịch từng chữ.

---

## 7. Lưu ý riêng cho nghiên cứu tiếng Việt / ít tài nguyên

- **Biến "low-resource" thành động lực (motivation), không thành lời xin lỗi.** Nêu con người/quy mô để
  chứng minh tầm quan trọng: mẫu thật *"Vietnamese, spoken by around 100 million people, lacks ..."*
  (ViSoBERT) — đặt gap là cơ hội, không phải điểm yếu.
- **Nói RÕ ngôn ngữ và điều kiện ngay trong abstract.** Với project này, nêu trục loại hình học là novelty:
  *"Vietnamese, a Latin-script tonal language with diacritics"* — vì reviewer quốc tế không tự biết,
  và đây là điểm phân biệt thật (không phải "đơn lập" — tiếng Trung cũng đơn lập).
- **Đừng lead bằng con số gây sốc chưa kiểm soát confound.** (Bài học nội bộ: "23x default-male" sụp còn
  ~3x sau de-confound.) Trong abstract nêu con số ĐÃ qua kiểm soát; nếu chưa chắc → hedge hoặc bỏ.
- **Phát hành artifact tiếng Việt = đòn bẩy chấp nhận.** Câu M6 "we release dataset/benchmark for Vietnamese"
  cực giá trị vì cộng đồng thiếu tài nguyên.
- **Không mượn oai benchmark "đa ngữ".** Nếu benchmark bạn dùng không thật sự chứa tiếng Việt, đừng ám chỉ.
  Nêu rõ bạn tự xây phần VN.
- **Đánh giá thận trọng:** ở low-resource, LLM-judge/auto-metric kém tin → trong abstract nên nêu
  *human adjudication / macro-F1* nếu có, tăng độ tin cậy kết quả.

---

## 8. Checklist tự rà (actionable)

- [ ] Có đủ 6 move? (Problem, Gap, Approach, Results, Conclusion, Contribution)
- [ ] 150–250 từ, 6–9 câu, một đoạn liền mạch (trừ khi venue yêu cầu structured)?
- [ ] M2 có từ đánh dấu bước ngoặt (However/Yet/Despite)?
- [ ] M3 nói RÕ bạn làm gì (đủ để người khác hình dung cơ chế), không mù mờ "deep learning"?
- [ ] M4 có **ít nhất 1 con số cụ thể** + baseline so sánh, nêu cả hướng lẫn độ lớn?
- [ ] M5 có đúng 1 câu takeaway "so what", không lặp số?
- [ ] Booster cho cái đo được, hedge cho diễn giải — không over-claim ("first/solves/proves")?
- [ ] Nêu rõ ngôn ngữ = tiếng Việt + đặc trưng loại hình (nếu là novelty)?
- [ ] Có câu release artifact (M6) nếu có phát hành?
- [ ] Thì nhất quán theo Mục 4? Mạo từ, collocation, "outperforms X" (không "than")?
- [ ] Không mở bài sáo rỗng ("With the rapid development of...")?
- [ ] Mọi con số trong abstract KHỚP số trong phần Results và đã kiểm soát confound?
- [ ] Không dùng viết tắt lạ mà chưa bung; tên method/benchmark nhất quán, dễ nhớ?

---

## 9. Ví dụ "trước → sau" (yếu → mạnh)

### Ví dụ A — bài diagnostic surface-reliance (đúng loại H1/H2/H3)

**TRƯỚC (yếu):**
> *With the rapid development of AI, text classifiers are very popular nowadays. In this paper, we do a
> research about Vietnamese classifiers and we find some interesting problems. We make many experiments
> and the results are good. This shows classifiers have some limitations and need improvement in the future.*

Vấn đề: mở bài sáo rỗng; không gap rõ; method mù mờ ("do a research", "make experiments"); **không một con số**;
takeaway rỗng; collocation sai; lời hứa tương lai thay kết quả.

**SAU (mạnh):**
> *Text classifiers report high accuracy on Vietnamese sentiment tasks, but it is unclear whether they
> understand content or merely exploit surface cues such as emotion-laden keywords. **Prior evaluations rely
> on aggregate accuracy and do not test this directly**, especially for Vietnamese, a Latin-script tonal
> language. **We introduce a matched-deletion probe** that removes candidate anchor tokens while holding the
> rest of the sentence fixed, applied to three classifiers across two Vietnamese corpora. **We find that
> models retain only 61% of their accuracy after anchor removal, a drop of 24 points**, whereas human
> agreement is largely unaffected. **These results indicate that reported accuracy substantially overstates
> genuine understanding** for Vietnamese sentiment models. **We release the probe and annotations** to
> support diagnostic evaluation in low-resource settings.*

(≈115 từ — có thể giãn tới ~180 khi thêm chi tiết; **số liệu minh họa, KHÔNG phải kết quả thật** — thay bằng số đo được.)

### Ví dụ B — bài resource/benchmark tiếng Việt

**TRƯỚC (yếu):**
> *Vietnamese is a low-resource language and there are not many models. We build a new dataset and a model.
> Our model is better than other models. We hope it will be useful.*

Vấn đề: gap kể lể tự thương; không nói dataset lớn cỡ nào, task gì; "better" không số; kết bằng hy vọng.

**SAU (mạnh):**
> *Vietnamese, spoken by around 100 million people, still lacks specialized resources for [task X]. **We
> present [NAME], the first public [benchmark] for [task X] in Vietnamese**, comprising [N] annotated examples
> across [k] domains with inter-annotator agreement of [κ]. **We benchmark [m] models and find that the best,
> PhoBERT, reaches [XX.X] macro-F1, still [Y] points below human performance**. **Error analysis shows that
> failures concentrate on [phenomenon]**, indicating that [task X] remains an open challenge for Vietnamese
> NLP. **We release the dataset and code** at [url].*

(Các `[...]` điền số thật; frame theo abstract PhoBERT/ViSoBERT thật ở Mục nguồn.)

### Ví dụ C — sửa riêng câu Results (M4)

- **Yếu:** *"Our method significantly improves the performance compared with baselines."*
- **Mạnh:** *"Our method reaches 88.7 macro-F1, improving over the PhoBERT baseline by 5.2 points (a 6.2% relative gain)."*
  → cùng một ý nhưng có hướng + độ lớn + baseline có tên. Đây là điều reviewer Q1 thưởng.

---

## Nguồn thật đã trích (fetch xác minh 2026-08-05)

> Ghi rõ verbatim (nguyên văn, trong ngoặc kép) hay paraphrase (WebFetch tóm tắt, chỉ cụm trong ngoặc là nguyên văn).
> Lưu ý kỹ thuật: phải fetch trang **HTML** `aclanthology.org/<ID>/` hoặc `arxiv.org/abs/<ID>`, KHÔNG fetch `.pdf` (trả binary).

1. **Nguyen & Nguyen (2020)** — *PhoBERT: Pre-trained language models for Vietnamese.* Findings of EMNLP 2020.
   https://aclanthology.org/2020.findings-emnlp.92/ — **verbatim** ("We present PhoBERT with two versions...
   the first public large-scale monolingual language models pre-trained for Vietnamese... consistently
   outperforms... XLM-R (Conneau et al., 2020)... We release PhoBERT...").
2. **Nguyen, Phan, Nguyen & Nguyen (2023)** — *ViSoBERT: A Pre-Trained Language Model for Vietnamese Social
   Media Text Processing.* EMNLP 2023, pp. 5191–5207. https://aclanthology.org/2023.emnlp-main.315/ —
   **paraphrase** (cụm nguyên văn: "surpasses the previous state-of-the-art models on multiple Vietnamese
   social media tasks", "far fewer parameters").
3. **McCoy, Pavlick & Linzen (2019)** — *Right for the Wrong Reasons: Diagnosing Syntactic Heuristics in
   Natural Language Inference.* ACL 2019. https://aclanthology.org/P19-1334/ — **verbatim từng phần**
   ("...by relying on heuristics that are effective for frequent example types but break...", "HANS
   (Heuristic Analysis for NLI Systems)...", "...substantial room for improvement... the HANS dataset can
   motivate and measure progress...").
4. **Gururangan, Swayamdipta, Levy, Schwartz, Bowman & Smith (2018)** — *Annotation Artifacts in Natural
   Language Inference Data.* NAACL 2018. https://aclanthology.org/N18-2017/ — **verbatim từng phần**
   ("a simple text categorization model can correctly classify the hypothesis alone in about 67% of SNLI and
   53% of MultiNLI", "the success of natural language inference models to date has been overestimated...").
5. **Joshi, Santy, Budhiraja, Bali & Choudhury (2020)** — *The State and Fate of Linguistic Diversity and
   Inclusion in the NLP World.* ACL 2020 / arXiv:2004.09095. https://arxiv.org/abs/2004.09095 — **verbatim**
   (toàn abstract, gồm "...only a very small number of the over 7000 languages...", "...so that no language
   is left behind.").
6. **Jiao, Yin, Shang, Jiang, Chen, Li, Wang & Liu (2020)** — *TinyBERT: Distilling BERT for Natural Language
   Understanding.* Findings of EMNLP 2020. https://aclanthology.org/2020.findings-emnlp.372/ — **verbatim từng
   phần** ("a novel Transformer distillation method...", "TinyBERT4 with 4 layers... achieves more than 96.8%
   the performance of its teacher BERT-Base on GLUE... 7.5x smaller and 9.4x faster on inference").
7. **Geva, Schuster, Berant & Levy (2021)** — *Transformer Feed-Forward Layers Are Key-Value Memories.*
   EMNLP 2021. https://aclanthology.org/2021.emnlp-main.446/ — **verbatim** (toàn abstract, gồm "Feed-forward
   layers constitute two-thirds of a transformer model's parameters, yet their role... remains under-explored...").
