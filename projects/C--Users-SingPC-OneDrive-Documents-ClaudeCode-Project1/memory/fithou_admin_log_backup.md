---
name: fithou-admin-log-backup
description: "Fithou Website có nhật ký hệ thống (audit) + sao lưu/khôi phục CSDL+MinIO, chỉ system_admin"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-28T12:27:27.460Z
---

Fithou Website (Next.js+Directus) đã thêm 2 chức năng admin, **chỉ system_admin**, ở `/quan-tri/nhat-ky` và `/quan-tri/sao-luu` (nav trong sidebar `app/quan-tri/page.tsx`).

**Nhật ký hệ thống** (`lib/fithou-audit.ts`):
- Ghi audit trail vào collection Directus `fithou_admin_logs` (tạo bằng `scripts/setup-audit-collection.mjs`, chạy trong container web). Vì web đăng nhập Directus bằng 1 token chung nên directus_activity không phân biệt được người → phải log riêng theo phiên thật.
- `logAdminAction()` gọi ở: login route, `app/api/fithou-advanced-admin/route.ts` (tập trung, key `admin.<action>`), editor articles route (`content.publish`/`content.delete`), route backup. Tab 2 đọc `directus_activity` (chỉ đọc).

**Sao lưu/khôi phục** (`lib/fithou-backup.ts` + `app/api/fithou-backup/route.ts` + `components/backup-manager.tsx`):
- Phạm vi: CSDL `fit_hou_cms` (pg_dump `--clean`) + tùy chọn MinIO bucket `fithou-cms` (mc mirror). Chạy NỀN spawn detached, theo dõi qua file STATUS/LOG trong volume `fithou_backups:/app/backups`; UI polling.
- Khôi phục có bảo vệ: bắt gõ "KHOI PHUC", TỰ sao lưu an toàn trước, `pg_terminate_backend` ngắt kết nối, restore `ON_ERROR_STOP=0`, rồi **reseat DIRECTUS_STATIC_TOKEN cho DIRECTUS_ADMIN_EMAIL** (tránh lặp sự cố 401). Nếu bản sao lưu đổi cấu trúc collection thì nên restart Directus sau đó.

**Hạ tầng đã đổi (deploy):**
- `Dockerfile` (web) runner stage: `apk add postgresql16-client gzip` (16.14 khớp server) + tải `mc` + `mkdir /app/backups`.
- `fithouone-deploy/docker-compose.yml` fithou-web: thêm env `POSTGRES_HOST=postgres/PORT=5432`, `S3_ENDPOINT/S3_ACCESS_KEY/S3_SECRET_KEY/S3_BUCKET=fithou-cms`, `depends_on minio`, volume `fithou_backups`. (POSTGRES_USER/DB/PASSWORD sẵn từ app .env). Đã khai báo volume `fithou_backups`.
- Lưu ý: chỉ backup phần WEBSITE; toàn server (3 phân hệ) vẫn dùng `fithouone-deploy/scripts/backup.sh|restore.sh` ở host. Xem [[fithouone_deploy]], [[fithou_minio_storage]], [[fithou_website_local]].
