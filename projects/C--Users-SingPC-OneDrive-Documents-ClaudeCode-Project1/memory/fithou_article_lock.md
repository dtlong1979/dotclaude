---
name: fithou-article-lock
description: Website fit.hou.edu.vn khóa bài viết nội bộ (yêu cầu đăng nhập) + audit PII 5 năm
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-14T18:17:23.067Z
---

Tính năng KHÓA BÀI VIẾT nội bộ trên website Fithou (`D:\dev\Fithou Website`, Next.js 16 + Directus, service prod `fithou-web` trong fithouone-deploy). Bài viết = collection Directus `legacy_articles`, render SSR ở `app/bai-viet/[sourceAid]/page.tsx` (nội dung `content_html`).

**Cơ chế (SSR thật, ẩn PII cả ở HTML/SEO/RSS):**
- Field `require_login` (boolean, default false) trên `legacy_articles`. Tick trong admin biên tập (`components/fithou-visual-editor.tsx`) — bài mới mặc định PUBLIC.
- **Reader-auth tách hệ admin** (`fithou_admin_session`): cookie httpOnly `fithou_reader` = JWT do hou-cntt phát. `lib/reader-auth.ts::getReaderUser()` verify bằng gọi `http://hou-cntt-api:8000/api/auth/me` (Bearer), fail→null (fail-safe không mở khóa). Routes `app/api/reader-auth/login|logout`. Trang đăng nhập độc-giả `app/dang-nhap?returnUrl=` (same-origin, `safeReturnUrl` chống open-redirect) → đăng nhập xong quay lại ĐÚNG bài. Nút Đăng nhập trên gate trỏ `/dang-nhap?returnUrl=<path bài>`.
- Gate = `components/article-login-gate.tsx`. Đã chặn rò ở MỌI surface: detail page, generateMetadata/JSON-LD (mô tả trung tính + noindex), `feed.xml`, tìm kiếm, category-page, page-builder, và **chỉ mục AI** `fithou_article_index` (bài khóa không index; `indexArticle` tự gỡ nếu `require_login`).

**Audit PII 5 năm (đã chạy 2026-08-15):** script `scratchpad/pii-audit.mjs` chạy trong container directus (`docker compose cp` + `node`, login admin từ `.env`). Quét 572 bài published ≥2021-08-15, khóa **205 bài** (mssv 107 / ngày sinh 53 / ảnh+nhóm nhạy cảm 45) + gỡ 39 khỏi chỉ mục AI. Regex mã SV HOU: `\b\d{2}[A-Z]\d{3,}[A-Z]?\d{2,}\b`. User chọn "tự khóa mọi bài nghi ngờ". Reversible: bỏ tick trong admin hoặc PATCH require_login=false.

**Tạo field Directus prod:** login admin (`DIRECTUS_ADMIN_EMAIL/PASSWORD` trong deploy `.env`) → `POST /fields/legacy_articles` (không chạy full seed để tránh đụng permissions). Xem [[fithou_website_local]].
