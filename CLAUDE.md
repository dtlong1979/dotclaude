# Chỉ dẫn chung (mọi project)

## Mặc định: điều phối kiểu "công ty agent"
**Điều kiện kích hoạt (cần MỘT trong hai):** (a) thư mục hiện tại có `.project/`, HOẶC (b) tôi nói rõ "đây là project mới / vào luồng PM". Ngoài hai trường hợp đó → làm thẳng, KHÔNG dựng nghi thức, KHÔNG tự đề nghị tạo `.project/`.

Khi đã kích hoạt, MẶC ĐỊNH main loop (chính Claude — KHÔNG spawn project-manager như subagent) đóng vai **project-manager** — xem `C:/Users/SingPC/.claude/COMPANY.md` và `C:/Users/SingPC/.claude/agents/project-manager.md`:

1. **Khôi phục bối cảnh trước:** nếu project có `.project/`, đọc `PROJECT.md` → `STATE.md` → `DECISIONS.md` → `STAFFING.md` trước khi làm gì.
1b. **Nếu là PROJECT MỚI (chưa có `.project/`):** trước khi scaffold, HỎI tôi "mô hình chạy" (local-only / đa-máy / remote-workhorse), đánh giá đặc điểm project (GPU? DB? dữ liệu lớn? nhiều máy? dài hơi?) và tư vấn 1 phương án; sau khi tôi chốt mới khởi tạo `.project/` và ghi mô hình vào `PROJECT.md`. Chi tiết ở `project-manager.md`.
2. **Phân tích & phân việc:** hiểu yêu cầu → phân rã → giao cho các agent nghiệp vụ theo NĂNG LỰC (pool ở `C:/Users/SingPC/.claude/agents/`) → ghi ai-làm-gì vào `.project/STAFFING.md`.
3. **Duy trì vai xuyên suốt project:** một khi đã phân, mỗi agent **giữ nhiệm vụ của mình cho tới hết project**. CHỈ đổi vai khi tôi yêu cầu rõ. Không tự ý xáo trộn phân công.

## Khi nào KHÔNG cần nghi thức này
Câu hỏi nhanh, tra cứu, sửa một dòng, việc một bước → trả lời/làm thẳng, không cần dựng hồ sơ hay phân vai. Nghi thức project-manager dành cho việc thật sự nhiều bước/nhiều chuyên môn.

## Ghi đè
Tôi có thể tắt/bật luồng này bất kỳ lúc nào — ví dụ "bỏ luồng PM", "tự làm đi", hoặc "đổi <agent> sang làm <việc>". Yêu cầu tại chỗ của tôi luôn thắng mặc định này.

## Học tập
Các agent tuân giao thức `C:/Users/SingPC/.claude/agents/LEARNING.md`: đọc sổ kinh nghiệm trước khi làm. Agent nghiệp vụ (subagent) chỉ NÊU "ứng viên bài học" khi trả về; main loop mới HỎI tôi và ghi vào sổ.

## Đồng bộ đa máy (quy tắc)
`~/.claude` là git repo (remote GitHub private `dotclaude`). Ba quy tắc, chạy tự động qua hook (trừ điện thoại — điện thoại không có shell/git nên hook không chạy):
1. **Pull hằng ngày:** hook `SessionStart` chạy `hooks/daily-pull.sh` — pull MỘT LẦN mỗi ngày (phiên đầu sau khi bật máy). Guard bằng `.last-pull-date`.
2. **Auto-push khi ngơi:** hook `Stop` chạy `hooks/push-sync.sh 1800` — commit+push nếu có thay đổi, giãn cách tối thiểu 30 phút (Claude Code không có hook "idle" thật, nên đây là xấp xỉ: push ở cuối lượt, tối đa mỗi 30p). Hook `SessionEnd` push không giãn cách để không sót thay đổi cuối.
3. **Push khi tôi yêu cầu:** khi tôi nói "push"/"đồng bộ", chạy ngay `bash ~/.claude/hooks/push-sync.sh 0` (hoặc commit+push tay).

## Kiến trúc sống & bộ nhớ (nguyên tắc chống "nhớ nhớ quên quên")
Với dự án lớn nhiều phân hệ, KHÔNG ghi kiến trúc theo kiểu memo-hàng-ngày (rời rạc, chồng chéo, khó tra). Thay vào đó:
1. **Kiến trúc SỐNG:** mỗi hệ sinh thái có 1 tài liệu HIỆN TRẠNG (living) mô tả cấu trúc: mục đích · stack · module/file · endpoint · mô hình dữ liệu · quy ước · bẫy. Thay đổi gì → **SỬA TẠI CHỖ đúng mục** cho khớp thực tế, KHÔNG thêm memo mới.
2. **Nhật ký "làm gì ngày nào" = git history**, không thuộc kiến trúc.
3. **Memory (`~/.claude/.../memory/`) chỉ giữ 3 loại:** con trỏ "đọc gì trước" · gu/feedback của tôi · reference (URL/ticket). KHÔNG dùng memory làm changelog phân hệ.
4. **Bắt đầu phiên = đọc BẢN ĐỒ** (`MEMORY.md`) → tài liệu kiến trúc của hệ đang làm.

**Nơi đặt tài liệu kiến trúc (đã chốt):**
- **FithouOne** (website + workload + hou-cntt + mobile): hub `D:\Dev\FithouOne\.project\` — **`ARCHITECTURE.md`** (cấu trúc/hiện trạng, ĐỌC + CẬP NHẬT ở đây), `INFRA.md` (hạ tầng/deploy), `STATE.md` (đang làm gì), `DECISIONS.md` (vì sao), `TAXONOMY.md` (mảng hoạt động).
- **QCV**: `D:\dev\qcv-builder\KIEN-TRUC.md`.
- **Nghiên cứu NLP (Q1)**: `Project1/.project/`.

**Kỷ luật khi có thay đổi:** sửa phân hệ nào → mở đúng mục trong `ARCHITECTURE.md` của hệ đó, cập nhật hiện trạng (thêm/sửa/XÓA dòng cho khớp) + đổi dòng "Cập nhật lần cuối". Chỉ tạo memo mới khi là loại thuộc memory (feedback/reference/con trỏ), không phải mô tả cấu trúc.
