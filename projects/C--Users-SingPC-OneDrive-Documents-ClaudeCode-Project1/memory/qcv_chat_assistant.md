---
name: qcv-chat-assistant
description: "Plugin Trợ lý ảo (chat bubble) cho website QCV Origin — themes/FAQ Excel/LLM/lead detection, chạy độc lập không đụng theme"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9f34285f-7927-41e5-81c6-4c1b9e1b5527
  modified: 2026-08-06T09:31:11.103Z
---

Plugin **`qcv-chat-assistant`** ("QCV Trợ lý ảo") **v1.4.0** — chat bubble cho site sinh từ lõi QCV Origin. Mã ở `D:\xampp74\htdocs\qcv-origin\wp-content\plugins\qcv-chat-assistant\`, ZIP giao hàng ở `D:\dev\qcv-chat-assistant\qcv-chat-assistant-1.4.0.zip`. Liên quan [[qcv_origin_optimizer]], [[qcv_web_project]]. ~6.100 dòng, không composer/thư viện ngoài/jQuery frontend. Đóng gói bằng ZipArchive dấu `/` (xem [[qcv_zip_dong_goi]]).

**v1.4 — VÁ BẢO MẬT AI/injection (user yêu cầu "vá ngay", 06/08/2026)**. Audit độc lập (security-specialist) xác nhận SQLi/XSS/CSRF/nonce/email-header/Telegram-HTML đã an toàn sẵn; history LƯU SERVER-SIDE (không giả mạo hội thoại được) và output AI đã `esc_html`→`wp_kses_post` (kín XSS). Đã vá:
- **Prompt-injection hardening** (`class-qcv-chat-llm.php::build_system_prompt`): thêm "NGUYÊN TẮC AN TOÀN" (coi input khách là DỮ LIỆU không phải lệnh; chặn bỏ-qua-chỉ-dẫn/đóng vai/giả định/DAN/giả danh admin/né bằng ngoại ngữ-base64); "BẢO MẬT CHỈ DẪN" (cấm lộ system prompt); rào dữ liệu biz_info/FAQ trong `<thong_tin_doanh_nghiep>`/`<tai_lieu_faq>`. **Chốt chặn đầu ra** `looks_like_prompt_leak()`: nếu model nhả nguyên văn dấu mốc nội bộ → trả từ chối (chống dump prompt).
- **[CAO] `client_ip()` (`class-qcv-chat-store.php`)**: trước LUÔN tin `X-Forwarded-For`/`X-Real-IP` → gọi thẳng origin đổi header mỗi request = né sạch rate-limit → đốt tiền LLM + dội mail/Telegram + đầu độc log. Vá: chỉ đọc header khi REMOTE_ADDR là **proxy nội bộ** (loopback/private — Tadu chạy cùng máy), ngược lại dùng REMOTE_ADDR. Hàm `is_trusted_proxy()` dùng `FILTER_FLAG_NO_PRIV_RANGE|NO_RES_RANGE`.
- **Trần LLM toàn cục/giờ** (`api.php::llm_budget_exceeded`, mặc định 500, filter `qcv_chat_llm_hourly_cap`) — lưới thứ hai chống cost-abuse; vượt trần → lùi về FAQ.
- **[TB] SSRF webhook** (`notify.php`): `wp_remote_post`→**`wp_safe_remote_post`** + `redirection:0` (chặn 169.254.169.254/localhost/nội bộ).
- **[TB] Key LLM nhồi vào DOM admin** (`admin.php`): thôi echo `ai_key`, dùng placeholder + giữ key cũ khi để trống (giống smtp_pass/tg_token).
- **[THẤP]**: cắt `phone` 100 ký tự trước regex ở `/lead`; key Gemini chuyển sang header `x-goog-api-key` (không để trên URL → khỏi lọt access-log); thêm `LIBXML_NONET` cho SimpleXML parse .xlsx.

**Hai bài học WP-security tái dùng** (agent nêu, độ tin cao): (1) plugin có REST public + rate-limit theo IP → PHẢI kiểm hàm lấy IP có tin `X-Forwarded-For`/`X-Real-IP`/`CF-Connecting-IP` mù quáng không, và origin có bị gọi thẳng (bỏ qua CDN) không — nếu có thì rate-limit-theo-IP vô hiệu, kéo theo đốt tiền LLM. (2) plugin gọi HTTP tới URL do người dùng cấu hình → dùng `wp_safe_remote_*` chứ KHÔNG `wp_remote_*` (chỉ bản `safe_` mới qua `wp_http_validate_url` chặn IP nội bộ — trái trực giác "WP tự chặn").

**v1.3 — THƯ VIỆN 10 AVATAR DỰNG SẴN (user yêu cầu)**: 5 nam + 5 nữ, bán thân, người châu Á, PNG 256×256 nền trong, ở `assets/avatars/{nam,nu}-{1..5}.png`, tổng **48KB**. Là **hình vẽ minh hoạ phẳng (flat vector), KHÔNG phải ảnh chụp** — đã nói rõ với user trước khi làm. Sinh bằng **`D:\dev\qcv-chat-assistant\gen_avatars.py`** (Python+Pillow, vẽ ở 4× rồi LANCZOS thu nhỏ để khử răng cưa). Style: nam-1/nu-1 tai nghe tư vấn viên, nam-2 vest+cà vạt, nam-3 áo thun tóc vuốt, nam-4/nu-4 kính, nu-2 bob+vest, nu-3 tóc dài, nam-5/nu-5 **không nền tròn** (hợp chế độ icon_bare).
- **`builtin_avatars()`** liệt kê 10 mã; **`resolve_image()`** đổi `builtin:nam-1` → URL. **Lưu MÃ chứ không lưu URL tuyệt đối** — vì site dựng ở localhost rồi đổi tên miền khi giao khách, URL tuyệt đối sẽ hỏng. `sanitize_image_value()` đối chiếu mã với danh sách thật (chặn nhét bừa đường dẫn) — **`esc_url_raw` XOÁ SẠCH `builtin:xxx`** nên phải tách khỏi `$url_fields`, đây là bẫy dễ dính.
- Admin: `field_media()` = preview (nền ca-rô) + **🖼 Chọn avatar có sẵn** (lưới 10, tick `is-on`) + **Tải ảnh riêng** (wp.media) + Gỡ ảnh. Dùng cho cả icon nút lẫn avatar khung chat.
- `avatarFit`: **cover** chỉ khi khách TỰ TẢI ảnh (ảnh chụp cần cắt đầy khung), **contain** cho avatar dựng sẵn + icon (hình vẽ, cắt là mất đầu).

**BÀI HỌC VẼ AVATAR bằng PIL** (nếu sửa/thêm mẫu):
- **Thứ tự vẽ quyết định tất cả**: tóc-nền → thân → cổ → mặt → mái → ngũ quan → phụ kiện. Vẽ mặt ĐÈ lên tóc → tóc thành "mũ bơi" (lỗi vòng 1). Tóc phải là ellipse LỚN HƠN đầu nằm phía sau, mặt vẽ đè lên chừa viền tóc quanh trán/hai bên.
- **Áo KHÔNG cổ thì cổ phải vẽ TRƯỚC thân**, nếu không khối da đè lên áo (lỗi nam-3/nu-3 vòng 2). Áo CÓ cổ thì cổ vẽ sau thân + trước vạt cổ áo → da lộ trong chữ V, nhìn đúng.
- **Nén bảng màu 128 (`quantize(colors=128, method=FASTOCTREE)`) giảm 74%** (184KB→48KB) mà viền vẫn mượt — ảnh flat ít màu.
- Luôn soi ở **cỡ thật 44px trên nền màu**, không chỉ nhìn 128px.

**v1.2 — ICON ẢNH RIÊNG + hướng dẫn Telegram chi tiết (user yêu cầu)**:
- **Icon**: `field_media()` mở Thư viện WP (`wp_enqueue_media()` + `wp.media` trong admin.js, preview nền ca-rô để thấy vùng trong suốt) thay vì bắt gõ URL. Setting mới: `icon_alt` (chú thích khi di chuột + aria-label) và **`icon_bare`** (bỏ nền nút — PNG hình người đứng riêng đẹp hơn là nhốt trong khối tròn màu; `.is-bare` transparent + drop-shadow trên ảnh). Nút không có chữ → `.qcv-tip` tooltip CSS hiện khi `:hover`/`:focus-visible`, tự lật trái/phải theo `pos-*`, có mũi nhọn. `QCV_Chat_Settings::avatar()` = avatar_url → **fallback về icon_url** → mặc định; `avatarFit` = cover (ảnh chụp) vs **contain** (icon, để không bị cắt).
- **Telegram 4 bước có tick xanh** (`tab_notify_telegram()` + `step()`): bước 1 tạo bot ghi rõ từng câu BotFather hỏi; bước 2 dán token → gọi **`telegram_get_me()`** (cache 1h) xác nhận + hiện **link t.me/<bot> bấm được**; bước 3 hai cột Cách A (cá nhân) / Cách B (nhóm); bước 4 tự lấy Chat ID. **3 bẫy đã ghi rõ trên UI**: (a) trong NHÓM bot không đọc được tin thường → **phải gõ `/start`** (privacy mode), (b) Telegram chỉ giữ update **~24h**, (c) **ID nhóm là số ÂM** đừng xoá dấu trừ. Thông báo lỗi của `telegram_discover_chat_ids` cũng nhắc đủ 3 điều này + link bot.
- **FIX chống nháy (FOUC)**: CSS trong Shadow DOM nạp qua `<link>` là BẤT ĐỒNG BỘ → lần tải đầu khách thấy nút/ảnh trần chưa style. Sửa: `.qcv-root{visibility:hidden}` + JS thêm `.is-ready` khi `link.onload`/`onerror` + timeout 3s làm lưới an toàn. CSS lỗi hoàn toàn → luật ẩn cũng không áp → widget vẫn hiện (thoái lui an toàn).

**v1.1 — NÚT TRỢ LÝ chọn kiểu + vị trí (user yêu cầu để né xung đột nút sẵn có)**: 6 kiểu nút tách riêng khỏi theme khung chat (`launcher_styles()`: circle/pill/**tab**/rounded/outline/soft) + `launcher_color` riêng + `show_pulse` tắt mặc định. Vị trí: `position` (trái/phải) × `vpos` (top/**middle**/bottom). **Mặc định = thanh dọc dính mép, giữa bên phải** — góc dưới là nơi đông đúc (gọi/Zalo/giỏ hàng/lên-đầu-trang/cookie), giữa màn hình luôn trống. `offset_y` nhận SỐ ÂM khi neo giữa (xê dịch so với tâm). Kiến trúc CSS: `.qcv-root` phủ full viewport + `pointer-events:none`; hai `.qcv-anchor` riêng cho nút và khung → vị trí nút không kéo theo vị trí khung; **lớp bọc lo neo, nút lo hover** (nếu để chung, transform hover đè transform canh giữa). Mở khung → ẩn nút (`.is-open .qcv-launcher{opacity:0}`) → hết bài toán khung che nút.
- **BUG đã sửa**: khung chat dùng chung `offset_x` với nút → kiểu tab đặt `offset_x=0` làm khung dính mép và **bị cắt bóng đổ**. Sửa: biến riêng `--qcv-panel-x = max(offsetX, 12)`.
- **Đã đo thật bằng Chrome** (không tin ảnh): nút gap mép 0, tâm nút = tâm viewport (350/350); mở khung → nút opacity 0 + pointer-events none, khung gap 12px, cũng canh giữa.

**v1.1 — 3 KÊNH THÔNG BÁO độc lập** (`class-qcv-chat-notify.php` viết lại; kênh lỗi không ảnh hưởng kênh khác, `lead()` không bao giờ fatal):
1. **Email 2 lựa chọn**: `mail_method=wp` (mặc định, qua `wp_mail()`, tôn trọng plugin SMTP sẵn có — `detect_mail_plugin()` tự nhận diện WP Mail SMTP/Easy WP SMTP/Post SMTP/FluentSMTP và báo trên UI) hoặc `mail_method=smtp` (SMTP riêng). **Cách ly SMTP**: gắn `phpmailer_init` ngay trước gửi + gỡ ngay sau + cờ `$use_own_smtp` chặn kép → mail WooCommerce/plugin khác KHÔNG bị đụng (đã test 3 lượt: other=mail / ours=smtp / other=mail).
2. **Telegram**: `telegram_send()` (HTML parse_mode, nhiều chat_id, cắt 4000 ký tự vì Telegram giới hạn 4096) + **`telegram_discover_chat_ids()` đọc getUpdates tự điền Chat ID** (nhân viên khỏi mò). SĐT để trần trong tin → bấm gọi được.
3. **Webhook**: POST JSON `{phone,name,email,reasons,page_url,transcript[],admin_url,site,time}` + ký **HMAC SHA-256** header `X-QCV-Signature` nếu có `webhook_secret`. Đây là đường nối Zalo/Slack/CRM qua Make/n8n.

**QUYẾT ĐỊNH: KHÔNG làm Zalo OA trực tiếp** (user phân vân, tôi khuyến nghị và user không phản đối). Lý do: Zalo không có bot đơn giản như Telegram — cần OA verify + app developers.zalo.me, access token phải refresh định kỳ (thêm cron + chỗ hỏng trong TỪNG site khách), gửi tin chủ động bị giới hạn chính sách, ZNS tính phí/tin. Webhook để ngỏ đường nối Zalo khi cần mà không bắt mỗi site ôm token. Nếu sau này QCV có OA verify sẵn thì cân nhắc lại.

**Kiến trúc**: 1 option `qcv_chat_settings` + 3 bảng riêng (`wp_qcv_chat_conv/msg/faq`) + `uninstall.php` dọn sạch. Giao diện dựng trong **Shadow DOM** (`#qcv-chat-host`) → CSS theme không lọt vào, CSS widget không rò ra. Chỉ hook `wp_enqueue_scripts`; không thêm class body, không lọc nội dung.

**Hai chế độ trả lời**: (1) kịch bản (nút bấm nhanh) + FAQ Excel — `class-qcv-chat-faq.php` đọc .xlsx bằng **ZipArchive+SimpleXML tự viết** (sharedStrings + sheet đầu theo workbook.xml.rels, xử lý inlineStr/ô trống/BOM CSV), `class-qcv-chat-matcher.php` chấm điểm **IDF + thưởng khớp cụm + phạt coverage**, 2 ngưỡng: ≥answer_threshold(0.62) trả thẳng, ≥suggest_threshold(0.35) hỏi lại "có phải bạn muốn hỏi"; (2) LLM Gemini/OpenAI/Claude qua `wp_remote_post` — key chỉ ở server. Prompt hệ thống cài cứng 3 hàng rào: giới hạn chủ đề (chống đóng vai/giả admin), hội tụ về xin SĐT, cấm bịa ngoài `biz_info`+FAQ. **AI lỗi → tự lùi về FAQ/kịch bản.**

**Lead detection** (`class-qcv-chat-detect.php`): SĐT VN (0/+84/84, chấp nhận "0912 345 678" nhờ regex nén khoảng trắng giữa chữ số, chuẩn hoá về 0xxxxxxxxx), email, tên (chỉ khi khách nói rõ "mình tên là"), ý định đặt hàng (~24 từ khoá). Trúng → flag cuộc chat (tô vàng + đếm ở menu) + email `wp_mail` kèm transcript. Đã verify: bắt đúng +84→0, KHÔNG bắt nhầm "12345".

**BÀI HỌC KỸ THUẬT (3 bug đã gặp và sửa)**:
1. **`wp_enqueue_script` trong `wp_footer` priority 99 = script KHÔNG BAO GIỜ in ra** — WP in script footer ở `wp_footer` priority 20. Phải enqueue ở `wp_enqueue_scripts`. Triệu chứng: HTTP 200, không lỗi, nhưng grep không thấy widget.
2. **Page cache `qcv-origin-optimizer` che mọi thay đổi** (`X-QCV-Origin-Cache: HIT`). Cấu hình widget inline trong HTML nên PHẢI xả cache — đã nối `QCV_Origin_Optimizer_Cache::clear()` (+ WP Rocket/W3TC/LiteSpeed) vào `Settings::clear_page_caches()`, gọi khi save/activate/deactivate.
3. **Form lồng form** ở tab FAQ (cần enctype upload) — HTML không cho phép. Tab FAQ render NGOÀI form cài đặt.

**Không dùng nonce cho REST công khai** (page cache làm nonce hết hạn → chặn nhầm khách thật). Thay bằng: rate-limit theo IP (transient, mặc định 20 tin/phút) + honeypot `website` + cap 2000 ký tự.

**Đã verify thật trên localhost/qcv-origin**: lint 0 lỗi, 5 tab admin + lịch sử render sạch (form mở/đóng khớp), nhập .xlsx thật (openpyxl tạo) đọc đúng tiếng Việt + bỏ dòng trống/thiếu, so khớp không dấu ("tra gop"→"trả góp" 1.21đ), REST /message 3 luồng OK, email dựng đúng, screenshot Chrome headless xác nhận giao diện. Khách vừa cho số → bot cảm ơn (setting `phone_thanks`) thay vì xin số tiếp — bug UX đã sửa.

**Lưu ý deploy**: theme QCV thường đã có nút gọi/Zalo nổi → v1.1 giải bằng kiểu "thanh dọc + giữa bên phải" mặc định (đã verify: giỏ hàng theme ở góc dưới, nút trợ lý ở giữa, không chạm nhau).

**MẸO TEST TRÌNH DUYỆT (quan trọng, tiết kiệm nhiều thời gian)**:
- **Browser pane MCP treo** với trang Megastore nặng (timeout 30s ×2) → dùng Chrome headless: `/c/Program Files/Google/Chrome/Application/chrome.exe --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=9000 --window-size=1280,800 --screenshot=out.png URL`.
- **Ảnh chụp bị "mờ đục" = Chrome đóng băng hiệu ứng CSS giữa chừng**, KHÔNG phải lỗi code. Thêm **`--force-prefers-reduced-motion`** để tắt animation → ảnh và số đo mới đúng (plugin đã có sẵn `@media (prefers-reduced-motion)` tắt animation).
- **Đo số thật thay vì nhìn ảnh**: trang test chạy JS ghi `getBoundingClientRect()`/`getComputedStyle()` vào `<div id="qcv-test-out">`, rồi `--dump-dom | grep`. Cách này phát hiện đúng bug lệch vị trí mà mắt không thấy.
- **`wp_mail` trên XAMPP local LUÔN fail**: `Invalid address: (From): wordpress@localhost` (PHPMailer từ chối domain không TLD) và fail TRƯỚC `phpmailer_init` nên hook không chạy → tưởng code sai. Test bằng cách `add_filter('wp_mail_from', fn => 'x@tenmien-that.vn', 1)` giả lập production, hoặc chặn `pre_wp_mail` để xem nội dung.
- **Đo `getComputedStyle` của thuộc tính CÓ transition sẽ ra giá trị SAI** nếu không tắt animation (virtual time đóng băng giữa chừng): tooltip đo ra `opacity:1` trong khi CSS ghi 0. Dấu hiệu nhận biết: thuộc tính KHÔNG transition (vd `visibility`) thì đúng, thuộc tính CÓ transition thì sai. Luôn `--force-prefers-reduced-motion` + đảm bảo media query reduced-motion có tắt transition của chính thứ đang đo.
- **Ép hiện tooltip để chụp ảnh**: chèn `<style>` vào `shadowRoot` với `.qcv-tip{opacity:1!important;visibility:visible!important}` — không mô phỏng được `:hover` trong headless.
- **Python/PIL trên Windows KHÔNG hiểu path `/d/...`** của MSYS → `FileNotFoundError`. Phải dùng `D:/...`.
- `rm -rf` bị permission chặn → dùng `rm -f` từng file + `rmdir`.
