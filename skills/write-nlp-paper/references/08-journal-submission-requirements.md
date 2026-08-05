# 08 — YÊU CẦU NỘP BÀI & CHÍNH SÁCH TẠP CHÍ (submission compliance)

> File này **bổ sung** cho 01–07. Bảy file kia lo **văn phong tu từ** (viết phần cho hay, đúng, thuyết phục).
> File này lo **tuân thủ nộp bài** (format, khai báo, chính sách) — thứ khiến một bài **viết hay vẫn bị
> desk-reject** trước khi tới phản biện. Hai chiều **trực giao**: phải đạt CẢ HAI.
>
> **Nguồn:** audit 50 tạp chí AI/NLP/IT uy tín (ACL/MIT, Elsevier, Springer, IEEE, ACM, Nature Portfolio,
> Cell Press, Wiley, PLOS, PeerJ, Frontiers, JMLR/JAIR/TMLR…), 2026-08-05. Chi tiết từng tạp chí ở
> `journal-guidelines/agent-01..10-*.md` trong workspace project.
>
> ⚠️ **Con số cụ thể (giới hạn từ, phí trang, keyword count) THAY ĐỔI theo thời gian và bị chặn crawl** —
> LUÔN mở trang "Guide for Authors / Submission Guidelines" của tạp chí ĐÍCH bằng trình duyệt người để xác
> minh trước khi nộp. File này cho **bản đồ dạng yêu cầu** và **những gì hay bị bỏ sót**, không thay trang gốc.

---

## 0. Nguyên tắc trùm: hai loại "đúng"

Một bài có thể **viết chuẩn từng phần (01–07)** mà vẫn chết vì:
- sai LaTeX style-file (JMLR/JAIR/TMLR → **desk-reject không phản biện**);
- thiếu Highlights / Data Availability Statement / khối Declarations;
- khai dùng AI **sai vị trí**;
- vượt giới hạn trang (IEEE tính **phí** hoặc auto-reject);
- **over-claim tầm quan trọng** ở tạp chí xét theo *soundness* (PLOS ONE, PeerJ, Sci Reports, IEEE Access, Frontiers, TMLR).

→ Sau khi viết xong nội dung, **chạy một lượt "compliance" theo §12** đối chiếu tạp chí đích.

---

## 1. Nhận diện "họ nhà xuất bản" — mỗi họ một chữ ký

Biết tạp chí đích thuộc họ nào là biết ngay 80% yêu cầu format:

| Họ | Tạp chí (ví dụ trong audit) | Chữ ký nhận diện |
|----|------------------------------|------------------|
| **ACL-family** (MIT Press) | Computational Linguistics, TACL | Nộp **ẩn danh**; giới hạn theo **trang**; natbib (`acl_natbib`); **Limitations bắt buộc**; khai release code/data ở dạng ẩn danh |
| **Elsevier** | Computer Speech & Language, IP&M, Information Sciences, Neural Networks, Neurocomputing, Pattern Recognition, KBS, ESWA, Big Data Research, Speech Comm, DKE | **Highlights (3–5 gạch ≤85 ký tự)** + graphical abstract; **CRediT**; **Declaration of competing interest**; Data availability; **AI-declaration ĐẶT TRƯỚC References** |
| **Springer** | LREV, Applied Intelligence, NCA, AI Review, Cognitive Computation, DMKD, MIR, IJMLC, J Big Data, Discover Computing | Khối **"Statements and Declarations"** trước references (Funding + Competing + **CRediT** + Data availability + Ethics), mục không áp dụng ghi **"Not applicable"**; **AI khai trong Methods**; nộp file nguồn editable |
| **IEEE** | TPAMI, TNNLS, TKDE, TASLP, T-Affective Comp, IEEE Access, T-Big Data | **IEEEtran double-column**; ref **numeric [n]**; **Index Terms**; giới hạn **trang + phí vượt trang** ($110–220/trang); **ORCID**; AI khai ở **Acknowledgments**; reproducibility **Code Ocean badge** |
| **ACM** | TALLIP, TOIS, TIST, CSUR, TKDD | Template **acmart**; **CCS Concepts** (>2 trang); **ACM Reference Format**; AI khai ở **Acknowledgements**; **Artifact badging** (tùy chọn, cần repo DOI) |
| **Nature Portfolio** | Nature Machine Intelligence, Scientific Reports | **Methods ĐẶT CUỐI**; abstract không citation; **Reporting Summary** + code chia sẻ cho reviewer; ref **superscript số**; giới hạn từ chặt (NMI ≤3.500) |
| **Cell Press** | Patterns | **STAR Methods** bắt buộc; **Highlights 4×85 ký tự** + **Bigger Picture ≤300 từ** + eyebrow; **code có DOI trước accept**; "Declaration of interests" kể cả khi rỗng |
| **Wiley** | JASIST | **APA 7th**; AI khai **hai nơi** (cover letter + bản thảo), chính sách AI ngặt nhất |
| **Mega-OA soundness** | PLOS ONE, PeerJ CS, Scientific Reports, IEEE Access, Frontiers in AI | Duyệt theo **độ chặt kỹ thuật, KHÔNG xét novelty/impact** → **cấm over-claim tầm quan trọng**; data/code mạnh tay |
| **Open ML** | JMLR, JAIR, TMLR | Miễn phí, CC-BY; **style-file sai = desk-reject**; **reproducibility/code checklist**; TMLR xét *claims-đủ-chứng-cứ* + có người quan tâm, **không đòi novelty** |

---

## 2. Abstract: structured hay không, giới hạn từ, cấm gì

- **NLP/CL (ACL-family, CSL, LREV, NLE): abstract UNSTRUCTURED** — KHÔNG chia Background/Methods/Results/
  Conclusions. Đây là chuẩn của lĩnh vực; đừng bê structured-abstract kiểu y-sinh vào.
- **Ngoại lệ có structured/semi-structured:** Cognitive Computation (4 đề mục), JAIR (structured abstract mới),
  PeerJ CS (hỗ trợ cả hai). → nếu đích là các tạp chí này, viết theo heading của họ.
- **Giới hạn từ rất khác nhau** (phải tra tạp chí đích): Nature MI ~100–150; ComSoc/IEEE 100–200; Sci Reports
  ≤200; TASLP/MIR 150–250; CSUR <200; PLOS ONE ≤300; IJMLC <350; PeerJ ≤~500. Springer thường 150–250.
- **Gần như luôn cấm trong abstract:** citation `[x]`, công thức, viết tắt chưa bung. (IEEE/Nature/PLOS nhấn.)
- Liên kết `01-abstract.md`: nội dung 6-move vẫn đúng; file này thêm **ràng buộc hình thức theo venue**.

## 3. Highlights / Graphical abstract / Bigger Picture / eyebrow (DỄ SÓT NHẤT)

- **Highlights** = đặc sản **Elsevier** (và Cell): **3–5 gạch**, mỗi gạch **≤85 ký tự kể cả dấu cách**, nộp
  **file riêng** ngoài bản thảo. Bắt buộc ở nhiều tạp chí Elsevier (Computer Speech & Language, Speech Comm…).
  Cell/Patterns: **tối đa 4 gạch ≤85 ký tự**.
- **Graphical abstract**: Elsevier (tùy chọn, ~1328×531 px) / Cell (tùy chọn).
- **Bigger Picture** (Patterns): 1–2 đoạn ≤300 từ nêu ý nghĩa rộng.
- **eyebrow**: nhãn phân loại ngắn (Cell Press).
- Springer/IEEE/ACM/PLOS/Nature **không** dùng Highlights → đừng thêm nhầm.

## 4. Keywords / Index Terms / CCS Concepts

- **Keywords thường** (Elsevier/Springer): ~4–6.
- **TACL**: 5–10 keywords đặt ở **ô "Comments for the Editor"**, KHÔNG trong bài.
- **IEEE**: "Index Terms" theo taxonomy IEEE (ComSoc ≥3; TNNLS 4–5).
- **ACM**: **CCS Concepts** (hệ phân loại riêng, bắt buộc cho bài >2 trang) — không phải keyword tự do.

## 5. Giới hạn độ dài & phí

- **Theo TRANG** (ACL-family, IEEE, ACM) vs **theo TỪ** (Nature, Springer/Elsevier thường mềm).
- **IEEE tính phí vượt trang** (MOPC $220/trang ComSoc; $110→$220 SPS/TASLP); **page limit gồm cả references
  + tiểu sử**; ngưỡng NỘP khác ngưỡng TÍNH PHÍ.
- **ACM TIST**: trần cứng **25 trang KỂ CẢ references** (auto-reject). **CSUR**: 8k–20k từ.
- **Nature MI**: main text **≤3.500 từ** (loại abstract/Methods/refs), display items ≤6.
- **Mega-OA** (PLOS ONE, PeerJ) thường **không giới hạn từ cứng**.

## 6. Data & Code availability (BẮT BUỘC ở đa số journal Q1)

- **Data Availability Statement (DAS)** là mục **bắt buộc** ở Elsevier, Springer, Nature, PLOS, Wiley.
  ⚠️ **KHÔNG được viết "available upon request"** (Nature/PLOS từ chối) — phải nêu **repo cụ thể + link/DOI**.
- **ACL-family** không gọi tên "DAS" nhưng **bắt khai release code/data** (ở dạng ẩn danh khi review) — cùng
  bản chất, dễ sót vì khác tên.
- **Code availability — mức khắt khe tăng dần:**
  - PLOS: code **open-source**, deposit archive, tuân Open Source Definition.
  - PeerJ: **archival repo có DOI** (Zenodo…), **không** GitHub trần.
  - Nature MI: code **chia sẻ cho reviewer NGAY từ vòng bình duyệt** + công khai khi xuất bản.
  - Cell/Patterns: code **có DOI TRƯỚC khi accept**.
  - IEEE: khuyến khích **Code Ocean capsule** (badge trên Xplore); bài ML có thể bắt buộc.
  - JMLR: kèm code + reproducibility checklist; ACM: Artifact Availability badge (repo DOI).
- Khớp `04-methods.md` (reproducibility checklist) — nhưng đây là **nghĩa vụ khai báo hình thức**, không chỉ mô tả.

## 7. Reporting checklists & chuẩn thống kê (khung cố định, không phải văn xuôi)

- **Nature**: "Reporting Summary" + checklist theo loại nghiên cứu (CONSORT/STROBE/PRISMA/ARRIVE khi áp dụng).
- **Cell/Patterns**: **STAR Methods** — khung cố định: Resource Availability (Lead contact / Materials /
  **Data and code availability**) + Method Details + **Quantification and Statistical Analysis**.
- **PLOS (khắt khe):** nêu **p-value chính xác cho mọi giá trị ≥0.001**, test statistic + **degrees of freedom**,
  **sample size + power**, tên + **phiên bản phần mềm**.
- Khớp `05-results.md` (kỷ luật thống kê) — file kia dạy *cách viết*, đây là *mức chi tiết bắt buộc khai*.

## 8. Khối Declarations (CRediT / COI / Funding / Ethics) — và VỊ TRÍ

- **CRediT author contributions**: chuẩn ở Elsevier, Springer, PLOS, nhiều nơi (14 vai).
- **Competing/Conflict of interest**: bắt buộc **kể cả khi "không có"** (câu mẫu). COI phủ lùi 3 năm (Springer)
  / 5 năm (ACL-family).
- **Funding**, **Ethics approval/Consent** khi có dữ liệu người.
- **VỊ TRÍ khác nhau (bẫy):**
  - Springer: khối **"Statements and Declarations" trong bản thảo, TRƯỚC references** (mục không áp dụng ghi
    "Not applicable").
  - Elsevier: các statement trước references; **Competing interest có thể là file upload riêng**.
  - **PLOS**: competing/funding/contributions **nhập Ở HỆ THỐNG, KHÔNG để trong file bản thảo**.
  - Cell: "Declaration of interests" **là một section trong text** kể cả khi rỗng + form.

## 9. Khai báo dùng AI/LLM — LLM KHÔNG BAO GIỜ là tác giả, nhưng VỊ TRÍ KHAI khác nhau

Đồng thuận toàn ngành: **LLM không đủ tư cách tác giả**; chỉnh ngôn ngữ nhẹ thường **miễn khai**; dùng để
tạo/hiểu nội dung thì **phải khai**. Nhưng **đặt ở đâu là bẫy**:

| Nhà xuất bản | Nơi khai dùng generative AI |
|--------------|------------------------------|
| **Elsevier** | Statement riêng **ngay TRƯỚC References** (không đặt trong Methods); cấm AI tạo/sửa artwork |
| **Springer** | Trong **Methods** (hoặc Acknowledgements nếu không có Methods) |
| **Nature Portfolio** | Trong **Methods** |
| **PLOS** | Trong **Methods** (kèm mô tả đánh giá) |
| **IEEE** | Trong **Acknowledgments** (nêu hệ AI + phần bài dùng) |
| **ACM** | Trong **Acknowledgements** |
| **Frontiers** | Trong **Acknowledgements** (tên/phiên bản/model/nguồn) |
| **Cell Press** | Template khai chuẩn; giới hạn ở readability |
| **Wiley (JASIST)** | **Hai nơi**: cover letter + bản thảo (chính sách ngặt nhất: AI không tự phân tích dữ liệu, không làm reviewer) |
| **PeerJ** | **Acknowledge trong bài**; không khai = misconduct |

## 10. Ẩn danh, Cover letter, Reference style, Style-file

- **Ẩn danh (double-blind):** ACL-family (CL, TACL), IP&M, Neural Computing & Applications → bỏ tên/affiliation,
  self-citation ngôi thứ ba. TACL có **anonymity window + quy tắc 9 tháng** (không nộp bản vừa bị review ở
  hội nghị ACL trong 9 tháng).
- **Cover letter:** **PLOS bắt buộc ≤1 trang** (cấm xin miễn phí trong đó); **JAIR** có 3 câu hỏi bắt buộc
  (significance 150 từ + so bài JAIR gần + prior publication); **JMLR** đề cử action editor & reviewer;
  Nature/Cell nêu significance; JBD có checklist; ACM survey (CSUR/CL) cần **proposal/cover letter trước**.
- **Reference style (đổi tạp chí = viết lại refs):** natbib/author-year (ACL, Springer nhiều tạp chí) · **numeric
  [n]** (IEEE, một số Elsevier `elsarticle-num`) · **ACM Reference Format** · **Vancouver** (PLOS, Cognitive
  Computation) · **APA 7th** (JASIST). ESWA nghi Harvard — luôn kiểm.
- **LaTeX style-file:** JMLR/JAIR/**TMLR sai style-file → desk-reject**; IEEEtran; acmart; template Springer/
  Elsevier. Kiểm template **trước khi viết**, không phải lúc nộp.

## 11. Triết lý duyệt: NOVELTY vs SOUNDNESS (ảnh hưởng cách viết Intro/Abstract/Discussion)

- **Xét novelty/impact** (đa số: IEEE Trans, Elsevier, Springer, Nature, Cell, JAIR, AIJ): phải bán tính mới →
  `02-introduction.md` (gap kiểm chứng được, contributions map 1–1) áp dụng tối đa.
- **Xét SOUNDNESS, KHÔNG xét novelty/impact** (PLOS ONE, PeerJ CS, Scientific Reports, IEEE Access, Frontiers,
  **TMLR**): quyết định biên tập chỉ nhìn *độ chặt kỹ thuật/thống kê/đạo đức*. → **cấm over-claim tầm quan
  trọng**; TMLR: *"claims được chứng cứ khớp"* là tiêu chí số 1, over-claim = lý do reject hàng đầu. Khớp thẳng
  chuẩn viết của user (không over-claim) và `06-discussion.md`.
- **Mục Limitations BẮT BUỘC RIÊNG:** ACL-family / ARR (TACL). Khác với "limitations lồng trong Discussion" ở
  `06`; ở đây là **section riêng, không tính giới hạn trang**.

## 12. Lưu ý riêng tiếng Việt / ít tài nguyên (từ audit)

- **ACM TALLIP** (đích rất hợp): **tái lập là ĐIỀU KIỆN** (không chỉ khuyến khích) — "no proof of reproducibility
  → không phù hợp"; **công bố tài nguyên ngôn ngữ tính là đóng góp nặng**.
- **NEJLT** (OA no-APC, chuyên NLP): ràng buộc đạo đức đặc thù đáng học cho mọi bài low-resource — **trả công
  người tham gia ≥ lương sống**, **cộng đồng dễ tổn thương nên là ĐỒNG TÁC GIẢ**, **cấm dữ liệu GDPR-nhạy cảm**,
  bắt chọn 1 category, cấm "journal extension" của paper hội nghị.
- **Dữ liệu crawl mạng xã hội** (rất hay dùng cho tiếng Việt): chuẩn bị **ethics statement + consent/nguồn +
  ẩn danh**; nhiều journal soundness (PLOS/PeerJ) soi kỹ. Khớp `04-methods.md` §7 (annotation + IAA κ).
- **Chọn venue theo mục tiêu:** muốn nhanh + chấp nhận diagnostic/negative result → nhóm **soundness** (PeerJ CS,
  Sci Reports, TMLR, Frontiers, IEEE Access); muốn prestige + có tài nguyên ngôn ngữ mới → **TALLIP, LREV, TACL,
  Computer Speech & Language**.

## 13. Desk-reject kill-list (chết trước phản biện — kiểm TRƯỚC khi nộp)

- [ ] Sai/không dùng **LaTeX style-file** của venue (JMLR/JAIR/TMLR/IEEE/ACM).
- [ ] **Vượt giới hạn** trang/từ (IEEE tính phí; TIST auto-reject >25tr).
- [ ] Thiếu **Highlights** (Elsevier bắt buộc) / **CCS Concepts** (ACM) / **Index Terms** (IEEE).
- [ ] Thiếu **Data Availability Statement** hoặc viết "available on request".
- [ ] Thiếu **khối Declarations** (CRediT/COI/Funding) hoặc đặt **sai vị trí**.
- [ ] Khai dùng **AI sai chỗ** (xem §9) hoặc quên khai.
- [ ] Không **ẩn danh** khi venue yêu cầu (ACL-family, IP&M, NCA); vi phạm **anonymity window/9 tháng** (TACL).
- [ ] Thiếu **cover letter** bắt buộc (PLOS, JAIR questions, JMLR nominations).
- [ ] Thiếu **mục Limitations riêng** (ACL/ARR).
- [ ] **Reference style** sai họ; thiếu file **nguồn editable** (Springer).
- [ ] **Over-claim tầm quan trọng** khi nộp tạp chí **soundness-based**.
- [ ] (Nature/Cell) thiếu **Reporting Summary / STAR Methods**; Methods đặt sai chỗ (Nature = cuối).

## 14. Quy trình "compliance pass" (chạy sau khi nội dung đã xong theo 01–07)

1. Mở **trang Guide-for-Authors của tạp chí ĐÍCH** (bằng trình duyệt người — publisher chặn crawl, xem §15).
2. Xác định **họ nhà xuất bản** (§1) → suy ra bộ yêu cầu mặc định.
3. Điền **thẻ mục tiêu**: abstract (structured? giới hạn từ?), highlights?, keywords/index terms?, giới hạn độ
   dài, DAS + code policy, reporting checklist?, khối Declarations + vị trí, **vị trí khai AI**, ẩn danh?,
   cover letter?, reference style, style-file.
4. Đối chiếu **kill-list §13**.
5. Nếu venue **soundness-based** → rà lại Abstract/Intro/Discussion hạ mọi câu bán "tầm quan trọng/novelty".
6. (Tiếng Việt) kiểm ethics dữ liệu + release tài nguyên ngôn ngữ (§12).

## 15. Lưu ý tra cứu (đã kiểm nghiệm khi audit 50 tạp chí)

Các site nhà xuất bản **chặn WebFetch tự động**: `sciencedirect.com` (403), `dl.acm.org`/`acm.org` (403),
`cell.com`/`peerj.com` (403), `cambridge.org` (429), `computer.org` (JS-render, chỉ trả header), `cis.ieee.org`
(418); `nature.com`/`link.springer.com` **redirect qua cookie IDP**. Cách lấy nội dung:
- **WebSearch trích đoạn** từ chính URL guide + trang **policy chung của publisher** (thường fetch được:
  elsevier.com policy, nature.com/nature-portfolio/editorial-policies, IEEE Author Center, ACM authors).
- **Springer**: có thể vượt cookie IDP bằng cách fetch `idp.springer.com/authorize?...redirect_uri=<trang>` lấy
  `code` rồi fetch URL cuối `...?error=cookies_not_supported&code=<code>`.
- **Con số đặc thù tạp chí LUÔN cần xác minh bằng trình duyệt người** — đừng lấy số từ site template bên thứ ba
  (scispace/paperpile) làm chuẩn; đánh dấu "chưa xác minh" nếu chỉ có snippet.
