# 02 — INTRODUCTION (viết cho bài Q1 AI/NLP, tiếng Anh)

> Phần này chỉ nói về **Introduction**. Grounding: 7 phần mở đầu THẬT (trích verbatim, nguồn ở cuối file).
> Bối cảnh áp dụng: tác giả VN, nghiên cứu tiếng Việt / ít tài nguyên, chủ đề surface-feature reliance.
> Quy ước: **giải thích bằng tiếng Việt, mẫu câu bằng tiếng Anh** (bài đích viết EN).

---

## 1. Rhetorical moves (Swales CARS) — thứ tự & độ dài

Introduction NLP hiện đại đi theo mô hình **CARS (Create A Research Space)** của Swales, 3 move:

| Move | Tên | Mục đích | Độ dài điển hình (bài 8 trang) |
|------|-----|----------|-------------------------------|
| **M1** | Establishing a territory | Đặt vấn đề vào lĩnh vực, nêu tầm quan trọng, tóm tình trạng hiện tại | 1 đoạn (3–6 câu). ĐỪNG dài. |
| **M2** | Establishing a niche (GAP) | Chỉ ra thiếu sót/mâu thuẫn/câu hỏi chưa trả lời của M1 | 1–2 đoạn — đây là **trái tim** của Introduction |
| **M3** | Occupying the niche | "In this paper, we…" — cách tiếp cận + đóng góp + (đôi khi) kết quả chốt | 1–2 đoạn, kết bằng bullet contributions |

**Quy luật tỉ lệ:** M1 ngắn nhất, M2 sâu nhất, M3 cụ thể nhất. Tác giả yếu thường làm ngược (M1 dài lê thê, M2 mờ, M3 hứa suông).

**Chuyển từ rộng → hẹp (funnel):** mỗi câu trong M1→M2 phải hẹp hơn câu trước một bậc. Ví dụ chuỗi thu hẹp thật của DetectGPT: LLM tạo văn bản trôi chảy → nên cần công cụ phát hiện → các công cụ hiện có có điểm yếu X → chúng tôi khai thác tính chất Y. Không nhảy cóc từ "AI đang phát triển" thẳng sang "chúng tôi đo curvature".

---

## 2. Cấu trúc đoạn điển hình

Bài **hội nghị NLP (ACL/EMNLP, ~8 trang)** — Introduction gọn 4–6 đoạn:

1. **Đoạn 1 (M1):** territory + significance. 1 câu "hook" khách quan, không đại ngôn.
2. **Đoạn 2 (M2a):** tình trạng hiện tại chi tiết hơn (thường trích 3–6 công trình gần).
3. **Đoạn 3 (M2b — GAP):** "However, …" — nêu thiếu sót cụ thể, có thể đo được.
4. **Đoạn 4 (M3):** "In this paper, we propose/study …" — cách làm + phát hiện chốt.
5. **Đoạn 5:** **bullet list contributions** (2–4 gạch đầu dòng). Nhiều bài đóng thêm 1 câu "roadmap" hoặc bỏ hẳn.

Bài **journal Q1 (TACL, CL, IEEE/ACM TASLP…)**: Introduction **dài hơn, có thể gộp một phần Related Work** ngay trong M2 (2–3 đoạn điểm literature có phê phán), rồi mới tới M3. Journal cho phép nhiều context hơn; hội nghị ép cô đọng và tách hẳn Related Work thành mục riêng. → **Biết venue đích trước khi viết.** Với chương trình này (target Q1 journal cho H1/H2/H3), nghiêng bố cục journal: M2 mang tính survey-phê-phán nhẹ.

**Đoạn cuối = contributions** gần như bắt buộc ở NLP. Đây là "hợp đồng" với reviewer: mọi thứ liệt kê ở đây PHẢI xuất hiện lại trong Results.

---

## 3. Sentence frames theo move (EN) + giải thích (VI)

### M1 — Establishing the territory
- `X has become a central/standard task in NLP …` — câu định vị, trung tính.
- `Pre-trained language models … have recently … helped to produce significant improvement gains for various NLP tasks.` (thật, PhoBERT) — nêu tiến bộ mà KHÔNG tâng bốc.
- `Language technologies contribute to … around the world. However, only a very small number of the over 7000 languages … are represented …` (thật, Joshi et al.) — **mẫu vàng cho low-resource:** 1 câu tích cực rồi "However" bẻ ngay sang gap. Territory + niche chỉ trong 2 câu.

*VI:* M1 mở bằng một sự thật ai cũng đồng ý, có thể trích 1 nguồn khảo sát; tránh câu triết lý ("Since the dawn of communication…").

### M2 — Signaling the GAP
Các "gap connector" (đặt đầu câu/đoạn):
- `However, …` / `Despite this success, …` / `Yet, it remains unclear whether …`
- `While prior work has shown A, little attention has been paid to B.`
- `This strength can also be a weakness: … models … are prone to adopting shallow heuristics that succeed for the majority of training examples, instead of learning the underlying generalizations …` (thật, McCoy et al.) — **mẫu vàng cho hướng "surface reliance":** biến điểm mạnh thành gap, gap là một *hiện tượng đo được*, không phải "chưa ai làm".
- `Existing X … may not fully represent … because such data feature …` (theo ViSoBERT) — gap kiểu "mismatch domain/ngôn ngữ".

*VI:* gap mạnh = một **mệnh đề có thể sai** ("models rely on surface cues rather than content"), không phải một khoảng trống hành chính ("no study exists for Vietnamese").

### RQ / Hypothesis (đặt cuối M2 hoặc đầu M3)
- `We ask: does detector D rely on surface features F rather than content when judging Vietnamese text?`
- `We hypothesize that removing matched surface cues will collapse classifier accuracy to near chance if the model relies on those cues.`
- `The identification and empirical validation of the hypothesis that …` (thật, DetectGPT) — nêu giả thuyết như một đóng góp kiểm chứng được.

### M3 — Occupying the niche + contributions
Câu mở M3:
- `In this paper, we look at the relation between …` (thật, Joshi et al.)
- `In this paper, we propose / present / study / introduce …`

Bullet contributions (mẫu, mỗi bullet 1 động từ mạnh + 1 kết quả kiểm chứng được):
- `We introduce <method/metric>, the first <precise scope> for <task/language>.`
- `We show that <finding> on <N datasets/models>, reducing/improving <metric> by <number>.`
- `We release <artifact> (data/code/benchmark) to enable reproducible study of <problem>.`

Ví dụ thật (ViSoBERT) — 3 bullet: (i) *first* model cho VN social media; (ii) SOTA trên nhiều task; (iii) phân tích emoji/teencode/diacritics. Mỗi bullet ánh xạ tới một mục Results.

---

## 4. Quy ước ngôn ngữ (thì, thể, hedging, trích dẫn)

**Thì (tense):**
- M1 sự thật chung → **present simple** (`LLMs generate fluent text`).
- Công trình trước → **present perfect** (`Prior work has shown…`) hoặc past (`Bowman et al. (2015) devised…`).
- Việc mình làm trong bài → **present** (`In this paper, we propose…`, `We show that…`) — chuẩn NLP; tránh future ("we will").

**Thể:** ưu tiên **chủ động "we"** (`we propose`, `we find`) — NLP chuộng câu thẳng, đúng chuẩn viết của user (viết thẳng vào việc mình làm). Bị động chỉ khi tác nhân không quan trọng.

**Hedging vs booster:**
- **Hedge** khi tuyên bố nhân quả/khái quát: `suggests`, `tends to`, `may`, `we hypothesize`, `provides evidence that`. DetectGPT dùng "tends to be significantly more negative" — hedge + số liệu, không tuyệt đối hóa.
- **Booster** chỉ cho điều ĐÃ chứng minh trong bài: `we show`, `we demonstrate`, `significantly`. Đừng boost novelty ("revolutionary", "the best").
- Nguyên tắc: **để số liệu tự nói**; một câu có số > mười tính từ.

**Trích dẫn hỗ trợ luận điểm:** mỗi câu M2 quan trọng nên có neo trích dẫn. Trích để (a) chứng minh territory tồn tại, (b) chứng minh gap CHƯA được lấp — không phải trang trí. Dạng: `Prior detectors rely on token-likelihood features (Author, Year; Author, Year).` Tránh trích một cục 8 nguồn không phân biệt.

---

## 5. Reviewer Q1: THƯỞNG gì / RED FLAG gì

**Reviewer thưởng:**
- Gap là **mệnh đề kiểm chứng được**, gắn thẳng với thí nghiệm sẽ làm.
- Contributions **đo được** và **map 1–1** với Results.
- Một câu chốt định lượng sớm (`reduces accuracy from 88% to 54%`) — tạo niềm tin.
- Motivation "vì sao quan trọng NGAY CẢ khi thất bại" (nếu detector KHÔNG bám surface cue thì cũng là phát hiện đáng giá).
- Framing khiêm tốn nhưng sắc: nói rõ mình làm gì và KHÔNG làm gì.

**RED FLAG (trừ điểm / desk-reject rủi ro):**
- **Gap mơ hồ:** "has not been well studied" mà không nói studied *cái gì* sẽ sai/thiếu.
- **Over-claim novelty:** "first ever", "novel" mà M2 không chứng minh khoảng trống; reviewer sẽ chỉ ra 1 bài đi trước là hỏng.
- **"Gap-spotting" hời hợt:** gap chỉ là "chưa có cho tiếng Việt" (X-in-language-Y) — reviewer coi là incremental. Phải nâng thành câu hỏi khoa học (loại hình học tiếng Việt tạo ra hiện tượng KHÁC, không chỉ "thiếu dữ liệu").
- **Contributions không đo được:** "we explore", "we investigate" mà không có deliverable.
- **Mở bài quá rộng / lịch sử hóa.**
- **Hứa mà không giao:** bullet nêu điều Results không có.

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ + cách sửa

1. **Mở bài "vũ trụ":** *"Since the dawn of human communication, language has been…"* → **Sửa:** vào thẳng task + số liệu/nguồn. (So với PhoBERT mở bằng "Pre-trained language models… have recently…" — cụ thể, 1 câu.)
2. **Motivation yếu / vòng vo:** kể lể tầm quan trọng của AI nói chung. → **Sửa:** motivation phải dẫn TỚI gap của bài, không phải quảng cáo lĩnh vực.
3. **Đóng góp không đo được:** "we study the problem of…". → **Sửa:** động từ giao được (introduce/show/release) + con số/artifact.
4. **Chuỗi câu không thu hẹp (thiếu funnel):** mỗi câu một chủ đề rời. → **Sửa:** ép mỗi câu hẹp hơn câu trước; dùng connector (However/Yet/Specifically).
5. **Lạm dụng "very/significantly" không số liệu; over-hedge ("maybe possibly could")** → chọn 1 mức chắc chắn đúng với bằng chứng.
6. **Trích dẫn kiểu danh mục** (liệt kê không phê phán). → **Sửa:** mỗi trích gắn một chức năng luận điểm.
7. **Lỗi mạo từ/thì** (a/the, present-perfect) làm reviewer nghi ngờ độ chỉn chu → rà riêng một lượt.
8. **Câu meta thừa** ("In this section we will introduce the introduction of…") → cắt; viết thẳng.

---

## 7. Lưu ý riêng: nghiên cứu tiếng Việt / ít tài nguyên

**Biện minh gap thế nào cho MẠNH (tránh "vì chưa ai làm"):**

- **Không dùng:** "No prior work studies AI-detector reliability for Vietnamese." (gap hành chính → incremental).
- **Dùng — nâng lên hiện tượng khoa học:** đặc trưng **loại hình học** tiếng Việt tạo ra hành vi model KHÁC, khiến kết luận từ tiếng Anh không chuyển giao được. Với chương trình này, trục novelty đã chốt: **chữ Latin + DẤU THANH + đơn lập (isolating)** — ví dụ:
  - *Dấu thanh / thiếu dấu* là surface cue đặc thù VN mà detector/classifier tiếng Anh không có → matched-deletion trên dấu thanh là thí nghiệm chỉ VN mới làm được.
  - *Không biến hình (no morphology)* → nhiều "shortcut" hình thái mà mô hình EN dựa vào KHÔNG tồn tại → kiểm được giả thuyết reliance sạch hơn.
- **Universality argument:** đóng khung tiếng Việt như **một ca kiểm chứng (stress test)** cho một tuyên bố tổng quát (surface-reliance), không phải "case study địa phương". Reviewer Q1 mua "Vietnamese as a controlled probe of a general claim", không mua "we did X for Vietnamese too".
- **Cẩn trọng đã ghi trong project:** "multilingual" của benchmark KHÔNG bảo đảm có VN (RAID/M4) → nếu nói gap về dữ liệu, phải nêu chính xác benchmark nào thiếu VN. Và **góc "đơn lập" KHÔNG là novelty** nếu đối thủ là tiếng Trung (cũng đơn lập) — phải lead bằng **Latin + dấu thanh**.
- **Số liệu ngôn ngữ dùng để tăng sức nặng, KHÔNG để thương hại:** "~100 million speakers" (ViSoBERT) đặt như bằng chứng tầm quan trọng, không phải "tội nghiệp ngôn ngữ nhỏ". Joshi et al. là mẫu: dùng số (7000+ ngôn ngữ) để lập luận, không than.

---

## 8. Checklist tự rà (tick trước khi nộp)

- [ ] M1 ≤ 1 đoạn, câu đầu cụ thể, có neo trích dẫn (không "since the dawn…").
- [ ] Mỗi câu M1→M2 hẹp hơn câu trước (funnel).
- [ ] Gap là **mệnh đề kiểm chứng được** (có thể sai), không phải "chưa ai làm".
- [ ] Gap của VN nâng lên **hiện tượng loại hình học** (Latin + dấu thanh), không phải X-in-Vietnamese.
- [ ] Có RQ hoặc hypothesis nêu tường minh.
- [ ] M3 mở bằng "In this paper, we…" và nêu cách tiếp cận.
- [ ] Có **bullet contributions** (2–4), mỗi bullet động từ giao được + kết quả đo được.
- [ ] Mỗi contribution **map 1–1** tới một mục Results (không hứa suông).
- [ ] Ít nhất 1 con số chốt xuất hiện sớm.
- [ ] Thì đúng (present cho "we", perfect cho prior work); "we" chủ động.
- [ ] Hedge cho tuyên bố nhân quả; boost chỉ cho điều đã chứng minh; không "novel/first" nếu M2 chưa chứng minh.
- [ ] Không câu meta/tự-biện-hộ thừa; số liệu tự nói.
- [ ] Rà riêng một lượt mạo từ/thì/số nhiều (non-native pass).

---

## 9. Ví dụ "trước → sau"

**Ví dụ A — câu mở M1 (chống mở bài vũ trụ)**
- *Trước:* "Since the beginning of the digital era, artificial intelligence has transformed every aspect of human life, and text classification is one of its most important applications."
- *Sau:* "Pre-trained language models now underpin most Vietnamese NLP systems, yet it remains unclear whether their decisions rest on content or on surface cues such as diacritics (Author, Year)."
- *Vì sao:* câu Sau vào thẳng đối tượng, gài sẵn gap và trục novelty (dấu thanh), có chỗ trích dẫn.

**Ví dụ B — gap "hành chính" → gap "khoa học"**
- *Trước:* "However, no previous work has evaluated AI-text detectors on Vietnamese, so we fill this gap."
- *Sau:* "However, detectors are calibrated on English morphological and stylistic cues; Vietnamese is an isolating, Latin-script language marked by tone diacritics, so it is unknown whether these detectors track generation artifacts or merely surface orthographic patterns that differ systematically for native writers."
- *Vì sao:* câu Sau nêu một giả thuyết có thể sai và giải thích *vì sao* VN là ca kiểm chứng, không phải "chưa ai làm".

**Ví dụ C — contribution mơ hồ → đo được**
- *Trước:* "We investigate the reliance of classifiers on surface features in Vietnamese and provide some analysis."
- *Sau:*
  - "We introduce a matched-deletion protocol that removes diacritic/lexical surface cues while preserving content, and apply it to N=3 classifiers."
  - "We show that deleting matched surface cues drops macro-F1 from 0.86 to 0.58, evidence of strong surface reliance."
  - "We release the counterfactual Vietnamese benchmark and code for reproducibility."
- *Vì sao:* mỗi bullet có deliverable + số, map thẳng tới Results; không "investigate/some analysis".

---

## Nguồn thật đã trích (verbatim, fetched — KHÔNG bịa)

1. **PhoBERT: Pre-trained Language Models for Vietnamese** — Nguyen & Nguyen (2020). arXiv:2003.00744. https://arxiv.org/abs/2003.00744 — (M1 câu mở "Pre-trained language models…"; 4 bullet contributions "the first large-scale monolingual… for Vietnamese").
2. **The State and Fate of Linguistic Diversity and Inclusion in the NLP World** — Joshi, Santy, Budhiraja, Bali, Choudhury (ACL 2020). arXiv:2004.09095. https://arxiv.org/abs/2004.09095 — (mẫu M1→M2 low-resource "…only a very small number of the over 7000 languages…"; "In this paper we look at…").
3. **Right for the Wrong Reasons: Diagnosing Syntactic Heuristics in NLI** — McCoy, Pavlick, Linzen (ACL 2019). arXiv:1902.01007. https://arxiv.org/abs/1902.01007 — (mẫu gap surface-reliance: "shallow heuristics that succeed for the majority of training examples, instead of learning the underlying generalizations").
4. **DetectGPT: Zero-Shot Machine-Generated Text Detection using Probability Curvature** — Mitchell et al. (ICML 2023). arXiv:2301.11305. https://arxiv.org/abs/2301.11305 — (contributions dạng "identification and empirical validation of the hypothesis that…").
5. **Annotation Artifacts in Natural Language Inference Data** — Gururangan, Swayamdipta, Levy, Schwartz, Bowman, Smith (NAACL 2018). arXiv:1803.02324. https://arxiv.org/abs/1803.02324 — (M1 định nghĩa task rồi cài gap về dataset artifacts).
6. **Can AI-Generated Text be Reliably Detected?** — Sadasivan et al. (2023). arXiv:2303.11156. https://arxiv.org/abs/2303.11156 — (gap về độ tin cậy detector; framing "not reliable in practical scenarios").
7. **ViSoBERT: A Pre-Trained Language Model for Vietnamese Social Media Text Processing** — Nguyen, Phan, Nguyen, Nguyen (EMNLP 2023). arXiv:2310.11166. https://arxiv.org/abs/2310.11166 — (3 bullet contributions "the first…"; biện minh VN "~100 million speakers", emoji/teencode/diacritics).

> Ghi chú: trích dẫn lấy qua bản HTML đầy đủ (ar5iv.labs.arxiv.org) vì PDF aclanthology/arxiv trả binary. Câu verbatim đã đối chiếu tại nguồn; nếu đưa vào bản thảo, fetch lại toàn văn để xác minh số trang/câu.
