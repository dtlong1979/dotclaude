---
name: qcv-optimizer-backup-holes
description: "Lỗ hổng backup của qcv-origin-optimizer (sửa ở 0.1.94) — backup từng tự ghi đè bằng ảnh hỏng; luật \"không backup thì không đụng ảnh gốc\""
metadata: 
  node_type: memory
  type: project
  originSessionId: 9f34285f-7927-41e5-81c6-4c1b9e1b5527
---

Trong `qcv-origin-optimizer` (xem [[qcv_origin_optimizer]]), chức năng sao lưu ảnh gốc từng có nhiều lỗ làm **mất dữ liệu vĩnh viễn**. Người dùng tự phát hiện lỗ đầu tiên (17/07/2026) khi hỏi: "lần chạy thứ 2 đem ảnh đang có trên màn hình chứ không phải ảnh backup ra để xử lý và lại cất lại vào backup?" — đúng.

Các lỗ đã sửa ở **0.1.94-backup-ghi-mot-lan**:

1. `backup_original()` chốt chặn bằng **post meta**, còn file đích thì tên cố định + `@copy` ghi đè. Meta mất (clone site / restore CSDL cũ / cài lại plugin) → lần chạy sau sao lưu **ảnh đã hỏng đè lên bản tốt**. → chốt chuyển sang **file**.
2. `filesize > 0` **không đủ**: `copy()` ghi theo dòng, bị giết giữa chừng để lại file cụt >0 byte → được coi là backup rồi **khoá vĩnh viễn**. → dùng `image_file_complete()` (đã có sẵn trong file, dòng ~1177) + chép qua `.qcv-tmp` rồi `rename`.
3. `backup_original()` trả `void`, hàm gọi **resize bất kể sao lưu thành công hay không**. → trả `bool`; **không có bản lưu thì không đụng vào ảnh gốc**.
4. `purge_webp_files()` glob `{tên}*.webp` xoá cả **.webp khách tự upload** (không có ảnh nguồn → không gì sinh lại). → chặn bằng `la_attachment()`.
5. `collect_backups()` gán backup **chỉ theo ID** → ID bị tái sử dụng sau restore dump cũ → khôi phục ảnh người khác đè lên. → đối chiếu tên `{id}-{basename}`; đồng thời bỏ qua file `.qcv-tmp`.
6. `restore_latest_batch()` là **bản song sinh chưa vá** của `restore_all_from_backup()` (copy thẳng, xoá cờ optimized, không xếp hàng rebuild) mà vẫn gắn nút sống → cho chuyển tiếp sang bản an toàn.

**Why:** backup mà có thể bị ghi đè bởi sản phẩm lỗi của lần trước thì không còn là backup — nút "Khôi phục" trả về đúng ảnh hỏng.

**How to apply:** mọi thao tác ghi ảnh trong plugin phải dùng `image_file_complete()` + tmp/rename; khi nhân đôi một hàm nguy hiểm, cho bản cũ chuyển tiếp thay vì giữ hai bản rồi vá lệch nhau.
