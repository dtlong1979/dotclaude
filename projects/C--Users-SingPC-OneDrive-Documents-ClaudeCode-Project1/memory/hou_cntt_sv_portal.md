---
name: hou_cntt_sv_portal
description: Cổng Sinh viên web fit.hou.edu.vn/sinhvien (bản web của app) + nền portfolio public & kê khai rèn luyện
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-13T13:58:49.784Z
---

Xây **Cổng Sinh viên** (bản web của app di động) tại `fit.hou.edu.vn/sinhvien`, định hướng về sau có **portfolio public xác thực được** (gửi nhà tuyển dụng/minh chứng) và **SV tự kê khai rèn luyện + ảnh minh chứng** (KHÔNG chấm điểm — chấm ĐRL ở hệ khác; chỉ kê khai theo khung 5 tiêu chí TT16/2015-BGDĐT + cấp link public xem).

**Kiến trúc chốt — same-origin, KHÔNG lộ `api.*`** (ẩn URL API ≠ bảo mật; bảo mật thật = auth CAS + phân quyền owner). Edge nginx `D:\dev\fithouone-deploy\nginx\conf.d\fithouone.conf`, trong server `fit.hou.edu.vn` (vốn → fithou-web:3000) thêm:
- `location /sinhvien/api/` → `http://hou-cntt-api:8000/api/` (SPA gọi `/sinhvien/api/me/*` → backend `/api/me/*`, dùng lại router sẵn có).
- `location /sinhvien` → `http://hou-cntt-api:8000/sinhvien` (SPA tĩnh).
Backend mount `/sinhvien` = StaticFiles `web-sv/` (giống web-admin ở `/admin`). Router mount prefix `/api` nên `/me` thật ra `/api/me`.

**Đã làm (local, CHƯA deploy):**
- `backend/app/services/sv_portal.py`: `ensure_tables()` tạo 6 mầm + `RL_TIEU_CHI` (5 nhóm TT16) + `PF_LOAI` + get/save prefs.
- `backend/app/api/routes/sv_me.py`: `/me/prefs` (GET/PUT), `/me/ho-so-mo-rong` (GET/PUT) — owner-only (mssv từ token, KHÔNG nhận client). Đăng ký trong main.py.
- `web-sv/index.html`: SPA shell port từ mockup (còn dữ liệu mẫu, chưa nối API).
- Mockup duyệt: Artifact https://claude.ai/code/artifact/b916684e-9d75-4f6c-91c1-f3960ceb5461 (Dashboard, lịch **3 ca Sáng/Chiều/Tối mỗi ca 1 môn**, Hồ sơ dày theo form K25, Nhiệm vụ, Cài đặt tùy biến chạy thật).

**6 mầm gieo sẵn (bảng, `sv_portal.py`):** (1) `sv_ho_so_mo_rong` hồ sơ dày (liên hệ/địa chỉ/phụ huynh/THPT/giới thiệu + ky_nang_cntt & hoat_dong_doan_the jsonb) — nội bộ, KHÔNG tự public; (2) `sv_ui_prefs` màu/theme/font/size/avatar; (3) `sv_portfolio` public_slug + enabled(default false)+share_mode+share_token+sections — bền sau tốt nghiệp; (4) `sv_portfolio_items` generic theo `loai` (experience|project|research|award|certificate|activity|ren_luyen) + visibility/verified/source + media/chi_tiet jsonb (rèn luyện: {tieu_chi,hoc_ky,nam_hoc}); (5) `sv_media` 2 bucket sv-public/sv-private (ảnh minh chứng mặc định private); (6) verified/source = phân biệt khoa-kiểm-định vs tự-khai. Public page `/sv/{slug}` (chưa dựng) CHỈ đọc field public+enabled.

**Nguồn hồ sơ K25:** `D:\Downloads\Phiếu thông tin sinh viên mới (Responses).xlsx` — Google Form 369 SV, các trường: cơ bản+giới tính+ngày sinh+SĐT, địa chỉ thường trú/trọ, THPT, 6 hoạt động đoàn thể (bool), phụ huynh (họ tên/SĐT/email/nơi làm/địa chỉ), tự giới thiệu, công việc mơ ước, 16 kỹ năng CNTT thang 1-5. CHỈ K25 có bộ này; K21-24 trống → cần importer map.

**Việc còn (chưa làm):** importer form K25 → sv_ho_so_mo_rong; nối SPA vào API thật (prefs/hồ sơ/lịch 3 ca/nhiệm vụ/portfolio); endpoints portfolio + kê khai rèn luyện + upload ảnh (MinIO 2 bucket); trang public `/sv/{slug}` + QR xác thực; deploy (scp fithouone-deploy + build hou-cntt-api + reload nginx). Liên quan [[hou_cntt_app_audit_log]] [[fithou_minio_storage]] [[fithou_server_infra]].
