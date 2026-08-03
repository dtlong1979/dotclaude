---
name: fithou_messaging_consistency
description: "Rà soát đồng nhất tin nhắn/trao đổi 3 hệ FithouOne; đã căn chỉnh reactions/broadcast/security, còn nợ refactor onclick web-admin"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-31T08:14:01.794Z
---

Rà soát chéo tin nhắn/trao đổi: **hou-cntt chat** (tin nhắn 1-1/nhóm thật), **workload trao đổi** (diễn đàn threaded), **fithouOne website** (KHÔNG có messaging — CMS 1 chiều, đẩy thông báo sang hub fire-and-forget từ script import-fithou-newest.mjs). Liên quan [[fithou_websocket_realtime]] [[workload_trao_doi_reactions]].

**Đã căn chỉnh (deploy):**
- **Reactions chat hou-cntt → 5 loại** (like/love/agree/haha/sad) như workload. `phan_ung.loai` (đã có sẵn). Backend: `chat.set_reaction` (thay toggle_like, ON CONFLICT DO UPDATE), route `POST /chat/{cid}/messages/{mid}/react` (loai form), `/like` giữ làm alias; `get_messages` trả `reactions`(json_object_agg), `toi_reaction`. App chat_thread_screen: hàng 5 emoji trong action sheet + `_reactEmojisFor` trên bong bóng. Const `_kReactEmoji`.
- **admin.py create_noti → hub.broadcast({"type":"thong_bao"})** — thông báo do admin/GV tạo cũng real-time (trước chỉ website /internal/push broadcast).
- **hou-cntt security headers + CSP** (trước KHÔNG có gì): middleware `security_headers` ở main.py — X-Frame DENY, nosniff, Referrer same-origin, Permissions-Policy, COOP, HSTS(prod), CSP. CSP `connect-src` mở api/wss fit.hou.edu.vn.

**Khác biệt GIỮ NGUYÊN (hợp lý, user chốt):** chat = thu hồi mềm (SV ≤3h, GV/cán bộ vô hạn, cột thu_hoi) vs workload = xóa cứng (24h/admin). Chat không có edit (recall thay thế) vs workload có edit 24h.

**CÒN NỢ — refactor onclick web-admin để siết CSP:** CSP hou-cntt hiện `script-src 'self' 'unsafe-inline'` (TẠM) vì web-admin/app.js có 110 inline handler (96 onclick+8 onchange+2 oninput+4 onkeydown), nhiều cái dùng `this.value`/`this`/`event`, vướng dual-escaping. Muốn ngang workload (`script-src 'self'` không unsafe-inline) phải chuyển hết sang event delegation (data-act/data-args + token $value/$this/$event) rồi bỏ 'unsafe-inline'. XSS hiện đã được `esc()` chặn ở nguồn nên rủi ro còn lại thấp. Chưa làm (rủi ro hồi quy, cần click-test UI admin).

**fithouOne:** CSP next.config.ts `connect-src 'self' https:` THIẾU `wss:` — nếu sau nối hub WS phải thêm (chưa làm, chưa có WS client). Thông báo website→hub là 1 chiều.

Nhất quán sẵn có: WS hub duy nhất (JWT app + wl-token HMAC workload web); push privacy chung chung mọi nơi; xóa không mồ côi (chat=DB CASCADE, workload=CTE đệ quy); escape XSS 2 nơi.
