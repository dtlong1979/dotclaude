---
name: fithou-minio-storage
description: Directus (website fit.hou.edu.vn) lưu file/ảnh vào MinIO bucket fithou-cms; đã migrate toàn bộ file cũ
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-28T06:23:46.321Z
---

Website Fithou (Directus 11) lưu trữ tệp/ảnh trên **MinIO** thay vì local. Cấu hình ở `fithouone-deploy/docker-compose.yml` service `directus`: `STORAGE_LOCATIONS="minio,local"` (minio mặc định cho file MỚI, giữ local để rollback), driver s3, endpoint `http://minio:9000`, bucket **`fithou-cms`**, path-style, creds = `S3_ACCESS_KEY/S3_SECRET_KEY` (= MINIO_ROOT_USER/PASSWORD).

**Đã migrate (2026-07-28):** toàn bộ 3458 file `storage=local` → `minio` (mc mirror volume `fithouone_directus_uploads` → bucket, rồi `UPDATE directus_files SET storage='minio'`). Bucket `fithou-cms` ~4272 object / 837MB. Bucket **`workload`** là của hou-cntt (tách riêng).

**GOTCHA token đọc (gây sập trang chủ 2026-07-28):** app đọc Directus bằng `DIRECTUS_STATIC_TOKEN` (env fithou-web). Token này PHẢI khớp `directus_users.token` của 1 user có quyền đọc. Nếu không khớp → MỌI read 401 → trang chủ trắng (không bài viết/slider). Public role KHÔNG có read (no-token=403), nên site phụ thuộc token này. Đã fix: `UPDATE directus_users SET token='<env token>' WHERE email='admin@example.edu.vn'`. Kiểm tra nhanh khi trang trắng: `docker exec fithou-web node` fetch `/items/site_settings` kèm Bearer token → phải 200. Trang chủ `force-dynamic` nhưng fetch cache 300s → sau khi fix chờ tới 5' hoặc rebuild.

Backup: `~/backup-directus_files-20260728-0611.sql` trên server. **Bản local 837MB (volume directus_uploads) VẪN CÒN** làm lưới an toàn — chưa xóa. Khi chốt ổn: xóa volume + bỏ `local` khỏi STORAGE_LOCATIONS để thu hồi đĩa (server đang 85% dùng / 15G trống). Rollback = `UPDATE directus_files SET storage='local'`. Xem [[fithouone_deploy]], [[fithou_website_local]].
