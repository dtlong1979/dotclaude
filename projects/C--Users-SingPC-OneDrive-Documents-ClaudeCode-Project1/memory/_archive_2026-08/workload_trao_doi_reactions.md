---
name: workload_trao_doi_reactions
description: "workload Trao đổi thêm reactions 5 loại, vote/poll, sửa+xóa 24h, thông báo bất biến; web+app đã deploy"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-31T10:04:47.213Z
---

Nâng cấp phần Trao đổi (feed) của workload. Liên quan [[workload_app]] [[app_workload_bridge]].

**DB (db.py SCHEMA + migration, tự tạo khi init_db):**
- `post_reactions(post_id,user_id,loai,PK(post_id,user_id))` — thay post_likes; migrate 1 lần likes→reactions loai='like'.
- `post_polls(id,post_id,question,multi)` + `poll_options(id,poll_id,text,ord)` + `poll_votes(poll_id,option_id,user_id,PK(option_id,user_id))`.
- cột `post_comments.updated_at` (đánh dấu đã sửa).

**Reactions:** 5 loại `like 👍 · love ❤️ · agree ✅ · haha 😂 · sad 😢` (agree = xác nhận đồng ý công việc). Hằng `REACTIONS`/`REACTION_LABELS` ở app.py. Mỗi người 1 loại/bài (bấm lại = bỏ).

**Sửa/xóa (app.py `can_edit_post` + `_within_hours`, FORUM_EDIT_HOURS=24):** tác giả sửa/xóa bài+bình luận trong 24h; admin xóa mọi lúc. **Thông báo (kind=thong_bao) BẤT BIẾN** — không ai sửa/xóa/thu hồi ("gửi nhầm là chịu"). Xóa bình luận kéo theo trả lời con.

**Routes web (app.py):** /trao-doi/react, /vote, /sua, /comment/sua; /xoa + /comment/xoa siết 24h + chặn thông báo; forum_create nhận poll_q/poll_opts/poll_multi (`_create_poll`). forum_view truyền react_counts/my_react/polls_by/can_edit. Template forum.html: thanh reactions, poll bar (fill %), nút sửa (details), ô tạo poll trong composer.

**App (2 lớp):** workload app_api.py endpoints `/api/app/feed/{id}/react|edit|delete`, `/feed/vote`, `/feed/comment/{id}/edit|delete`; api_feed trả reactions/react_total/my_reaction/poll/can_edit/can_delete + per-comment can_edit/can_delete + me_id. Gateway hou-cntt `api/routes/workload.py` proxy các route đó. Dart: workload_api.dart (react/vote/editPost/deletePost/editComment/deleteComment/post+poll); _FeedTab (`_reactionBar`,`_pollBox`, PopupMenu sửa/xóa bài, `_cmtAction` sửa/xóa bình luận, poll trong `_newPost`).

Trạng thái: web + backend + gateway ĐÃ DEPLOY (4 bảng verify OK). App CHỜ build/cài (đang build x86_64). WS phase1 vẫn chờ user bật nginx [[fithou_websocket_realtime]].

**Cập nhật sau (UI + ảnh + poll):**
- **Composer app** đổi từ AlertDialog nhỏ → **bottom sheet lớn** (`_composerSheet` heightFactor, drag handle, header icon, nút gửi bo tròn, `validate` inline giữ nội dung). `_deco` = ô nền mềm bo tròn.
- **Poll composer**: toggle **Bài viết/Bình chọn** (poll ẩn ô nội dung); ô lựa chọn ĐỘNG (tự thêm khi gõ ô cuối, nút xóa/thêm). Bài poll gửi content=câu hỏi; `_pollBox`(app)+forum.html bỏ lặp câu hỏi khi ==content.
- **Ảnh trong Trao đổi** (bài + bình luận): cột `posts.image`/`post_comments.image`; lưu qua `_save_upload` (storage workload), phục vụ CÔNG KHAI `/trao-doi/anh/{stored}`. Web: form multipart + `<img class=fimg>`. App: upload qua gateway `POST /gv/workload/upload` (`wl.call_upload` multipart) → tên file → gắn `image` vào feed create/comment; api_feed trả URL tuyệt đối (WORKLOAD_PUBLIC_URL=canbo.fit.hou.edu.vn); `_feedImage`+`_viewImage` (xem full). Đã verify upload+serve 200.
- **Chat hou-cntt** (khác workload): ô nhập có nút emoji 😊 (bảng ~64 emoji) + ảnh 📷 ngay trong pill [[fithou_messaging_consistency]].
