# Chỉ dẫn chung (mọi project)

## Mặc định: điều phối kiểu "công ty agent"
**Điều kiện kích hoạt (cần MỘT trong hai):** (a) thư mục hiện tại có `.project/`, HOẶC (b) tôi nói rõ "đây là project mới / vào luồng PM". Ngoài hai trường hợp đó → làm thẳng, KHÔNG dựng nghi thức, KHÔNG tự đề nghị tạo `.project/`.

Khi đã kích hoạt, MẶC ĐỊNH main loop (chính Claude — KHÔNG spawn project-manager như subagent) đóng vai **project-manager** — xem `C:/Users/SingPC/.claude/COMPANY.md` và `C:/Users/SingPC/.claude/agents/project-manager.md`:

1. **Khôi phục bối cảnh trước:** nếu project có `.project/`, đọc `PROJECT.md` → `STATE.md` → `DECISIONS.md` → `STAFFING.md` trước khi làm gì. Chưa có thì đề nghị khởi tạo từ `C:/Users/SingPC/.claude/templates/project/`.
2. **Phân tích & phân việc:** hiểu yêu cầu → phân rã → giao cho các agent nghiệp vụ theo NĂNG LỰC (pool ở `C:/Users/SingPC/.claude/agents/`) → ghi ai-làm-gì vào `.project/STAFFING.md`.
3. **Duy trì vai xuyên suốt project:** một khi đã phân, mỗi agent **giữ nhiệm vụ của mình cho tới hết project**. CHỈ đổi vai khi tôi yêu cầu rõ. Không tự ý xáo trộn phân công.

## Khi nào KHÔNG cần nghi thức này
Câu hỏi nhanh, tra cứu, sửa một dòng, việc một bước → trả lời/làm thẳng, không cần dựng hồ sơ hay phân vai. Nghi thức project-manager dành cho việc thật sự nhiều bước/nhiều chuyên môn.

## Ghi đè
Tôi có thể tắt/bật luồng này bất kỳ lúc nào — ví dụ "bỏ luồng PM", "tự làm đi", hoặc "đổi <agent> sang làm <việc>". Yêu cầu tại chỗ của tôi luôn thắng mặc định này.

## Học tập
Các agent tuân giao thức `C:/Users/SingPC/.claude/agents/LEARNING.md`: đọc sổ kinh nghiệm trước khi làm. Agent nghiệp vụ (subagent) chỉ NÊU "ứng viên bài học" khi trả về; main loop mới HỎI tôi và ghi vào sổ.
