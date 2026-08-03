---
name: agent-company-model
description: "Mô hình \"công ty agent\" global ở ~/.claude — 13 nhân sự theo năng lực + template hồ sơ dự án + quy trình khôi phục project cũ"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 652bdd3d-a937-4512-bb4f-f1fcc80682ba
  modified: 2026-08-03T09:26:12.562Z
---

Đã dựng mô hình tổ chức agent kiểu công ty ở **global** `~/.claude/` (dùng cho MỌI project), ngày 2026-08-03.

**Ba tầng tách bạch:**
- **Nhân sự** = `~/.claude/agents/*.md` — 18 agent theo NĂNG LỰC, không thuộc project: project-manager (điều phối), system-analyst, system-architect, backend/frontend/mobile-engineer, db-specialist, wp-engineer, security-specialist, reviewer (đọc code tìm lỗi), tester (viết & chạy test), backend-performance-specialist, ai-engineer, designer, data-analyst, researcher, market-researcher, marketing-specialist. Định nghĩa agent KHÔNG nhắc stack/tên project; stack lấy từ hồ sơ project.
- **Hồ sơ dự án** = `<project>/.project/` với 4 file: PROJECT.md (stack/kiến trúc), STATE.md (tiến độ+cạm bẫy, đọc ĐẦU TIÊN), DECISIONS.md (quyết định+lý do), STAFFING.md (ai làm gì). Template ở `~/.claude/templates/project/`.
- **Phân công** = việc động do project-manager làm: đọc hồ sơ → tuyển agent theo năng lực → ghi STAFFING.md.

**Chống quên/lẫn:** agent không mang state; tri thức dùng chung phải import tường minh trong `<project>/CLAUDE.md`; STATE.md là nguồn sự thật tiến độ.

**Lớp học tập (đã dựng):** mỗi agent có 1 sổ kinh nghiệm nghề tổng quát ở `~/.claude/agents/experience/<agent>.md`; giao thức ở `~/.claude/agents/LEARNING.md`. Cơ chế ghi user chốt: **agent tự ghi thẳng NHƯNG phải HỎI user trước**. Bộ lọc "đáng ghi" (thỏa ≥1): (1) cách xử lý lặp ≥3 lần, (2) chỉ ra sau sàng lọc/thử-sai, (3) trái kiến thức chung/model bỏ sót, (4) quên thì hậu quả đắt. KHÔNG ghi: lý thuyết chung (đã trong model), đặc thù project (→.project/), việc 1 lần, sự thật đổi nhanh (→internet). Định dạng CÓ ĐIỀU KIỆN "**Khi** <bối cảnh> → <nên làm> · vì <sự cố> · độ tin · ngày" để tránh máy móc. Đã seed thật: wp-engineer (ZipArchive), mobile-engineer (compileSdk≥36). Kho tri thức riêng agent đã BỎ (tri thức chung ở model, đặc thù ở project) — agent chỉ giữ kinh nghiệm.

**Tài liệu điều hành:** `~/.claude/COMPANY.md`. Tri thức chia sẻ chọn lọc: `~/.claude/shared-knowledge/` (import qua @import trong CLAUDE.md project = cơ chế "phân quyền").

**Quy trình khôi phục project cũ** (project-manager chạy): đọc PROJECT.md → STATE.md → DECISIONS.md → STAFFING.md trước khi làm.

**Mặc định hành vi (đã đặt ở `~/.claude/CLAUDE.md`):** khi bắt đầu việc quy mô project, main loop MẶC ĐỊNH đóng vai project-manager: khôi phục bối cảnh `.project/` → phân tích → phân việc cho agent theo năng lực → ghi STAFFING.md. Agent GIỮ vai xuyên suốt project, chỉ đổi khi user yêu cầu rõ. Việc vặt/1 bước thì bỏ nghi thức, làm thẳng. User ghi đè bất kỳ lúc nào ("bỏ luồng PM"...). Lưu ý: subagent không tự đẻ subagent → PM = chính main loop là hợp lý nhất.

Liên quan: đây là phần "agent + bộ nhớ 2 cấp" bàn trong hướng cải thiện workflow Claude Code. Phần vector/graph auto-memory (ý 3,4) hoãn tới khi kho tri thức > ~1000 mẩu.
