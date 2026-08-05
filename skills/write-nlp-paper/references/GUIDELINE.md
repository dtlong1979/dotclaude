# GUIDELINE — Viết bài báo Q1 chủ đề AI/NLP (bản tổng hợp xuyên suốt)

> Bản này **nối** 7 file phân tích từng phần trong `sections/` thành một mạch toàn bài. Giá trị của nó
> là những thứ **chỉ lộ ra khi nhìn cả bài**: dòng chảy tu từ xuyên các phần, ma trận chống trùng lặp,
> bảng thì/giọng nhất quán, kỷ luật thống kê, và playbook tiếng Việt/ít tài nguyên.
>
> Bài đích viết **tiếng Anh**. Giải thích tiếng Việt — mẫu câu tiếng Anh.
> Chi tiết từng phần: đọc file tương ứng trong `sections/` (được trích dẫn ở mỗi mục).
>
> **Grounding:** mọi quy luật dưới đây rút từ ví dụ THẬT trong ~35 bài NLP mở (ACL/EMNLP/NAACL/TACL/arXiv,
> gồm PhoBERT, ViSoBERT, ViHSD, HANS, Gururangan, DetectGPT, XLM-R, Sadasivan, Joshi, EURO-5K, FormosanBench…).
> Nguồn cụ thể nằm ở cuối mỗi file `sections/*.md`.

---

## 0. Ba nguyên tắc trùm cả bài

1. **Một sợi chỉ (the contract thread).** Research question/gap nêu ở Introduction → hứa trong bullet
   *contributions* → giao trong Results → diễn giải trong Discussion → chốt trong Conclusion. Abstract là
   bản thu nhỏ của cả sợi chỉ đó. **Mỗi contribution phải map 1–1 tới một kết quả.** Hứa mà không giao =
   red flag chết người.
2. **Đúng phần nói đúng việc.** Results = *WHAT*; Discussion = *WHY / SO-WHAT*; Conclusion = *thông điệp +
   hướng đi*. Trộn vai (diễn giải trong Results, số mới trong Conclusion) là lỗi cấu trúc reviewer bắt ngay.
3. **Để số liệu tự nói, viết thẳng vào việc mình làm.** Booster cho cái đo được, hedge cho diễn giải; cắt
   câu meta/tự-biện-hộ/sáo rỗng; không over-claim ("first/solves/proves/SOTA") khi chưa kiểm chứng.

---

## 1. Dòng chảy tu từ toàn bài (rhetorical arc)

```
INTRODUCTION            RESULTS               DISCUSSION            CONCLUSION
─────────────           ────────              ──────────            ──────────
M1 territory            trả lời RQ1..k        khẳng định finding    nhắc đóng góp
M2 GAP  ───────────┐    bằng số + stats  ┐    diễn giải cơ chế      thông điệp (no số)
M3 "we…"+contribs  │                     │    so với prior work     hàm ý "so what"
    │  hứa (i)(ii) │    giao (i)(ii)(iii)│    hàm ý + limitations    future work cụ thể
    └── RQ ────────┴──── đo ─────────────┴──── giải thích ──────────┘  (đóng khung)
                         ▲
ABSTRACT = nén cả arc vào 6 câu: Problem→Gap→Approach→Results(số)→Takeaway→Contribution
RELATED WORK = bản đồ định vị: mỗi dòng nghiên cứu → hạn chế → NEO về gap của M2
METHODS = hợp đồng tái lập: ai đọc cũng dựng lại được (data→model→train→setup→baseline→metric→ethics)
```

**Kiểm tra tính khép kín:** mỗi RQ nêu ở Introduction phải (a) được một mục Results trả lời bằng số, và
(b) được một đoạn Discussion diễn giải. Nếu một RQ không có cả hai → hoặc cắt RQ, hoặc bổ sung thí nghiệm.

---

## 2. Bản đồ nhanh 7 phần

| Phần | Chức năng cốt lõi (một câu) | Moves | Bắt buộc phải có | File |
|------|----------------------------|-------|------------------|------|
| **Abstract** | Bán cả bài trong 150–250 từ | Problem→Gap→Approach→Results→Takeaway→Contribution | ≥1 con số + baseline có tên; 1 câu takeaway | `sections/01-abstract.md` |
| **Introduction** | Tạo không gian nghiên cứu (CARS) | Territory→Gap→"we…"+contribs | Gap kiểm chứng được; bullet contributions map 1–1 Results | `sections/02-introduction.md` |
| **Related Work** | Định vị đóng góp trên bản đồ | Mở chủ đề→Tổng hợp dòng→Hạn chế→NEO gap | Câu gộp nhiều citation; câu "unlike/we…" | `sections/03-related-work.md` |
| **Methods** | Hợp đồng tái lập | Formalize→Data→Model→Train→Setup→Baseline→Metric→Ethics | Seed+phần cứng+model-selection; so sánh công bằng; metric có lý do | `sections/04-methods.md` |
| **Results** | Trình bày WHAT | Dẫn bảng→Finding→Số+so sánh→Ablation→Error | mean±std + significance test; số văn khớp bảng | `sections/05-results.md` |
| **Discussion** | Diễn giải WHY/SO-WHAT | Finding→Cơ chế→So prior→Hàm ý→Limitations→Mở đường | ≥1 cơ chế (có hedge); limitations cụ thể; trả lời RQ | `sections/06-discussion.md` |
| **Conclusion** | Chốt thông điệp + hướng | Đóng góp→Thông điệp→"so what"→Future work | Không số mới; future work đặt tên được | `sections/07-conclusion.md` |

---

## 3. Ma trận CHỐNG TRÙNG LẶP — cùng một phát hiện, bốn giọng khác nhau

Đây là bảng quan trọng nhất của bản tổng hợp. Lỗi phổ biến: nói y hệt một câu ở Abstract, Results,
Discussion, Conclusion. Cùng MỘT phát hiện ("model tụt 24 điểm khi xoá anchor") phải được viết **khác nhau**:

| Phần | Viết phát hiện đó thế nào | Có con số? | Có "vì sao"? |
|------|---------------------------|:---------:|:-----------:|
| **Abstract** | "models retain only 61% of accuracy after anchor removal, a drop of 24 points" | ✅ 1 số đắt | ❌ |
| **Results** | "F1 drops from 0.86 to 0.62 (−24 pts); the drop is significant (bootstrap, p<0.01), consistent across 5 seeds" | ✅ đầy đủ + stats | ❌ (chỉ WHAT) |
| **Discussion** | "the large, consistent drop suggests the classifier's competence rests on lexical anchors rather than sentence meaning; this extends McCoy et al. to a tonal language" | ⚠️ nhắc định tính | ✅ cơ chế + so sánh |
| **Conclusion** | "high benchmark accuracy can mask a reliance on surface anchors" | ❌ (mức thông điệp) | ✅ hàm ý rộng |

**Quy tắc cắt-dán:** nếu một câu trong Conclusion có thể dán nguyên si vào Abstract → viết lại. Nếu một câu
trong Discussion chỉ lặp số của Results mà không thêm diễn giải → xoá.

---

## 4. Bảng thì (tense) & giọng (voice) — nhất quán xuyên bài

| Ngữ cảnh | Thì | Ví dụ |
|----------|-----|-------|
| Sự thật chung / chân lý lĩnh vực | present simple | *LLMs generate fluent text.* |
| Dòng nghiên cứu (cả lĩnh vực) — Related Work | **present perfect** | *A growing body of work **has shown**…* |
| Một bài cụ thể + kết quả của họ | past simple | *Gururangan et al. (2018) **showed** that…* |
| Mô tả mô hình/định nghĩa/công thức — Methods | present | *The encoder **maps** each token to…* |
| Việc BẠN đã làm (thu data, train, chạy) | **past** | *We **collected** 5,000 comments and **trained**…* |
| Bảng/hình "thể hiện" gì — Results | present | *Table 2 **shows**…; Model A **outperforms** B.* |
| Đóng góp của bài (Intro/Abstract/Conclusion) | present hoặc past | *In this paper, we **propose**… / we **introduced**…* |
| Diễn giải, kết luận còn đúng — Discussion | present | *These results **suggest** that…* |
| Hướng tương lai — Conclusion | will + **base verb** | *We **will investigate**…* (KHÔNG "will investigated") |

**Giọng:** **quy trình → passive** (*"the corpus was tokenized"*); **quyết định/đóng góp → "we" chủ động**
(*"we propose", "we chose macro-F1 because…"*). NLP hiện đại chuộng "we"; tránh "This paper proposes" lặp lại.

---

## 5. Kỷ luật con số & thống kê (cross-cutting — bắt buộc Q1)

Rút chung từ `04-methods.md` + `05-results.md`:

- **Không variance thì không có tuyên bố:** báo **mean ± std** qua **≥3–5 seed**; seed ghi cụ thể (13/42/123).
- **Mọi "tốt hơn" cần ba thứ:** tốt hơn *ai* (baseline có tên) + *bao nhiêu* (points, absolute/relative) +
  *có ý nghĩa thống kê không* (test + p/CI).
- **"significant" = đã chạy test.** Chưa test mà muốn nói "lớn" → dùng *substantially/considerably/markedly*.
- **Hiệu số hai đại lượng %** gọi là **points / percentage points**, KHÔNG gọi "%": 79→82 là **3 points**.
- **Chọn test:** paired bootstrap / permutation (2 hệ, cùng test set); Welch's t-test (trung bình qua seed);
  báo **CI 95%** khi có thể. Dataset nhỏ (thường gặp ở VN) → **bootstrap CI trên test set là bắt buộc**.
- **Số văn = số bảng.** Bold = ô tốt nhất mỗi cột; caption tự đủ nghĩa (giải thích †, ±, bold).
- **Công bằng và nói rõ:** cùng preprocessing/tokenizer/budget/split; nói rõ số nào *tự chạy* vs *trích bài gốc*
  và có cùng setting không. (Công bằng có thể thành điểm cộng: PhoBERT thắng XLM-R "dù ít tham số hơn".)
- **Trung thực > đẹp:** báo cả chỗ thua và chênh lệch không có ý nghĩa (*"not significant, p=0.18"*) — TĂNG độ tin.

---

## 6. Hiệu chỉnh hedge vs booster (cross-cutting)

Nguyên tắc một dòng: **booster cho quan sát, hedge cho giải thích.**

| Dùng | Khi nào | Từ |
|------|---------|----|
| **Booster** | điều dữ liệu ĐÃ chứng minh (hiệu ứng lớn, đã test) | *show, demonstrate, find, establish, outperforms* |
| **Hedge** | suy luận vượt dữ liệu: cơ chế, nhân quả, khái quát | *suggest, indicate, may, could, a likely explanation, appears to* |

- Discussion là nơi **hedge quan trọng nhất**: diễn giải cơ chế mà không hedge = over-claim nhân quả.
- **Tương quan ≠ nhân quả:** chưa có can thiệp đối chứng → *associated with / co-occurs with*, không *causes*.
- **Đừng chồng hedge** ("it may possibly perhaps suggest" ✗) — một hedge đúng chỗ là đủ.
- **Tránh tuyệt đối hoá:** *first / novel / solves / proves / guarantees / all / never* — trừ khi kiểm chứng được.

---

## 7. Bảng RED FLAG tổng hợp (những thứ khiến reviewer Q1 reject)

| Phần | Red flag chết người nhất |
|------|--------------------------|
| Abstract | Không một con số nào; method mù mờ ("deep learning"); gap–method lệch |
| Introduction | Gap mơ hồ / "chưa ai làm"; contributions không đo được; over-claim novelty mà M2 không chứng minh |
| Related Work | **Annotated bibliography** ("X did… Y did…"); bỏ sót bài mốc/bài 12–18 tháng gần; chê đối thủ lộ liễu |
| Methods | Thiếu chi tiết tái lập (seed/phần cứng/model-selection); so sánh không công bằng; leakage (chọn model trên test) |
| Results | Thiếu significance/variance; cherry-picking; số văn ≠ số bảng; diễn giải quá đà; "SOTA" hơn baseline yếu |
| Discussion | Lặp lại Results; over-claim nhân quả/generalization; giấu limitation; không trả lời RQ |
| Conclusion | Copy-paste Abstract; future work sáo rỗng ("more data"); đưa **kết quả mới** vào |

---

## 8. Playbook TIẾNG VIỆT / ÍT TÀI NGUYÊN (cross-cutting)

Rút chung — đây là phần khiến bài của người Việt hoặc bật lên hoặc bị coi là incremental:

1. **Novelty thật = trục loại hình học, KHÔNG phải "low-resource".** Trục phân biệt của tiếng Việt là
   **chữ Latin + DẤU THANH (diacritics)**. ⚠️ **KHÔNG** lead bằng "đơn lập/isolating" — tiếng Trung cũng đơn lập.
   Dấu thanh là surface cue đặc thù mà matched-deletion/counterfactual khai thác được → chỉ tiếng Việt làm được.
2. **"Stress test", không phải "case study".** Đóng khung tiếng Việt như **một ca kiểm chứng cho một tuyên bố
   tổng quát** (surface-reliance), không phải "chúng tôi làm X cho tiếng Việt luôn". Reviewer Q1 mua cái trước.
3. **Low-resource là ĐỘNG LỰC, không phải lời xin lỗi.** Dùng số người dùng ("~100 million speakers", như
   ViSoBERT) làm bằng chứng tầm quan trọng, không phải để thương hại. Joshi et al. là mẫu (dùng số để lập luận).
4. **Phát hành artifact = đòn bẩy chấp nhận.** Câu "we release dataset/benchmark/code for Vietnamese" cực giá trị.
5. **Cảnh giác nhãn "multilingual".** Benchmark "đa ngữ" (RAID/M4…) KHÔNG chắc có tiếng Việt — phải fetch xác
   minh danh sách ngôn ngữ trước khi dựa vào; đừng mượn oai.
6. **Tiền xử lý tiếng Việt phải tự-giải-thích cho reviewer quốc tế:** tách từ (RDRSegmenter/VnCoreNLP) + nêu
   **mức token** (syllable vs word); dấu thanh (giữ/chuẩn hoá/khôi phục); **Unicode NFC/NFD**; emoji/teencode;
   code-switching Việt–Anh. Bỏ trống = không tái lập được + reviewer nghi ngờ.
7. **Annotation:** nêu **số annotator + guideline + quy trình xử lý bất đồng + IAA (κ)**; **báo κ dù thấp** và
   giải thích (κ≈0.52 = "moderate", task chủ quan) — trung thực TĂNG độ tin.
8. **Thống kê là bắt buộc trên dữ liệu nhỏ:** delta 1–2 điểm rất dễ do may rủi → nhiều seed + bootstrap CI + p.
9. **Đừng biến baseline yếu thành SOTA giả.** Đưa cả baseline đa ngữ mạnh (mBERT/XLM-R đôi khi *vượt* mô hình
   đơn ngữ trên tác vụ VN); nói khiêm tốn đúng phạm vi ("strongest reported on [VN dataset X] to date").
10. **"First / no prior work"** chỉ dùng sau khi tra **ACL Anthology + arXiv cs.CL + VLSP/VJOL**, luôn kèm
    *"to the best of our knowledge"* (bài tiếng Việt hay chưa index tốt).
11. **Đánh giá tự động kém tin ở VN:** LLM-as-judge/auto-metric dịch từ tiếng Anh → ưu tiên **macro-F1 + human
    adjudication**; nếu dùng LLM-judge, PHẢI thảo luận độ tin trong Discussion.
12. **Future work "mở rộng ngôn ngữ" chỉ có giá trị khi gắn GIẢ THUYẾT ngôn ngữ học** + nhấn tính tái dùng của
    *phương pháp* (matched-deletion/counterfactual), không nhấn con số F1 trên một corpus.

---

## 9. Kill-list lỗi tiếng Anh của tác giả không bản ngữ (xuyên mọi phần)

- **Mạo từ a/an/the** thiếu/thừa: *"We propose **a** method for detect**ing** features."*
- **Danh-động-từ sau giới từ:** sau for/of/by/without dùng V-ing.
- **Danh từ không đếm được:** *research* (không "researches"), *the literature* (không "literatures"),
  *information*, *work* (không "related works"); *experiments* đúng số nhiều.
- **Thì sau modal:** *will* + **base verb** (*"we will investigate"*, không "will investigated").
- **Comma splice:** *"We tuned the model, we report…"* → dùng "and" hoặc tách câu.
- **Collocation:** *conduct/run an experiment* (không "make"); *obtain results* (không "gain"); *conduct research*.
- **"outperforms than / superior than"** → *outperforms X* (no "than"); *superior **to** X*.
- **Số/đơn vị:** dấu chấm thập phân (85.3, không 85,3); "F1" viết hoa F; hiệu số là "points".
- **Over-claim từ ngữ:** *prove, obviously, perfect, significantly (chưa test)* → *suggest, indicate, substantially*.
- **Câu meta/mở bài vũ trụ:** *"With the rapid development of AI…"*, *"Since the dawn of…"*, *"As we all know…"* → cắt.
- **Thuật ngữ không nhất quán** (utterance/sentence/text lẫn lộn) → chốt một từ, giữ glossary.
- **Mẹo:** viết ý bằng tiếng Việt trước, rồi diễn đạt lại bằng *frame* tiếng Anh — KHÔNG dịch từng chữ; đọc to
  để bắt câu sai ngữ pháp; rà **một lượt riêng** chỉ soi mạo từ/thì/số nhiều.

---

## 10. Thứ tự viết khuyến nghị (không viết tuần tự 1→7)

1. **Methods** trước (bạn nhớ rõ nhất, ít cảm xúc nhất) → khoá chặt tính tái lập.
2. **Results** (bảng/hình + số + stats) → biết chính xác mình có gì trong tay.
3. **Introduction** (giờ mới biết gap/contributions thật là gì để hứa đúng cái đã giao).
4. **Related Work** (định vị sau khi rõ đóng góp).
5. **Discussion** (diễn giải cái Results đã cho).
6. **Conclusion** (chốt).
7. **Abstract CUỐI CÙNG** (nén cả bài; giờ mới có đủ số & thông điệp để nén chuẩn).

Lý do: Abstract và Introduction hứa gì thì Results/Methods phải có nấy — viết phần "hứa" sau phần "giao" để
không hứa hão.

---

## 11. Checklist nộp bài — một trang (rút gọn; chi tiết ở từng file section)

**Sợi chỉ & cấu trúc**
- [ ] Mỗi RQ (Intro) có một mục Results trả lời + một đoạn Discussion diễn giải.
- [ ] Mỗi bullet contribution map 1–1 tới một kết quả (không hứa hão).
- [ ] Không trộn vai: Results không diễn giải sâu; Conclusion không có số/kết quả mới.
- [ ] Cùng một phát hiện được viết KHÁC nhau ở Abstract/Results/Discussion/Conclusion (ma trận §3).

**Số & thống kê**
- [ ] mean±std ≥3–5 seed; significance test + p/CI cho mọi "tốt hơn"; "significant" chỉ khi có test.
- [ ] Số văn khớp số bảng; "points" cho hiệu số %; absolute vs relative rõ ràng.
- [ ] So sánh cùng điều kiện, nói rõ; báo cả kết quả thua.

**Tái lập (Methods)**
- [ ] Seed + phần cứng + thời gian + tiêu chí chọn model; khoảng + số trial hyperparameter.
- [ ] (VN) segmenter + mức token + dấu thanh + NFC/NFD + emoji/teencode; annotation + IAA(κ) + guideline.
- [ ] Không leakage; link artifact (ẩn danh khi review) + giấy phép; data/ethics statement khi cần.

**Ngôn ngữ & liêm chính**
- [ ] Thì/giọng theo bảng §4; hedge/booster theo §6; cắt câu meta/sáo rỗng.
- [ ] Kill-list §9 đã rà một lượt riêng (mạo từ/thì/số nhiều/collocation).
- [ ] Mọi con số & trích dẫn **xác minh được** (fetch toàn văn, không bịa); số chưa chắc → đánh dấu rõ.
- [ ] Không over-claim "first/SOTA/solves"; "first" kèm "to the best of our knowledge" + đã tra kỹ.

**Tiếng Việt / ít tài nguyên (§8)**
- [ ] Novelty đóng khung theo trục **Latin + dấu thanh** (không "đơn lập"); "stress test" không "case study".
- [ ] Không mượn oai "multilingual" chưa xác minh có VN; artifact release nêu rõ.

---

## 12. Tuân thủ nộp bài (chiều thứ hai — trực giao với văn phong)

Mục 1–11 lo **viết cho đúng/hay**. Nhưng một bài viết chuẩn vẫn **desk-reject** nếu sai chính sách tạp chí.
Chi tiết ở `sections/08-journal-submission-requirements.md` (rút từ audit 50 tạp chí AI/NLP/IT). Cốt lõi:

- **Biết "họ nhà xuất bản"** (ACL-family / Elsevier / Springer / IEEE / ACM / Nature / Cell / Wiley / mega-OA /
  open-ML) → biết ngay 80% yêu cầu format.
- **Đừng bỏ sót nhóm mục ngoài thân bài:** Highlights (Elsevier 3–5×≤85 ký tự), **Data Availability Statement**
  (không "on request"), code policy, khối **Declarations** (CRediT/COI/Funding), **khai dùng AI đúng vị trí**
  (Elsevier trước refs · Springer/Nature/PLOS trong Methods · IEEE/ACM/Frontiers Acknowledgments · JASIST 2 nơi),
  reporting checklist (Nature Reporting Summary / Cell STAR Methods), **Index Terms/CCS Concepts**, ẩn danh,
  cover letter, reference style, **LaTeX style-file** (sai = desk-reject ở JMLR/JAIR/TMLR).
- **Triết lý duyệt quyết cách "bán":** tạp chí **soundness-based** (PLOS ONE, PeerJ CS, Scientific Reports,
  IEEE Access, Frontiers, **TMLR**) **KHÔNG xét novelty/impact** → **cấm over-claim tầm quan trọng**; tạp chí
  xét novelty (IEEE Trans, Elsevier, Springer, Nature, Cell, JAIR, AIJ) thì áp Mục 1–11 tối đa.
- **Limitations là SECTION RIÊNG bắt buộc** ở ACL-family/ARR (khác "limitations lồng trong Discussion" ở §7).
- **Tiếng Việt/ít tài nguyên:** TALLIP coi tái lập là điều kiện + coi release tài nguyên ngôn ngữ là đóng góp;
  NEJLT có ràng buộc đạo đức đặc thù (trả công người tham gia ≥ lương sống, cộng đồng dễ tổn thương là đồng tác giả).
- **Luôn xác minh con số ở trang Guide-for-Authors gốc** của tạp chí đích (site publisher chặn crawl).

---

*Hết bản tổng hợp. Đọc chi tiết + mẫu câu + ví dụ trước→sau trong từng file `sections/0X-*.md`;
yêu cầu nộp bài ở `sections/08-journal-submission-requirements.md`.*
