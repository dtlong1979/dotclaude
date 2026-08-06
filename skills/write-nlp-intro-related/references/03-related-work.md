# 03 — RELATED WORK / BACKGROUND (guideline viết bài Q1 NLP)

> Phạm vi file: DUY NHẤT phần Related Work / Background. Bài đích viết **tiếng Anh**;
> ngữ cảnh: tác giả người Việt, chủ đề NLP tiếng Việt / ngôn ngữ ít tài nguyên
> (surface-feature reliance, AI-text detection, LLM-as-judge).
> Giải thích bằng tiếng Việt — mẫu câu bằng tiếng Anh.
>
> GROUNDING: mọi mẫu "câu thật" trong file được trích verbatim từ Related Work/Background
> của bài NLP mở (ar5iv/arXiv). Danh sách nguồn ở cuối. Câu do tôi soạn làm khuôn thì
> ghi rõ là *frame* (khuôn), không phải trích dẫn.

---

## Phân biệt trước tiên: "Related Work" vs "Background"

Hai thứ KHÁC nhau, đừng gộp bừa:

- **Background (Kiến thức nền):** dạy người đọc khái niệm/ký hiệu/định nghĩa cần để hiểu
  phần Method (ví dụ: định nghĩa "surface feature", cơ chế subword tokenization, thanh điệu
  tiếng Việt, cách một AI-detector tính perplexity). Mục tiêu: **đủ để hiểu**, không định vị
  đóng góp. Viết ở **present tense** (chân lý chung). Thường đứng ngay sau Introduction hoặc
  đầu Method.
- **Related Work (Công trình liên quan):** **định vị đóng góp của bạn** trong bản đồ nghiên
  cứu — ai đã làm gì, dòng nào để lại khoảng trống gì, và bạn lấp chỗ nào. Mục tiêu:
  **thuyết phục rằng đóng góp của bạn mới & cần thiết**. Đây KHÔNG phải chỗ dạy khái niệm.

Quy tắc: nếu một đoạn không giúp người đọc thấy **bạn khác/hơn ở đâu**, nó thuộc Background
(hoặc nên cắt), không thuộc Related Work.

---

## 1. Rhetorical moves — bốn nước đi bắt buộc

Related Work Q1 không phải "kể lại các bài", mà là một **lập luận** dẫn tới gap của bạn. Cấu
trúc lõi (lặp cho mỗi chủ đề, không phải cho mỗi bài):

**Move 1 — Mở chủ đề (topic sentence tổng hợp).** Câu đầu mỗi đoạn nêu *một luận điểm về
cả một dòng nghiên cứu*, không phải tên một bài. Người đọc phải biết đoạn này nói về CHỦ ĐỀ gì.

**Move 2 — Tổng hợp dòng nghiên cứu (grouped synthesis).** Gộp nhiều bài chung một câu theo
điểm chung/khác, dùng citation cụm. Đây là phần phân biệt Q1 với sinh viên: *bạn đọc thay
người đọc và rút ra quy luật*, không dán mỗi bài một câu.

**Move 3 — Chỉ ra hạn chế của dòng đó (lịch sự, có lý do).** Nêu điều dòng trước CHƯA làm /
giả định họ đặt / bối cảnh họ chưa phủ. Không chê người — chê *khoảng trống*.

**Move 4 — Neo về gap & đóng góp của bạn (research-gap → contribution).** Một câu chuyển:
"Chính vì [hạn chế], trong bài này chúng tôi [đóng góp]". Đây là nước đi hay bị quên nhất;
thiếu nó thì Related Work trôi nổi, reviewer hỏi "so what?".

Ví dụ chuỗi 4 move thật, từ McCoy et al. (2019) — họ mở bằng tổng hợp cả dòng, rồi neo về mình:
> "This project relates to an extensive body of research on exposing and understanding
> weaknesses in models' learned behavior and representations." *(Move 1–2: mở + gộp cả dòng)*
> ... "Our work focuses instead on structural phenomena, following the proof-of-concept work
> done by Dasgupta et al. (2018)." *(Move 3–4: instead = tách khỏi dòng, neo về mình)*

Và Gururangan et al. (2018) minh họa Move 2 + Move 4 sát nhau:
> "Levy et al. (2015) demonstrated that supervised lexical inference models rely heavily on
> artifacts in the datasets..." → "These findings coincide with ours, and strongly suggest
> that supervised models will exploit shortcuts in the data..." *(neo bài mình vào dòng đó)*.

> Sơ đồ một đoạn Related Work chuẩn:
> `[topic sentence] → [gộp 2–4 bài + điểm chung] → [nhưng dòng này giả định/bỏ sót X] → [ta làm Y]`

---

## 2. Cách tổ chức: thematic / chronological / methodological

Ba trục sắp xếp. **Mặc định Q1 = thematic.** Ba trục có thể lồng nhau (thematic ở cấp
section, chronological *trong* một chủ đề).

| Trục | Sắp theo | Khi nào dùng | Rủi ro |
|---|---|---|---|
| **Thematic** (chủ đề/luận điểm) | Nhóm vấn đề (VD: "shortcut detection", "low-resource models", "counterfactual eval") | **Mặc định**, gần như luôn dùng cho Q1 | Cần thật sự tổng hợp, không lười |
| **Methodological** (theo phương pháp) | Họ kỹ thuật (probing / adversarial / watermarking / zero-shot) | Khi đóng góp của bạn LÀ một phương pháp mới, đối chiếu với các họ phương pháp | Dễ thành catalog kỹ thuật |
| **Chronological** (thời gian) | Mốc thời gian | Chỉ khi câu chuyện của bạn LÀ sự tiến hóa (survey; "từ n-gram → BERT → LLM") | **Nguy hiểm**: dễ tụt thành liệt kê "năm X, năm Y" |

Sadasivan et al. (2023) là mẫu **methodological** đẹp — chia đúng ba họ:
> "Several detection works study this problem as a binary classification problem..." /
> "Another stream of work focuses on zero-shot AI text detection without any additional
> training overhead..." / "Another line of work aims to watermark AI-generated texts..."
> → ba dòng phương pháp, mỗi dòng một đoạn, rồi bài họ tấn công cả ba.

**Số đoạn điển hình:**
- Bài hội nghị (ACL/EMNLP, 8 trang): Related Work = **3–5 đoạn**, ~0.75–1 trang; mỗi đoạn =
  một chủ đề. Nếu chật chỗ, nhiều bài NLP **gộp Related Work vào Introduction** (xem Sadasivan;
  Joshi et al. 2020 thậm chí không có section riêng — dàn citation trong intro/typology).
- Bài tạp chí Q1 (dài hơn): **1.5–3 trang**, 4–7 đoạn, có thể chia sub-subsection theo chủ đề.
- **Quy tắc "một chủ đề = một đoạn"**: nếu một đoạn nhảy 3 chủ đề → tách; nếu 3 đoạn cùng nói
  một ý → gộp.

**Section riêng vs gộp Introduction:**
- Section riêng "Related Work" (thường Section 2 hoặc áp chót trước Conclusion): khi có nhiều
  dòng cần phân loại rõ.
- Gộp vào Introduction: bài ngắn, đóng góp sắc, ít dòng liên quan — nêu gap ngay trong intro.
- Đặt Related Work **áp chót** (sau Method/Results): khi cần người đọc hiểu phương pháp mình
  rồi mới so được — hợp với bài diagnostic/counterfactual như của bạn.

---

## 3. Sentence frames (tiếng Anh) — copy & thay ruột

### 3a. Câu gộp nhiều citation (grouped / synthesizing) — XƯƠNG SỐNG của Related Work
Đây là kỹ năng quan trọng nhất. Một câu, nhiều bài, một luận điểm.

- *A growing body of work has shown that neural NLU models exploit **surface cues** rather
  than task-relevant content [C1; C2; C3].*
- *Several studies have documented **spurious correlations** in benchmark datasets [C1; C2],
  where models achieve high accuracy by relying on annotation artifacts alone.*
- *Prior work on X broadly falls into two lines: (i) ... [C1; C2], and (ii) ... [C3; C4].*
- *To address low-resource languages, one could either train a language-specific model
  [C1; C2; C3] or fine-tune an existing multilingual model [C4; C5].* — khuôn theo PhoBERT thật:
  > "For other languages, one could retrain a language-specific model using the BERT
  > architecture (Cui et al., 2019; de Vries et al., 2019; Vu et al., 2019; Martin et al., 2020)
  > or employ existing pre-trained multilingual BERT-based models (Devlin et al., 2019;
  > Conneau and Lample, 2019; Conneau et al., 2020)."
  → một câu, **7 citation, chia 2 lựa chọn** — mật độ cao mà vẫn có luận điểm.
- *This line of research converges on a common finding: ... [C1; C2; C3].*

### 3b. Câu so sánh / đối lập ("Unlike X, we...")
Neo bạn vào bản đồ. Đừng để reviewer tự đoán bạn khác gì.

- *Unlike prior work that evaluates detectors only on **high-resource English** [C1; C2], we
  study surface reliance in **Vietnamese**, a tonal, isolating language written in Latin script.*
- *In contrast to classification-based probes [C1], our approach is **model-agnostic** and
  requires no access to model internals.* — khuôn theo McCoy: *"Unlike the classification
  approach, this approach is agnostic to model structure..."*
- *Whereas [C1] measure X on synthetic data, we test it under **matched-deletion counterfactuals**.*
- *Our work departs from this line in that ...*
- *While these approaches ... , they share a common assumption that ..., which we relax.*
- *Building on [C1] but going further, we ...* — (dùng khi kế thừa chứ không phủ nhận;
  giống McCoy *"following the proof-of-concept work done by Dasgupta et al. (2018)"*).

### 3c. Câu nêu HẠN CHẾ lịch sự + neo gap
Không dùng "wrong / bad / naive". Chê khoảng trống, không chê tác giả. (Giải thích tiếng Việt
ở dưới mỗi câu.)

- *However, these methods have largely been **confined to** English and other high-resource
  settings [C1; C2].*
  → "confined to" = giới hạn trong (trung tính, không phải lỗi của họ); nêu phạm vi chưa phủ.
- *This line of work, while effective, **leaves open the question of** whether ... in
  low-resource languages.*
  → "leaves open the question of" = còn bỏ ngỏ câu hỏi — cực lịch sự, biến hạn chế thành câu hỏi.
- *Existing benchmarks, though widely adopted, **do not account for** typological features
  such as Vietnamese tone diacritics.*
  → "do not account for" = chưa tính đến — nêu cái họ chưa xét, không nói họ sai.
- *A **remaining challenge** is that current detectors ...*
  → khung "thách thức còn lại": đóng góp của bạn thành lời giải tự nhiên.
- *To the best of our knowledge, **no prior work has** examined surface reliance in Vietnamese
  AI-text detection.*
  → tuyên bố gap; CHỈ dùng khi đã tra kỹ (xem mục 7 về rủi ro với ngôn ngữ ít tài nguyên).
- *These findings, however, **may not transfer** to isolating languages, where word boundaries
  are not marked orthographically.*
  → "may not transfer" = có thể không chuyển được — nhẹ, có căn cứ ngôn ngữ học.

**Cụm nối "hạn chế lịch sự" nên thuộc (whitelist):** `have largely focused on`, `is largely
limited to`, `leaves open`, `do not account for`, `remains underexplored`, `it remains unclear
whether`, `has received comparatively little attention`.
**Cụm nên TRÁNH (chê lộ liễu):** `fail to`, `naive`, `simplistic`, `wrong`, `obviously`,
`merely`, `ignore the fact that`, `surprisingly overlooked`.

---

## 4. Quy ước ngôn ngữ (thì, thể, cách trích dẫn)

**Thì (tense) — quy tắc thực dụng:**
- **Present perfect** cho *dòng nghiên cứu / hiện trạng cả lĩnh vực*: *"A growing body of work
  **has shown** that ..."*, *"Detection methods **have been proposed** for ..."*. → hàm ý "tới
  nay vẫn đúng/vẫn tiếp diễn". Đây là thì chủ lực mở đầu đoạn.
- **Simple past** cho *một nghiên cứu cụ thể + kết quả cụ thể*: *"Levy et al. (2015)
  **demonstrated** that ..."* (đúng như bài thật). Một hành động đã xong của một nhóm.
- **Simple present** cho *chân lý chung / phát biểu về phương pháp còn hiệu lực / bài của bạn*:
  *"This approach **is** agnostic to model structure"*, *"In this paper we **propose** ..."*.

**Thể (voice):** ưu tiên **chủ động** với tác nhân là tác giả trước (*"Gururangan et al. (2018)
showed..."*) hoặc là bạn (*"we measure..."*). Bị động chỉ khi tác nhân không quan trọng
(*"Watermarking has been proposed to..."*).

**Integral vs non-integral citation** — dùng có chủ đích:
- **Integral** (tên tác giả là thành phần câu): *"**McCoy et al. (2019)** introduced HANS to ..."*
  → dùng khi bài đó là *nhân vật chính*, bạn muốn làm nổi/đối thoại trực tiếp với nó.
- **Non-integral** (citation trong ngoặc cuối câu): *"NLU models exploit surface cues
  [McCoy et al., 2019; Gururangan et al., 2018]."* → dùng khi *luận điểm* là chính, bài chỉ là
  bằng chứng. **Câu gộp nhiều bài hầu như luôn non-integral** (đó là cách nén nhiều citation).
- Nhịp điển hình một đoạn: mở bằng **non-integral gộp** (nêu dòng) → **integral** cho 1–2 bài
  đại diện đáng bàn sâu → non-integral khi neo gap.

**Trích dẫn theo cụm (citation clustering):** gom các bài cùng luận điểm vào một cặp ngoặc
`[C1; C2; C3]`, đừng rải mỗi bài một câu. Cụm citation = tín hiệu bạn đã tổng hợp.

**Citation density (mật độ):** Related Work Q1 dày citation — mỗi luận điểm tổng hợp cần
≥2 bài chống lưng (một câu "several studies" mà chỉ 1 citation là red flag). Nhưng **không phải
mỗi câu một citation**: câu topic-sentence và câu neo-gap có thể không có citation (chúng là
tiếng nói của bạn). Cân: bằng chứng thì cite dày, lập luận thì để bạn nói.

---

## 5. Reviewer Q1 — THƯỞNG gì / RED FLAG gì

**Reviewer THƯỞNG (viết vào review là điểm cộng):**
- Related Work **có luận điểm**: đọc xong thấy rõ gap và vì sao đóng góp cần thiết.
- **Tổng hợp thật**: một câu nói được điểm chung/khác của cả dòng, không chỉ liệt kê.
- **Công bằng với đối thủ**: nêu điểm mạnh dòng trước rồi mới nói giới hạn — cho thấy bạn hiểu.
- **Trích đúng, đủ, cập nhật**: có các bài mốc + bài 12–18 tháng gần đây.
- **Neo rõ ràng**: mỗi chủ đề kết bằng "ta khác/thêm ở đây".

**RED FLAG (reviewer trừ điểm, hay ghi thẳng vào phản biện):**
- **Annotated bibliography / liệt kê rời** — "X did A. Y did B. Z did C." mỗi câu một bài,
  không có sợi chỉ nối. **Lỗi chết số 1.**
- **Bỏ sót bài quan trọng / bài của chính reviewer** — thiếu công trình nền hoặc bài mới trực
  tiếp cạnh tranh → reviewer nghĩ bạn không nắm lĩnh vực (hoặc giấu). Với NLP tốc độ cao, thiếu
  bài 2025–2026 cùng chủ đề là rất rủi ro.
- **Chê đối thủ lộ liễu** — "prior work fails to / naively ignores" → phản cảm, và reviewer có
  thể chính là tác giả đó.
- **Không neo về mình** — kể một loạt bài rồi hết đoạn, không nói bạn liên quan/khác thế nào.
- **Citation nhồ đồ** — "several studies show X [1 citation]"; hoặc cite bài không đọc/sai nội dung.
- **Related Work = Background trá hình** — chỉ dạy khái niệm, không định vị đóng góp.
- **Câu gộp SAI** — nhét vào một câu các bài thực chất khác nhau chỉ để tiết kiệm chỗ.

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ + cách sửa

1. **Liệt kê tuyến tính "In [year], author proposed..."** (dịch thẳng lối viết luận văn VN).
   → Sửa: mở đoạn bằng *luận điểm*, gộp bài, dùng present perfect. (xem §3a).
2. **Thiếu mạo từ / sai the-a** trước danh từ đếm được: *"We propose method"* → *"We propose **a**
   method"*; *"surface feature is important"* → *"**The** surface feature ..."* / *"Surface
   features are ..."*.
3. **Lạm dụng "In this paper, we..." lặp lại / câu mở meta thừa** ("This section presents related
   works"). → Bỏ câu meta; vào thẳng luận điểm. ("Related work**s**" — số nhiều sai; luôn
   "related work", không đếm được.)
4. **"Researches / literatures / informations"** — các từ này KHÔNG đếm được: dùng *"research",
   "studies", "the literature", "information"*.
5. **Thì lẫn lộn** — trộn quá khứ/hiện tại tùy hứng. → Áp quy tắc §4 (perfect cho dòng, past cho
   bài cụ thể, present cho chân lý/của bạn).
6. **Chê đối thủ vì lo bị chê ngược** (over-defensive) — viết "their method is not good for
   Vietnamese". → Chuyển sang khung gap trung tính: *"has largely focused on English"* + neo.
7. **Dịch idiom sai / trang trọng thái quá** ("As we all know", "It is obvious that",
   "Nowadays"). → Cắt; văn học thuật EN không cần lời dẫn cảm thán.
8. **Câu quá dài, nhiều mệnh đề nối bằng "and, and"** (ảnh hưởng cú pháp Việt). → Tách 1 câu
   thành 2; một câu một ý.
9. **Copy cấu trúc đoạn của một bài rồi thay tên** (đạo văn cấu trúc) — xem §8.
10. **Citation không nhất quán / thiếu năm / sai integral–non-integral** (VD dùng "[Nguyen]"
    giữa câu như chủ ngữ). → Theo §4; theo template citation của venue (ACL: `\citet` vs `\citep`).

---

## 7. Lưu ý riêng: tiếng Việt / ngôn ngữ ít tài nguyên

Vấn đề đặc thù: **ít công trình tiền lệ trực tiếp bằng/về tiếng Việt** → dễ rơi vào 1 trong 2
bẫy: (a) tuyên bố "no prior work" quá mạnh rồi bị reviewer chỉ ra bài đã có; (b) không có gì
để cite nên đoạn rỗng.

**Chiến lược định vị khi thiếu tiền lệ:**
- **Định vị bắc cầu (bridge):** neo vào dòng nghiên cứu *quốc tế/ngôn ngữ giàu tài nguyên* rồi
  chỉ ra nó **chưa được kiểm ở tiếng Việt**. Đây là cách hợp lệ và mạnh:
  *frame:* *"Surface reliance has been extensively studied for English NLU [C1; C2; C3], but
  **whether these findings hold for Vietnamese remains unexplored**."* → bạn thừa hưởng cả dòng
  làm nền, gap là "chưa ai kiểm ở VN".
- **Định vị theo loại hình học (typology) — novelty thật của bạn:** đừng nói chung chung
  "low-resource"; nêu *đặc trưng ngôn ngữ* khiến kết quả tiếng Anh không tự động chuyển:
  *frame:* *"Unlike English, Vietnamese is an **isolating, tonal** language written in Latin
  script **with tone diacritics**; word boundaries are not marked by whitespace, so subword and
  deletion-based probes behave differently."* (Cảnh báo từ STATE của project: "âm tiết rời/đơn
  lập" KHÔNG phải novelty vì tiếng Trung cũng đơn lập — trục phân biệt thật là **chữ Latin +
  dấu thanh**. Neo vào đó.)
- **So sánh với công trình ngôn ngữ giàu tài nguyên một cách công bằng:** thừa nhận English đã
  đi trước và cho phương pháp; positioning không phải "họ dở" mà "họ chưa phủ typology này".
  *frame:* *"We adapt the matched-deletion paradigm of [C1] — originally developed for English —
  to the typological setting of Vietnamese."*
- **Gom tiền lệ gián tiếp:** nếu không có bài đúng chủ đề tiếng Việt, cite (i) mô hình nền VN
  (PhoBERT, ViSoBERT, ViBERT) như *bối cảnh hạ tầng*, (ii) bài cùng phương pháp ở ngôn ngữ khác,
  (iii) bài cùng ngôn ngữ khác nhiệm vụ. Nói rõ mối liên hệ, đừng cite lấy số.
- ViSoBERT là mẫu định vị VN thật: họ thừa nhận PhoBERT/ViBERT/vELECTRA *"performed well on
  general Vietnamese NLP tasks"* rồi neo gap: *"These pre-trained language models are still
  limited to Vietnamese social media tasks."* → khen trước, gap sau, đúng bài.
- **Về "no prior work"/"first":** chỉ dùng sau khi tra ACL Anthology + arXiv cs.CL + VLSP/VJOL;
  hạ nhiệt bằng *"to the best of our knowledge"*. Reviewer VN nội địa có thể biết bài tiếng Việt
  chưa index tốt → tra kỹ hơn bình thường.

---

## 8. Checklist tự rà (tick trước khi nộp)

Tổ chức & lập luận:
- [ ] Mỗi đoạn mở bằng **topic sentence là luận điểm**, không phải tên một bài.
- [ ] Có ≥1 **câu gộp nhiều citation** thật sự tổng hợp (không phải "X did / Y did").
- [ ] Mỗi chủ đề **neo về đóng góp của bạn** (Move 4) — có ít nhất một câu "unlike/whereas/we".
- [ ] Sắp xếp **thematic** (hoặc methodological có lý do); không tụt thành chronological liệt kê.
- [ ] 3–5 đoạn (hội nghị) / 4–7 đoạn (tạp chí); mỗi đoạn đúng một chủ đề.

Công bằng & bao phủ:
- [ ] Có nêu **điểm mạnh** dòng trước trước khi nói giới hạn (không chê lộ liễu).
- [ ] Không sót **bài mốc** và **bài 12–18 tháng gần đây** cùng chủ đề.
- [ ] Hạn chế viết bằng cụm **whitelist** (§3c), không dùng "fail/naive/wrong".
- [ ] Mọi "several studies / a growing body" có **≥2 citation** chống lưng.

Ngôn ngữ & trích dẫn:
- [ ] Thì đúng: perfect (dòng) / past (bài cụ thể) / present (chân lý & của bạn).
- [ ] Integral vs non-integral dùng có chủ đích; câu gộp dùng non-integral.
- [ ] "related work" (số ít, không đếm), "the literature", "studies" — không "researches".
- [ ] Không đoạn nào chỉ là Background trá hình (mọi đoạn phục vụ định vị).
- [ ] **Không đạo văn cấu trúc**: không mượn khung đoạn + thứ tự câu của một bài rồi thay tên
      (paraphrase cả câu VÀ trình tự lập luận; tự viết topic sentence của mình).
- [ ] Mọi citation đã **fetch xác minh toàn văn** (theo liêm chính project — nhất là preprint 2026).

---

## 9. Ví dụ "trước → sau" (liệt kê rời → tổng hợp có luận điểm)

### Ví dụ A — dòng "surface reliance / shortcut"
**TRƯỚC (annotated bibliography — red flag):**
> Gururangan et al. (2018) found annotation artifacts in NLI. McCoy et al. (2019) built HANS to
> test syntactic heuristics. Niven and Kao (2019) studied BERT on argument reasoning. Poliak et
> al. (2018) showed hypothesis-only baselines work.

*Vấn đề:* 4 câu, 4 bài, không sợi chỉ; người đọc không biết luận điểm hay gap.

**SAU (tổng hợp + neo):**
> A growing body of work has shown that NLU models often succeed by exploiting **surface cues**
> rather than the intended reasoning: models can achieve high accuracy from hypothesis-only
> inputs [Poliak et al., 2018] and from annotation artifacts alone [Gururangan et al., 2018],
> and they collapse when such cues are removed by controlled diagnostics [McCoy et al., 2019].
> These studies, however, are **confined to English NLI**; whether the same surface reliance
> governs **Vietnamese** classifiers — where orthography encodes tone rather than morphology —
> **remains unexamined**. We fill this gap with a matched-deletion probe for Vietnamese.

*Cải thiện:* 1 topic sentence luận điểm → gộp 3 bài quanh 1 ý (surface cues) → gap typology → neo.

### Ví dụ B — mô hình nền tiếng Việt (Background-ish → định vị)
**TRƯỚC (liệt kê + không neo):**
> PhoBERT is a Vietnamese language model. ViBERT is another one. ViSoBERT was trained on social
> media. XLM-R is multilingual.

**SAU:**
> Pre-trained models for Vietnamese have progressed from general-domain monolingual models
> [PhoBERT: Nguyen and Nguyen, 2020; ViBERT] toward domain-specialized ones for social-media
> text [ViSoBERT: Nguyen et al., 2023], consistently **outperforming multilingual baselines**
> such as XLM-R on Vietnamese benchmarks. Yet all of these models are evaluated on **task
> accuracy**; none characterizes *what signal* they rely on. Our study instead asks whether such
> gains reflect content understanding or surface-feature exploitation.

*Cải thiện:* biến 4 mẩu thành một quỹ đạo (general → social) + luận điểm chung (beat multilingual)
+ gap (đo accuracy chứ chưa đo "dựa vào gì") + neo.

### Ví dụ C — dòng AI-text detection (methodological)
**TRƯỚC:**
> Some works fine-tune RoBERTa to detect GPT text. Some works use zero-shot log-probability.
> Some works use watermarking.

**SAU (nhóm theo phương pháp — khuôn theo Sadasivan et al. 2023):**
> Existing AI-text detectors fall into three lines: **supervised classifiers** fine-tuned per
> target model [C1; C2], **zero-shot** methods that threshold per-token log-probability [C3; C4],
> and **watermarking** that imprints detectable patterns at generation time [C5]. All three,
> however, have been validated almost exclusively on **English**, and prior audits show
> supervised detectors mis-flag non-native writing [C6]. It is therefore unclear how they behave
> on **Vietnamese academic prose**, which we investigate here.

*Cải thiện:* ba câu rời → một câu ba dòng phương pháp (citation cụm) → giới hạn chung (English +
false-positive) → neo về đóng góp VN.

---
```

<!-- HẾT NỘI DUNG SECTION. Nguồn thật ở phần trả về của agent. -->
