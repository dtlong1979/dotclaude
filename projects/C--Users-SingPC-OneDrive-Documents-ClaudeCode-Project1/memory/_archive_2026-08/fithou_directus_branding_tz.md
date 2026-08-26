---
name: fithou-directus-branding-tz
description: Trang login Directus đã brand Fithou; và cách hiển thị giờ VN trong web (container chạy UTC)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-28T13:10:04.396Z
---

**Múi giờ (Fithou Website):** container web chạy **UTC** và **không có tzdata** → `new Date().getHours()`/`TZ=` KHÔNG ra giờ VN. Muốn hiển thị GMT+7 phải format tường minh bằng ICU: `new Intl.DateTimeFormat("en-GB", { timeZone: "Asia/Ho_Chi_Minh", ... })` (dùng `en-GB` để ra thứ tự dd/mm/yyyy rồi giờ; `vi-VN` đảo giờ lên trước). Áp dụng ở `app/quan-tri/nhat-ky/page.tsx` và `components/backup-manager.tsx`. Timestamp audit vẫn LƯU UTC (ISO) là đúng — chỉ đổi lúc hiển thị. Xem [[fithou-admin-log-backup]].

**Chặn Studio Directus chỉ cho admin:** các policy Fithou (Content Admin/Editor/Publisher/Contributor) đặt `app_access=false` → chỉ role **Administrator** vào được Directus Studio `/admin`. Bật lại: PATCH `/policies/<id>` `{app_access:true}`.
⚠ GOTCHA đã xử lý: ban đầu tắt app_access làm HỎNG đăng nhập website (báo "chưa được cấp quyền Fithou Admin") vì `createFithouSession` (lib/fithou-auth.ts) đọc `role.name` bằng TOKEN CỦA CHÍNH USER — token đó mất quyền đọc role khi app_access=false. Đã sửa: sau `/auth/login`, lấy `id` qua /users/me rồi đọc role+hồ sơ bằng **token admin** (`loginAsAdmin()`), có đường dự phòng tra theo email. Giờ đăng nhập website độc lập hoàn toàn với quyền Directus của user.

**Trang đăng nhập Directus (cms.fit.hou.edu.vn) đã brand Fithou** qua `directus_settings` (PATCH bằng DIRECTUS_STATIC_TOKEN, không sửa code Directus):
- project_name="Trường Đại học Mở Hà Nội", project_descriptor="Khoa Công nghệ Thông tin", project_color="#1e40af".
- Dòng tiêu đề thứ 3 "Trang quản trị hệ thống" thêm bằng `custom_css` (`.public-view .title-box .title .subtitle::after`).
- project_logo=public_foreground=public_favicon = logo Fithou (`public/fithou-icon.png` đã upload thành file Directus) → thay logo Directus.
- public_background = ảnh AI (PNG) người dùng cung cấp: não nơ-ron + đám mây + mũ/sách + mạch điện, tông xanh (từ `D:/Downloads/directusbkg.png`) → panel phải. (Trước đó từng dùng SVG tự tạo `scratchpad/login-bg.svg`.)
- DOM login Directus 11: `.public-view` → trái `.container`(`.title-box>.logo>img` + `.title>.type-title`/`.subtitle`) + `.content`(form); phải `.art>.fallback`(nền).
- Đổi ảnh/logo sau này: upload file mới lên Directus rồi PATCH `/settings` trường tương ứng (script mẫu ở `scratchpad/brand-directus-login.mjs`). OPENAI_API_KEY KHÔNG cấu hình trong container nên không sinh ảnh DALL·E được — ảnh nền hiện là SVG.
