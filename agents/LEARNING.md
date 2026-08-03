# Giao thức Học tập của nhân sự (Learning Protocol)

Áp cho MỌI agent. Mục tiêu: agent khôn dần nhờ ghi lại bài học nghề — nhưng KHÔNG phình, KHÔNG máy móc.

## Nguyên tắc nền
- "Học" = ghi bộ nhớ ngoài rồi nạp lại, KHÔNG phải model tự thông minh lên.
- Agent chỉ có MỘT kho riêng: **kinh nghiệm nghề tổng quát** (`experience/<agent>.md`).
- Tri thức khác KHÔNG thuộc agent: lý thuyết chung → có sẵn trong model; đặc thù project → `.project/`; quy trình bài bản → skill; sự thật tươi → internet; gu của user → bộ nhớ user.

## Vòng học
1. TRƯỚC khi làm: đọc sổ kinh nghiệm của mình. Coi là GỢI Ý, kiểm chứng trước khi áp (có thể lỗi thời).
2. Làm việc — ưu tiên suy luận của chính mình; sổ bổ trợ, không thay thế.
3. SAU khi làm: soi xem có "ứng viên bài học" nào không (tiêu chí dưới).
4. Có ứng viên:
   - Nếu đang chạy như **subagent** → chỉ NÊU ứng viên trong phần trả về (mục "Ứng viên bài học"). KHÔNG tự hỏi user, KHÔNG tự ghi — subagent không có kênh hỏi user.
   - Nếu đang là **main loop** → HỎI user; đồng ý thì tự ghi thẳng vào sổ. (Main loop cũng là nơi tiếp nhận ứng viên do subagent nêu, rồi hỏi user & ghi.)
5. Định kỳ → cô đọng (skill consolidate-memory).

## Ghi cái gì? (bộ lọc thông minh — thỏa ÍT NHẤT MỘT)
1. **Lặp lại**: cùng một cách xử lý đã cần dùng ≥3 lần → là pattern, không ngẫu nhiên.
2. **Tốn công mới ra**: chỉ phát hiện sau khi sàng lọc/thử-sai/điều tra → cứu công lần sau.
3. **Trái trực giác / model bỏ sót**: kết quả khác điều "lẽ ra đúng", hoặc kiến thức chung bị hiểu sai/thiếu → vá điểm mù.
4. **Quên thì đắt**: từng gây mất dữ liệu / hỏng / bug nghiêm trọng → chi phí quên cao.

## KHÔNG ghi
- Lý thuyết chung model đã biết (REST, indexing, cache...).
- Đặc thù một project → để ở `.project/STATE.md` / `DECISIONS.md`.
- Việc ngẫu nhiên một lần, chưa chắc lặp.
- Sự thật đổi nhanh (phiên bản, giá, id) → lấy từ internet khi cần.

## Cách hỏi & ghi (việc của MAIN LOOP)
- Chỉ MAIN LOOP hỏi user và ghi sổ. Subagent chỉ nêu ứng viên trong phần trả về; main loop tổng hợp các ứng viên đó lại.
- Hỏi gọn: "Phát hiện bài học: <tóm tắt>. Đáng ghi vì <1 trong 4 tiêu chí>. Ghi vào sổ <agent> không?"
- User gật → append thẳng vào `C:/Users/SingPC/.claude/agents/experience/<agent>.md`. User lắc → bỏ, không hỏi lại đúng cái đó trong phiên.

## Định dạng bài học (CÓ ĐIỀU KIỆN, không mệnh lệnh cứng)
> **Khi** <bối cảnh áp dụng> → <nên làm gì> · vì <sự cố gốc/bằng chứng> · độ tin: cao/vừa/thấp · <ngày>

- Luôn có "**Khi** ..." để giới hạn phạm vi → tránh áp máy móc ra ngoài ca hợp lệ.
- Viết "cân nhắc/nên", tránh "LUÔN/KHÔNG BAO GIỜ" trừ khi thật sự tuyệt đối.
- Độ tin thấp = mới thấy 1-2 lần; gặp lại đúng thì nâng lên.

## Vệ sinh (chống phình & máy móc)
- Mỗi mục 1–2 dòng. Trần ~30 mục hoặc ~3KB mỗi sổ.
- Vượt trần, hoặc thấy mục trùng/cũ → cô đọng: gộp, sửa, XÓA cái lỗi thời.
- Nạp tinh: khi sổ lớn, chỉ đọc phần liên quan việc đang làm (grep), không bê cả sổ.
