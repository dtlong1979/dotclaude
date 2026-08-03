---
name: qcv-zip-dong-goi
description: "Đóng gói ZIP plugin WP phải dùng PHP ZipArchive (dấu /), KHÔNG dùng PowerShell Compress-Archive (dấu \\ làm hỏng giải nén trên Linux)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9f34285f-7927-41e5-81c6-4c1b9e1b5527
---

Khi đóng gói ZIP plugin/theme WordPress để cài lên máy chủ Linux (các project QCV — xem [[qcv_origin_optimizer]]), **KHÔNG dùng `Compress-Archive` của PowerShell**: nó ghi tên entry bằng dấu `\` (sai chuẩn ZIP). Trên Linux, `\` bị hiểu là ký tự trong tên file chứ không phải phân cách thư mục → giải nén hỏng, plugin không cài được. Người dùng gặp lỗi này ở 0.1.99 và báo "file báo lỗi vì dùng sai dấu \ /".

**How to apply:** đóng gói bằng PHP ZipArchive, ép mọi tên entry sang dấu `/`:
```php
$that = str_replace( "\\", '/', $item->getPathname() );
$trong_zip = substr( $that, $len ); // relative, forward slash
$zip->addFile( $that, $trong_zip );
```
Rồi kiểm lại: duyệt `getNameIndex()`, không entry nào được chứa `\`. Xác minh bằng `unzip -l` (công cụ Unix) chứ đừng chỉ tin ZipArchive của Windows. Script mẫu: scratchpad/dong-goi.php.

**Why:** ZipArchive luôn ghi dấu `/` đúng chuẩn; Compress-Archive trên Windows PowerShell 5.x thì không.

Bẫy kèm theo: heredoc trong Bash tool **nuốt dấu `\`** (`"\\"` thành `"\"`), gây parse error PHP — viết script có backslash bằng Write tool, đừng dùng heredoc.
