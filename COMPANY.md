# Mô hình "Công ty Agent" — cách vận hành

Đây là mô hình tổ chức nhân sự AI dùng chung cho MỌI project trên máy này.
Ba khái niệm tách bạch, nằm ở ba nơi khác nhau:

## 1. Nhân sự (Agent) — `C:/Users/SingPC/.claude/agents/*.md`
- Mỗi agent là một **cá thể có NĂNG LỰC**, KHÔNG thuộc project nào.
- Định nghĩa agent chỉ mô tả "làm được gì", tuyệt đối không nhắc stack/tên project cụ thể.
- Cùng một agent phục vụ nhiều project khác nhau; bối cảnh đến từ hồ sơ project, không từ trí nhớ agent.

## 2. Hồ sơ dự án (Project) — `<project>/.project/*.md`
Mỗi project giữ hộp riêng, là NGUỒN SỰ THẬT DUY NHẤT về project đó:
- `PROJECT.md`  — stack, kiến trúc, quy ước (đổi chậm).
- `STATE.md`    — đang làm gì, còn nợ gì, cạm bẫy (cập nhật liên tục).
- `DECISIONS.md`— đã chốt gì & VÌ SAO (để không lật lại quyết định cũ).
- `STAFFING.md` — project này dùng agent nào, ai làm phần nào.

Template ở `C:/Users/SingPC/.claude/templates/project/`.

## 3. Phân công (Staffing) — việc động, do project-manager làm
`project-manager` LÀ VAI CỦA MAIN LOOP (chính Claude đang chat), KHÔNG spawn như subagent — vì subagent không tự đẻ được subagent. Chỉ main loop mới giao việc cho các agent nghiệp vụ. Khi có project mới hoặc mở lại project cũ:
1. Đọc `PROJECT.md` + `STATE.md` + `DECISIONS.md` TRƯỚC TIÊN (quy trình khôi phục).
2. Xác định nhu cầu → tuyển agent theo năng lực → ghi vào `STAFFING.md`.
3. Giao việc cho từng agent nghiệp vụ (qua Agent tool); agent tự đọc hồ sơ rồi làm phần của mình, xong thì *báo cáo lại* cho main loop.

## Lớp học tập (kinh nghiệm)
- Mỗi agent có MỘT sổ kinh nghiệm nghề tổng quát: `C:/Users/SingPC/.claude/agents/experience/<agent>.md`.
- Agent đọc sổ trước khi làm. Sau khi làm, nếu gặp bài học đáng ghi (theo bộ lọc): agent nghiệp vụ (subagent) chỉ NÊU "ứng viên bài học" trong phần trả về; MAIN LOOP mới hỏi user và ghi vào sổ. (Subagent không có kênh hỏi user trực tiếp.)
- Chi tiết bộ lọc/định dạng/vệ sinh: `C:/Users/SingPC/.claude/agents/LEARNING.md`.
- Kinh nghiệm = tổng quát-hóa (đúng nhiều project). Đặc thù project vẫn ở `.project/`.

## Ba lớp chống "quên & lẫn giữa các project"
1. Agent KHÔNG mang state — mọi bối cảnh lấy từ hồ sơ project đang mở.
2. Tri thức dùng chung phải khai báo tường minh trong `<project>/CLAUDE.md` (import chọn lọc).
3. `STATE.md` là nguồn sự thật về tiến độ — không tin "trí nhớ hội thoại". CHỈ main loop được ghi `STATE.md` (agent nghiệp vụ chỉ báo cáo lại); cập nhật sau mỗi mảng việc là BẮT BUỘC.

## Danh sách nhân sự hiện có
Điều phối:  project-manager
Phân tích:  system-analyst (làm rõ yêu cầu/đặc tả), system-architect (kiến trúc)
Kỹ thuật:   backend-engineer, frontend-engineer, mobile-engineer, db-specialist,
            wp-engineer, security-specialist
Chất lượng: reviewer (đọc code tìm lỗi), tester (viết & chạy test)
Chuyên sâu: backend-performance-specialist (tối ưu hiệu năng), ai-engineer (AI/ML/LLM)
Thiết kế:   designer (UI/UX)
Dữ liệu:    data-analyst
Nghiên cứu: researcher, market-researcher
Kinh doanh: marketing-specialist
