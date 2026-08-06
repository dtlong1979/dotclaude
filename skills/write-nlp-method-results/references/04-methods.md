# 04 — METHODS / METHODOLOGY / APPROACH

> Guideline viết phần Method cho bài báo Q1 AI/NLP, ưu tiên ngữ cảnh tác giả người Việt và nghiên cứu tiếng Việt / ít tài nguyên. **Bài đích viết bằng tiếng Anh.**
> Giải thích bằng tiếng Việt, mẫu câu bằng tiếng Anh.
>
> **Kim chỉ nam duy nhất của Method = TÁI LẬP ĐƯỢC (reproducible).** Một reviewer đọc xong Method phải tin rằng: (a) họ hiểu chính xác bạn đã làm gì, và (b) nếu có code + dữ liệu họ dựng lại được kết quả trong sai số hợp lý. Mọi lựa chọn văn phong dưới đây phục vụ mục tiêu đó.

Tất cả câu trích trong file này là **câu thật, lấy từ bài đã xuất bản** (nguồn liệt kê ở cuối). Không có câu bịa. Khi dùng làm khuôn, thay nội dung nhưng giữ cấu trúc tu từ.

---

## 1. Các tiểu mục chuẩn & thứ tự (cái nào bắt buộc)

Thứ tự điển hình của một phần Method NLP (đọc từ trên xuống chính là mạch reviewer mong đợi):

| # | Tiểu mục | Bắt buộc? | Nội dung cốt lõi |
|---|----------|-----------|------------------|
| 1 | **Problem formulation / Task definition / Notation** | Bắt buộc với bài có mô hình/thuật toán mới; có thể gộp vào intro nếu task chuẩn | Định nghĩa bài toán hình thức: input, output, ký hiệu. VD: cho $x$, dự đoán $y \in \mathcal{Y}$. |
| 2 | **Data & preprocessing** | **Bắt buộc** | Nguồn dữ liệu, kích thước, chia train/dev/test, tiền xử lý, (với dữ liệu tự thu: thu thập + annotation + IAA). |
| 3 | **Model / Architecture / Approach** | **Bắt buộc** (đây là "we propose") | Kiến trúc, thành phần mới, công thức. Phân biệt rõ đóng góp vs. thành phần mượn. |
| 4 | **Training details / Hyperparameters** | **Bắt buộc để reproducible** | Optimizer, LR, batch size, epochs/steps, seed, phần cứng, thời gian, model-selection. |
| 5 | **Experimental setup** | **Bắt buộc** | Cấu hình thí nghiệm, câu hỏi nghiên cứu ánh xạ vào thí nghiệm nào, cách chia điều kiện. |
| 6 | **Baselines / Comparison systems** | **Bắt buộc nếu có so sánh** | Định nghĩa baseline, nguồn (re-implement hay lấy số từ bài gốc), điều kiện công bằng. |
| 7 | **Evaluation metrics** | **Bắt buộc** | Metric nào, vì sao (macro-F1 khi lệch lớp...), cách tính, test ý nghĩa thống kê. |
| 8 | **Ethics / Data statement** | Bắt buộc khi có dữ liệu người thật / mạng xã hội / annotation | Nguồn, quyền, ẩn danh, giấy phép, chế độ đãi ngộ annotator. |

**Ghi chú thứ tự:** một số venue (ARR/ACL) tách "Experimental Setup" thành mục riêng ngay đầu phần Experiments (mục 4–7 gộp thành §Experiments). Chọn 1 trong 2 layout, nhưng **7 khối thông tin phải đủ**. Với bài *diagnostic/analysis* (như hướng surface-reliance của project này), khối "Model" thường nhỏ (dùng mô hình có sẵn) còn khối "Probe/Intervention design" (matched-deletion, counterfactual) phình to — đó chính là đóng góp, phải viết kỹ nhất.

---

## 2. Rhetorical moves của Methods + độ chi tiết để reproducible

Method vận hành theo chuỗi "moves" (nước đi tu từ). Mỗi move có một mức chi tiết tối thiểu.

**Move 1 — Định khung bài toán (formalize).** Chuyển vấn đề mơ hồ thành đối tượng toán học. *Chi tiết cần:* định nghĩa mọi ký hiệu trước khi dùng; nói rõ cái gì cho trước, cái gì cần học/đo.

**Move 2 — Mô tả dữ liệu & nguồn gốc (situate the data).** *Chi tiết cần:* con số cụ thể (số mẫu, số token, phân bố lớp), cách chia tập, seed chia. Với dữ liệu tự thu: quy trình thu + làm sạch + annotation.
> Trích thật (ViSoBERT): *"We crawled textual data from Vietnamese public social networks such as Facebook, Tiktok, and YouTube"*; và liệt kê từng bước làm sạch: *"removing noncanonical texts, removing comments including links, ... and keeping emojis in training data."* — mức liệt kê từng thao tác này là chuẩn tối thiểu để người khác dựng lại corpus.

**Move 3 — Trình bày cách tiếp cận/đóng góp (propose).** Đây là chỗ duy nhất dùng "we propose / we introduce". *Chi tiết cần:* công thức đầy đủ, sơ đồ kiến trúc, và **lý do thiết kế** (design rationale), không chỉ mô tả.
> Trích thật (HANS): *"we introduce a controlled evaluation set called HANS ..., which contains many examples where the heuristics fail"* + nêu rõ nguyên lý thiết kế: *"we design our dataset around such examples, so that models that employ these heuristics are guaranteed to fail on particular subsets ..., rather than simply show lower overall accuracy."*

**Move 4 — Khai báo cấu hình huấn luyện (specify).** *Chi tiết cần:* đủ để chạy lại — optimizer, LR, batch size, steps, seed, GPU, thời gian.
> Trích thật (PhoBERT): *"We use a batch size of 1024 across 4 V100 GPUs (16GB each) ... resulting in 13.8M × 40 / 1024 ≈ 540K training steps for PhoBERTbase."* — chú ý họ cho cả công thức ra số bước, người đọc kiểm tra được.

**Move 5 — Định nghĩa so sánh & đo lường (operationalize).** *Chi tiết cần:* baseline lấy ở đâu, metric nào và vì sao, có test thống kê không.
> Trích thật (XLM-R): *"We also consider three machine translation baselines: (i) translate-test: dev and test sets are machine-translated to English and a single English model is used."*

**Move 6 — Rào đón đạo đức/giới hạn dữ liệu (account).** *Chi tiết cần:* nguồn/quyền/ẩn danh; với annotation là số annotator, đãi ngộ, guideline.

**Nguyên tắc "reproducible ceiling":** viết Method như thể **bạn không có mặt để giải thích**. Mọi câu "we tuned it appropriately" / "standard settings" đều là lỗ hổng — reviewer không biết "standard" của bạn là gì.

---

## 3. Sentence frames tiếng Anh (kèm giải thích tiếng Việt)

### 3.1. Giới thiệu notation / định khung bài toán
*(Dùng thì hiện tại — định nghĩa là chân lý bền vững)*

- **"Let $x \in \mathcal{X}$ denote an input sentence and $y \in \mathcal{Y} = \{1, \dots, K\}$ its label; our goal is to learn a function $f_\theta: \mathcal{X} \to \mathcal{Y}$."**
  → *Gán ký hiệu cho input/output rồi phát biểu mục tiêu. Định nghĩa TRƯỚC khi dùng.*
- **"We formulate X as a Y task, where the model receives ... and predicts ..."**
  → *Định khung: X là bài toán loại Y.*
- **"Given a classifier $f$ and an input $x$, we define the surface-reliance score as ..."**
  → *Khung chuẩn cho bài diagnostic: "cho ... , ta định nghĩa ...".*
- **"Throughout, we use boldface for vectors ($\mathbf{h}$) and calligraphic letters for sets ($\mathcal{D}$)."**
  → *Khai báo quy ước ký hiệu — reviewer đánh giá cao sự nhất quán.*

### 3.2. Mô tả mô hình / kiến trúc
*(Hiện tại cho mô tả cấu trúc; quá khứ cho việc bạn đã làm)*

- **"Our model consists of three components: (i) ..., (ii) ..., and (iii) ..."**
  → *Liệt kê thành phần — dàn ý rành mạch cho reviewer.*
- **"We build on XLM-R (Conneau et al., 2020) and add a ... layer on top of the [CLS] representation."**
  → *Nói rõ mượn cái gì (build on) và thêm cái gì (đóng góp).*
- **"The encoder maps each token to a contextual embedding $\mathbf{h}_i \in \mathbb{R}^d$, which is then ..."**
  → *Mô tả luồng dữ liệu qua kiến trúc bằng hiện tại.*
- **"Formally, the attention weight is computed as $\alpha_{ij} = \mathrm{softmax}(\cdot)$."**
  → *"Formally, ..." báo hiệu chuyển sang công thức chính xác.*
- Trích thật (XLM-R) làm khuôn khai báo cấu hình: **"we ... train two different models: XLM-R Base (L = 12, H = 768, A = 12, 270M params) and XLM-R (L = 24, H = 1024, A = 16, 550M params)."**
  → *Khai báo layer/hidden/head/tham số gọn trong ngoặc — chuẩn vàng.*

### 3.3. Nêu hyperparameter / training details
*(Thì quá khứ — đây là việc bạn ĐÃ làm)*

- **"We optimized the model using Adam (Kingma and Ba, 2015) with a learning rate of 2e-5, a batch size of 32, for 10 epochs."**
  → *Một câu gói optimizer + LR + batch + epochs.*
- **"We selected the best checkpoint based on macro-F1 on the development set."**
  → *Nêu tiêu chí chọn model — thiếu cái này là red flag.*
- **"All experiments were run with three random seeds (13, 42, 123); we report mean and standard deviation."**
  → *Seed cụ thể + báo mean±std → chống nghi ngờ "chọn seed đẹp".*
- **"Models were trained on a single NVIDIA A100 GPU; each run took approximately 2 hours."**
  → *Phần cứng + thời gian → minh bạch chi phí, giúp người khác lượng sức.*
- Trích thật (Dodge et al., "Show Your Work") — nên báo cáo: **"Bounds for each hyperparameter"**, **"Number of hyperparameter search trials"**, và **"Corresponding validation performance for each reported test result."**
  → *Danh sách tối thiểu cần khai để claim là reproducible.*

### 3.4. Mô tả baseline
- **"We compare against three baselines: (i) a majority-class predictor, (ii) a fine-tuned PhoBERT (Nguyen and Nguyen, 2020), and (iii) ..."**
  → *Đánh số baseline rõ ràng.*
- **"For a fair comparison, all baselines use the same preprocessing, tokenizer, and training budget as our model."**
  → *Câu này TRỰC TIẾP dập red flag "so sánh không công bằng".*
- **"We re-implemented X following the original paper; we could not obtain the released code, so results may differ slightly from those reported in ..."**
  → *Trung thực khi tái hiện — tăng độ tin, không giấu.*
- **"We report the numbers from the original paper (Author, Year) where the experimental setting is identical; otherwise we re-ran the system."**
  → *Nói rõ số nào tự chạy, số nào trích — reviewer rất soi điểm này.*

### 3.5. Mô tả evaluation metric
- **"We evaluate using macro-averaged F1, which weights all classes equally and is therefore robust to the class imbalance in our dataset."**
  → *Nêu metric KÈM lý do — không để trần "we use F1".*
- **"We report accuracy on the entailment and non-entailment subsets separately, as aggregate accuracy can mask heuristic reliance."** *(khuôn theo tinh thần HANS)*
  → *Với bài diagnostic: tách metric theo subset để lộ hành vi ẩn.*
- **"Statistical significance was assessed using a paired bootstrap test (Koehn, 2004) with $10^4$ resamples; we mark results with $p < 0.05$."**
  → *Có test thống kê → khác biệt là thật hay nhiễu.*
- Trích thật (Kaushik et al.) làm khuôn cho thiết kế đánh giá đối chứng: **"We show that classifiers trained on original IMDb reviews fail on counterfactually-revised data and vice versa."**
  → *Mẫu phát biểu kết quả của một thiết kế counterfactual — Method phải mô tả cách tạo dữ liệu này trước.*

---

## 4. Quy ước: thì, thể, ký hiệu toán

### Thì (tense)
- **Quá khứ** cho MỌI việc BẠN đã thực hiện: thu dữ liệu, huấn luyện, chạy thí nghiệm.
  *"We collected 5,000 comments and annotated them ..."*
- **Hiện tại** cho mô tả mô hình/định nghĩa/công thức (đúng vĩnh viễn) và cho fact chung.
  *"The model consists of ..."; "Macro-F1 is the unweighted mean of per-class F1."*
- Đừng trộn lẫn trong một câu mô tả pipeline. Câu định nghĩa (hiện tại) và câu hành động (quá khứ) tách bạch.

### Thể (voice)
- **Passive** phổ biến ở Method để nhấn quy trình, không nhấn người: *"The corpus was tokenized using ...", "Hyperparameters were tuned on the dev set."* Passive giúp mô tả nghe khách quan, tái lập.
- **"We" chủ động** cho **quyết định thiết kế** và **đóng góp**: *"We propose ...", "We chose macro-F1 because ...", "We designed the probe so that ..."* — chỗ nào có phán đoán/lựa chọn của bạn thì "we", để reviewer thấy ai chịu trách nhiệm quyết định.
- Nguyên tắc gọn: **quy trình → passive; quyết định → "we"**. (PhoBERT/XLM-R dùng "we" cho thiết kế: *"We use a batch size of 1024 ..."*, *"We train two different models ..."*.)

### Ký hiệu toán (math notation)
- Định nghĩa **trước khi dùng**, mỗi ký hiệu một nghĩa duy nhất trong cả bài.
- Quy ước phổ biến: vô hướng thường ($n, d, K$), vector **đậm thường** ($\mathbf{h}, \mathbf{x}$), ma trận **đậm HOA** ($\mathbf{W}$), tập hợp **calligraphic** ($\mathcal{D}, \mathcal{Y}$), tham số Hy Lạp ($\theta, \alpha$).
- Hàm/toán tử viết rõ: $\mathrm{softmax}(\cdot)$, $\|\cdot\|_2$. Dùng $\odot$ cho Hadamard, đừng để mơ hồ.
- Số chiều luôn ghi: $\mathbf{h}_i \in \mathbb{R}^d$. Reviewer kiểm tính nhất quán chiều để bắt lỗi.
- Có nhiều ký hiệu → cân nhắc một **bảng notation** nhỏ.

---

## 5. Reviewer Q1 THƯỞNG gì / RED FLAG

### Reviewer thưởng (viết được thì cộng điểm mạnh)
- **Đủ chi tiết để chạy lại**: seed, phần cứng, thời gian, model-selection, link code/dữ liệu ẩn danh.
- **So sánh công bằng minh bạch**: cùng preprocessing/budget/tokenizer; nói rõ số nào tự chạy vs. trích.
- **Metric chọn có lý do** gắn với đặc điểm dữ liệu (lệch lớp → macro-F1).
- **Báo cáo variance**: mean ± std trên nhiều seed; có test ý nghĩa thống kê.
- **Design rationale**: giải thích *vì sao* thiết kế thế, không chỉ *cái gì*.
- **Ablation** tách đóng góp của từng thành phần.
- **Data/ethics statement** đàng hoàng khi có dữ liệu người thật.

### RED FLAG (reviewer trừ điểm / đòi revise / reject)
- **Thiếu chi tiết tái lập**: không seed, không phần cứng, "we tuned hyperparameters" mà không nói khoảng/tiêu chí. (Dodge et al. nhấn: phải khai *"Number of hyperparameter search trials"* + *"Bounds for each hyperparameter"*.)
- **So sánh KHÔNG công bằng**: mô hình mình tune kỹ, baseline để mặc định; khác preprocessing/budget mà vẫn so trực tiếp.
- **Metric mập mờ**: "F1" mà không nói micro/macro/binary; không nói tính trên tập nào.
- **Không seed / không variance**: một con số duy nhất, không biết là may hay thật; đặc biệt nguy khi khác biệt nhỏ.
- **"SOTA-chasing" 0.3 điểm** không test thống kê, không nhiều seed.
- **Số trích sai/không nguồn**: lấy số baseline từ bài khác nhưng setting khác → so lệch. (Đối chiếu lưu ý liêm chính của project: mọi số phải xác minh, số chưa xác minh **đánh dấu rõ**.)
- **Rò rỉ dữ liệu (leakage)**: chọn model trên test; tiền xử lý/normalize fit trên cả tập; overlap train/test.
- **Mô tả kiến trúc mơ hồ**: không đủ để vẽ lại sơ đồ; kích thước/chiều thiếu.

---

## 6. Lỗi sơ đẳng của tác giả Việt / không bản ngữ + cách sửa

1. **Thiếu mạo từ / sai số nhiều-ít.**
   - ✗ *"We use pretrained model to extract feature."*
   - ✓ *"We use a pretrained model to extract features."*
2. **Dùng "propose" cho việc setup (không phải đóng góp).**
   - ✗ *"We propose to use Adam optimizer with learning rate 2e-5."* (Adam không phải đóng góp của bạn.)
   - ✓ *"We optimized the model using Adam with a learning rate of 2e-5."* Để dành "propose/introduce" cho phần thật sự mới.
3. **Lạm dụng hiện tại cho việc đã làm.**
   - ✗ *"We collect data and train the model for 10 epochs."*
   - ✓ *"We collected the data and trained the model for 10 epochs."*
4. **Câu dài lồng nhiều mệnh đề, khó lần logic.** → Tách thành câu ngắn, mỗi câu một ý (thu → làm sạch → chia). Văn Method chuộng câu ngắn, chính xác.
5. **Dịch nguyên văn kiểu Việt.**
   - ✗ *"In this paper, we will do experiment to prove that ..."*
   - ✓ *"We conduct experiments to test whether ..."* (không "will" trong mô tả đã làm; "prove" quá mạnh → "test/examine/assess".)
6. **"Experiments" ở số ít / "researches" / "informations".** → *experiments, research (không đếm), information (không đếm), literature (không đếm).*
7. **Nối câu bằng dấu phẩy (comma splice).**
   - ✗ *"We tuned the model, we report the best result."*
   - ✓ *"We tuned the model and report the best result."* hoặc tách hai câu.
8. **Over-claim ngôn từ**: "prove", "obviously", "perfect", "significantly better" khi chưa test thống kê. → "suggest", "indicate", "consistent with", và dùng "significant" CHỈ khi có test.
9. **Thuật ngữ không nhất quán** (lúc "utterance", lúc "sentence", lúc "text" cho cùng một thứ). → Chốt một thuật ngữ, dùng xuyên suốt; khai báo ở lần đầu.
10. **"allow to / permit to" thiếu tân ngữ.** → *"which allows us to ..."* / *"enabling ... to ..."*.

*Mẹo:* đọc to từng câu; câu nào không phát âm trôi thường sai ngữ pháp. Và giữ một **glossary thuật ngữ** cho cả bài.

---

## 7. Lưu ý riêng tiếng Việt / ít tài nguyên

Đây là chỗ khác biệt của project. Reviewer quốc tế **không quen tiếng Việt** → mô tả phải tự-giải-thích, không giả định người đọc biết đặc thù tiếng Việt.

### 7.1. Dữ liệu tự thu (crawl mạng xã hội)
- Nêu **nguồn, khoảng thời gian, cách lấy** (API chính thức?), **giấy phép/điều khoản**. Trích thật (ViSoBERT): *"We crawled textual data from Vietnamese public social networks such as Facebook, Tiktok, and YouTube"* (kèm mốc thời gian) — nên bắt chước mức cụ thể này.
- Liệt kê **từng bước làm sạch** (ViSoBERT liệt kê 5 thao tác) — đừng gộp thành "we cleaned the data".

### 7.2. Annotation & inter-annotator agreement (IAA) — reviewer soi kỹ
- Bắt buộc nêu: **số annotator, nền tảng annotator (background), guideline, quy trình xử lý bất đồng, và chỉ số IAA cụ thể**.
- Trích thật (ViHSD): *"Two annotators annotate the entire dataset. If there are any different labels between two annotators, we let the third annotators annotate those labels"* và *"The final inter-annotator agreement for the dataset is κ = 0.52."*
- **Báo cáo κ dù thấp** và diễn giải: κ ≈ 0.52 là "moderate" (thang Landis & Koch) — nói thẳng và giải thích vì sao task khó (nhãn chủ quan, ranh giới offensive/hate mờ), thay vì giấu. Trung thực về κ thấp **tăng** độ tin.
- Đãi ngộ annotator + đạo đức: nêu trả công/tình nguyện, cảnh báo nội dung độc hại nếu có.

### 7.3. Tiền xử lý đặc thù tiếng Việt (phải giải thích cho người ngoài)
- **Tách từ (word segmentation)**: tiếng Việt không phân từ bằng khoảng trắng — "học sinh" là MỘT từ dù có dấu cách. Phải nói dùng công cụ gì.
  - Trích thật (PhoBERT): *"we employ RDRSegmenter (Nguyen et al., 2018) from VnCoreNLP (Vu et al., 2018) to perform word and sentence segmentation"*, rồi *"we then apply fastBPE ... using a vocabulary of 64K subword types."*
  - Nêu rõ **mức tokenization**: syllable-level vs. word-level (đã tách từ) — kết quả có thể khác nhau, reviewer cần biết bạn chọn cái nào.
- **Dấu thanh / diacritics**: văn mạng thường mất dấu ("khong" ↔ "không"/"khống"). Nói rõ bạn **giữ, chuẩn hóa, hay khôi phục dấu** — đây có thể chính là biến surface-feature bạn nghiên cứu (khớp trục novelty của project: chữ Latin + dấu thanh).
- **Chuẩn hóa Unicode**: tiếng Việt có tổ hợp dấu (NFC vs. NFD) → "à" có thể là 1 hoặc 2 code point. Nêu bạn chuẩn hóa về NFC (hay NFD) — bỏ qua là nguồn lỗi âm thầm.
- **Teencode / emoji / viết tắt** mạng xã hội: nói rõ xử lý (giữ emoji? map teencode?). ViSoBERT nêu *"keeping emojis in training data"* và tokenizer "decode emojis and teencode".
- **Trộn mã (code-switching)** Việt–Anh phổ biến trong dữ liệu MXH → khai báo cách xử lý token tiếng Anh xen kẽ.

### 7.4. Khan hiếm tài nguyên
- Nêu rõ khi **không có** dataset chuẩn/benchmark tiếng Việt → phải tự xây (đó là đóng góp, nói ra).
- **Cảnh báo LLM-as-judge / auto-metric ở tiếng Việt kém tin** (đúng theo lưu ý project): ưu tiên **macro-F1 + human adjudication**, đừng phụ thuộc metric tự động dịch từ tiếng Anh.
- Nếu dùng model đa ngữ (mBERT/XLM-R): kiểm tra **thật sự có tiếng Việt trong pre-training** — đừng giả định "multilingual" là có VN (bài học project: RAID/M4 "đa ngữ" nhưng KHÔNG có tiếng Việt).

---

## 8. Reproducibility checklist (rà trước khi nộp)

**Dữ liệu**
- [ ] Nguồn, kích thước (số mẫu/token), phân bố lớp.
- [ ] Cách chia train/dev/test + seed chia; không rò rỉ giữa các tập.
- [ ] Tiền xử lý mô tả đủ để chạy lại (với VN: segmenter, mức token, dấu thanh, Unicode NFC/NFD, emoji/teencode).
- [ ] (Tự thu) quy trình thu + làm sạch + **annotation + IAA (κ) + guideline + đãi ngộ**.
- [ ] Link dữ liệu/artifact (ẩn danh khi review) + giấy phép.

**Mô hình**
- [ ] Kiến trúc đủ chi tiết để vẽ lại (layer/hidden/head/params, chiều mọi tensor).
- [ ] Nói rõ mượn gì (build on) vs. đóng góp gì (propose).
- [ ] Công thức đầy đủ cho thành phần mới; ký hiệu định nghĩa trước khi dùng.

**Huấn luyện**
- [ ] Optimizer, learning rate (+ schedule/warmup), batch size, epochs/steps.
- [ ] **Seed** cụ thể + số lần chạy; báo **mean ± std**.
- [ ] Tiêu chí chọn model (metric nào trên dev).
- [ ] Khoảng tìm hyperparameter + số trial + tiêu chí chọn (theo Dodge et al.).
- [ ] Phần cứng (GPU) + thời gian/chi phí mỗi lần chạy.

**Đánh giá & so sánh**
- [ ] Metric nêu chính xác (macro/micro/binary F1...) + lý do chọn.
- [ ] Baseline định nghĩa rõ; số nào tự chạy vs. trích từ bài gốc (cùng setting?).
- [ ] Cùng preprocessing/budget/tokenizer cho mọi hệ (công bằng).
- [ ] Test ý nghĩa thống kê + đánh dấu $p$; nêu variance.
- [ ] Ablation tách đóng góp (nếu có nhiều thành phần).

**Liêm chính & đạo đức**
- [ ] Mọi số **xác minh được**; số chưa xác minh **đánh dấu rõ**.
- [ ] Data/ethics statement khi có dữ liệu người thật/MXH (ẩn danh, quyền, cảnh báo nội dung).
- [ ] Khai báo dùng LLM/công cụ hỗ trợ nếu venue yêu cầu.

---

## 9. Ví dụ "trước → sau"

### Ví dụ 1 — Hyperparameter mơ hồ → tái lập được
**Trước:** *"We trained our model with suitable hyperparameters until it converged and achieved good performance."*
→ *Vấn đề:* "suitable", "converged", "good" đều không đo được; không seed, không phần cứng, không tiêu chí chọn model. Red flag tái lập.
**Sau:** *"We fine-tuned PhoBERT-base for 10 epochs using Adam (learning rate 2e-5, linear warmup over the first 10% of steps, batch size 32). We selected the checkpoint with the highest macro-F1 on the development set. All experiments were run with three seeds (13, 42, 123) on a single NVIDIA A100 GPU (≈45 min/run); we report mean and standard deviation."*

### Ví dụ 2 — Tiền xử lý tiếng Việt bỏ trống → tự-giải-thích cho reviewer quốc tế
**Trước:** *"We preprocessed the Vietnamese text and fed it to the model."*
→ *Vấn đề:* reviewer không biết bạn tách từ hay không, giữ dấu hay bỏ, xử lý emoji ra sao — không thể tái lập, và với tiếng Việt các lựa chọn này đổi kết quả.
**Sau:** *"Vietnamese lacks whitespace-delimited word boundaries; we therefore performed word segmentation with RDRSegmenter from VnCoreNLP (Vu et al., 2018) before subword tokenization. We normalized all text to Unicode NFC, retained tone marks and emojis (which are informative on social media), and left code-switched English tokens unchanged. Teencode was left as-is to preserve the surface signal under study."*

### Ví dụ 3 — So sánh không công bằng / over-claim → công bằng, đúng mực
**Trước:** *"Our model is obviously better than BERT, proving the effectiveness of our method (92.1 vs 91.8 F1)."*
→ *Vấn đề:* "obviously"/"proving" over-claim; 0.3 điểm không test thống kê; không rõ baseline có cùng điều kiện, số lấy đâu.
**Sau:** *"Our model reached 92.1 macro-F1, compared with 91.8 for a fine-tuned PhoBERT baseline trained under the same preprocessing, tokenizer, and budget. The 0.3-point difference is not statistically significant under a paired bootstrap test (p = 0.21, $10^4$ resamples); we therefore report it as comparable rather than superior, and attribute our gains instead to the robustness results in §5."*

---

## Nguồn thật đã tra & trích (aclanthology / arXiv, xác minh toàn văn qua ar5iv HTML)

1. **PhoBERT** — Nguyen & Nguyen (2020), *Findings of EMNLP*. arXiv:2003.00744 — word segmentation (RDRSegmenter/VnCoreNLP), fastBPE 64K, 20GB/~3B token, batch/steps.
2. **XLM-R** — Conneau et al. (2020), *ACL*. arXiv:1911.02116 — khai báo cấu hình (L/H/A/params), CommonCrawl, MT baselines.
3. **ViSoBERT** — Nguyen et al. (2023), *EMNLP*. arXiv:2310.11166 — crawl MXH tiếng Việt, các bước làm sạch, giữ emoji/teencode, SentencePiece.
4. **ViHSD (Vietnamese Hate Speech Detection)** — Luu et al. (2021). arXiv:2103.11528 — quy trình annotation, IAA κ = 0.52, 33,400 comment, chia 7-1-2.
5. **Counterfactually-Augmented Data** — Kaushik, Hovy & Lipton (2020), *ICLR*. arXiv:1909.12434 — thiết kế minimal-edit/counterfactual, đánh giá original vs revised.
6. **HANS / "Right for the Wrong Reasons"** — McCoy, Pavlick & Linzen (2019), *ACL*. arXiv:1902.01007 — thiết kế controlled eval set để lộ surface heuristics.
7. **"Show Your Work"** — Dodge et al. (2019), *EMNLP*. arXiv:1909.03004 — chuẩn báo cáo hyperparameter search, seed, validation, budget.

> Ghi chú tra cứu: trang `aclanthology.org/<ID>/` và `arxiv.org/abs/<ID>` chỉ trả **abstract**; toàn văn Method lấy được qua **ar5iv.labs.arxiv.org/abs/<ID>** (bản HTML). Tránh fetch `.pdf` (trả binary). Câu trích trên là verbatim từ các bản HTML này.
