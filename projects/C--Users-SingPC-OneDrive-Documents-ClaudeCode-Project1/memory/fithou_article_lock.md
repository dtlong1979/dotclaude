---
name: fithou-article-lock
description: Website fit.hou.edu.vn khóa bài viết nội bộ (yêu cầu đăng nhập) + audit PII 5 năm
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-15T07:23:52.941Z
---

Tính năng KHÓA BÀI VIẾT nội bộ trên website Fithou (`D:\dev\Fithou Website`, Next.js 16 + Directus, service prod `fithou-web` trong fithouone-deploy). Bài viết = collection Directus `legacy_articles`, render SSR ở `app/bai-viet/[sourceAid]/page.tsx` (nội dung `content_html`).

**Cơ chế (SSR thật, ẩn PII cả ở HTML/SEO/RSS):**
- Field `require_login` (boolean, default false) trên `legacy_articles`. Tick trong admin biên tập (`components/fithou-visual-editor.tsx`) — bài mới mặc định PUBLIC.
- **Reader-auth tách hệ admin** (`fithou_admin_session`): cookie httpOnly `fithou_reader` = JWT do hou-cntt phát. `lib/reader-auth.ts::getReaderUser()` verify bằng gọi `http://hou-cntt-api:8000/api/auth/me` (Bearer), fail→null (fail-safe không mở khóa). Routes `app/api/reader-auth/login|logout`. Trang đăng nhập độc-giả `app/dang-nhap?returnUrl=` (same-origin, `safeReturnUrl` chống open-redirect) → đăng nhập xong quay lại ĐÚNG bài. Nút Đăng nhập trên gate trỏ `/dang-nhap?returnUrl=<path bài>`.
- Gate = `components/article-login-gate.tsx`. Đã chặn rò ở MỌI surface: detail page, generateMetadata/JSON-LD (mô tả trung tính + noindex), `feed.xml`, tìm kiếm, category-page, page-builder, và **chỉ mục AI** `fithou_article_index` (bài khóa không index; `indexArticle` tự gỡ nếu `require_login`).

**Audit PII 5 năm (đã chạy 2026-08-15):** script `scratchpad/pii-audit.mjs` chạy trong container directus (`docker compose cp` + `node`, login admin từ `.env`). Quét 572 bài published ≥2021-08-15, khóa **205 bài** (mssv 107 / ngày sinh 53 / ảnh+nhóm nhạy cảm 45) + gỡ 39 khỏi chỉ mục AI. Regex mã SV HOU: `\b\d{2}[A-Z]\d{3,}[A-Z]?\d{2,}\b`. User chọn "tự khóa mọi bài nghi ngờ". Reversible: bỏ tick trong admin hoặc PATCH require_login=false.

**Bổ sung 2026-08-15 (3 fix):** (1) Admin xem được bài khóa kể cả Xem trước — gate `page.tsx` cho qua nếu có reader HOẶC `getCurrentFithouUser()` (admin `fithou_admin_session`). (2) Nút toggle 🔒 "Bảo mật" ở DANH SÁCH quản trị `app/quan-tri/page.tsx` (component `article-secure-toggle.tsx` + route PATCH `app/api/fithou-editor/articles/[id]/secure` bảo vệ same-origin+requireFithouUser+canDelete/canPublish) để rà nhanh (audit khóa nhầm nhiều). (3) **SSO đọc-giả**: hou-cntt `/api/auth/login` (auth.py) set cookie httpOnly `fithou_reader=<jwt>` (secure, samesite lax, path /, 8h) → SV đăng nhập ở web-sv/website được website nhận diện, bấm từ thông báo sang bài khóa KHÔNG phải login lại (SV đã login trước lúc deploy cần login lại 1 lần). App di động dùng Bearer nên bỏ qua cookie. **BẪY đã vá (2026-08-15):** cookie set lúc login nhưng logout web-sv chỉ xóa localStorage → đăng xuất rồi VẪN xem được bài khóa (cookie sống 8h). Vá: `web-sv logout()` gọi `POST /api/reader-auth/logout` (same-origin, Set-Cookie Max-Age=0) trước khi thoát.

**Tạo field Directus prod:** login admin (`DIRECTUS_ADMIN_EMAIL/PASSWORD` trong deploy `.env`) → `POST /fields/legacy_articles` (không chạy full seed để tránh đụng permissions). Xem [[fithou_website_local]].
