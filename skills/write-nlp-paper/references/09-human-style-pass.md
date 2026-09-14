# 09 — Lượt rà văn phong người viết (BẮT BUỘC mỗi lần)

Chưng cất từ hai vòng người dùng tự chấm bài FJCAI 2027 và ICEIR 2026 (tháng 9/2026). Mục đích: bài đọc như
một nhà nghiên cứu viết bình thường, không mang "mùi" câu chữ đã qua đánh bóng tự động, và mỗi khẳng định
đúng bằng mức bằng chứng. Chạy lượt này **sau mỗi lần viết hoặc sửa bài, và luôn chạy lại trước khi nộp**,
kể cả khi người dùng không nhắc.

## 1. Cấu trúc đoạn

**Không dùng nhãn in đậm đầu đoạn** kiểu `\textbf{Label.} Nội dung…` hay `**Label.** …` (cả trong danh sách
`\item \textbf{…}`). Người dùng thấy kiểu này "ngang ngang", không giống người viết.
- Mặc định: viết đoạn văn thường, **câu đầu nêu chủ đề**.
- Nếu nhãn mang ý thì đưa ý đó vào câu đầu: `\textbf{Sample.} We read one paper…` → `Our sample reads one
  paper…`; `\textbf{Label shift.} Sessions differ…` → `Sessions also differ in class balance: …`.
- Chỉ khi thật sự cần tiêu đề: dùng dòng tiêu đề riêng (subsection, hoặc dòng nghiêng đậm đứng một mình), không
  dùng nhãn chạy liền đoạn.
- Liệt kê kiểu `\emph{Standard}: …, \emph{LOSO}: …` trong một đoạn → viết thành các câu liền mạch.
- Không in đậm cụm từ giữa câu để nhấn (`with \textbf{four negative values}`).

## 2. Dấu câu

**Bỏ em dash (`---`, `—`)** trừ khi thật sự không thay được. Thay bằng dấu phẩy, ngoặc đơn, dấu hai chấm
(trước một danh sách), hoặc tách câu. Kiểm tra: `grep -n -- "---" main.tex | grep -v "^[0-9]*:%"`.

## 3. Cấu trúc câu dễ lộ

| Dấu hiệu | Ví dụ đã gặp | Cách sửa |
|---|---|---|
| Đối xứng "not X but Y", "rather than" dày đặc | "not one point out of the forty… but one point out of three" | "corresponds to about a third of the headroom, even though some forty points remain" |
| Đếm tròn | "three things are ours", "four practices to three groups", "three downstream consequences" | liệt kê trực tiếp, không đếm |
| Câu ngắn kiểu khẩu hiệu | "Selection matters." · "It matters where it is close." · "The hazard arose later." | "The selection procedure also matters." · gộp vào câu sau |
| Châm ngôn | "Complementarity is not the absence of shared content; it is…" | "These results suggest that multimodal benefit depends on complementary label-relevant information…" |
| Ẩn dụ, nhân hoá | "everything fusion is worth", "a margin consumes", "survived all three checks", "fusion gets three chances", "defies intuition" | "the observed fusion headroom", "remained positive across all three metrics", "We evaluate three fusion strategies", "does not follow a simple pattern" |
| Tu từ bóng bẩy | "would swamp the margins", "the wrong instrument", "The fused numbers alone support the wrong conclusion" | nói thẳng điều đo được |
| Câu meta kể quá trình | "The diagnostics are meant to change how a margin is read, so we applied them to a margin of our own…" | "As an illustrative case study, we apply the diagnostics to…" |
| Cặp "We do not suggest… We suggest…" | | "This does not make such margins wrong, but reporting them beside…" |
| Câu triết lý thừa | "that is the claim we would want falsified" | bỏ, hoặc nói mục đích cụ thể ("to make the audit reproducible") |

## 4. Không để dấu vết quy trình làm việc hay công cụ

Không viết những câu để lộ cách làm bằng công cụ tìm kiếm, parser hay agent:
- "search summaries", "read from the paper's PDF rather than abstracts", "machine check", "tables are raster
  images whose cells could not be read".
- Viết theo **kiểm chứng**: "All reported values were verified against the original papers";
  "a numerical verification script is provided".
- Loại một nguồn: nêu **tiêu chí khoa học** ("excluded when no matched comparison could be identified"), không
  nêu giới hạn công cụ. Sửa luôn chú thích tương ứng trong file dữ liệu phát hành.

## 5. Số liệu và các lần chạy

- **Chỉ báo kết quả lần chạy cuối.** Không viết trong bài chuyện chạy lại, sai lệch giữa các lần chạy hay tính
  không tất định: đó là việc của tác giả. Người đọc sẽ hỏi "sao không tất định?" và câu đó đọc như tự bào chữa.
- Nếu phải chạy lại (ví dụ để lưu dự đoán cho bootstrap), thay hẳn file kết quả cũ, cập nhật **mọi** bảng, hình
  và câu có số; chạy lại cả các thí nghiệm liên quan trong cùng môi trường.
- Môi trường (CPU/GPU, phiên bản thư viện, số luồng) ghi trong README hoặc requirements của repo, không ghi trong bài.
- **Không lặp số chính** ở cả abstract, contributions, results, discussion và conclusion. Số ở abstract và
  Results; contributions trỏ tới mục; Discussion và Conclusion nói ý, không nhắc lại số.

## 6. Mức khẳng định đúng bằng chứng

- **Nguồn gốc hay quy trình của người khác:** "the original study reports…", "consistent with…", không khẳng
  định như đã chứng minh. Soát cả tiêu đề, chú thích hình, nhãn trục, legend.
- **Nhân quả:** chỉ khi có đối chứng; nếu không thì "consistent with poor transfer…; this experiment does not
  establish its cause".
- **Thống kê:** khi các phép kiểm định cho kết quả khác nhau (bootstrap loại 0, permutation p = 0,06) thì nói
  cả hai, không viết "nothing measurable". Nêu đơn vị lấy mẫu (hội thoại, không phải phát ngôn).
- **Mệnh đề toán:** nêu đủ điều kiện ("increasing in λ whenever it exceeds its chance level 1/K").
- **Khái quát:** "does reach the opposite conclusion among our eleven tested configurations", không "would
  reach"; "provides limited dynamic range", không "cannot separate"; "generally small", không "a few points at
  most" khi bảng có giá trị 9.
- **Khảo sát:** nói rõ "purposive code audit", có bảng từng hệ (URL, commit, file, dòng code) trong repo.
- **Không gán quan điểm cho bài được trích** khi họ không nói vậy (ví dụ Delgado & Tibau khuyên dùng MCC, không
  khuyên báo cáo cả kappa và MCC).
- Thí nghiệm có số cụ thể mà không có Methods/bảng/CI trong bài (câu mượn từ bài khác) → bỏ.

## 7. Đồng bộ sau mỗi lần sửa

- Đổi một định nghĩa hay tiêu chí (ví dụ "same table, architecture" → "same paper, protocol, model family and
  evaluation setting") thì grep và sửa **mọi** chỗ: abstract, contributions, methods, chú thích bảng, recommendations,
  câu tham chiếu kiểu "violating the last condition".
- Soát **thuật ngữ cũ còn sót** sau khi đổi: "floor" → "majority-class baseline", "chance-corrected/chance
  correction" → "collapse-resistant", "prior" trong nhãn trục hình, "label-fit" → "supervised", cả keywords.
- Kiểm tra lại số trang, dịch không lỗi, abstract trong giới hạn từ.

## Lệnh rà nhanh (LaTeX)

```bash
grep -n -- "---" main.tex | grep -v "^[0-9]*:%"                    # em dash
grep -n "textbf{[A-Z][^}]*\.}" main.tex                            # nhãn in đậm đầu đoạn
grep -n -i "rather than\|not merely\|matters\.\|worth\|consume\|survive\|defies\|swamp\|wrong instrument" main.tex
grep -n -i "summar\|pdf\|raster\|machine check\|rerun\|re-run\|non-determin\|deviat" main.tex
```
Mỗi kết quả grep phải được xem và quyết định giữ hay sửa; không sửa máy móc (ví dụ "rather than" đôi khi là
cách nói tự nhiên duy nhất).
