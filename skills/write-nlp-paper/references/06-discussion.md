# 06 — DISCUSSION (Thảo luận)

> Phần này thuộc guideline viết bài Q1 AI/NLP, bối cảnh tác giả người Việt / nghiên cứu tiếng Việt & ít tài nguyên. **Bài đích viết bằng tiếng Anh.** Giải thích bằng tiếng Việt, mẫu câu bằng tiếng Anh.
>
> **Chức năng cốt lõi của Discussion: DIỄN GIẢI Ý NGHĨA, không lặp lại số liệu.** Results nói "cái gì" (what) — Discussion nói "thế thì sao / vì sao" (so what / why). Nếu một câu chỉ nhắc lại con số mà không thêm diễn giải, nó thuộc Results, không thuộc Discussion.
>
> **Grounding:** các câu tiếng Anh minh hoạ ở mục 3 và 9 được viết theo khuôn mẫu quan sát từ 6 phần Discussion/Limitations THẬT (liệt kê ở cuối). Câu trích nguyên văn có ghi rõ nguồn + đánh dấu ngoặc kép; câu do tôi soạn để làm frame thì KHÔNG gán nguồn.

---

## 1. Rhetorical moves của Discussion

Trình tự tu từ điển hình (không phải mọi bài đủ 6, nhưng thứ tự này là mạch chuẩn):

1. **Khẳng định phát hiện chính (restate key finding, ở mức diễn giải).** Không copy bảng — nói ý nghĩa: "X cho thấy Y". Trả lời thẳng research question đặt ở Introduction.
2. **Diễn giải cơ chế (why / how).** Vì sao có kết quả đó? Đề xuất lời giải thích có căn cứ, **có hedge**. Đây là phần khó nhất và là nơi reviewer Q1 tìm giá trị trí tuệ.
3. **So với công trình trước (situate).** Khớp ai? Trái ai? Và **vì sao** khớp/trái (khác dữ liệu? khác ngôn ngữ? khác thiết lập?). Không chỉ "phù hợp với [12]".
4. **Hàm ý (implications).** Lý thuyết (đóng góp vào hiểu biết chung) và thực tiễn (ai dùng được, dùng thế nào). Phân tầng, đừng thổi phồng.
5. **Limitations (thẳng thắn).** Nêu ranh giới thật của kết luận — biến nó thành điểm mạnh, không phải lời xin lỗi.
6. **Mở đường (future work).** Ngắn, gắn với limitation vừa nêu; tránh danh sách ước mơ.

Nguyên tắc vàng: **mỗi move phải "kiếm được chỗ đứng"** — nếu bỏ đi mà bài không mất gì, thì nó là filler.

---

## 2. Cấu trúc điển hình & ranh giới

**Hai kiểu bố cục thường gặp:**

- **Kiểu journal (Discussion tách riêng):** một mục `Discussion` dài, đôi khi có tiểu mục theo từng finding hoặc theo từng RQ. Q1 journal thường yêu cầu kiểu này; Discussion rõ ràng nhất ở journal.
- **Kiểu hội nghị NLP (ACL/EMNLP/NAACL):** thường KHÔNG có mục tên "Discussion" riêng. Diễn giải nằm rải trong `Analysis`, hoặc mục kiểu `Why does it matter?`, hoặc gộp `Results and Discussion`. `Limitations` là mục BẮT BUỘC riêng (theo ACL policy). → Nếu nộp hội nghị, đừng cố nhét một mục "Discussion" hình thức; đặt diễn giải trong Analysis và giữ Limitations riêng.

**Ranh giới với Results:** Results = quan sát trung tính + số liệu ("model A đạt 62.1 F1, cao hơn B 4 điểm"). Discussion = diễn giải ("khoảng cách này gợi ý B phụ thuộc đặc trưng bề mặt vốn biến mất trong tập matched-deletion"). **Test nhanh:** câu có chứa con số mới mà chưa từng xuất hiện ở Results? → có thể bạn đang nhét kết quả vào nhầm chỗ.

**Ranh giới với Conclusion:** Discussion = diễn giải CHI TIẾT có sắc thái, có hedge, có so sánh. Conclusion = chốt NGẮN, cao độ, một-hai câu take-home + đóng khung lại đóng góp; KHÔNG mở diễn giải mới, KHÔNG số liệu mới. Nếu Conclusion của bạn dài bằng Discussion, một trong hai sai chỗ.

---

## 3. Sentence frames (tiếng Anh) — kèm giải thích tiếng Việt

### 3.1 Khẳng định finding chính (past cho phát hiện cụ thể, present cho khái quát)
- `Our results show that [model] relies on [surface cue] rather than [content], answering the question of whether ...` — trả lời thẳng RQ.
- `Taken together, these findings indicate that ...` — tổng hợp nhiều kết quả thành một mệnh đề. *(Khuôn quan sát ở Basque MLLM: "Those three findings together indicate that ...")*
- `The most striking result is that ...` — dùng tiết kiệm, chỉ cho phát hiện thật sự nổi bật.

### 3.2 Giải thích nguyên nhân / cơ chế (BẮT BUỘC hedge)
- `A likely explanation is that ...`
- `This pattern may stem from the fact that [model] was pretrained on a task closely aligned with ours ...` — *(khuôn từ Hausa correction, Discussion: "M2M100 is an encoder–decoder model pretrained on a task much more similar to ours ...")*
- `We attribute this gap to ..., although we cannot rule out ...` — vừa đề xuất cơ chế vừa thừa nhận cơ chế thay thế.
- `The weaker the model's competence in a language, the more errors it is likely to introduce.` — *(nguyên văn LLM-as-Judge LRL: "The weaker the LLM's competence in a language, the more errors and biases are likely to be introduced ...")* — mẫu câu nêu cơ chế theo dạng "càng… càng…", vẫn có `likely`.

### 3.3 So sánh với prior work
- `This is consistent with [Author, year], who found ...` — khớp.
- `In contrast to [Author, year], we find ..., possibly because our data covers [Vietnamese / a tonal, isolating language] rather than [English].` — trái, **kèm lý do**.
- `Our results extend [line of work] to the low-resource setting, where [prior assumption] no longer holds.` — mở rộng, định vị đóng góp.
- `Even when compared to [prior]'s already modest results, our scores remain low, suggesting that ...` — *(khuôn từ FormosanBench: "even when compared to Zheng et al. (2024)'s already modest results")* — so sánh thẳng thắn cả khi kết quả của mình khiêm tốn.

### 3.4 Hàm ý (implication)
- `Practically, this implies that practitioners should not assume [X] for [low-resource language] by default.`
- `Human validation remains essential, especially for low-resource languages, where [tool] reliability cannot be assumed by default.` — *(nguyên văn LLM-as-Judge LRL)* — booster có kiểm soát: mạnh mẽ nhưng có phạm vi ("especially for...").
- `Theoretically, our findings suggest that [surface reliance] is not an artifact of English but a more general property of ...`

### 3.5 Limitations (lịch sự nhưng THẬT — không tự huỷ)
- `Although [language] is representative of many low-resource languages in the resources available, our results may not fully generalize to other low-resource languages.` — *(khuôn từ Basque MLLM Limitations)* — nêu giới hạn generalization mà vẫn giữ giá trị: khẳng định tính đại diện TRƯỚC, rồi mới hedge.
- `We present results for only a limited number of [items/languages]; a broader range would help build a more comprehensive understanding.` — *(khuôn từ FormosanBench Limitations)*
- `Because our noise is synthetic, it might not match naturally occurring patterns in real documents.` — *(khuôn từ Hausa Limitations)* — giới hạn tính hiệu lực cấu trúc (construct validity), nêu cụ thể chứ không chung chung.
- `We do not make quantitative claims; our analysis is qualitative and bounded by a sample of N items.` — *(khuôn từ Zeno's Paradox Limitations: "We also do not make quantitative claims.")* — tự giới hạn phạm vi tuyên bố = tăng độ tin, không giảm.

### 3.6 Mở đường (gắn với limitation)
- `Future work could extend this to [other tonal languages] to test whether the mechanism we identify generalizes.`
- `While a longitudinal analysis was not feasible with our sample, future work could ...` — *(khuôn từ Zeno's Paradox)* — future work MỌC RA TỪ limitation vừa nêu, không rời rạc.

---

## 4. Quy ước ngôn ngữ: thì, hedging, booster

**Thì (tense):**
- **Present** cho diễn giải và khẳng định khái quát: `These results suggest that surface reliance persists ...` (mệnh đề vẫn đúng ngoài bài).
- **Past** cho phát hiện cụ thể của chính bạn / hành động đã làm: `Model B dropped 9 F1 points under matched deletion.`
- **Present perfect** khi nối tới literature đang tiếp diễn: `Prior work has shown that ...`

**Hedging (đây là nơi hedge QUAN TRỌNG NHẤT trong cả bài):** `may / might / could / suggests / indicates / a likely explanation / appears to / is consistent with / we hypothesize that`. Diễn giải cơ chế mà không hedge = over-claim nhân quả — red flag số một ở Discussion.

**Booster (khẳng định mạnh) — dùng có kiểm soát:** `clearly, strongly, demonstrate, establish`. Chỉ dùng cho điều dữ liệu THỰC SỰ chứng minh (ví dụ hiệu ứng lớn, đã kiểm định). Với diễn giải/nguyên nhân → luôn hedge. Cách chuyên nghiệp: **booster cho quan sát, hedge cho giải thích.** Ví dụ: "The drop is large and consistent (booster); a plausible cause is lexical anchoring (hedge)."

**Cân bằng theo tinh thần user (viết thẳng, cắt meta):** hedge là để CHÍNH XÁC, không phải để tự phòng thủ. Đừng chồng nhiều lớp hedge ("it may possibly perhaps suggest" ✗). Một hedge đúng chỗ là đủ. Và **đừng viết câu tự-dự-đoán/tự-biện-hộ** kiểu "we believe our work will be very useful" — thay bằng mệnh đề kiểm chứng được: "our benchmark distinguishes models that prior metrics conflate."

---

## 5. Reviewer Q1 THƯỞNG gì / RED FLAG

**Reviewer cho điểm cao khi:**
- Discussion **trả lời đúng RQ** đã hứa ở Introduction (đóng khung khép kín).
- Có **cơ chế** thuyết phục, không chỉ mô tả lại số.
- **So sánh có phân tích** với prior work (giải thích khác biệt, không chỉ trích dẫn).
- **Limitations trung thực và cụ thể** — reviewer tin tác giả hiểu rõ giới hạn của chính mình.
- Phân biệt rạch ròi **tương quan vs nhân quả**.

**RED FLAG (trừ điểm / xin sửa lớn):**
- **Lặp lại Results** — kể lại số liệu, zero diễn giải.
- **Over-claim nhân quả:** "X causes Y" khi chỉ có tương quan/quan sát trên một setup.
- **Over-claim generalization:** kết luận cho "mọi ngôn ngữ ít tài nguyên" từ 1 ngôn ngữ, 1 dataset.
- **Giấu limitation** hoặc viết limitation chiếu lệ ("as with any study, there are limitations").
- **Không trả lời RQ** — Discussion trôi sang chủ đề khác.
- **Không so với prior work** — như thể bài ra đời trong chân không.
- **Con số mới xuất hiện lần đầu ở Discussion** (đáng lẽ ở Results).

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ — và cách sửa

1. **Limitations kiểu tự phủ nhận (self-destruct).** Viết "our sample is too small and our method is not robust, so results may be unreliable" → vô tình mời reject.
   - Sửa: nêu giới hạn KÈM phạm vi vẫn hợp lệ. *"Our study covers one language; while this limits breadth, the controlled matched-deletion design lets us isolate the effect cleanly."* Giới hạn là ranh giới, không phải lời thú tội.

2. **Limitations chiếu lệ (throwaway).** Một câu chung chung "there are some limitations" rồi thôi → reviewer đọc là né tránh.
   - Sửa: nêu 2–3 giới hạn CỤ THỂ, có thật, mỗi cái một câu, ưu tiên cái reviewer chắc chắn sẽ hỏi (cỡ mẫu, tính đại diện, construct validity).

3. **Lặp Results vì sợ "thiếu nội dung".** Tâm lý muốn Discussion dài.
   - Sửa: mỗi đoạn Discussion phải thêm MỘT ý mới (cơ chế / so sánh / hàm ý). Nếu không có ý mới, cắt.

4. **Over-claim do dịch word-by-word từ tiếng Việt.** "Kết quả chứng minh rằng..." → "results prove that" (từ `prove` quá mạnh trong tiếng Anh học thuật).
   - Sửa: `results suggest / indicate / show`. Bỏ `prove`, `obviously`, `it is well known that`.
   - Xem thêm phần thì/hedge ở mục 4.

5. **Nhầm tương quan ↔ nhân quả** do cấu trúc câu tiếng Việt lỏng về tác nhân.
   - Sửa: nếu chưa có can thiệp/thí nghiệm đối chứng, dùng `is associated with / co-occurs with`, không dùng `causes / leads to`.

6. **Câu meta thừa** ("In this section, we will discuss...", "It is worth noting that...", "As we all know...").
   - Sửa: vào thẳng nội dung. Theo chuẩn viết của user — cắt câu meta/tự-biện-hộ, VIẾT THẲNG vào việc mình làm và tìm thấy.

---

## 7. Lưu ý riêng tiếng Việt / ít tài nguyên — nêu giới hạn sao cho MẠNH

Ở low-resource, ba giới hạn hay bị nêu YẾU. Cách biến chúng thành phần trình bày mạnh:

- **Generalizability (chỉ 1 ngôn ngữ):** ĐỪNG xin lỗi. Khẳng định tính đại diện trước, rồi khoanh vùng. Mẫu Basque: *"Although Vietnamese is representative of many tonal, isolating, Latin-script low-resource languages, our results may not fully generalize to other low-resource languages."* → vừa thật thà vừa nêu bật vì sao chọn tiếng Việt là chọn ĐÚNG (nó đại diện một lớp loại hình học).
- **Cỡ mẫu nhỏ:** nêu con số thẳng và nói rõ tuyên bố nào KHÔNG rút ra được. Mẫu Zeno's Paradox: *"We do not make quantitative claims."* / *"a longitudinal analysis was not feasible with our sample of N."* → tự giới hạn = tăng độ tin.
- **Đặc thù ngôn ngữ = novelty, không phải cái cớ.** Với tiếng Việt, trục phân biệt thật là **chữ Latin + dấu thanh** (KHÔNG phải "đơn lập/không biến hình" — tiếng Trung cũng đơn lập). Trong Discussion, dùng đặc thù này để GIẢI THÍCH cơ chế: ví dụ vì sao xoá dấu thanh (matched-deletion trên diacritics) làm lộ surface reliance mà tiếng Anh không có tương ứng. → đặc thù ngôn ngữ trở thành công cụ chẩn đoán, là đóng góp.
- **Đánh giá kém tin ở low-resource:** nếu bài dùng LLM-as-judge/auto-metric, PHẢI thảo luận độ tin. Mẫu LLM-as-Judge LRL: *"Human validation remains essential, especially for low-resource languages, where judge reliability cannot be assumed by default."* — nêu như một hàm ý phương pháp, không phải chỉ là caveat.
- **Cẩn trọng nhãn "multilingual":** khi so với prior "đa ngữ" mà thực ra không có tiếng Việt (RAID, M4...), Discussion nên chỉ ra khoảng trống này như một lý do đóng góp của bài — nhưng chỉ khi đã fetch xác minh danh sách ngôn ngữ.

---

## 8. Checklist tự rà (trước khi coi Discussion là xong)

- [ ] Câu đầu (hoặc gần đầu) **trả lời thẳng RQ** của Introduction?
- [ ] Mỗi đoạn thêm **ít nhất một ý mới** (cơ chế / so sánh / hàm ý), không lặp Results?
- [ ] Có **ít nhất một lời giải thích cơ chế**, và nó **có hedge**?
- [ ] Có **so sánh phân tích** với ≥2 prior work (khớp và/hoặc trái, kèm lý do)?
- [ ] Hàm ý phân tầng **lý thuyết + thực tiễn**, không thổi phồng?
- [ ] Không có **con số mới** nào xuất hiện lần đầu ở đây?
- [ ] Mọi tuyên bố nhân quả đã kiểm: có can thiệp đối chứng không? nếu không → hạ xuống `associated with`?
- [ ] Generalization **khoanh đúng phạm vi** (không nhảy từ 1 ngôn ngữ ra "mọi low-resource")?
- [ ] Limitations: **2–3 cái cụ thể, thật**, mỗi cái kèm phạm vi vẫn hợp lệ — KHÔNG tự huỷ, KHÔNG chiếu lệ?
- [ ] Future work **mọc ra từ** limitation vừa nêu?
- [ ] Bỏ hết câu meta/tự-biện-hộ/`prove`/`obviously`?
- [ ] Discussion khác rõ với Conclusion (Conclusion không mở diễn giải mới)?

---

## 9. Ví dụ "trước → sau"

### Ví dụ 1 — Lặp Results (không diễn giải)
**Trước:** *"Model B achieved 62.1 F1, which is 4 points lower than Model A's 66.1 F1. Under matched deletion, Model B dropped to 53.0 F1."*
→ Chỉ kể lại số. Đây là Results.

**Sau:** *"The 9-point drop that Model B suffers under matched deletion—far larger than Model A's—suggests that B's apparent competence rests substantially on surface cues that our controlled deletion removes. This is consistent with [Author, year] for English, and our results extend that finding to a tonal, Latin-script language where the cue is diacritic-bearing."*
→ Diễn giải cơ chế + hedge + so sánh + định vị đóng góp.

### Ví dụ 2 — Limitations tự huỷ → limitations mạnh
**Trước:** *"Our dataset is small and only in Vietnamese, so our results might not be reliable and cannot be generalized."*
→ Mời reject: tự nghi ngờ độ tin của chính mình.

**Sau:** *"Our study covers a single language and a sample of N items. While this limits breadth, the controlled matched-deletion design isolates the surface-reliance effect cleanly, and Vietnamese is representative of tonal, Latin-script low-resource languages; results may nonetheless not fully generalize to typologically different low-resource languages, which we leave to future work."*
→ Nêu giới hạn thật + phạm vi vẫn hợp lệ + đại diện loại hình + future work gắn liền.

### Ví dụ 3 — Over-claim nhân quả/generalization → hiệu chỉnh
**Trước:** *"These results prove that LLM judges are unreliable and should never be used for any low-resource language."*
→ `prove` quá mạnh; `never / any` khái quát quá xa dữ liệu.

**Sau:** *"These results suggest that LLM-as-judge reliability degrades as the model's competence in the target language weakens; accordingly, human validation remains essential for low-resource languages, where judge reliability cannot be assumed by default."*
→ Hedge cơ chế (`suggest`, `as ... weakens`) + hàm ý phương pháp có phạm vi, không cấm tuyệt đối.

---

## Nguồn thật đã tra (HTML mở, trích ngày 2026-08-05)

Các câu trong ngoặc kép có gán "nguyên văn" được lấy qua WebFetch trang HTML; nên xác minh lại toàn văn PDF trước khi trích vào bản thảo (fetch bằng một model nhỏ có thể sai lệch nhỏ).

1. **FormosanBench: Benchmarking Low-Resource Austronesian Languages in the Era of LLMs** — arXiv 2506.21563. (Results/Discussion: so sánh "even when compared to Zheng et al. (2024)'s already modest results"; ROUGE<20 noise vs signal; Limitations: "only a limited number of Formosan languages".) https://arxiv.org/html/2506.21563
2. **The Zeno's Paradox of 'Low-Resource' Languages** — arXiv 2410.20817. (Limitations: "We also do not make quantitative claims"; sample of 150 papers, longitudinal not feasible.) https://arxiv.org/html/2410.20817
3. **Multimodal Large Language Models for Low-Resource Languages: A Case Study for Basque** — arXiv 2511.09396. (Conclusions: "Those three findings together indicate that ..."; Limitations: "Although Basque is representative ... may not fully generalize".) https://arxiv.org/html/2511.09396
4. **Challenges and Recommendations for LLMs-as-a-Judge in Multilingual Settings and Low-Resource Languages** — arXiv 2607.02235. (Discussion: hedged concession về LLM judge; "Human validation remains essential ..."; "The weaker the LLM's competence ... the more errors and biases are likely to be introduced".) https://arxiv.org/html/2607.02235
5. **Automatic Correction of Writing Anomalies in Hausa Texts** — arXiv 2506.03820. (Discussion: cơ chế "M2M100 ... pretrained on a task much more similar to ours"; Limitations: synthetic noise may not match natural documents.) https://arxiv.org/html/2506.03820
6. **A Pilot Study of Text-to-SQL Semantic Parsing for Vietnamese** — ACL Anthology 2020.findings-emnlp.364. (Trang chỉ có abstract; dùng làm ví dụ bối cảnh Vietnamese low-resource, KHÔNG trích Discussion vì không lấy được toàn văn HTML.) https://aclanthology.org/2020.findings-emnlp.364/
