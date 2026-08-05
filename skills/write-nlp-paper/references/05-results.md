# 05 — RESULTS / EXPERIMENTS (hướng dẫn viết cho bài Q1 AI/NLP)

> Phần này CHỈ bàn cách viết mục **Results / Experiments**. Bài đích viết **tiếng Anh**;
> giải thích bằng tiếng Việt, mẫu câu bằng tiếng Anh.
>
> **Nguyên tắc vàng của Results: TRÌNH BÀY, KHÔNG DIỄN GIẢI SÂU.** Results kể "cái gì đã xảy ra"
> (con số, xu hướng, so sánh); *tại sao* và *nghĩa là gì* để dành cho Discussion. Để số liệu tự nói.
> Một câu Results tốt = một quan sát kiểm chứng được từ bảng/hình, cộng đúng một mệnh đề so sánh.

Toàn bộ mẫu câu dưới đây trích/mô phỏng từ các phần Results THẬT (nguồn liệt kê cuối file). Các câu đặt trong
`" "` kèm chú nguồn là **trích nguyên văn**; câu ghi *[frame]* là khung để bạn điền số của mình.

---

## 1. Rhetorical moves của Results — và ranh giới với Discussion

Một mục Results NLP điển hình chạy theo 4–5 nước đi (moves), lặp lại cho từng bảng/thí nghiệm:

1. **Dẫn tới bảng/hình (pointer).** Một câu chỉ người đọc tới bảng và nói bảng đó *chứa gì*, cùng
   setup nào. Ví dụ thật: *"Tables 2 and 3 compare PhoBERT scores with the previous highest reported
   results, using the same experimental setup."* (PhoBERT) — chú ý cụm **"using the same experimental
   setup"**: khẳng định so sánh công bằng ngay khi dẫn bảng.

2. **Nêu quan sát chính (headline finding).** Câu nói kết quả nổi bật nhất, thường một câu gọn:
   *"It is clear that our PhoBERT helps produce new SOTA performance results for all four downstream
   tasks."* (PhoBERT)

3. **Con số + so sánh + mức cải thiện.** Trích số cụ thể so với baseline, kèm delta:
   *"PhoBERT helps boost the Biaffine parser with about 4% absolute improvement, achieving a LAS at
   78.8% and a UAS at 85.2%."* (PhoBERT). Luôn nói **absolute** hay **relative**, và so với **cái gì**.

4. **Ablation / phân tích thành phần.** Bỏ/đổi từng phần để chỉ ra phần nào đóng góp:
   *"experimental results demonstrate that incorporating our synthetic data consistently improves
   performance across all evaluation metrics, surpassing the previous benchmark."* (Ladin low-resource).

5. **Error analysis / kết quả xấu (trung thực).** Nói thẳng chỗ mô hình hỏng, KHÔNG giấu:
   *"performance on the MCQA task remains low across all models... This suggests that the MCQA task is
   inherently more challenging than the SA task."* (Ladin) — câu này ở ranh giới: *nêu số thấp* (Results)
   + một mệnh đề *suggests* nhẹ (đã hơi lấn Discussion, chấp nhận được nếu chỉ một câu).

**Ranh giới Results ↔ Discussion (rất hay bị sai):**
- Results = *WHAT*: "Model A đạt F1 82.3, cao hơn baseline 3.1 điểm; chênh lệch có ý nghĩa (p<0.01)."
- Discussion = *WHY / SO WHAT*: "Cải thiện này cho thấy tín hiệu bề mặt đủ để... điều này hàm ý rằng...".
- Trong Results, được phép một câu *"which suggests..."* rất ngắn để nối mạch, nhưng **không** diễn giải
  cơ chế, không so với công trình khác về mặt lý thuyết, không nói "điều này quan trọng vì...".
- Mẹo phân biệt: nếu câu của bạn có thể SAI dù bảng số vẫn ĐÚNG → đó là diễn giải → đẩy sang Discussion.

---

## 2. Cách tổ chức Results: theo research question hay theo experiment?

Hai cách bố trí chính, chọn theo cấu trúc bài:

**(A) Theo research question (RQ).** Mỗi tiểu mục trả lời một RQ đã nêu ở Introduction.
- Nên dùng khi bài có 2–4 RQ rõ (rất hợp chương trình "surface-reliance": RQ1 = có bám bề mặt không?
  RQ2 = mạnh cỡ nào? RQ3 = xuyên ngôn ngữ/EN↔VI ra sao?).
- Ưu điểm: reviewer thấy ngay bạn *trả lời đúng câu đã hứa*. Mỗi tiểu mục mở bằng: *"RQ1: Does the
  detector rely on surface cues? Table 2 shows that..."*.

**(B) Theo experiment/setup.** Mỗi tiểu mục là một thí nghiệm (main results → ablation → error analysis).
- Nên dùng khi có một đóng góp chính + nhiều phân tích bổ trợ (hợp bài kiểu PhoBERT: main benchmark
  results, rồi so tham số/model size).
- Trình tự chuẩn: **Main results → Ablation → Analysis/robustness → Error analysis**.

**Khuyến nghị cho chương trình này:** dùng (A) theo RQ ở cấp tiểu mục, và trong mỗi RQ đi theo trình tự
của (B) (số chính trước, ablation/robustness sau). Đây là dạng lai được reviewer Q1 ưa.

**Vai trò bảng/hình vs văn (chia việc, không lặp):**
- **Bảng** = nơi chứa *mọi con số* (mean±std, mọi baseline, mọi metric). Văn KHÔNG chép lại cả bảng.
- **Hình** = xu hướng/quan hệ (learning curve theo cỡ dữ liệu, độ nhạy tham số, phân bố lỗi).
- **Văn** = *chọn lọc* 2–4 con số quan trọng nhất, chỉ ra xu hướng, và **nói điều bảng KHÔNG tự nói**
  (ví dụ: "chênh lệch có ý nghĩa thống kê", "biến thiên lớn giữa các seed"). Quy tắc: nếu câu văn chỉ
  đọc lại một ô trong bảng mà không thêm nhận định → xóa.
- Mỗi bảng/hình phải được *nhắc tới ít nhất một lần* trong văn ("Table 3 shows..."); bảng không được
  nhắc là bảng thừa.
- Caption tự đủ nghĩa (self-contained): người đọc hiểu bảng mà không cần đọc văn; **bold = kết quả tốt
  nhất mỗi cột**, ghi rõ trong caption ("Best results in **bold**.").

---

## 3. Sentence frames tiếng Anh (theo chức năng)

### 3.1 Dẫn tới bảng/hình
- *"Table 2 shows/presents/reports the [metric] of all models on [dataset]."*
- *"Table 1 presents the translation performance results for both directions across diverse
  configurations."* (Ladin — trích thật)
- *"Tables 2 and 3 compare our model with the previous highest reported results, using the same
  experimental setup."* (PhoBERT — trích thật; chú ý mệnh đề công bằng)
- *"Figure 3 plots [metric] as a function of [training-set size / hyperparameter]."*
- Thì: động từ chỉ bảng dùng **hiện tại đơn** ("shows", "presents", "reports") vì bảng "luôn" thể hiện thế.

### 3.2 Nêu con số chính + cải thiện %
- *[frame]* "Our model achieves an F1 of 82.3, outperforming the strongest baseline (79.2) by 3.1 points."
- *[frame]* "PhoBERT obtains 0.8% absolute higher accuracy than these two models." (PhoBERT — trích thật)
- *[frame]* "This corresponds to a 4% absolute improvement, achieving a LAS at 78.8%." (PhoBERT — thật)
- *[frame]* "The proposed scheme yields an 8% relative improvement over the Transformer baseline."
- Phân biệt rõ **absolute** ("3.1 points", "3.1 absolute") vs **relative** ("a 4% relative gain").
  Với F1/accuracy tính theo %, dùng **"points" / "percentage points (pp)"** cho hiệu số để tránh nhập nhằng
  ("tăng từ 79% lên 82%" = **3 points**, KHÔNG phải "tăng 3%").

### 3.3 Báo cáo significance & variance (bắt buộc ở Q1)
- *"We report the mean ± standard deviation across 5 random seeds."* (khung chuẩn)
- *"BERT: mean ± standard deviation across 5 seeds; LLMs: mean ± bootstrap std (n = 1,000 iterations)."*
  (EURO-5K — trích thật)
- *"FFT significantly outperforms LoRA across both base models (p < 0.01)."* (EURO-5K — trích thật)
- *"The 1.8-point gap is not statistically significant (p > 0.30)."* (EURO-5K — mô phỏng sát bản thật —
  cách nói TRUNG THỰC khi chênh lệch không có ý nghĩa)
- *[frame]* "We assess significance with a paired bootstrap test (10,000 resamples of the test set);
  differences marked † are significant at p < 0.05."
- *[frame]* "Improvements over [baseline] are statistically significant under a Welch's t-test across
  seeds (p < 0.05)."
- Chọn test theo tình huống: **paired bootstrap / permutation (sign-flip)** cho so sánh 2 hệ trên cùng
  test set; **Welch's t-test** cho so trung bình qua nhiều seed; báo **CI 95%** khi có thể.

### 3.4 Mô tả ablation
- *[frame]* "Removing [component X] drops F1 by 2.4 points (from 82.3 to 79.9), confirming its
  contribution."
- *"Incorporating our synthetic data consistently improves performance across all evaluation metrics."*
  (Ladin — trích thật)
- *[frame]* "When we replace [X] with [Y], performance degrades on [dataset] but remains stable on
  [other], indicating that the gain is [not] uniform across settings."
- *[frame]* "Each component contributes positively; the largest single drop comes from removing [X]."

### 3.5 Thừa nhận kết quả không như kỳ vọng (trung thực, không biện hộ dài)
- *"Performance on the MCQA task remains low across all models."* (Ladin — trích thật)
- *[frame]* "Contrary to our expectation, [Model A] does not outperform [Model B] on [task]; the two are
  statistically indistinguishable (p = 0.21)."
- *[frame]* "On [dataset], our method underperforms the baseline by 1.2 points. We attribute this to
  [factual reason: e.g. the small test set / label noise], which we examine in Section [Discussion]."
- *[frame]* "The gains are inconsistent: [method] helps on [A] and [B] but hurts on [C]."
- Tiếng Việt — CÁCH VIẾT: nêu số xấu bằng câu KHẲNG ĐỊNH ngắn, cho lý do NGẮN dựa trên *dữ kiện* (không
  suy đoán dài), rồi trỏ sang Discussion. Tránh: "Có lẽ do mô hình chưa được tối ưu..." (mơ hồ, phòng thủ).

### 3.6 Error analysis
- *[frame]* "We manually inspect 100 errors and group them into [3] categories (Table 5)."
- *"Our models sometimes struggle with correctly answering parts-of-speech questions."* (Vietnamese MRC — thật)
- *"They have trouble understanding deep figurative language."* (Vietnamese MRC — thật)
- *[frame]* "The dominant error type ([X], 46% of errors) occurs when [condition]."

---

## 4. Quy ước ngôn ngữ (thì, thể, số, động từ)

**Thì (tense) — quy tắc thực dụng:**
- **Hiện tại đơn** cho điều bảng/hình "thể hiện" (chân lý của bài): *"Table 2 shows...", "Model A
  outperforms B."*
- **Quá khứ đơn** cho *hành động cụ thể bạn đã làm* và *quan sát trên một lần chạy*: *"We trained the
  model for 10 epochs.", "The model achieved 82.3 on the dev set."*
- Thực tế nhiều bài Q1 dùng hiện tại đơn cho phần lớn phát biểu kết quả ("achieves", "obtains") — nhất
  quán trong một mục là quan trọng hơn việc chọn thì nào.

**Thể (voice):** ưu tiên **chủ động** khi chủ thể là mô hình/kết quả ("PhoBERT achieves..."); dùng **bị
động** cho quy trình ("Models were evaluated with 5-fold cross-validation."). Tránh bị động lạm dụng.

**Viết số & phần trăm:**
- Nhất quán số chữ số thập phân trong cùng bảng (thường 1 hoặc 2: 82.3 hoặc 82.31).
- Hiệu số của hai đại lượng %: gọi là **points / percentage points (pp)**, KHÔNG gọi "%".
- Nói rõ **absolute** vs **relative** mỗi khi báo cải thiện.
- Metric viết hoa nhất quán (F1, not f1; Accuracy/Acc; BLEU; chrF++). Định nghĩa viết tắt ở lần đầu.
- Không bao giờ để con số trong văn KHÁC con số trong bảng (lỗi sao chép — reviewer bắt ngay).

**Động từ báo kết quả (sắc thái mạnh → yếu, dùng đúng liều):**
- **outperforms / surpasses / exceeds** — thắng rõ, có số đỡ lưng.
- **achieves / obtains / yields / reaches / attains** — trung tính, "đạt".
- **improves over / boosts / raises ... by** — nhấn mức tăng.
- **is comparable to / on par with / matches** — ngang bằng (dùng khi chênh không có ý nghĩa!).
- **lags behind / underperforms / trails** — thua (dùng thẳng thắn cho kết quả xấu).
- TRÁNH: "significantly" khi CHƯA chạy significance test — trong ngữ cảnh khoa học "significant" ngụ ý
  kiểm định thống kê. Muốn nói "lớn" mà chưa test → dùng **"substantially / considerably / markedly"**.

---

## 5. Reviewer Q1 THƯỞNG gì / RED FLAG

**Reviewer THƯỞNG (dễ được accept):**
- Có **significance test** cho mọi tuyên bố "tốt hơn"; báo **mean±std qua ≥3–5 seed**.
- So sánh **cùng điều kiện** (cùng data split, cùng ngân sách tham số/tính toán) — và NÓI RÕ điều đó,
  như PhoBERT: "using the same experimental setup". PhoBERT còn khéo léo nêu mình thắng XLM-R *dù dùng ít
  tham số hơn* ("far fewer parameters... 135M vs. 250M") — so sánh công bằng lại thành điểm cộng.
- **Trung thực với kết quả xấu** (báo cả chỗ thua) → tăng độ tin cả bài.
- **Ablation** tách bạch đóng góp từng phần; **error analysis** định lượng (phân loại lỗi, có %).
- Số trong văn khớp bảng; bold đúng ô tốt nhất; caption tự đủ nghĩa.

**RED FLAG (dễ bị reject / major revision):**
- **Thiếu significance test / thiếu variance**: chỉ một con số một lần chạy, không std, không seed →
  reviewer không tin delta 0.3 điểm là thật.
- **Cherry-picking**: chỉ khoe dataset/metric mình thắng, giấu chỗ thua; chọn checkpoint tốt nhất trên
  test set.
- **Bold sai / số sai**: bold ô không phải tốt nhất; số văn ≠ số bảng.
- **So sánh không cùng điều kiện**: baseline train ít epoch hơn, data split khác, hoặc lấy số từ bài khác
  mà không nói rõ điều kiện khác nhau.
- **Không variance nhưng tuyên bố "significant"**: dùng chữ "significant" mà không có test.
- **Diễn giải quá đà ở Results**: giải thích cơ chế/ý nghĩa dài dòng — reviewer thấy bạn đang "bán" thay
  vì báo cáo. (Đẩy sang Discussion.)
- **Over-claim SOTA**: tuyên bố "state-of-the-art" khi chỉ hơn 1 baseline yếu, hoặc chênh trong sai số.
- **Bảng khổng lồ không nhắc trong văn** / hình không đọc được (chữ nhỏ, không nhãn trục).

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ — và cách sửa

| Lỗi hay gặp | Vì sao sai | Sửa |
|---|---|---|
| "increase 3%" khi F1 đi từ 79→82 | Đó là 3 **points**, không phải 3% (3% của 79 = 2.37) | "an increase of 3 points" hoặc "3 percentage points" |
| Lạm dụng "significantly" cho mọi cải thiện | "significant" = đã kiểm định thống kê | Dùng "substantially/considerably" nếu chưa test; hoặc chạy test rồi mới dùng |
| "The result is very good / impressive." | Chủ quan, không đo được, giọng quảng cáo | Thay bằng con số + so sánh: "improves F1 by 3.1 points over [X]" |
| "Our model is the best." | Over-claim, không nói "best" theo tiêu chí/điều kiện nào | "achieves the highest F1 among the compared models on [dataset]" |
| Thì lộn xộn giữa các câu | Người đọc mất mạch | Chốt một quy ước (present cho "shows/achieves", past cho hành động), giữ nhất quán |
| Dịch nguyên "kết quả cho thấy rằng" → "The result shows that..." lặp lại mỗi câu | Đơn điệu | Đổi biến: "Table X shows", "We observe", "As reported in", "The model attains" |
| Mạo từ: "achieves best F1", "on test set" | Thiếu a/the | "achieves **the** best F1", "on **the** test set" |
| "compare with baseline" thiếu đối tượng cụ thể | Reviewer không biết baseline nào | Nêu tên baseline: "compared with mBERT and XLM-R" |
| Diễn giải dài ngay dưới bảng ("This proves our idea because...") | Lấn Discussion, giọng phòng thủ | Một câu quan sát; lý do để Discussion |
| Câu meta thừa: "In this section, we will present..." | Không mang thông tin | Vào thẳng: "Table 2 shows..." |

Nguyên tắc chung khớp chuẩn viết của user: **viết thẳng vào việc mình làm và số mình thu được**, cắt câu
tự-biện-hộ / tự-dự-đoán / meta; để số liệu tự nói.

---

## 7. Lưu ý riêng cho tiếng Việt / ít tài nguyên

Đây là bối cảnh dễ bị reviewer "soi" nhất, vì baseline yếu và dataset nhỏ khiến kết quả dễ nhiễu:

- **Baseline yếu → đừng biến thành SOTA giả.** Nếu chỉ có vài baseline yếu, thắng chúng KHÔNG đủ để nói
  "SOTA". Nói khiêm tốn + đúng phạm vi: *"to the best of our knowledge, the strongest reported result on
  [Vietnamese dataset X] to date"*, và LIỆT KÊ rõ đã so với ai. Lưu ý: cùng chủ đề, mBERT đôi khi *vượt*
  mô hình đơn ngữ trên tác vụ VN (VSMRC báo mBERT thắng) — nên đưa cả baseline đa ngữ mạnh, đừng chỉ so
  với mô hình yếu.
- **Dataset nhỏ → thống kê là bắt buộc, không phải tùy chọn.** Với test set nhỏ, delta 1–2 điểm rất dễ
  do may rủi. BẮT BUỘC: nhiều seed (≥5), **bootstrap CI trên test set** (resample test set — đặc biệt
  hợp khi test nhỏ), và báo p-value. Cách EURO-5K làm là mẫu tốt: "mean±std across 5 seeds" + "bootstrap
  n=1,000" + "p<0.01".
- **Trung thực với chênh lệch nhỏ.** Nếu 1.8 điểm mà p>0.30 → nói thẳng "not statistically significant"
  (như EURO-5K). Điều này KHÔNG làm yếu bài — nó làm bài đáng tin.
- **Chất lượng dữ liệu VN.** Nếu có nhiễu nhãn, trùng lặp, hay tiền xử lý tiếng Việt đặc thù (tách từ,
  dấu), báo cáo minh bạch ở Results/Setup — reviewer quốc tế không biết đặc thù tiếng Việt, phải nói rõ.
- **Tránh over-claim khái quát.** Kết quả trên một corpus VN nhỏ → không suy ra "cho tiếng Việt nói
  chung" hay "cho mọi ngôn ngữ ít tài nguyên". Giới hạn phạm vi ngay trong câu chữ.
- **So sánh cross-lingual (EN↔VI) phải cùng điều kiện.** Nếu so anchor-reliance EN vs VI, đảm bảo cùng
  giao thức đo, cùng cỡ mẫu; nếu khác, nói rõ và không quy kết chênh lệch cho ngôn ngữ.

---

## 8. Checklist tự rà Results (tick trước khi nộp)

**Nội dung & tổ chức**
- [ ] Mỗi bảng/hình được nhắc ít nhất một lần trong văn; không có bảng "mồ côi".
- [ ] Văn chọn lọc 2–4 số quan trọng, KHÔNG chép lại cả bảng.
- [ ] Mỗi tuyên bố "tốt hơn" nói rõ *tốt hơn AI*, *bao nhiêu* (points/relative), *trên dataset/metric nào*.
- [ ] Bố cục theo RQ hoặc theo experiment nhất quán; trình tự main → ablation → analysis → error.
- [ ] Diễn giải sâu (why/so-what) đã được đẩy sang Discussion.

**Thống kê (bắt buộc Q1)**
- [ ] Báo **mean ± std** qua ≥3–5 seed (hoặc CV) cho kết quả chính.
- [ ] Có **significance test** cho mọi so sánh then chốt (paired bootstrap / permutation / Welch's t-test);
      ghi rõ test nào, p-value/CI.
- [ ] Chữ "significant/significantly" chỉ dùng khi CÓ test đứng sau.
- [ ] Chênh lệch nhỏ không có ý nghĩa → nói thẳng "not significant (p=...)".

**Công bằng & trung thực**
- [ ] Mọi model so cùng data split, cùng ngân sách tham số/compute; điều kiện khác nhau (nếu có) được nêu.
- [ ] Có báo cả kết quả xấu / chỗ thua; không cherry-pick metric/dataset.
- [ ] Số chọn checkpoint theo dev set, không theo test set.

**Trình bày & ngôn ngữ**
- [ ] Số trong văn KHỚP số trong bảng (rà từng con số).
- [ ] Bold = ô tốt nhất mỗi cột; caption tự đủ nghĩa, giải thích ký hiệu (†, ±, bold).
- [ ] Số thập phân nhất quán; "points" cho hiệu số %, phân biệt absolute/relative.
- [ ] Thì nhất quán; mạo từ a/the đúng; động từ báo kết quả đúng liều (không over-claim SOTA).

---

## 9. Ví dụ "trước → sau"

### Ví dụ 1 — Dẫn bảng + over-claim + sai đơn vị
**Trước:**
> In this section, we will show our results. Our model is very good and gets the best score. It increases
> the F1 by 3% compared to baseline, which proves our method is effective.

**Sau:**
> Table 2 shows the F1 of all models on the ViHSD test set. Our model achieves an F1 of 82.3, outperforming
> the strongest baseline (79.2) by 3.1 points (absolute). This improvement is statistically significant
> under a paired bootstrap test (10,000 resamples, p < 0.01).

*Sửa gì:* bỏ câu meta + "very good/proves"; "3%"→"3.1 points"; nêu tên/đối tượng baseline; thêm significance;
đẩy "effective" (why) sang Discussion.

### Ví dụ 2 — Thiếu variance, chênh nhỏ thổi phồng
**Trước:**
> Our method significantly outperforms XLM-R (F1 80.1 vs 79.4), showing the superiority of our approach.

**Sau:**
> Averaged over 5 random seeds, our method reaches 80.1 ± 0.6 F1, compared with 79.4 ± 0.5 for XLM-R
> (Table 3). The 0.7-point gap is not statistically significant (Welch's t-test, p = 0.18); the two models
> are therefore comparable on this dataset.

*Sửa gì:* thêm mean±std; chạy test → hóa ra KHÔNG có ý nghĩa; hạ giọng từ "significantly outperforms" xuống
"comparable"; bỏ "superiority".

### Ví dụ 3 — Kết quả xấu bị né tránh
**Trước:**
> Our model works well on most tasks. (— rồi im lặng về task MCQA nơi mô hình kém)

**Sau:**
> While our model improves SA (Table 1), performance on the MCQA task remains low across all models
> (best Acc = 41.2). This gap points to the difficulty of MCQA in the low-resource setting, which we
> analyze in Section 6.

*Sửa gì:* báo thẳng task thua + con số; một câu trỏ sang phân tích; không giấu, không biện hộ dài. (Mẫu
theo cách Ladin low-resource báo "performance ... remains low across all models".)

---

## QUY LUẬT CỐT LÕI của Results (tóm tắt)

- **Trình bày, không diễn giải sâu:** Results nói *WHAT* (số, xu hướng, so sánh); *WHY/SO-WHAT* để
  Discussion. Nếu câu có thể sai dù bảng đúng → nó là diễn giải, đẩy đi.
- **Mỗi tuyên bố "tốt hơn" phải kèm ba thứ:** tốt hơn *ai*, *bao nhiêu* (points, absolute/relative), và
  *có ý nghĩa thống kê không* (test + p-value/CI).
- **Không có variance thì không có tuyên bố:** mean±std qua ≥3–5 seed; với dataset VN/ít tài nguyên nhỏ,
  bootstrap CI trên test set là bắt buộc.
- **So sánh công bằng và nói rõ điều đó** ("same experimental setup", cùng data split & ngân sách tham số)
  — công bằng còn có thể thành điểm cộng (thắng dù ít tham số hơn).
- **Trung thực > đẹp:** báo cả kết quả xấu và chênh lệch không có ý nghĩa; điều đó *tăng* độ tin của bài.
- **Bảng chứa số, văn chọn lọc + nói điều bảng không tự nói;** số văn phải khớp số bảng, bold đúng ô,
  caption tự đủ nghĩa.
- **Ngôn ngữ đúng liều:** "significant" chỉ khi có test; hiệu số % là "points"; tránh "SOTA" khi chỉ hơn
  baseline yếu hoặc chênh trong sai số; cắt câu meta/tự-khen.

---

## Nguồn thật đã tra (verbatim quotes ở trên trích từ đây)

- Nguyen & Nguyen, **PhoBERT: Pre-trained language models for Vietnamese** (Findings of EMNLP 2020) —
  arXiv 2003.00744. https://arxiv.org/abs/2003.00744 (đọc bản HTML ar5iv).
- **Exploring NLP Benchmarks in an Extremely Low-Resource Setting** (Italian↔Ladin) — arXiv 2509.03962.
  https://arxiv.org/html/2509.03962v1
- **Investigating Recent Large Language Models for Vietnamese Machine Reading Comprehension** —
  arXiv 2503.18062. https://arxiv.org/html/2503.18062
- **EURO-5K: When Does Domain Pretraining Matter?** — arXiv 2606.02971. https://arxiv.org/html/2606.02971
  (nguồn cho mẫu câu mean±std, bootstrap CI, Welch's t-test, "p<0.01" / "p>0.30").
- **VSMRC: A Vietnamese Dataset for Text Segmentation and Multiple-Choice Reading Comprehension** —
  arXiv 2506.15978 (dùng cho nhận định "mBERT có thể vượt mô hình đơn ngữ trên tác vụ VN").

*Ghi chú liêm chính:* các câu trong `" "` là trích/rút gọn từ Results thật của các bài trên (đọc qua bản
HTML mở); các câu *[frame]* là khung tổng quát để tác giả điền số của mình, KHÔNG gán cho bài nào. Không
có số liệu nào bị bịa. Vài bài preprint 2025–2026 cần đối chiếu lại toàn văn trước khi trích vào bản thảo.
