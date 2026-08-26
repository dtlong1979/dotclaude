---
name: fithou_websocket_realtime
description: "Lớp real-time WebSocket cho FithouOne (hub ở hou-cntt); Pha 1 LIVE — nginx 2 tầng đã bật, verify 101 + online_users OK"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-31T12:19:00.472Z
---

Nâng cấp real-time toàn FithouOne bằng WebSocket, thay polling. Kiến trúc: **1 hub duy nhất ở hou-cntt-api** (`/api/ws?token=<JWT>`), app mở 1 kết nối WS, các phân hệ đẩy sự kiện qua hub. Liên quan [[app_workload_bridge]].

**Backend (hou-cntt, ĐÃ DEPLOY):**
- `services/ws_hub.py` = `ConnectionManager` in-memory (dict username→set[WebSocket]), `hub.send_to(usernames, payload)`.
- `api/routes/ws.py` = endpoint `/ws` (auth JWT query param → username, accept, add vào hub, ping→pong) + `/ws-health` (GET, đếm online_users, để verify).
- `main.py` include ws.router.
- `chat.py` send route: `bg.add_task(hub.send_to, members, {"type":"chat","cid",...})` — mọi thành viên hội thoại.
- `internal.py` /workload-push: sau FCM còn `hub.send_to(usernames, {"type":"workload","loai"})` (map ma_cb→username qua tai_khoan).
- **QUAN TRỌNG:** Dockerfile đổi `-w 3` → **`-w 1`** vì hub in-memory theo tiến-trình; nhiều worker sẽ tách hub, tin không giao chéo worker. 1 worker async + threadpool đủ cho quy mô Khoa. Muốn scale lớn → Redis pub/sub rồi mới tăng worker.

**App (hou-cntt/mobile, ĐÃ BUILD+CÀI x86_64):**
- `core/ws_service.dart` = `WsService` singleton, 1 kết nối `wss://api.fit.hou.edu.vn/api/ws?token`, broadcast Stream `events`, tự reconnect backoff 2→30s, ping 30s. **Fallback im lặng**: WS lỗi → màn hình vẫn poll như cũ.
- `auth.dart`: start(token) khi login/load, stop() khi logout.
- `chat_thread_screen.dart` + `chat_list_screen.dart`: nghe events type=="chat" → `_load()`. `workload_home.dart`: type=="workload" → `_refreshTab(loai)`. Poll cũ giữ làm dự phòng.

**NGINX ĐÃ BẬT (2026-07-31):** cả 1.2 (IT) + 1.20 (user) đã cấu hình Upgrade. Verify LIVE: GET thường→404, WS+token sai→403, WS+token đúng→**101**, `online_users` 0→1→0. WS Pha 1 chạy thật.

**Lịch sử cấu hình (cần sudo):** bật nginx WS ở CẢ 2 tầng.
- Server 1.20: đã đặt sẵn `/home/fitadm/fithouone.conf.new` (thêm `location /api/ws` với proxy_http_version 1.1 + Upgrade/Connection + read_timeout 3600s). Áp: `sudo cp ~/fithouone.conf.new /etc/nginx/conf.d/fithouone.conf && sudo nginx -t && sudo systemctl reload nginx`.
- Front nginx 1.2 (tôi KHÔNG với tới): location proxy api.fit.hou.edu.vn cần thêm `proxy_http_version 1.1; Upgrade $http_upgrade; Connection "upgrade";`.
- Verify: `curl https://api.fit.hou.edu.vn/api/ws-health` → online_users tăng khi app mở. WS handshake là HTTP/1.1 Upgrade (chỉ hop nginx→backend), KHÔNG ảnh hưởng HTTP/2 cho trang.

**Pha 2 (ĐÃ LÀM + verify):**
- **Workload web (Jinja) real-time**: trình duyệt workload nối hub bằng token HMAC ngắn hạn `ma_cb.exp.sig` (ký bằng WORKLOAD_APP_SERVICE_TOKEN). Workload `/trao-doi/ws-token` cấp `{ws_url}` (env HUB_WS_URL mặc định wss://api.fit.hou.edu.vn/api/ws). Hub ws.py thêm nhánh `?wl=` → verify HMAC → ma_cb→username hou-cntt (tai_khoan) → nối hub CHUNG (nhận đúng event type "workload"). forum.html mở WS, onmessage→ping() ngay (poll 10s làm fallback). Verify: wl-token → hub 101 + online_users=1.
- **Thông báo website FithouOne → app tức thời**: `hub.broadcast(payload)` (gửi mọi kết nối) trong ws_hub; internal.py `/push` (website đăng thông báo) `bg.add_task(hub.broadcast, {"type":"thong_bao"})`; app dashboard SV nghe type "thong_bao" → `_refreshNoti()`. (broadcast chỉ báo tín hiệu, không kèm dữ liệu.)

**LỖI REGRESSION (2026-07-31, ĐÃ VÁ + deploy):** `internal.py::workload_push` gọi `db.execute(...)` để map ma_cb→username NHƯNG THIẾU `db: Session = Depends(get_db)` ở chữ ký → mỗi lần workload đẩy sự kiện đều **NameError → HTTP 500** → cả WS `send_to` LẪN FCM (bg task) đều không chạy → real-time Công việc chết, chỉ còn poll 8s (nên "nhắn xong 1 lúc sau mới thấy", off-tab không có gì). Vá: thêm `db=Depends(get_db)`. Verify sau rebuild: POST /api/internal/workload-push (token đúng, ma_cb giả) → **HTTP 200** `{ok,queued,loai}` (trước là 500). **Bài học: FastAPI route dùng `db` PHẢI khai báo Depends(get_db) — thiếu là NameError, nuốt luôn bg task vì raise trước khi trả response.**

**App badge/tự-đọc (workload_home.dart, ĐÃ BUILD+CÀI):** thêm chấm đỏ (`Badge isLabelVisible`) trên tab Thông báo + Trao đổi khi có WS event lúc đang ở tab khác (`_newNotif/_newFeed`); khởi động lấy `me().counts.unread_notifications>0` để hiện sẵn; `_select(i)` mở tab là **nạp lại ngay** (hết "1 lúc sau" do chờ poll) + xóa chấm đỏ; mở Thông báo tự gọi `_NotifTabState._markSeen()` = readAllNotifications() trên server + đổi hiển thị sang đã đọc TẠI CHỖ (giữ danh sách, không xóa) → chấm đỏ tự mất, không phải bấm từng cái.

**Web workload `/thong-bao` tự-đọc-khi-vào (2026-07-31):** `notifications_page` lấy notes RỒI `UPDATE is_read=1 WHERE user_id AND is_read=0` + commit + `unread=0` → chuông (`unread_notif_count` render base.html sau đó) về 0, số thông báo hết; notes lần xem này vẫn giữ kiểu "unread" để dễ nhận. (Yêu cầu: vào trang = coi như đọc hết.)

**App composer thống nhất:** trích `composerSheet(context,{icon,title,sendLabel,body,heightFactor,validate})` + `composerDeco(context,{hint,label})` thành HÀM TOP-LEVEL trong workload_home.dart; `_FeedTabState._composerSheet/_deco` giờ chỉ gọi lại. Dialog "Báo cáo cuối ngày" (`_DiaryTabState._dailyReport`) đổi từ AlertDialog xấu → bottom sheet cùng phong cách (icon assignment_turned_in, ô mềm bo tròn).

**Còn có thể làm tiếp:** unread/danh sách chat live sâu hơn; workload web nhận cả tin chat; gộp badge chat vào nút switch GvRootShell.
