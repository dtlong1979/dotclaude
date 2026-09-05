# MEMORY — Bản đồ tri thức (đọc TRƯỚC khi làm)

> Đây là **BẢN ĐỒ**, không phải kho nội dung. Kiến trúc chi tiết nằm ở **tài liệu SỐNG** của từng hệ
> (sửa TẠI CHỖ khi thay đổi — xem CLAUDE.md mục "Kiến trúc sống"). Memory chỉ giữ: con trỏ · gu/feedback · reference.

## 🗺️ FithouOne — website + workload + hou-cntt + mobile
> **Tri thức FithouOne KHÔNG ở đây** — nằm HẾT trong project: **`D:\dev\FithouOne\.project\`**. Bắt đầu làm FithouOne → đọc ở đó:
> - **`ARCHITECTURE.md`** — cấu trúc/hiện trạng mọi phân hệ (module · endpoint · bảng · bẫy) + bảng "ghi nhận gì vào đâu". **Sửa tại chỗ khi đổi.**
>   - Trong đó có mục **⚙️ ĐỤNG VÀO GÌ THÌ PHẢI KIỂM GÌ** (A–J): giảng viên · đồng bộ Trường · điều kiện đăng ký ·
>     lịch · mã lớp · đọc Excel Trường · phân quyền · thông báo · ghi dữ liệu thật · màn song song web/app.
>     **ĐỌC TRƯỚC KHI SỬA** — mỗi dòng là một lần đã làm hỏng thật.
> - `INFRA.md` (hạ tầng · cứu server · phát hành mobile) · `STATE.md` (đang làm) · `DECISIONS.md` (vì sao) · `TAXONOMY.md` (mảng).
> - `_archive_memory/` — 45 memo cũ (khảo cổ). Repo mã: `D:\dev\hou-cntt` (có `CLAUDE.md` trỏ về hub).

## QCV — dịch vụ web trọn gói
**ĐỌC TRƯỚC:** `D:\dev\qcv-builder\KIEN-TRUC.md` (kiến trúc + trạng thái + việc còn lại).
- [Web Project](qcv_web_project.md) — nhật ký 74KB (khảo cổ); màu 4 lớp đè, hướng chốt B2 qcv-core
- Bẫy đã biết: [Xám 128](qcv_xam_128.md) · [Zip đóng gói](qcv_zip_dong_goi.md) · [Backup holes](qcv_optimizer_backup_holes.md) · [Origin Optimizer](qcv_origin_optimizer.md) · [Chat Assistant](qcv_chat_assistant.md)

### QCV 2 — bỏ WordPress, làm sản phẩm riêng (từ 2026-09-05)
**ĐỌC TRƯỚC:** `D:\dev\QCV\PHUONG-AN-KY-THUAT.md` — phương án kỹ thuật, 6 vòng phản biện, hội tụ, sẵn sàng mốc G0.
Hồ sơ rà soát: `D:\dev\QCV\_ra-soat\` (vòng 1–3, 5 hợp nhất, 5 đo hosting, 6). Hệ WP cũ (`qcv-builder\KIEN-TRUC.md`) chỉ để rút bài học, KHÔNG kế thừa mã.
**CẢNH BÁO ràng buộc đã ĐỔI (vòng 5 và 7)** — đừng dùng lại bản cũ:
- Nền: **Laravel 13 + PHP 8.3, KHÔNG Filament** (khu quản trị dùng hệ lược đồ sinh giao diện), **Blade** không Twig, **MariaDB duy nhất** (bỏ hẳn SQLite), canvas **section-first** không GrapesJS.
- Hạ tầng (vòng 7): **QCV thuê VPS, có root, mọi site khách trên máy QCV. KHÔNG dùng panel** — Ubuntu + Caddy + PHP-FPM một pool mỗi site + Ansible + bộ lệnh `qcv-site` do Trạm gọi. Khách thấy "Trang dịch vụ" trong admin thay panel. Thư qua dịch vụ ngoài, không mail server. WAF Tadu ngoài phạm vi.
- **Đã gỡ ở vòng 7, không thêm lại** (xem mục 29): Site Connector, WebAuthn và bốn loại khoá, ba chiến lược cache Apache/LiteSpeed/PHP, trình cài đặt trên trình duyệt, ba mức kết nối, cron HTTP. Lý do: chúng là phòng thủ cho "hosting lạ của khách" — tình huống không xảy ra.

## Nghiên cứu NLP Q1 (`Project1/.project/` + `Project1/CLAUDE.md`)
Đo "surface-feature reliance" tiếng Việt/ít tài nguyên → bài Q1; vũ khí chung matched-deletion/counterfactual.
- [Emotion Anchors](emotion_anchors_paper.md) · [AI Detector VN](ai_detector_vn_study.md) · [Fake News SLR](fake_news_slr_paper.md)
- [CARE-Fusion](care_fusion_project.md) (+[trong Monitor](care_fusion_in_monitor.md)) · [Honorifics](honorifics_diss_directions.md) · [Sentiment Monitor](hou_sentiment_monitor.md)
- Skill viết bài: [NLP paper](write_nlp_paper_skill.md) · [Onomastics](write_onomastics_paper_skill.md) · [IT paper mặc định](it_paper_default_skill.md)

## Dự án nhỏ khác
- [Dissertation→Practice](dissertation_to_practice.md) — phát triển luận án 2014 thành đề tài ứng dụng
- [License Checker](license_checker_app.md) (+[Defender trap](license_checker_defender_trap.md)) — kiểm bản quyền Win/Office
- [Shadowing App](shadowing_app.md) (+[build env](shadowing_build_env.md)) — app học nghe/nói tiếng Anh
- [Wedding Builder](wedding_builder.md) — SaaS website đám cưới
- [Project Overview](project_overview.md) — chat + quản lý công việc nội bộ (nền tảng chung)

## Gu & cách làm việc (feedback/user — luôn áp dụng)
- [UI Copy Style](ui_copy_style.md) — văn phong giao diện: TRANG TRỌNG, THUẦN VIỆT, không emoji/khẩu ngữ
- [Research Writing](research_writing_standards.md) — chuẩn viết/rà bài NCKH (rõ, đúng vấn đề, không over-claim)
- [Agent Company](agent_company_model.md) — mô hình "công ty agent" (~/.claude), template `.project/`
