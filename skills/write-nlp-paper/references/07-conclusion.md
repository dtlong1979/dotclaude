# 07 — CONCLUSION (và Future Work)

> Phần này thuộc guideline viết bài Q1 AI/NLP, ngữ cảnh tác giả Việt / nghiên cứu tiếng Việt & ít tài nguyên. Bài đích viết **tiếng Anh**. Giải thích bằng tiếng Việt, mẫu câu bằng tiếng Anh.
>
> Nguyên tắc nền (theo chuẩn viết của user): **viết thẳng vào việc mình làm** ("we did X, obtaining Y"), cắt câu meta / tự-biện-hộ / sáo rỗng, để thông điệp tự nói. Conclusion KHÔNG phải nơi phòng thủ, cũng KHÔNG phải nơi khoe lại con số.

Tài liệu này được **grounding bằng 7 phần Conclusion THẬT** (trích dẫn nguyên văn, ghi nguồn) — xem cuối file và các trích trong từng mục. Không có câu nào bịa.

---

## 1. Rhetorical moves của Conclusion

Conclusion mạnh của bài NLP đi theo 4 nước (moves), thường gói trong **1–2 đoạn**:

**Move 1 — Nhắc lại vấn đề + đóng góp (1 câu, ở mức thông điệp).**
Mở bằng "In this paper/work, we..." tóm việc đã làm. KHÔNG lặp lại motivation dài dòng của Introduction, KHÔNG chép câu đầu Abstract.
> Grounding (CheckList, ACL 2020): mở conclusion bằng chính đóng góp — CheckList adopts *"principles from behavioral testing in software engineering"*.

**Move 2 — Thông điệp/phát hiện chính (1–2 câu, KHÔNG con số).**
Diễn đạt kết quả ở mức "điều ta học được", không phải bảng số. Đây là chỗ phân biệt rõ với Abstract (Abstract được nêu số; Conclusion nêu ý nghĩa).
> Grounding (HANS, McCoy et al. 2019): *"their high accuracies on NLI test sets may be due to the exploitation of invalid heuristics rather than deeper understanding of language."* — một câu, không con số, đọng lại thông điệp.

**Move 3 — Hàm ý rộng hơn / "so what" (1–2 câu).**
Vì sao cộng đồng nên quan tâm. Với hướng chẩn đoán surface-reliance: hàm ý cho cách ta *đánh giá* model, không chỉ cho một dataset.
> Grounding (HANS): *"test sets drawn from the same distribution as the training set may be inadequate for assessing whether a model has learned to perform the intended task."*
> Grounding (Vietnamese MRC, 2025): *"this study underscores the potential of scaling LLM-based solutions for underrepresented languages, which can drive further innovation..."*

**Move 4 — Future work CỤ THỂ (1–3 câu, hoặc gộp tiêu đề "Conclusion and Future Works").**
Nêu hướng *đặt tên được*: dataset/ngôn ngữ/kỹ thuật cụ thể — KHÔNG phải "we will explore more data".
> Grounding (VN–Chinese MT, 2025): *"In the future, we will investigate other techniques such as contrastive learning for machine translation to improve our system."* — 1 câu, nêu đích danh kỹ thuật.
> Grounding (Liang et al. 2023, GPT detector bias): *"Future detection methods should move beyond solely relying on perplexity measures and consider more advanced techniques, such as second-order perplexity methods and watermarking..."*

**Lưu ý bố cục tiêu đề:** hai kiểu đều được ở Q1 —
- `Conclusion` riêng + `Future Work` riêng (khi hướng tương lai nhiều/đáng 1 đoạn), hoặc
- `Conclusion and Future Works` gộp (phổ biến ở bài NLP ứng dụng; ViANLI, VN–Chinese MT dùng kiểu này).

---

## 2. Độ dài, cấu trúc & phân biệt với Abstract / Discussion

**Độ dài:** 1–2 đoạn (~120–220 từ). Bài diagnostic/analysis thường ngắn hơn bài dataset. Conclusion **hai câu** vẫn hợp lệ nếu đủ đóng góp + 1 hướng (xem VN–Chinese MT). Đừng kéo dài để "cho oai".

**Vị trí:** sau Discussion / trước Limitations (hoặc gộp Limitations vào cuối Discussion — tùy venue). Nếu venue tách Limitations riêng (ACL Rolling Review bắt buộc), thì Conclusion KHÔNG cần liệt kê hạn chế nữa.

**Bảng "phần nào nói gì" — để KHÔNG trùng lặp:**

| Tiêu chí | **Abstract** | **Discussion** | **Conclusion** |
|---|---|---|---|
| Mục đích | Bán bài trong 200 từ | Diễn giải *tại sao* kết quả như vậy | Đóng lại: thông điệp + hướng đi |
| Con số cụ thể | CÓ (1–2 con số đắt giá) | CÓ (phân tích sâu, so sánh) | **KHÔNG** (nói ở mức ý nghĩa) |
| Kết quả MỚI | Không | Có thể (phân tích phụ, ablation) | **KHÔNG BAO GIỜ** |
| Độ dài | ~150–250 từ | Nhiều đoạn | 1–2 đoạn |
| Giọng | Nén, khách quan | Lập luận, cân nhắc | Khẳng định, hướng tới |
| Future work | Không | Có thể chớm | **CÓ, cụ thể** |
| Câu mở đặc trưng | "We present..." | "These results suggest..." | "In this paper, we..." |

**Quy tắc chống trùng:** nếu một câu trong Conclusion có thể **cắt-dán nguyên si** vào Abstract mà không lệch → viết lại. Abstract nói *"đã đạt F1 = X"*; Conclusion nói *"cho thấy model dựa vào tín hiệu bề mặt hơn là nội dung"*.

> Lưu ý grounding: một số bài (Liang et al. 2023) **không có Conclusion riêng** — Discussion đảm nhiệm. Nếu venue của bạn chuộng bố cục đó thì đừng ép thêm Conclusion trùng lặp; nhưng đa số Q1 NLP vẫn kỳ vọng một Conclusion gọn.

---

## 3. Sentence frames tiếng Anh (kèm giải thích tiếng Việt)

### Câu mở — nhắc đóng góp
- `In this paper, we introduced <X>, a <method/dataset/metric> for <problem>.`
  → *Giới thiệu lại đóng góp bằng một danh từ đặt tên được.*
- `In this work, we investigated whether <models> rely on <surface cues> rather than <content>.`
  → *Khung câu hỏi cho bài diagnostic (hợp H1/H2/H3 của project).*
- `We presented <X>, the first <resource/benchmark> for <low-resource setting>.`
  → *Chỉ dùng "the first" nếu KIỂM CHỨNG được là đầu tiên.*

### Câu chốt thông điệp (không con số)
- `Our results show that high benchmark accuracy can mask a reliance on <spurious/surface features>.`
- `These findings indicate that <detectors/judges> can be misled by <surface signal>, especially for <Vietnamese / native-speaker text>.`
- `Taken together, our analysis suggests that current evaluation practices <overstate> genuine language understanding in this setting.`

### Câu hàm ý rộng ("so what")
- `This has implications for how we <evaluate / deploy> <NLP models> in <low-resource languages>.`
- `Our matched-deletion framework is task-agnostic and can be applied beyond the settings studied here.`
  → *Chỉ nói "generalize/apply beyond" khi phương pháp thật sự tách rời task — không over-claim.*

### Câu future work CỤ THỂ
- `In future work, we will extend <the anchor-reliance metric> to <additional Vietnamese registers: social-media, formal news>.`
- `We plan to evaluate <specific models: PhoBERT, ViSoBERT, XLM-R> under the same counterfactual protocol.`
- `A natural next step is to pair <matched-deletion> with <watermarking / second-order perplexity> to test robustness of <AI-text detectors>.`
- `We leave a systematic fairness evaluation across <detector families> for future work.`

**Phản mẫu (sáo rỗng — TRÁNH):**
- ~~`In future, we will explore more data and other models.`~~ → không đặt tên gì.
- ~~`We hope this work inspires further research.`~~ → câu meta rỗng.
- ~~`There is still much work to be done.`~~ → vô nghĩa.

---

## 4. Quy ước ngôn ngữ (thì, thể, giọng)

**Thì (tense):**
- Việc ĐÃ làm trong bài → **past** hoặc **present perfect**: *"we introduced / we have shown"*. Bài NLP chuộng **past simple** cho hành động ("we proposed", "we evaluated").
- Sự thật/kết luận vẫn đúng chung → **present**: *"our results show that models rely on..."*, *"this suggests that..."*.
- Hướng tương lai → **future/modal**: *"we will extend", "a natural next step is", "future work could / should..."*.

**Thể (voice):** ưu tiên **chủ động ngôi "we"** cho đóng góp (*"we present"*) — chuẩn NLP hiện đại. Bị động chỉ dùng khi tác nhân không quan trọng (*"the dataset will be released"*).

**Giọng — tự tin có kiểm soát:**
- Khẳng định điều đã chứng minh: dùng động từ mạnh (*show, demonstrate, reveal*) khi có bằng chứng thật.
- Điều mới suy ra/chưa chắc chắn: hedge đúng liều (*suggest, indicate, may*). HANS dùng *"may be due to"* — vừa đủ.
- Đừng vừa khoe vừa xin lỗi. Một câu, một thái độ.

---

## 5. Reviewer Q1: THƯỞNG gì / RED FLAG

**Reviewer THƯỞNG (dấu hiệu bài chững chạc):**
- Conclusion **chốt được một câu thông điệp** đáng nhớ, không lặp số.
- Future work **cụ thể tới mức reviewer hình dung được thí nghiệm tiếp theo**.
- Thành thật về phạm vi: hàm ý rộng nhưng không vống.
- Phân biệt rõ với Abstract/Discussion — không cảm giác "đọc lại lần 3".

**RED FLAG (trừ điểm ngay):**
1. **Copy-paste Abstract** — câu chữ trùng khít Abstract. Reviewer nhận ra tức thì.
2. **Future work sáo rỗng** — "more data, more languages, more models" mà không tên.
3. **Đưa KẾT QUẢ MỚI** (số/bảng chưa xuất hiện ở Results) vào Conclusion — vi phạm cấu trúc, gây nghi ngờ.
4. **Over-claim tác động** — *"our method solves the problem of AI-text detection"*, *"this will transform NLP for all low-resource languages"*. Chốt to hơn bằng chứng = mất uy tín.
5. **Nhồi con số** — lặp lại F1/accuracy đã nói ở Abstract & Results.
6. **Câu meta rỗng** — "we hope", "much remains", "as future work suggests".
7. **Xin lỗi lê thê** về hạn chế (khác với Limitations có kiểm soát) — làm loãng đóng góp.

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ + cách sửa

| Lỗi hay gặp | Ví dụ sai | Sửa |
|---|---|---|
| Lặp Abstract nguyên khối | Chép lại 3 câu đầu Abstract | Viết lại ở mức *thông điệp*, bỏ con số |
| Thì lộn xộn | "We propose X and we have obtained... and we will proposed..." | Việc đã làm → past; hướng tới → will + verb nguyên thể |
| "will proposed / will investigated" | sai sau modal | `will` + **base verb**: *"we will investigate"* |
| Sáo rỗng dịch từ tiếng Việt | "In summary, this paper has many contributions and hope..." | Cắt "hope"; nêu đóng góp cụ thể |
| "the proposed method is very good/better" | mơ hồ, cảm tính | *"outperforms X on Y"* — cụ thể, hoặc bỏ nếu đã nói ở Results |
| Mạo từ với low-resource | "in low-resource language Vietnamese" | *"in the low-resource setting of Vietnamese"* / *"for Vietnamese, a low-resource language"* |
| "researches / literatures" (số nhiều sai) | "many researches show" | *"much research shows"* / *"many studies"* |
| Over-hedge: "maybe our method perhaps could..." | chồng hedge | một hedge: *"our method may..."* |
| Câu chủ đề mơ hồ mở đoạn | "There are many things in this paper." | *"In this paper, we introduced..."* |
| Future work = danh sách bừa | "We will do more experiments, more data, more models, deep learning..." | Chọn 2–3 hướng ĐẶT TÊN, mỗi hướng 1 mệnh đề |

**Mẹo văn phong:** đọc to Conclusion. Câu nào không thêm thông tin (chỉ "đưa đẩy") → xóa. Chuẩn user: **viết thẳng, cắt meta**.

---

## 7. Lưu ý riêng: tiếng Việt / ít tài nguyên

Future work kiểu "mở rộng sang ngôn ngữ/dữ liệu khác" RẤT dễ rơi vào sáo rỗng. Cách nêu cho **có giá trị**:

**Đừng viết (rỗng):**
- ~~"We will extend our work to other low-resource languages."~~
- ~~"More Vietnamese data will improve the results."~~

**Hãy viết (cụ thể, kiểm chứng được):**
- `We will extend the matched-deletion protocol to <specific registers>: Vietnamese social-media comments and formal news, where surface cues differ systematically.`
  → *Nêu đích danh domain + LÝ DO ngôn ngữ học vì sao đáng làm.*
- `Because Vietnamese lacks <resource X>, a next step is to build a counterfactual test set with human-verified minimal pairs, releasing it as a shared artifact.`
  → *Biến hạn chế nguồn lực thành đóng góp artifact tương lai.*
- `Our framework transfers to typologically related low-resource languages (e.g., <named languages>) where <the same surface phenomenon> is expected; verifying this is future work.`
  → *"Mở rộng ngôn ngữ" chỉ có giá trị khi gắn với một GIẢ THUYẾT ngôn ngữ học, không phải "vì nhiều thì tốt".*

**Nguyên tắc "so what" cho ít tài nguyên:** hàm ý rộng nên nhấn *diagnostic/phương pháp tái dùng được* (matched-deletion, counterfactual) — đây mới là thứ chuyển giao được sang ngôn ngữ khác, chứ không phải con số F1 trên một corpus VN. Điều này khớp trực tiếp với 3 hướng H1/H2/H3 của project (chung một "vũ khí" phương pháp).

> Grounding cho hàm ý ít tài nguyên (Vietnamese MRC 2025): kết bằng *"scaling LLM-based solutions for underrepresented languages"* — nêu ý nghĩa cho cả nhóm ngôn ngữ, không chỉ tiếng Việt.

---

## 8. Checklist tự rà (trước khi nộp)

- [ ] Conclusion dài 1–2 đoạn (~120–220 từ), không phình.
- [ ] Câu mở "In this paper/work, we..." nhắc đóng góp — KHÔNG chép Abstract.
- [ ] Có **một câu thông điệp** đáng nhớ, ở mức ý nghĩa (không con số).
- [ ] KHÔNG con số/bảng mới; KHÔNG kết quả chưa từng xuất hiện ở Results.
- [ ] Không câu nào cắt-dán được nguyên si vào Abstract.
- [ ] Có câu "so what" — hàm ý rộng, không over-claim.
- [ ] Future work nêu 1–3 hướng **đặt tên được** (dataset/ngôn ngữ/kỹ thuật cụ thể), mỗi hướng gắn lý do.
- [ ] Không có câu meta rỗng ("we hope", "much remains to be done").
- [ ] Thì đúng: việc đã làm = past/present perfect; hướng tới = will + base verb.
- [ ] Giọng tự tin có kiểm soát; hedge đúng liều, không chồng hedge.
- [ ] (Nếu venue có Limitations riêng) không lặp lại hạn chế ở đây.
- [ ] Đọc to: đã xóa mọi câu "đưa đẩy" không thêm thông tin.

---

## 9. Ví dụ "trước → sau"

### Ví dụ A — mở đầu lặp Abstract + sáo rỗng
**TRƯỚC:**
> In this paper, we proposed a novel method for AI-text detection in Vietnamese, and we obtained an F1 score of 0.87 which is better than baselines. We hope this work can inspire more research in the future. There is still much work to be done.

**Vấn đề:** lặp con số Abstract; "we hope" + "much work to be done" rỗng; không có thông điệp, không future work cụ thể.

**SAU:**
> In this paper, we asked whether AI-text detectors judge Vietnamese writing by its content or by surface style. Using matched deletion, we found that native-speaker text is often flagged for the very fluency cues that also mark machine text, revealing a two-sided bias current benchmarks hide. In future work, we will test whether pairing our protocol with watermark-based signals reduces this bias on formal-register Vietnamese.

---

### Ví dụ B — future work "more data" rỗng
**TRƯỚC:**
> Our approach works well. In the future, we will explore more data, more languages, and more powerful models to improve performance.

**SAU:**
> Our anchor-reliance metric exposes how emotion classifiers lean on a few lexical anchors rather than sentence-level meaning. Because this failure mode is not language-specific, a natural next step is to apply the metric to Vietnamese social-media text, where emotion is often carried by particles and emoji rather than single anchor words — a setting we expect to stress classifiers differently from English.

---

### Ví dụ C — over-claim tác động
**TRƯỚC:**
> We have solved the problem of surface reliance in NLP judges. Our method will transform how all low-resource languages are evaluated and guarantees fair judgments.

**Vấn đề:** "solved", "all", "guarantees" — vống xa bằng chứng.

**SAU:**
> Our counterfactual probes show that LLM-as-a-judge scores shift under surface-only edits that leave content intact, indicating that these judges are not yet robust for high-stakes evaluation. Our framework is a diagnostic, not a fix; extending it to more Vietnamese judging tasks, and to related low-resource languages, is left for future work.

---

## Nguồn grounding (7 phần Conclusion THẬT, trích nguyên văn)

1. **McCoy, Pavlick, Linzen (2019)** — *Right for the Wrong Reasons: Diagnosing Syntactic Heuristics in NLI* (HANS), ACL. arXiv:1902.01007. Trích: *"their high accuracies on NLI test sets may be due to the exploitation of invalid heuristics rather than deeper understanding of language."* — https://arxiv.org/abs/1902.01007
2. **Ribeiro, Wu, Guestrin, Singh (2020)** — *Beyond Accuracy: Behavioral Testing of NLP Models with CheckList*, ACL. arXiv:2005.04118. Trích: *"While useful, accuracy on benchmarks is not sufficient for evaluating NLP models."* — https://arxiv.org/abs/2005.04118
3. **Liang et al. (2023)** — *GPT detectors are biased against non-native English writers*. arXiv:2304.02819. Trích: *"Future detection methods should move beyond solely relying on perplexity measures..."* (bài dùng Discussion thay cho Conclusion) — https://arxiv.org/abs/2304.02819
4. **ViANLI (2024)** — *Adversarial Natural Language Inference for Vietnamese*. arXiv:2406.17716. Tiêu đề mục: "Conclusion and Future Works". Trích: *"we plan to augment the dataset by increasing the amount of data and expanding it to various text genres."* — https://arxiv.org/abs/2406.17716
5. **Vietnamese–Chinese MT (2025)** — *An Efficient Approach for Machine Translation on Low-resource Languages*. arXiv:2501.19314. Trích (conclusion 2 câu): *"In the future, we will investigate other techniques such as contrastive learning for machine translation to improve our system."* — https://arxiv.org/abs/2501.19314
6. **Vietnamese MRC with LLMs (2025)** — *Investigating Recent LLMs for Vietnamese Machine Reading Comprehension*. arXiv:2503.18062. Trích: *"this study underscores the potential of scaling LLM-based solutions for underrepresented languages..."* — https://arxiv.org/abs/2503.18062
7. **LLMs for education management in Vietnamese (2025)** — arXiv:2501.15022. Trích: *"we present a simple and effective framework for applying large language models (LLMs) to educational domain."* — https://arxiv.org/abs/2501.15022

> Ghi chú liêm chính: các trích trên lấy qua bản HTML mở (arXiv/ar5iv/ACL Anthology). Trước khi ĐƯA vào bản thảo cuối, verify lại nguyên văn từ PDF chính thức (theo quy ước liêm chính ở PROJECT.md). Không trích nào được suy diễn/bịa.
