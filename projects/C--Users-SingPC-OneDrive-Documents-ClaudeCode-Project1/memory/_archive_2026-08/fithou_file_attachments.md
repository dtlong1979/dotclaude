---
name: fithou_file_attachments
description: Đính kèm TỆP (pdf/office/zip…) chứ không chỉ ảnh ở chat + Trao đổi/Góp ý/Thông báo (app + workload web); backend đã sẵn allow-list
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-31T14:00:28.311Z
---

Mở rộng đính kèm từ CHỈ ẢNH sang TỆP bất kỳ (pdf/office/txt/zip…) ở mọi chỗ nhắn tin. Liên quan [[workload_trao_doi_reactions]] [[fithou_websocket_realtime]].

**Khảo sát (2026-07-31): backend phần lớn ĐÃ sẵn sàng cho tệp:**
- hou-cntt backend `core/uploads.py` allow-list đã gồm pdf/office/txt/csv/zip/rar, MAX 25MB; `/chat/upload` + `/admin/upload` nhận tài liệu OK từ trước. App chat RENDER đã có nhánh tải-tệp cho non-image — chỉ THIẾU picker.
- web-admin (thông báo + chat) đã có input file → xong.
- **FithouOne**: KHÔNG có nhắn tin user↔user; chỗ đính kèm duy nhất là editor bài viết/thông báo, đã cho pdf/office (45MB) → không cần sửa.

**Đã làm (2026-07-31, deploy + build):**
- **workload** (lưu bất kỳ đuôi từ trước, nhưng UI chỉ render `<img>`): thêm cột `posts.file_name` + `post_comments.file_name` (tên gốc); `_save_upload(f, allowed=None)` — allow-list OPT-IN (chỉ forum/chat truyền `ALLOWED_UPLOAD_EXT`, các nơi khác avatar/minh chứng GIỮ không giới hạn để không vỡ), trả `(stored,size,original_name)`, MAX 25MB. `is_image_name()` phân biệt ảnh/tệp. Route `/trao-doi/anh/{stored}?ten=` → serve_file tải về đúng tên gốc (ảnh vẫn inline). `_forum_file_url`. Template forum.html: ảnh→`<img>`, tệp→`<a class="ffile">📎 tên</a>`; composer input `accept` mở rộng ảnh+tài liệu. CSS `.ffile`. app_api feed serialize thêm `file_url`+`file_name` (helper `_attach_fields`); create post/comment nhận `file_name`.
- **gateway** hou-cntt `workload.py wl_upload`: cap 15MB→**25MB**, tên generic.
- **app** (`hou-cntt/mobile`): thêm dep `file_picker: ^10.3.2` (10.3.10) + phải bump `android/app/build.gradle.kts` **compileSdk >= 36** (flutter_plugin_android_lifecycle yêu cầu; file_picker 8.x compiled 34 → lỗi AAR). Chat `chat_thread_screen.dart`: thêm mục menu "Gửi tệp" `_attachFile()` (file_picker→/chat/upload). Workload `workload_home.dart`: `_pickAnyFile()`, `_attachRow` (2 nút Ảnh/Tệp, chip tên tệp), `uploadAttachment()` trả `(image,name)`, `post/feedComment(fileName)`, render `_feedFile()` (mở url_launcher external) cho `file_url`.

**Verify prod:** `_save_upload` .pdf nhận (bắt tên gốc) / .exe chặn; is_image_name đúng; _forum_file_url encode tên. 2 container rebuild, cột file_name có thật. APK build+cài OK.
