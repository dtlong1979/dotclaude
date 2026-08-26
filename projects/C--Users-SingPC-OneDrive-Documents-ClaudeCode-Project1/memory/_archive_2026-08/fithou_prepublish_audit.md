---
name: fithou_prepublish_audit
description: "Rà soát bản quyền trước phát hành FithouOne (publish=deploy dùng nội bộ, KHÔNG mở mã); đã gỡ ảnh Unsplash trên website"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-03T05:57:24.207Z
---

Rà soát bản quyền/giấy phép toàn hệ FithouOne trước khi **phát hành để SỬ DỤNG nội bộ** (user chốt: publish = deploy chạy cho khoa, KHÔNG công khai mã nguồn). Liên quan [[fithou_website_local]].

**Kết luận rà soát (2026-08): không có blocker bản quyền cho việc chạy nội bộ.**
- Font: tất cả OFL/hệ thống/MaterialIcons. Icon: lucide (ISC) + vẽ tay. Thư viện: MIT/BSD/Apache. → OK.
- Copyleft chỉ ở SERVER, không phát tán: **ffmpeg-static (GPL)** chạy server-side → GPL không ràng buộc dịch vụ tự host; **MinIO (AGPL)** tự host bản gốc không sửa → OK, ghim version; **Directus (BSL 1.1)** miễn phí khi tổ chức <~5M USD & không bán lại → khoa nội bộ OK. psycopg2-binary LGPL server-side = ghi chú.
- APK + tài nguyên web gửi tới người dùng: SẠCH giấy phép (chỉ permissive).
- Việc cần làm khi go-live là VẬN HÀNH, không phải bản quyền: đổi secret "dev" sang prod mạnh + xoay khóa live (OpenAI/Azure/Brevo/Firebase); đổi email gửi Brevo (đang là Gmail cá nhân dinhtuanlong@gmail.com) sang email khoa; siết Firebase API key (App Check); xác nhận quyền dùng logo HOU + ảnh người thật.

**ĐÃ LÀM — thay ảnh Unsplash trên website (deploy prod):**
- Website trước có 10 vị trí hotlink `images.unsplash.com`: 5 nền CSS trong `app/globals.css`, 3 ảnh gallery trong `lib/cms.ts`, 2 ảnh dự phòng trong `components/fithou-page-builder-renderer.tsx`.
- Thay bằng 10 ảnh nội bộ ở `public/generated/*.jpg`. Cách tạo (đạt độ THẬT): dùng **ảnh THẬT của khoa** (`public/nghien-cuu/lab-2|3|4.webp`, `public/gioi-thieu/activities/nghien-cuu-khoa-hoc.webp`) làm gốc, cho qua **OpenAI gpt-image-1 image-edit** (`/v1/images/edits`, `input_fidelity: high`, 1536x1024, jpeg) để làm sáng + màu tươi + bỏ chữ banner. Script Node ở scratchpad `gen_edits.mjs` (fetch+FormData, key đọc từ website `.env.local`, KHÔNG in key). Bản sinh-từ-đầu (text-to-image) bị chê "không thật" → chuyển sang image-edit từ ảnh thật.
- Deploy: scp 3 file mã + `public/generated/` lên `sscfit:/home/fitadm/code/fithouone/Fithou Website` (scp SFTP: đường dẫn có dấu cách để NGUYÊN, không escape `\`), rồi `docker compose build fithou-web && up -d`. Verify: `/` 200, ảnh `/generated/*.jpg` 200 image/jpeg, 0 tham chiếu unsplash. Lưu ý test: Next bind theo $HOSTNAME container (không phải 127.0.0.1) → fetch nội bộ phải qua hostname/nginx.
