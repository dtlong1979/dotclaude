---
name: research-writing-standards
description: "Chuẩn viết/rà bài NCKH của user — rõ-đơn giản-đúng vấn đề, cân bằng không-tự-phòng-thủ ↔ không-nói-quá, phương pháp tái lập được, để số liệu tự nói, cơ sở lý thuyết phải phân tích gắn câu hỏi nghiên cứu (không liệt kê)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b2ac8b1a-f022-4b3d-8097-e7e79df865f3
  modified: 2026-08-04T15:12:56.401Z
---

Tiêu chuẩn user yêu cầu cho MỌI bài nghiên cứu (manuscript, đề cương, review) khi tôi soạn hoặc rà:

1. **Rõ ràng, đơn giản, vào đúng vấn đề** — không lan man, không rườm rà; câu ngắn, thẳng.
2. **Cân bằng phòng thủ ↔ khiêm tốn:** KHÔNG tự phòng thủ quá cao (đừng thêm câu "giải trình / xin lỗi / hoãn cho công trình sau" cho một lựa chọn phạm vi hợp lý — nếu một hướng không tiềm năng thì cứ không đưa vào, không nợ lời biện minh), NHƯNG cũng KHÔNG nói quá kết quả (không over-claim; mọi khẳng định phải có số/trích dẫn/chứng minh đỡ, nếu không thì làm mềm).
3. **Phương pháp rõ ràng, minh bạch, tái lập được** — đủ tham số cụ thể, định nghĩa ký hiệu, cách đo; ghi rõ số nào là ĐO, số nào là ƯỚC TÍNH/MÔ PHỎNG (đừng để "đo trực tiếp" ở mục Kết quả mâu thuẫn với "mô phỏng/đại diện" ở mục Giới hạn).
4. **Để số liệu tự lên tiếng** — không diễn giải quá tay, không lặp lại con số bằng tính từ ("đáng kể", "vượt trội", "mạnh", "giòn"); trình số rồi để nó nói.
5. **Cơ sở lý thuyết KHÔNG phải bản liệt kê** — phải PHÂN TÍCH và gắn từng công trình dẫn ra với một khoảng-trống / câu-hỏi-nghiên-cứu của bài (kiểu bản đồ gap G→đóng góp C), không kể lể "ai làm gì".
6. **Viết THẲNG vào việc mình làm, cắt câu meta/tự-biện-hộ/tự-dự-đoán.** User đã tự sửa bản CertiHeal-Edge theo hướng này — các anti-pattern PHẢI tránh:
   - **Đừng dùng khung "X đưa vào đây không phải để Y mà để Z".** Viết thẳng: *"Chúng tôi đã thực nghiệm Z với X và thu được [số]."* (dẫn dắt bằng HÀNH ĐỘNG → KẾT QUẢ). Ví dụ: bỏ *"định thiên 'đi theo dòng điện' khó bị đánh bại"* → *"Chúng tôi cũng thử nghiệm ... bằng REINFORCE, nhưng kết quả kém hơn trường thuần."*
   - **Cắt câu tự-tuyên-bố-mình-trung-thực:** *"Chúng tôi báo cáo kết quả này để không cường điệu..."*, *"...mà chúng tôi định lượng thay vì cường điệu."*, *"chúng tôi cố ý tránh kiểu tuyên bố... vì nó gây hiểu nhầm"*, *"ta trình bày nó đúng như vậy"*. Số liệu trung thực TỰ NÓ đã trung thực — không cần tuyên bố mình trung thực. Chỉ cần nêu thẳng lưu ý ("cần hiểu thận trọng: ..."), không kể mình đã "cố ý" làm gì.
   - **Cắt đuôi tự-dự-đoán/tự-an-ủi ở cuối đoạn** ("giá trị thực của nó, nếu có, sẽ lộ ra ở..."). Một câu hướng-tương-lai NGẮN thì được; đừng biến mỗi kết quả yếu thành một đoạn tự bào chữa.
   - **Bỏ throat-clearing/dẫn dắt máy móc:** *"Điều quan trọng là phải..."*, *"Có N điều cần nói thẳng..."* → vào thẳng nội dung.
   - **Nêu giới hạn MỘT LẦN, gọn;** không lặp "đóng góp là ở A chứ không phải B" nhiều lần trong bài.

**Why:** User (Đinh Tuấn Long) là nhà nghiên cứu nhắm tạp chí Q1, coi liêm chính khoa học là ưu tiên số một. Đã nhiều lần chỉnh khi tôi: (a) thêm câu tự-phòng-thủ thừa (vụ "giải trình hoãn baseline AI" — user phản đối vì đó chỉ là hướng chưa đưa vào, không nợ ai); (b) để nhận định thiếu minh chứng ("[27] giòn" khi chưa test [27]); (c) để mâu thuẫn đo (0.7 s "đo trực tiếp" vs "liveness-probe mô phỏng"); (d) văn phong máy móc/tự-biện-hộ — user tự viết lại toàn bộ bản CertiHeal-Edge để cắt câu meta và viết thẳng vào việc mình làm (xem mục 6).

**How to apply:** Trước khi chốt bất kỳ đoạn nào — soi từng câu khẳng định: có số/trích dẫn/định lý đỡ không? nếu không → làm mềm hoặc bỏ. **Viết mỗi kết quả theo mẫu "chúng tôi đã [làm gì] với [công cụ] và thu được [số]", KHÔNG dùng khung "cái A đưa vào không phải để B mà để C".** Sau khi viết xong một đoạn, tự soát: có câu nào chỉ nói VỀ cách mình viết / mình trung thực / mình cẩn thận không (meta) → CẮT. Related-work tổ chức theo gap gắn câu hỏi, mỗi trích dẫn phục vụ một luận điểm. Bỏ mọi câu biện minh cho lựa chọn phạm vi. Ưu tiên câu ngắn; đừng "phán" thay số liệu. Xem [[dissertation-to-practice]] cho ví dụ áp dụng (CertiHeal-Edge). Bổ trợ: skill `write-abstract` (công thức 6 câu hỏi) và `strengthen-review-paper`.
