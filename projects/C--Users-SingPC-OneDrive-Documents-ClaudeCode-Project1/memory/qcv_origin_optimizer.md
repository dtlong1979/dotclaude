---
name: qcv-origin-optimizer
description: Plugin tối ưu WordPress cho site sinh từ QCV Origin; đánh giá + chẩn đoán performance webtrongoi.vn
metadata: 
  node_type: memory
  type: project
  originSessionId: 4b0af563-fb62-45a4-acd8-6d775c9461f8
---

Plugin `qcv-origin-optimizer` (v0.1.57, ~8.400 dòng/13 file PHP) tối ưu tốc độ/bảo mật/SEO/AI cho website sinh từ lõi QCV Origin, mã ở `C:\Users\SingPC\Documents\Codex\2026-06-22\d-qcv-qcv-web\outputs\qcv-origin-optimizer\`. Liên quan [[qcv_web_project]].

Lõi `D:\xampp74\htdocs\qcv-origin`: theme **megastore** + js_composer (WPBakery) + revslider + WooCommerce + đã bundle sẵn **WP Rocket** + Yoast Premium. Site mẫu: `D:\xampp74\htdocs\mauXX`.

Đánh giá 2026-07-03 (đã xuất `outputs\qcv-origin-optimizer-danh-gia-va-toi-uu-performance.md`):
- Kiến trúc tốt (module theo mức rủi ro safe/advanced/experimental, restore point, batch cron). Resource-optimizer là module mạnh nhất (async CSS, localize Google Fonts, defer, preload LCP, CLS guard, WebP responsive).
- **Vì sao Performance mobile vẫn ~50:** HTML live webtrongoi có 0 ảnh .webp / 130 JPG-PNG, LCP là JPEG banner ~2000px, 24 CSS render-blocking, Google Fonts chưa localize, .htaccess chưa có khối static-cache. Tức các module nặng (static_cache, webp_delivery, image_optimize, resource_advanced) chưa bật/chưa ăn. TBT chỉ 40ms nên CPU không phải vấn đề — nút thắt là mạng + render-blocking + LCP ảnh.
- **Ưu tiên fix:** (A) bật+verify browser-cache tĩnh (insight lớn nhất ~3.7MB), (B) bật WebP thật + preload bản WebP cho banner LCP, (C) localize Google Fonts, (D) Critical CSS above-the-fold + hoãn CSS lớn.
- **Bảo mật cần sửa:** `qcv-origin-optimizer.php:105` hardcode `agentic_gateway_token` (lộ trong mọi zip) + 4 mã kích hoạt plaintext dòng 21-33.

**Quan trọng:** webtrongoi.vn chạy bản **site-specific `webtrongoi-optimizer`** làm chính (dấu vết `qcv-webtrongoi-*`), generic chỉ phụ → fix ở generic phải nhân bản sang bản site-specific thì webtrongoi mới hưởng.

## Cập nhật 2026-07-16 — BUG BUILDER: WPBakery không mở được (bản 0.1.73-builderfix)
User báo "không vào được builder". Soi mã **bản master 0.1.72** (`Codex\2026-06-22\d-qcv-qcv-web\outputs\qcv-origin-optimizer\`): grep `vc_editable|elementor|builder` = **0 kết quả — không có guard builder nào**. Gốc rễ: **trình dựng trang chạy trên URL FRONTEND** (`/?vc_editable=true&vc_post_id=N`) chứ không phải wp-admin → `is_admin()` KHÔNG che được. Điểm lộ tẩy: `start_html_minify()` có `is_user_logged_in()` nhưng hàm anh em ngay cạnh `start_structure_output()` **thiếu** → ob_start nhào nặn HTML ngay trong builder; cộng `async_non_critical_styles`/`defer_safe_scripts`/`delay_low_priority_scripts` chỉ check `is_admin()`. `class-cache.php:46` thì VÔ CAN (đã guard đủ `is_user_logged_in` + bỏ qua mọi `$_GET`).

**FIX (0.1.73-builderfix)**: thêm `QCV_Origin_Optimizer::is_builder_context()` ở class chính — **chỉ đọc `$_GET`** (không dùng `is_preview()`/`is_customize_preview()` vì init() chạy lúc `$wp_query`/`$wp_customize` chưa có → sai hoặc `_doing_it_wrong`), có cache tĩnh, nhận diện WPBakery/Elementor/Beaver/Divi/Oxygen/Brizy/Thrive/SiteOrigin/Bricks + Customizer + preview. Chặn **ở chỗ ĐĂNG KÝ HOOK** chứ không vá từng hàm (tránh sót — có tận 4 filter nguy hiểm): `Resource_Optimizer::init()` return sớm; `SEO_AI::start_primary_seo_fallback()` (ob_start thứ 2, template_redirect 997) thêm vào guard; `Image_Optimizer::init()` chỉ bỏ 2 filter đổi HTML, **GIỮ** `wp_generate_attachment_metadata` để upload ảnh trong builder vẫn được tối ưu.

**Đã kiểm chứng bằng harness** (`scratchpad/test_builder_guard.php` — nạp mã THẬT với hàm WP giả lập, đếm hook): trang thường = 16 hook Resource + 4 Image; trong builder = **0 hook từ init()**, không còn `template_redirect`/`script_loader_tag`/`style_loader_tag`/`the_content`. Test logic 12 ca: `?p=12`, `?s=`, `?paged=2`, `?utm_source=` KHÔNG bị nhận nhầm là builder. ZIP: `outputs\qcv-origin-optimizer-0.1.73-builderfix.zip` (15 file, 90.5KB).

**PHÁT HIỆN QUAN TRỌNG — bản nền cục bộ lệch pha nặng**: `D:\xampp74\htdocs\qcv-origin` đang chạy optimizer **0.1.0 (523 dòng, 25/6)** trong khi master là 2286 dòng — **thiếu TẤT CẢ bản vá**: OPTIMIZED_MARKER, inject_async_css_fallback, no-cache HTML, is_builder_context. Nghĩa là **mọi site clone từ qcv-origin sẽ mang optimizer 0.1.0 dính đủ 7 lớp bug cũ**. Cần đồng bộ master → bản nền. (Suýt chẩn đoán nhầm vì lần đầu soi vào bản 0.1.0 này thay vì master.)

## Cập nhật 2026-07-03 (chiều) — nâng cấp generic trên mau21.thuvienwebqcv.vn
Các site mẫu thật ở server DirectAdmin `http://103.179.173.247:4444/` (admin/D7qfX52q79tYJF4S → Login as mauXX). Site sau Tadu WAF, HTTP (không SSL), cache tĩnh **đã ăn** (max-age 1 năm). Nhiều plugin nặng (WP Rocket, Yoast, YITH, use-your-drive...).

Đã build tới **0.1.62** (`outputs\qcv-origin-optimizer-0.1.62.zip`, đã deploy 0.1.61 lên mau21, kết quả tốt: Desktop 60→94, Mobile 60→76, **LCP mobile 19.5s→4.1s**). Các cải tiến tổng quát đã thêm:
- **WebP on-demand** (sinh khi giao ảnh/preload, không phụ thuộc batch) + preload LCP khớp đúng width → fix LCP banner PNG 1.16MB.
- **Fatal batch ảnh** (khi bấm Xanh/Vàng) do process bị kill (timeout/OOM, KHÔNG ghi được PHP fatal) → fix bằng **time-budget thích ứng max_execution_time + memory guard (gd_has_memory_for) + set_time_limit + try/catch từng ảnh**.
- **Cache-conflict guard** (`class-cache.php::guard_cache_conflicts`, admin_init, 1 lần/giờ): tự deactivate plugin cache trùng (WP Rocket/W3TC/LiteSpeed...) + đổi tên drop-in `advanced-cache.php`/`object-cache.php` lỗi/ngoại lai (regex `/home/USER/domains/DOMAIN/` không khớp ABSPATH) thành `.qcv-disabled`. Đã dọn WP Rocket clone lỗi (trỏ path `/home/demoqcv/domains/demo.einfo.vn/`).
- **async CSS `media=print`** (ưu tiên thấp, đỡ tranh băng thông mobile).
- **self_http_get** loopback: warm/self-request fallback qua 127.0.0.1 + Host header khi tên miền công khai không tự resolve (lỗi `cURL 28 Resolving timed out` sau WAF).

## Cập nhật 2026-07-03 (chiều muộn) — HTTPS + HTTP/2 cho mau21
Nút thắt mobile thật = **37 CSS chặn render / 219KB gzip trên HTTP/1.1** (theme megastore+WPBakery+Woo). Giải bằng hạ tầng thay vì code: **đã cấp Let's Encrypt** (DirectAdmin → SSL → LE, chỉ domain chính để chắc thành công) + **Force SSL redirect** + thêm `WP_HOME/WP_SITEURL=https` vào wp-config (khối `/* QCV_HTTPS_START */`). Server offer **ALPN h2** → HTTP/2 multiplex 37 CSS → render-blocking giảm mạnh, đồng thời fix Best Practices. Verify: http→301→https (1 hop, không loop), page cache HIT https, asset immutable, webp/LCP ok, không mixed-content/fatal. Plugin `normalize_internal_https_links` tự lo link https nên không mixed-content.

**Playbook HTTPS cho site mẫu khác:** DirectAdmin (login as mauXX) → SSL Certificates → "Free & automatic Let's Encrypt" (chỉ tick domain chính, bỏ www/wildcard/subdomain để không fail validation) → Save → tick "Force SSL with https redirect" → Save. Thêm WP_HOME/WP_SITEURL https vào wp-config. Xong đo lại PageSpeed (HTTP/2 tự bật khi https).

**Skill HTTPS:** `~/.claude/skills/activate-https-directadmin/SKILL.md` — quy trình cấp Let's Encrypt + force SSL + WP_HOME https + verify cho 1 site DirectAdmin (đã kiểm chứng mau21/mau22).

**Trạng thái site cuối 2026-07-03:**
- **mau21**: đang ở **BYPASS KHẨN CẤP** — deployed file `class-resource-optimizer.php` có `optimize_html_structure(){return $html;}` (TEMP_BYPASS_OPT) → tắt hết tối ưu HTML; thư mục cache đổi tên `qcv-origin-optimizer-broken`. Cần khôi phục: upload 0.1.67 sạch đè + xoá cache. HTTPS+HTTP/2 đã bật.
- **mau22**: HTTPS+HTTP/2 đã bật; plugin active + đã chạy Xanh (bằng script qcv-activate.php, đã đổi tên .txt vô hiệu); đang chạy **0.1.66**, cần lên **0.1.67** để có fix tương phản. Mọi asset cache 1 năm, Best Practices 100, font không mixed-content. Mobile ~67 (nghẽn render-blocking 243KB CSS/JS theme trên Slow 4G — cần Critical CSS mới vượt, đã hoãn vì rủi ro).

**Bài học lớn (0.1.65 crash):** regex xoá FB inline-script `<script>[\s\S]*?TOKEN[\s\S]*?</script>` quá tham → nuốt CSS/HTML giữa các script → trang mất style. Fix 0.1.66: dùng `(?:(?!</script>)[\s\S])*` chặn không vượt ranh giới thẻ. **LUÔN test regex cục bộ bằng PHP với HTML mô phỏng trước khi deploy.** PDF PageSpeed render bằng Python PyMuPDF (`/c/Users/SingPC/AppData/Local/Programs/Python/Python311/python`, poppler không có).

## Cập nhật 2026-07-06 — TRỊ TẬN GỐC double-optimize (sticky header vỡ + khoảng trống thừa)
Người dùng báo trên nhiều mẫu: cuộn xuống **header sticky vỡ CSS (lệch/box rỗng)** + **khoảng trống lớn dưới văn bản**; đặc trưng "MISS/lần đầu OK, F5 trên ẩn danh (cache HIT) mới hỏng". **Nguyên nhân thật = double-optimize**: `optimize_html_structure` chạy 2 lần (structure output-buffer 998 lần 1, rồi `Cache::store()`/`warm()` lần 2) → nhân đôi wrapper, style đã move, link async gallery (colorbox/prettyPhoto 3→4/6→8, tổng stylesheet 46→52). Việc bỏ lệnh optimize trong store()/warm() KHÔNG đủ (còn nguồn khác + cache đã lưu bản double).

**Fix tổng quát (chống-đạn): idempotency marker.** Trong `class-resource-optimizer.php`: hằng `OPTIMIZED_MARKER='<!--qcv-html-optimized-->'`; đầu `optimize_html_structure_safe` nếu HTML đã chứa marker → return luôn; cuối hàm chèn marker trước `</body>` (fallback `</html>`). Lần optimize thứ 2 thấy marker → thoát ngay → không double. Marker sống sót vì minify chạy ở buffer trong hơn (trước bước này). Đã test PHP cục bộ: chạy 2 lần idempotent, wrapper =1.

**Deploy mau03 (2026-07-06):** sửa file deploy qua File Manager JS = thay hàm public `optimize_html_structure` thêm guard đầu + bọc `qcv_mark_optimized()` (helper chèn marker) — KHÔNG cần đụng safe(). Verify saved (len 77963, có `qcv_mark_optimized`). **Xóa 2 file .html trong `wp-content/cache/qcv-origin-optimizer/`** (giữ index.php) ép tái tạo sạch — QUAN TRỌNG: curl thấy `X-Qcv-Origin-Cache: BYPASS` nên tưởng cache tắt, NHƯNG khách ẩn danh vẫn HIT từ file .html cache cũ (bản double) → đó là lý do user vẫn thấy hỏng dù đã sửa code lần trước. Verify cuối: HTTP 200, 46 stylesheet, gallery 3/6, wrapper/cls-guard/moved-style đều =1, marker=1, no fatal. **Còn lại: nhân rộng fix này sang mọi mẫu đã deploy (sửa code + XÓA cache mỗi site).** User cần hard-refresh (Ctrl+Shift+R)/ẩn danh mới vì cache trình duyệt giữ bản hỏng cũ.

**BÀI HỌC (2026-07-06/07): "mất sạch CSS sau F5" ≠ lỗi optimizer.** Ảnh user gửi cho thấy URL `https://mau03` với "Not secure". Chẩn đoán qua curl: mau03 vốn **HTTP** (http không redirect, asset http, cert cũ `CN=localhost` tự ký) → trình duyệt tự nâng lên https (Chrome HTTPS-First) → **mixed-content chặn toàn bộ CSS http → mất sạch bố cục**. Qua http thì hoàn hảo. → **Đã cài HTTPS cho mau03** (theo [[activate-https-directadmin]]): Let's Encrypt chỉ domain chính (bỏ www + le_wc_select0/1 wildcard vốn TICK SẴN phải bỏ), WP_HOME/WP_SITEURL https vào wp-config, Force SSL, xóa cache. Verify: http→301→https 1 hop không loop, 54 CSS đều https, mixed-content=0, HTTP/2, no fatal. **mau03 giờ có HTTPS hợp lệ.** Mẹo: luôn kiểm URL trong ảnh user (http/https) trước khi đổ lỗi cho code.

## Cập nhật 2026-07-07 — GỐC RỄ THẬT của "F5 tan hoang": CSS async preload-onload không F5-safe
Sau khi có HTTPS + marker, mau03 vẫn: **normal browser OK, ẩn danh + F5 → mất giao diện hoàn toàn**. Đây KHÔNG phải double-optimize (đã trị) mà là: hàm `async_non_critical_styles` (gated `enable_css_async_experimental`, hook style_loader_tag) chuyển nhiều CSS **above-fold** (font-awesome, owl-carousel, animate, vc_tta_style, google-fonts...) sang `rel="preload" as="style" onload="this.rel='stylesheet'"`. **Bug kinh điển:** khi F5, CSS đã nằm cache trình duyệt → sự kiện `onload` KHÔNG kích hoạt → `rel` không đổi thành stylesheet → CSS không áp → vỡ icon/slider/font. First-load (cache lạnh) thì onload chạy nên OK. (Logged-in = BYPASS = render sống nên "normal OK".)

**Fix (giữ async, thêm an toàn F5):** hàm `inject_async_css_fallback` chèn 1 `<script id="qcv-css-async-fallback">` cuối trang, ép mọi `link[rel=preload][as=style]`→rel=stylesheet và `link[media=print][onload]`→media=all, chạy **ngay + DOMContentLoaded + load**. Idempotent. Đã thêm vào `optimize_html_structure_safe`. Trên file deploy mau03: nhét vào hàm `qcv_mark_optimized` (đã có sẵn) dạng `$fb = base64_decode('...')` — **dùng base64 để tránh địa ngục escape JS→PHP→HTML** (nested quotes). Verify mau03: HTTP 200, no fatal, script fallback xuất hiện đúng cú pháp, đã xóa cache (12 file) tái tạo. Zip `qcv-origin-optimizer-0.1.72-cachefix.zip` giờ có cả marker + fallback.

## Cập nhật 2026-07-07 (tối) — GỐC RỄ THẬT NHẤT: HTML bị cache 30 NGÀY ở trình duyệt
User gửi bản HTML lỗi "save as" từ ẩn danh (F5). Phân tích: **KHÔNG có marker, KHÔNG có fallback, 413 link `http://mau03`** (27 CSS + 112 ảnh http) → đây là **trang HTTP-era CŨ** trình duyệt đang giữ, không phải bản server hiện tại (server render tốt: https+marker+fallback). Nguyên nhân: `.htaccess` do plugin ghi có `ExpiresDefault "access plus 1 month"` áp cho **text/html** → HTML trả `Cache-Control: max-age=2592000` + `Expires` xa → **trình duyệt cache trang HTML 30 ngày** → F5 phục vụ lại bản cũ (link http) → mixed-content chặn CSS → "tan hoang". Đây mới là lý do các fix trước "không ăn" khi user test (họ xem bản trình duyệt cache).

**Fix (2 lớp):** (1) `class-cache.php::cache_status_header` thêm `header('Cache-Control: no-cache, must-revalidate, max-age=0')` + `Expires` quá khứ cho MỌI path serve — header PHP THẮNG mod_expires (đã verify mau03 giờ trả `no-cache`). (2) `static_cache_rules()` thêm `ExpiresByType text/html/xhtml "access plus 0 seconds"` (belt-and-suspenders cho .htaccess). Deploy class-cache.php lên mau03 (edit qua File Manager: chèn 2 header sau dòng X-QCV, chèn ExpiresByType text/html trước image/jpg), verify HTTP 200 no fatal, `Cache-Control: no-cache`. **QUAN TRỌNG: user PHẢI hard-refresh (Ctrl+Shift+R) hoặc xóa dữ liệu duyệt web MỘT LẦN** để xả bản HTML cũ đang cache 30 ngày; sau đó header no-cache giữ luôn mới. Full-page cache vẫn chạy ở SERVER (nhanh), chỉ chặn browser-cache HTML.

**4 lớp bug đã trị trên mau03:** double-optimize (marker) + async-F5 (fallback script) + thiếu HTTPS (Let's Encrypt) + **HTML cache 30 ngày (no-cache header)**. Zip `qcv-origin-optimizer-0.1.72-cachefix.zip` có đủ 4.

**CÒN LẠI:** cả 4 bug có ở MỌI mẫu chạy optimizer bản cũ. Các mẫu đã cài HTTPS (mau01,02,05,06,07,08,09,10 + 03,04) vẫn cần deploy bản cachefix + xóa cache. HTTPS mau11-20 chưa làm (user bảo tạm dừng). Chờ user xác nhận mau03 (sau hard-refresh) mới nhân rộng.

## Cập nhật 2026-07-07 (trưa) — GỐC RỄ THẬT SỰ CUỐI CÙNG: is_ssl()=false → link http → mixed-content
User gửi ảnh **DevTools Network**: hàng loạt CSS/JS **`(blocked: mixed-content)`** (font-awesome, style.css, bootstrap, woocommerce, owl, js_composer...). Document 200 nhưng CSS/JS bị chặn → mất style. Bản HTML lỗi có **link plugin-asset `http://`** (yith, call-now-icon...) qua `plugins_url()`. **Gốc rễ:** `plugins_url()`/`content_url()` re-scheme theo `is_ssl()`, KHÔNG theo WP_HOME. WAF Tadu terminate SSL rồi forward request về WP dạng **HTTP không kèm `X-Forwarded-Proto`** → `is_ssl()`=false → sinh link `http://` dù WP_HOME=https → trên trang https bị Chrome chặn mixed-content. (curl thấy https vì HIT trúng cache-file sinh lúc is_ssl=true; browser trúng bản sinh lúc is_ssl=false — bất đối xứng theo timing/bucket cache.)

**Fix gốc + lưới an toàn (đã deploy mau03):**
1. **wp-config: ép `$_SERVER['HTTPS']='on';` VÔ ĐIỀU KIỆN** (thay block cũ gated theo HTTP_X_FORWARDED_PROTO — chính block đó là nguồn bug vì WAF không gửi header đó). Site đã force-ssl nên an toàn, không loop. → `is_ssl()`=true → mọi link https. Verify: 0 link http, 558 https.
2. **CSP `Content-Security-Policy: upgrade-insecure-requests`** (header PHP trong `cache_status_header` + `.htaccess` mod_headers + meta trong HEAD): trình duyệt TỰ nâng mọi http→https thay vì chặn — lưới an toàn cho bất kỳ link http sót/cache cũ.
Xóa cache. Verify mau03: HTTP 200, no fatal, header có cả `no-cache` lẫn `upgrade-insecure-requests`, 0 http link, marker+fallback đủ.

**BÀI HỌC:** "mixed-content sau WAF" — WP_HOME=https CHƯA đủ vì `plugins_url` theo `is_ssl()`. PHẢI ép `$_SERVER['HTTPS']='on'` vô điều kiện khi site sau proxy/WAF terminate SSL. Skill activate-https-directadmin đã sửa lại block wp-config này. Zip cachefix có đủ: marker + fallback + no-cache HTML + CSP upgrade-insecure. **5 lớp bug đã trị: double-optimize / async-F5 / thiếu-HTTPS / HTML-cache-30-ngày / is_ssl-mixed-content.**

## Cập nhật 2026-07-07 (chiều) — MẮT XÍCH CUỐI: mod_expires (.htaccess) đè header PHP cho response GZIP
User gửi **file HAR**. Phân tích (Python, PYTHONIOENCODING=utf-8): document response mà TRÌNH DUYỆT nhận có `cache-control: max-age=2592000`, `content-encoding: gzip`, `x-qcv-origin-cache: HIT`, **KHÔNG CSP** — trong khi curl (brotli/identity) nhận `no-cache`+CSP. Khác biệt: **GZIP**. Nguyên nhân: header no-cache+CSP tôi đặt bằng PHP (`cache_status_header`) bị **`mod_expires` (ExpiresDefault "1 month") trong .htaccess ĐÈ LÊN** cho response text/html — rõ nhất trên path gzip (mod_deflate). PHP header thua mod_expires. → trình duyệt nhận max-age 30 ngày + không CSP → cache lại trang cũ (link http) → mixed-content. **Sửa PHP là chưa đủ; PHẢI sửa .htaccess LIVE** (plugin chỉ ghi .htaccess khi activate, nên file live vẫn rule cũ).

**Fix .htaccess LIVE mau03** (public_html/.htaccess, sửa trực tiếp qua File Manager): thêm sau `ExpiresDefault`: `ExpiresByType text/html "access plus 0 seconds"`; thêm trong `<IfModule mod_headers.c>`: `Header always set Content-Security-Policy "upgrade-insecure-requests"` + `Header always set Cache-Control "no-cache, must-revalidate, max-age=0" "expr=%{CONTENT_TYPE} =~ m#text/html#i"`. Verify với **curl -H 'Accept-Encoding: gzip'** (đúng path browser): HTTP 200, HIT, `Cache-Control: no-cache`, `Content-Security-Policy: upgrade-insecure-requests`, nội dung marker=1, 0 http link. File cache hiện tại đã tốt (https). **Lưu ý deploy: (1) file HAR là vũ khí mạnh nhất để đọc header thật; (2) LUÔN test bằng gzip vì mod_expires xử khác; (3) mọi mẫu khác khi deploy cachefix PHẢI sửa cả .htaccess LIVE (hoặc re-activate plugin để ghi lại .htaccess mới có sẵn 3 rule này trong static_cache_rules); (4) .htaccess sai cú pháp = 500 sập site, verify ngay sau lưu.** Source `static_cache_rules()` đã có đủ 3 rule. **6 lớp bug đã trị.**

## Cập nhật 2026-07-07 (cuối) — THỦ PHẠM CUỐI CÙNG THẬT SỰ: cache của Tadu WAF (cấp hosting)
Sau tất cả, user vẫn lỗi + bật Disable cache vẫn chặn mixed-content. HAR (response headers đầy đủ) lộ ra: **`server: Tadu WAF 2.0.52`**, **`t-cache: Hit`**, **`date: Thu, 02 Jul 2026`** (cache từ 2/7, TRƯỚC mọi fix, hết hạn 1/8 do max-age cũ). Response body Tadu phát: **564 link http, 0 https, marker=0** = trang HTTP-era cũ. Đây KHÔNG phải plugin cache mà là **cache của Tadu WAF** (reverse-proxy chạy NGAY TRÊN origin 103.179.173.247 — mau03 resolve thẳng về IP này). 

**Cơ chế (giải thích toàn bộ triệu chứng):** Tadu cache trang `/` cho request **ẩn danh (không cookie)**; **bỏ qua cache nếu có cookie HOẶC có query-string**. → normal browser (có cookie WP/Woo) = Tadu bypass = origin tốt; ẩn danh (không cookie) = Tadu phát bản cache cũ 2/7 link http = mixed-content vỡ. curl tôi (HTTP/1.1 Schannel) = t-cache Miss = origin tốt nên MÃI tưởng đã xong; browser dùng HTTP/2 = t-cache Hit. Tadu **Vary: User-Agent** → mỗi UA 1 bucket.

**KHÔNG xả được từ phía tôi:** PURGE method→405; không có control Tadu/WAF/cache trong DirectAdmin (cả user LẪN admin, đã quét CMD_PLUGINS + menu); origin đã gửi `Cache-Control: no-cache` nhưng Tadu bỏ qua request `no-cache` và giữ entry cũ tới khi hết hạn. **Origin (WP+Apache) đã 100% đúng** — verified mọi kiểu.

**CÁCH XỬ (giao cho user/hosting):** (1) Xả cache Tadu WAF qua panel hosting/Tadu (KHÔNG có trong DirectAdmin — ở cấp nhà cung cấp), hoặc liên hệ hosting purge WAF cache cho domain; (2) sau khi purge, origin no-cache sẽ giữ Tadu không cache lại → hết vĩnh viễn. **Test xác nhận nhanh:** mở site bằng **trình duyệt KHÁC (Firefox/Edge) ẩn danh** → UA khác → Tadu MISS → hiện trang đúng (chứng minh origin ổn, chỉ Tadu kẹt). **Bài học lớn nhất cả session: khi debug "cache lạ sau proxy", ĐỌC HEADER `server:` và `*-cache:` trong HAR NGAY TỪ ĐẦU — curl Schannel không lên HTTP/2 nên không tái hiện được cache theo HTTP/2 của browser.** Việc nhân rộng mau11-20: sau khi cài HTTPS phải nhờ hosting purge Tadu cache (nếu Tadu đã cache bản http trước đó).

## Cập nhật 2026-07-07 (tối muộn) — REGRESSION THẬT SỰ tìm ra nhờ manh mối user "0.1.50 không lỗi / reset cache vẫn lỗi"
User: đã reset cache server mà VẪN lỗi; bản ≤0.1.50 cache cũng không lỗi. → KHÔNG chỉ tại Tadu cache mà là **regression trong optimizer**. Đọc `normalize_internal_https_links`: dòng đầu **`if ( ! is_ssl() ) return $html;`** → khi `is_ssl()`=false thì **để nguyên link http://** (không chuẩn hoá). Sau Tadu WAF terminate SSL + forward HTTP về origin, `is_ssl()`=false (dù wp-config ép `$_SERVER['HTTPS']='on'`, warm/self_http_get loopback qua http vẫn is_ssl false) → origin sinh trang link http → Tadu cache lại bản http → browser https → mixed-content. **Vì thế reset cache vẫn lỗi**: mỗi lần tái tạo, origin (is_ssl false) lại sinh link http.

**FIX GỐC (không phụ thuộc is_ssl):** đổi `normalize_internal_https_links` — bỏ guard `is_ssl()`, thay bằng: nếu `home_url('/')` bắt đầu bằng `https://` (tức site chạy https, luôn đúng vì WP_HOME=https) thì `str_replace('http://'.$host,'https://'.$host,$html)`. → chuyển MỌI link nội bộ sang https **bất kể request tới origin là http hay https**. Đã deploy mau03 (verify: guard is_ssl cũ đã bỏ, có home_url check + $host từ $home + str_replace; HTTP 200 no fatal), xóa plugin cache. Zip cachefix đã có. **Đây mới là fix then chốt cho mixed-content sau WAF** — quan trọng hơn cả wp-config `$_SERVER['HTTPS']='on'` (là fix phụ, vẫn giữ). Sau fix này, khi Tadu tái cache sẽ cache bản https. User cần reset cache Tadu/server 1 lần nữa để nó tái tạo bản https. **7 lớp bug đã trị. BÀI HỌC: nghe manh mối user (version nào OK) — nó chỉ thẳng regression thay vì đổ tại hạ tầng.**

Bản plugin cũ **0.1.67** (thêm auto-contrast dò row nền tối ép chữ trắng). Các bản 0.1.63→0.1.65 thêm: async CSS chỉ gallery/lightbox below-fold; iframe title a11y; loopback self_http_get; tắt messenger/chat (FB customerchat/page iframe) trên site mẫu `mau\d+` (giữ icon tĩnh); rewrite link sang domain "anh em" cũ (thuvienweb.vn→thuvienwebqcv.vn, suy từ "webqcv"→"web"); HSTS khi https; **fix mixed-content font**: URL Google Font localize giờ protocol-relative + đổi tên file CSS thành `-s2` để bypass WAF cache immutable (bug cũ: font .ttf ghi http:// tuyệt đối → blocked khi lên https). Sau deploy phải Xóa cache để tái tạo link CSS -s2. Còn lại: mobile nghẽn ở **render-blocking ~15 CSS layout theme** (js_composer/megastore/woo) — cần Critical CSS mới lên cao hơn (rủi ro, chưa làm). Debug: bật WP_DEBUG_LOG bằng chèn khối `/* QCV_DEBUG_START */` sau `<?php` trong wp-config (đã revert sau khi xong).

## Cập nhật 2026-07-16 (tối) — TÌM RA: "ảnh slider mất" = optimizer GHI HỎNG ẢNH GỐC
User báo mau04 có 2 slide (2 và 4) hiện mảng xám ở dưới. **Chẩn đoán sai 2 lần trước khi đúng**: (1) quét URL thấy tất cả 200 → tưởng lành; (2) ngưỡng "size<500B" bắt nhầm 2 icon 26×26px. Chỉ khi **giải mã file webp và NHÌN** mới thấy: phần dưới ảnh là mảng xám đặc — file có RIFF header hợp lệ + kích thước đúng nhưng **dữ liệu ghi thiếu**.

**Gốc rễ**: `image_max_width=1920` khiến optimizer resize ảnh **ĐÈ LÊN CHÍNH FILE GỐC .jpg** (2560→1920), tiến trình bị kill giữa chừng (OOM/timeout — đúng lỗi "Fatal batch ảnh" đã biết) → **ảnh gốc .jpg hỏng vĩnh viễn**, mọi bản .webp sinh ra sau đều thừa hưởng mảng xám. Bằng chứng chốt: bản `-1024x389.webp` (do WordPress tạo lúc upload, TRƯỚC optimizer) vẫn LÀNH, còn `.jpg` + `.webp` + `-qcv-*` đều hỏng. → **Xoá webp KHÔNG cứu được, phải phục hồi ảnh gốc.**

**Cách nhận biết nhanh** (dùng lại cho site khác): tải ảnh về, đọc 10-12 dòng pixel CUỐI; nếu `len(set(pixels)) <= 3` (đồng nhất) → ảnh ghi dở. Kèm dấu hiệu dung lượng: 30KB vs 113-196KB của ảnh lành cùng kích thước.

**Đã phục hồi**: `goi-du-lieu-khach.mau04/hinh-anh/slider/{1..5}.jpg` (tải 6/2026, TRƯỚC khi hỏng) là bản gốc duy nhất còn sống. Map theo kích thước — HTML `width`/`height` giữ metadata CSDL gốc: 1.jpg 1920x750=slide_2_img, **2.jpg 2049x779=20251204_Y07Js77Y (slide 2)**, 3.jpg 2560x974=20251106_NP9S6TV0-scaled, **4.jpg 2560x973=20251231_h789P7nH-scaled (slide 4)**, 5.jpg 2560x973=20251119_VGo5RHny-scaled. Xác nhận bằng so khớp NỬA TRÊN ảnh (phần chưa hỏng): độ lệch 1.0 và 0.7/255. File đã đặt đúng tên ở `D:\dev\qcv-builder\mau04-anh-slider-phuc-hoi\`.

**CẢNH BÁO NHÂN RỘNG**: bất kỳ site nào từng chạy image batch với `enable_image_optimize=1` + ảnh > 1920px đều CÓ THỂ đã bị ghi hỏng ảnh gốc mà không ai biết (frontend vẫn 200, chỉ mảng xám). 0.1.62+ đã thêm time-budget/memory guard nên không hỏng thêm, NHƯNG **không sửa được ảnh đã hỏng**. Nên quét toàn bộ site mẫu bằng cách đọc pixel dòng cuối.

## Cập nhật 2026-07-17 — ĐÍNH CHÍNH gốc rễ ảnh xám + bản 0.1.74-imagefix
**Giả thuyết "bị kill giữa chừng" là SAI** — tự tay bác bỏ bằng test: file ảnh hỏng **hoàn toàn hợp lệ** (JPEG có đủ `ffd8`/`ffd9`, WebP khai báo RIFF size khớp filesize, GD giải mã **không một cảnh báo**). Tức file được ghi XONG; **mảng xám nằm trong chính pixel**, bị mã hoá vào file hoàn chỉnh. → Không thể phát hiện bằng kiểm tra cấu trúc file (getimagesize/EOI/RIFF đều vô dụng), **phải so NỘI DUNG với ảnh nguồn**. Cơ chế thật: khâu resize sinh ra ảnh xám ở đáy rồi ghi xuống "thành công" (nghi GD/Imagick hụt bộ nhớ giữa `imagecopyresampled` → phần chưa vẽ giữ nguyên canvas xám), chưa xác định chính xác.

**Bằng chứng patient-zero**: trong các thumbnail WP của cùng 1 ảnh, `-1024x389`/`-1536x584`/`-600x228`/`-300x114` LÀNH (tạo lúc upload) nhưng `-768x292.jpg` HỎNG → ảnh gốc đã xám TẠI THỜI ĐIỂM sinh lại thumbnail đó, tức hỏng xảy ra sau upload, do optimizer.

**0.1.74-imagefix** (`outputs\qcv-origin-optimizer-0.1.74-imagefix.zip`): trong `class-image-optimizer.php` —
- `image_content_intact($path,$source)`: so **dải pixel đáy** (`bottom_strip_detail`, độ lệch chuẩn, lấy mẫu bước 4px); chỉ kết luận hỏng khi **nguồn CÓ chi tiết (sd>6) mà bản mới PHẲNG (sd<2)** → logo/icon/ảnh nền trắng không bị kết tội oan. **Đã kiểm chứng bằng file thật mau04: 4/4 đúng.**
- `image_file_complete($path)`: kiểm cấu trúc (EOI/IEND/RIFF size) — giữ lại vì rẻ, nhưng **không bắt được lỗi này**.
- Resize không còn `$editor->save($file)` ghi đè thẳng: ghi file tạm → kiểm 2 lớp → `rename()` nguyên tử; không đạt thì **giữ nguyên ảnh gốc** + ghi log `image_optimize_abort`.
- 2 chỗ `imagewebp()` cũng qua `finalize_written_image()` (trước đây chỉ kiểm `filesize>0` nên file hỏng lọt).

**PHÁT HIỆN LỚN — optimizer ĐÃ CÓ SẴN backup ảnh gốc**: `backup_original()` copy ảnh gốc vào `uploads/qcv-origin-backups/media/<id>-<tên file>` TRƯỚC khi resize, lưu đường dẫn ở post meta `_qcv_origin_image_backup`; có `restore_latest_batch()` (chỉ batch cuối). Thư mục trả **403 chứ không 404** trên mau04 → **tồn tại**. → Đây là đường phục hồi thật cho MỌI ảnh hỏng ở MỌI site, không cần đi tìm file gốc. Cần viết tool restore-all (theo post meta, không chỉ batch cuối).

**Công cụ quét**: `outputs\quet-anh-hong.py` (chạy từ ngoài, không cần mật khẩu): `python quet-anh-hong.py <host> /` → CSV. **2 tầng**: (1) nghi ngờ = đáy đồng màu hoặc bytes/pixel < 0.012; (2) đối chứng với ảnh nguồn → loại oan. Trên mau04: tầng 1 nghi 10 → tầng 2 loại oan 8 → **còn đúng 2 thật hỏng**. Chỉ quét ảnh ĐƯỢC THAM CHIẾU trên trang, không quét cả thư mục uploads.

**BÀI HỌC**: ngưỡng "size<500B" bắt nhầm icon 26×26; "đáy đồng màu" bắt nhầm logo/ảnh nền trắng. Muốn kết luận ảnh hỏng **BẮT BUỘC phải đối chứng với nguồn**.

## Cập nhật 2026-07-17 — 0.1.75: nút "Khôi phục ảnh gốc" + làm rõ nhãn webp
User không tìm thấy chỗ tắt webp: **nút CÓ tồn tại** (`class-admin.php:715`) nhưng nhãn cũ *"Ưu tiên ảnh WebP khi file đã sẵn sàng"* quá khó đoán → đổi thành *"Hiển thị ảnh WebP thay cho JPG/PNG — tắt nếu ảnh bị lỗi hiển thị"*. Tương tự `enable_image_optimize` → thêm *"(thu nhỏ ảnh quá lớn)"*.

**Nút "↺ Khôi phục ảnh gốc (N)"** đặt NGAY trong ô KPI *"Ảnh đã xử lý"* (user đề xuất — thấy lỗi ở đâu thì hành động ở đó), thay vì chôn ở mục "Khôi phục khi phát sinh lỗi" cuối trang. Chỉ hiện khi `restorable_count() > 0`.
- `Image_Optimizer::restorable_count()`: đếm post meta `_qcv_origin_image_backup` có file thật tồn tại.
- `Image_Optimizer::restore_all_from_backup()`: duyệt **MỌI** attachment có backup (khác `restore_latest_batch()` chỉ làm batch cuối — ảnh hỏng có thể từ batch cũ bất kỳ). Copy backup → file tạm → `rename()` nguyên tử; xoá mọi webp dẫn xuất; gỡ cờ `_qcv_origin_image_optimized` → **cron tự tối ưu lại dần bằng mã an toàn 0.1.74+**; xả cache. Trả `{restored, webp_removed, missing}`.
- Handler `admin_post_qcv_origin_restore_all_images` + thông báo nêu rõ số ảnh khôi phục / webp đã xoá / ảnh không có backup + nhắc Ctrl+Shift+R.

**Đã kiểm chứng logic bằng file thật**: ảnh xám 768×292 → khôi phục thành 2049×779 lành (độ chi tiết đáy 50.9), webp dẫn xuất bị xoá, không sót file tạm. ZIP: `outputs\qcv-origin-optimizer-0.1.75-imagefix.zip` (15 file, 94.2KB).

## Cập nhật 2026-07-17 — TÌM RA CƠ CHẾ THẬT (user đoán đúng): 0.1.76
User hỏi "có phải xử lý theo lô quá nhiều nên server không phản hồi kịp?" → **ĐÚNG**, và nó ghép nốt mắt xích còn thiếu. Chuỗi đầy đủ:
1. Lô quá nặng → PHP bị kill **giữa lúc `$editor->save($file)` ghi đè ảnh gốc** → ảnh gốc **cụt đuôi** (đây là giả thuyết ban đầu, ĐÚNG nhưng chưa đủ).
2. Lượt sau `@imagecreatefromjpeg()` giải mã ảnh cụt → libjpeg lấp phần thiếu bằng **xám**, chỉ phát warning mà `@` **nuốt mất**.
3. Ghi lại → thành file **HOÀN CHỈNH có xám nướng trong pixel** (đủ `ffd9`, GD không báo lỗi). → Giải thích vì sao tôi tìm thấy file hợp lệ và tưởng giả thuyết kill là sai.

**BUG GỐC (`batch_optimize_existing`)**: ngân sách thời gian là **CỔNG VÀO chứ không phải HẠN CHÓT** — `if ((time()-$started) >= $budget) break;` chỉ kiểm thời gian ĐÃ tốn, nên ở giây 14/15 vẫn cho phép **bắt đầu** một ảnh 2560px tốn thêm 20s → tổng 34s > `max_execution_time` → bị giết giữa lúc ghi. **Đã tái hiện bằng mô phỏng**: max_exec=30, ngân sách=12, ảnh #12 nặng 20s → bản cũ chạy tới 31s **BỊ GIẾT giữa lúc ghi ảnh #12**; bản vá dừng ở 9s an toàn.

**0.1.76 sửa**: (a) vòng lặp **chừa dự phòng cho ảnh kế tiếp** — `$du_phong = max(4.0, $cham_nhat*1.3)`, chỉ bắt đầu ảnh mới khi `$da_ton + $du_phong <= $budget`; tự học từ ảnh chậm nhất đã gặp; dùng `microtime(true)` thay `time()`; thêm `@set_time_limit(0)`; log kèm `seconds`/`slowest`. (b) `cron_batch()` bỏ sàn `max(batch_size(), 40)` → **tôn trọng số người dùng đặt** (trước ép 40 dù user chọn 10). (c) profile Xanh/Vàng/Đỏ hạ ép từ **30/60/100 → 12/20/30** (giờ chỉ là trần trên, ngân sách tự dừng sớm).

Kèm 0.1.74 (kiểm nội dung trước khi thay ảnh gốc + ghi file tạm→rename nguyên tử) và 0.1.75 (nút Khôi phục). ZIP: `outputs\qcv-origin-optimizer-0.1.76-imagefix.zip`. **Ba lớp**: chặn nguyên nhân (ngân sách đúng) + chặn hậu quả (kiểm nội dung) + cứu hộ (nút khôi phục).

## 2026-07-17 — "sao chỉ khôi phục 8 ảnh?" → 0.1.77-restoreall
**Vì sao chỉ 8**: `backup_original()` chỉ được gọi TRONG nhánh `if ($size['width'] > $max)` (dòng ~79 class-image-optimizer.php) — tức **chỉ ảnh từng bị thu nhỏ mới có bản sao lưu**. Ảnh khác optimizer không hề ghi đè (webp là file riêng) nên không cần khôi phục. Nhưng nút chỉ ghi "(8)" nên trông như bỏ sót → **cần nói rõ trong UI**, không phải chỉ sửa code.

**3 lỗ hổng THẬT đã bít trong 0.1.77**:
1. `collect_backups()` — hợp nhất 2 nguồn: postmeta `_qcv_origin_image_backup` **+ quét thẳng thư mục** `uploads/qcv-origin-backups/media`, đọc ID từ tên file `{id}-{ten}` (regex `^(\d+)-`), kiểm `get_post_type()=='attachment'`, rồi **vá lại meta đã mất**. Lý do: meta ở CSDL, file sao lưu ở đĩa — **lệch nhau khi clone site / restore DB cũ hơn uploads** (user ĐÃ clone mau03 sang server khác!). Bản cũ mất meta = mất luôn khả năng khôi phục dù file còn nguyên.
2. `purge_webp_files()` — xoá webp bằng meta **+ glob theo tên ảnh gốc** (`{ten}*.webp` + mọi size trong metadata). Bản cũ chỉ xoá theo meta = webp cũ (`-qcv-1600.webp`) từ lần optimize trước **vẫn nằm trên đĩa và vẫn được phục vụ** → "khôi phục" xong vẫn thấy ảnh xám.
3. **Kích thước phái sinh vẫn xám**: `-1024x389.jpg` do WP sinh TỪ ảnh gốc lúc nó đang hỏng; khôi phục ảnh gốc không sửa chúng. Thêm hàng đợi `REBUILD_KEY` + cron `REBUILD_HOOK` → `cron_rebuild()` gọi `wp_generate_attachment_metadata()` **có hạn chót giống batch** (dự phòng `max(4.0, chậm_nhất*1.3)`), còn dư thì `wp_schedule_single_event(+60s)`.

**BẪY đã tránh**: `wp_generate_attachment_metadata()` kích hoạt chính filter `optimize_upload` (đăng ký ở priority 20) → ảnh vừa khôi phục sẽ **bị resize lại ngay**, xoá sạch công khôi phục mà bản sao lưu thì đã dùng rồi. Chặn bằng cờ `self::$dang_dung_lai`, đặt lại trong khối **`finally`** (nếu để sau `try` mà hàm ném lỗi thì mọi ảnh sau đó im lặng không được tối ưu nữa).

`REBUILD_HOOK` đăng ký **vô điều kiện** ở đầu `init()` (trước các `return` khi tắt tính năng) — hàng đợi phải chạy tiếp kể cả khi user đã tắt optimizer. Kiểm chứng bằng thư mục giả lập: bản cũ 2 ảnh/1 webp → bản mới 4 ảnh/4 webp; bỏ qua file rác, không xoá nhầm webp của ảnh khác. ZIP: `outputs\qcv-origin-optimizer-0.1.77-restoreall.zip` (0.1.76 đã xoá).

## 2026-07-17 — ĐO ĐẠC LẬT NGƯỢC MỌI CHẨN ĐOÁN TRƯỚC: 0.1.78-webpfix
User: "chạy 1.76 xong lại lỗi, TẮT WEBP VẪN LỖI. Trước đó tắt webp thì ảnh KHÔNG lỗi." → tiền đề của tôi sai. Đo thật trên mau04 (không cần mật khẩu):

**SỰ THẬT ĐO ĐƯỢC**:
1. **Ảnh gốc .jpg LÀNH**: `2019/12/20251204_Y07Js77Y.jpg` 2049x779, 1382KB, sd_đáy=**53.19**. Ảnh gốc CHƯA BAO GIỜ hỏng.
2. **MỌI biến thể webp XÁM**: -qcv-480/768/1024/1366/1600 đều sd≈0.00.
3. **Tải ảnh gốc thật về, chạy ĐÚNG đường mã GD tại máy → cả 6 biến thể LÀNH (sd≈52)**. → **Mã sinh webp KHÔNG hỏng.**
4. HTML mau04: **75/75 URL ảnh là .webp, 0 jpg** — kể cả khi `?qcvnocache=` phá cache (`Cache-Control: no-cache`). URL webp **nằm trong CSDL**, không phải rewrite lúc chạy → **tắt WebP không đổi được HTML**, đó là lý do "tắt webp vẫn lỗi".
5. Cả 75 webp đều HTTP 200 — không phải lỗi 404.

**NGUYÊN NHÂN THẬT** (`class-image-optimizer.php` dòng ~246 và ~268):
```php
if ( file_exists( $webp ) ) { $files[] = $webp; continue; }   // KHÔNG BAO GIỜ sinh lại
```
webp đã tồn tại thì optimizer vĩnh viễn không đụng tới. Nên **webp xám do phiên bản optimizer CŨ sinh ra sẽ xám MÃI MÃI**, dù ảnh gốc lành và mã hiện tại đã đúng. Chạy tối ưu lại vô ích. **Chỉ xoá file webp mới thoát.**

**CÁC CHẨN ĐOÁN TRƯỚC ĐỀU SAI** (ghi lại để không lặp): "resize phá ảnh gốc" SAI (ảnh gốc chưa bao giờ hỏng); nút Khôi phục ảnh gốc **không liên quan** đến lỗi này; 8 bản sao lưu là đúng và vô hại. Bài học: **đo trước, đừng suy luận từ mã.**

**0.1.78 thêm `purge_all_derived_webp()`** — quét **THEO ĐĨA** (RecursiveIteratorIterator trên uploads), KHÔNG theo postmeta (webp hỏng ở mau04 không nằm trong meta của attachment nào). Xoá mọi `.webp` **CÓ ảnh nguồn .jpg/.jpeg/.png nằm cạnh**; **GIỮ** webp không có nguồn (= người dùng tự upload); bỏ qua thư mục sao lưu; xoá meta `_qcv_origin_image_webp*`+`_qcv_origin_image_optimized` để cron sinh lại. Nút "♻ Xoá & tạo lại toàn bộ WebP" trong ô "Ảnh đã xử lý". Kiểm chứng thư mục giả lập: 10 quét → xoá 8 phái sinh, giữ 2 webp tự upload, không đụng backup/ảnh gốc.

**LƯU Ý còn mở**: URL .webp nằm trong CSDL → nếu xoá webp mà không sinh lại kịp sẽ 404. purge xong PHẢI để cron chạy sinh lại. ZIP: `outputs\qcv-origin-optimizer-0.1.78-webpfix.zip`.

## 2026-07-17 (tiếp) — 0.1.79-webpfix: xoá-và-sinh-lại liền mạch + bỏ gỡ ?ver
**(1) `purge_and_rebuild_webp()`** thay `purge_all_derived_webp()` (0.1.78 đã bỏ). Lý do: URL .webp nằm trong CSDL → xoá hết rồi đợi cron = 404 toàn site trong lúc chờ. Giờ **mỗi ảnh: unlink → sinh lại NGAY** (`maybe_create_webp_file` + `create_responsive_webp_files` nhận `$file`, KHÔNG cần attachment_id → chạy được cả với ảnh không có trong media library, đúng ca mau04). Ảnh chỉ vắng mặt vài mili giây. Có hạn chót (dự phòng `max(4.0, chậm_nhất*1.3)`); dư → `WEBP_QUEUE_KEY` + `WEBP_HOOK` (`wp_schedule_single_event +30s`), ảnh chưa tới lượt **vẫn hiển thị bản cũ** chứ không mất. `collect_derived_webp()` trả về map ảnh_gốc => [webp].

**(2) LỖI GIAO DIỆN "F5 mới hỏng" — `strip_asset_version()`**: nó `remove_query_arg('ver', $src)` **xoá hẳn** ?ver, trong khi `.htaccess` của chính plugin đặt `ExpiresDefault "access plus 1 month"` → CSS/JS bị trình duyệt giữ 1 tháng **không có cách nào cache-bust**. Đo trên mau04: **37/40 CSS không còn ?ver=**. Sửa: thay ?ver bằng **`filemtime`** — URL đổi khi và chỉ khi file đổi. Giữ nguyên ?ver nếu: file ngoài wp-content (CDN), file không tồn tại trên đĩa, không có ?ver. Thêm `local_path_for()` (xử lý cả URL `//`). Kiểm chứng 6/6 đạt.

**ĐÃ LOẠI TRỪ bằng đo đạc (đừng nghi lại)**: CSS async (`onload=...stylesheet` = **0** trên mau04, tính năng TẮT); 404 (CSS 40/40 + JS 37/37 đều tải được); page cache của plugin (**không có header `X-Qcv-Origin-Cache`** → không hoạt động trên mau04; 3 lần tải đều 221804 byte); HTML minify (1549 dòng = không minify); `js_composer/custom.css` (137 byte, từ 2021, vô can).
**CHƯA CHỨNG MINH**: chưa tái hiện được lỗi F5 từ ngoài vì nó xảy ra khi đã đăng nhập + vừa sửa builder. `strip_asset_version` là nghi phạm mạnh nhất còn lại, sửa nó là đúng dù chưa chắc là THE cause. **Phép thử phân biệt: lúc hỏng, Ctrl+Shift+R có hết không? Hết = cache trình duyệt (đúng nghi phạm). Không hết = lỗi phía máy chủ.**
ZIP: `outputs\qcv-origin-optimizer-0.1.79-webpfix.zip`.

## 2026-07-17 (tiếp 2) — "Khối thứ 2 sau slider biến mất": KHÔNG PHẢI LỖI OPTIMIZER
Đo từ ngoài (mau04, không cần mật khẩu). **Hai lớp lỗi chồng nhau, optimizer vô can** (nó không hề đụng admin-ajax/vc_grid AJAX; 2 filter `the_content` của nó chạy ở priority 20/21 = SAU do_shortcode ở 11 nên không thể ảnh hưởng).

**Lớp ngoài — Tadu WAF chặn ĐÍCH DANH một action**: POST admin-ajax.php `action=heartbeat` → WordPress trả JSON bình thường; `action=vc_get_vc_grid_data` → **trang thử thách WAF** (`<script>function run(v,c){document.cookie=...}`); `action=khong_co_that` → 400. Tức WAF không chặn admin-ajax nói chung, chỉ chặn riêng `vc_get_vc_grid_data` (action này của WPBakery từng có lỗ hổng). JS của grid nhận HTML thử thách thay vì dữ liệu → grid treo ở chấm loading → khoảng trắng. Người đăng nhập có cookie nên lọt → **builder thấy, ngoài site không thấy**.

**Lớp trong — LỖI GỐC THẬT**: vượt thử thách WAF (parse `run(val,name)` rồi set cookie `__uip`) và gọi lại → WordPress trả **`{"status":"Nothing found"}`**. Vì `data-vc-grid-settings` chứa `"shortcode_id":"{\"failed_to_get_id\":\"vc_gid:1784262493115-a7250355c25feaac243cb8d61af868a3-6\"}"` → **WPBakery không định vị được shortcode grid trong nội dung trang** (page_id 12, tag vc_media_grid). **Nên dù mở WAF ra thì grid VẪN rỗng.** Sửa WAF thôi là chưa đủ.

**Kết luận cho user**: (1) nhờ Tadu bỏ chặn `vc_get_vc_grid_data`; (2) mở builder → vào từng Media Grid → Save Changes → Update trang, để WPBakery sinh lại grid ID (`failed_to_get_id` hay gặp ở site clone/import — mau04 là bản clone).

**Cùng lúc, đã xác nhận bằng đo đạc**: webp Dottie đã LÀNH cả 5 biến thể (sd ~52, Last-Modified 17/07 04:26–04:27) → **nút "Tạo lại toàn bộ WebP" của 0.1.79 CHẠY ĐÚNG**; user thấy xám là do cache trình duyệt (ảnh không có ?ver). Nội dung sửa trong builder cũng đã ra tới HTML ẩn danh ("kiểu dáng, form mẫu" = có). Server `Tadu WAF 2.0.52` cache HTML cho khách ẩn danh → giải thích "đăng nhập thấy update, ẩn danh không".

## 2026-07-17 (tiếp 3) — TÌM RA LỖI GỐC THẬT: js_composer regex hỏng. 0.1.80-gridfix
**MỘT DẤU GẠCH CHÉO NGƯỢC.** `js_composer/include/classes/shortcodes/vc-basic-grid.php` trên mau04:
```php
$id_pattern = '/'.$this->grid_id_unique_name.'\:([\w-_]+)/';   // SAI (mau04)
$id_pattern = '/'.$this->grid_id_unique_name.'\:([\w\-_]+)/';  // ĐÚNG (6.7.0 sạch)
```
Trong lớp ký tự, `-` giữa `\w` và `_` bị PCRE hiểu là KHOẢNG từ `\w` đến `_`. `\w` là LỚP chứ không phải ký tự đơn → "invalid range in character class" → **`preg_match()` trả về FALSE với MỌI chuỗi**. Đã chứng minh bằng PHP: `[\w-_]` → `bool(false)`; `[\w\-_]` → khớp, lấy đúng id. Hậu quả: `getId()` LUÔN trả `{"failed_to_get_id":"vc_gid:..."}` → AJAX trả `{"status":"Nothing found"}` → grid trống VĨNH VIỄN. **grid_id trong nội dung VẪN ĐÚNG** — chỉ đoạn mã ĐỌC nó là hỏng, nên lưu lại bao nhiêu lần cũng vô ích.

**js_composer trên mau04 là bản TRỘN**: `vc-basic-grid.php` là file đời cũ (dùng `function __construct`, `json_encode`, `urlencode`) nhưng `js_composer_front.min.js` **trùng từng byte với 6.7.0**; thiếu `include/autoload/hook-vc-grid.php`; có thư mục thừa `assets/js/dist_bak1/`. → cập nhật dở dang. **Đi theo bản clone** → khớp với "clone mau03 sang server khác vẫn lỗi".

**VÌ SAO chỉ Media Grid mất, lưới sản phẩm vẫn hiện**: template `include/templates/shortcodes/vc_basic_grid.php` dòng ~50 chỉ dựng sẵn item ở server cho `vc_basic_grid`:
`in_array( $this->settings['base'], array( 'vc_basic_grid' ), true )` → **`vc_media_grid` LUÔN phải qua AJAX** → dính cả regex hỏng lẫn WAF chặn.

**0.1.80 thêm `includes/class-wpbakery-grid-fix.php`** — vá LÚC THỰC THI, **KHÔNG sửa file js_composer** (bản vá file sẽ bay khi update, và không có bản sạch để đối chiếu). Chỉ dùng hook công khai của WPBakery:
- **Lớp 1** `do_shortcode_tag` → với vc_media_grid/vc_masonry_media_grid/vc_masonry_grid, nếu container rỗng thì gọi chính lớp WPBakery (`buildAtts`+`buildItems`+`renderItems`) rồi chèn vào container qua `preg_replace` sau `data-vc-public-nonce="..."`. **Bỏ hẳn AJAX → thoát luôn cả WAF.** Có cờ `$dang_dung` chống đệ quy.
- **Lớp 2** `vc_basic_grid_find_post_shortcode` (hook có sẵn ở cuối `findPostShortcodeById`) → `doc_ma_grid()` bóc `vc_gid` từ JSON hỏng bằng regex ĐÚNG, rồi `tim_grid_trong_noi_dung()` quét post_content tìm shortcode khớp. Cần cho phân trang/load-more.
- `ban_js_composer_bi_loi()` đọc thẳng file tìm mẫu hỏng (KHÔNG tin số phiên bản vì file bị trộn).
- Tự nhận biết: chỉ ra tay khi thấy dấu hiệu hỏng → site lành không bị đụng. Bỏ qua khi `is_builder_context()`/`vc_is_page_editable()`.
Kiểm chứng bằng nội dung THẬT của mau04: **5/5 grid tìm lại được**; nhận diện đúng file hỏng vs file lành. ZIP: `outputs\qcv-origin-optimizer-0.1.80-gridfix.zip`.

## 2026-07-17 (tiếp 4) — USER ĐÚNG: optimizer LÀ thủ phạm, nhưng GIÁN TIẾP. 0.1.81
User: "trước đó không hỏng, chỉ sau khi dùng optimizer mới hỏng". **ĐÚNG.** Chuỗi nhân quả:
1. `class-health-check.php:44` chấm **'fail'** nếu `PHP_VERSION < 7.4`; `class-audit.php:139` cảnh báo "PHP thấp hơn 7.4, cần kiểm tra hosting trước khi bật tối ưu" → **chính optimizer thúc giục nâng PHP lên 7.4**.
2. **PHP 7.3 đổi PCRE1 → PCRE2** (máy này: `PCRE 10.35`, PHP 7.4.25).
3. PCRE1 **chấp nhận** `[\w-_]` (nên WPBakery bán hàng triệu bản với dòng đó mà không ai kêu); **PCRE2 coi là LỖI BIÊN DỊCH** → `preg_match()` trả FALSE → mọi Media Grid chết cùng lúc trên mọi site.
→ Optimizer **không hề chạm** vào js_composer (đã grep: `class-plugin-replacement.php` chỉ có `candidates()`+`replacement_summary()`, **chỉ đọc**; optimizer chỉ *đọc* mấy file .woff của js_composer để preload). Nó chỉ khuyên nâng PHP — cú nâng đó làm lộ lỗi nằm sẵn.

**0.1.81 thêm mục health-check `check_js_composer_pcre()`** ngay DƯỚI mục "PHP 7.4 trở lên": nếu phát hiện js_composer dính lỗi thì cảnh báo. Nếu PHP<7.3 → "cập nhật js_composer TRƯỚC khi nâng PHP" (chặn trước, để không lặp lại thảm kịch này ở site khác). Nếu PHP>=7.3 → "đang tự vá, nhưng nên cập nhật js_composer".

**RÀ SOÁT REGEX (user yêu cầu)**: viết `outputs\ra-soat-regex.php` — dùng **token_get_all** (không dùng regex tìm regex), chỉ kiểm mẫu là hằng chuỗi TRỌN VẸN (theo sau là dấu phẩy; mẫu ghép bằng biến thì bỏ qua và đếm riêng), thử `preg_match()` thật rồi bắt `set_error_handler`. **Đã kiểm chứng bộ rà soát bằng file mồi** (bắt đúng `[\w-_]` và `[\d-x]`, bỏ qua đúng `[\w\-_]`, `[a-z]+`, `[\w-]`). Kết quả: **optimizer 193 mẫu — 0 lỗi, 0 mẫu dạng `[\w-x]`**; qcv-chat-assistant 15 mẫu — sạch. (Lần chạy đầu báo 10 lỗi nhưng **đều là báo nhầm của chính bộ rà soát** — nó chỉ lấy mảnh chuỗi đầu của mẫu ghép; đã sửa.)

**BÀI HỌC**: `[\w-]` (dấu - ở CUỐI lớp) là hợp lệ; `[\w-x]` (dấu - giữa lớp và ký tự) là lỗi PCRE2. Khi lỗi kiểu này xảy ra, `preg_match` trả `false` **im lặng** — không exception, không warning nếu có `@`.

## 2026-07-17 (tiếp 5) — Sửa chính chỗ gây thảm hoạ: 0.1.82
User gửi ảnh: site **PHP 7.2.34 vẫn chạy bình thường** nhưng health-check chấm **"Lỗi"** đỏ + cột Thao tác ghi **"Có thể dùng Smart Optimize"**. → **Nhóm đối chứng, xác nhận PCRE1 (PHP≤7.2) CHẤP NHẬN `[\w-_]`**.

**HAI LỖI UX ĐÃ GÂY RA THIỆT HẠI THẬT**:
1. `smart_optimize()` = `run_optimization_profile('yellow')` — **chỉ bật/tắt tuỳ chọn của chính plugin, KHÔNG đổi được PHP**. Nhưng cột Thao tác (`class-admin.php` ~1293) rơi vào **nhánh mặc định** `echo 'Có thể dùng Smart Optimize'` cho MỌI dòng không khớp điều kiện trước đó → mời dùng Smart Optimize cho việc nó bó tay.
2. PHP < 7.4 bị chấm **'fail'** dù site chạy tốt → chữ "Lỗi" đỏ đẩy user đi nâng PHP → PCRE2 → vỡ toàn bộ Media Grid.

**0.1.82 sửa**: (a) `check_php_version()` mới — PHP cũ = **'warning'** chứ không 'fail', ghi rõ "Website vẫn chạy bình thường — đây là khuyến nghị, không phải lỗi"; nếu `ban_js_composer_bi_loi()` → **"⚠️ ĐỪNG NÂNG PHP VỘI"** + bảo cập nhật WPBakery trước. (b) `class-audit.php:139` cũng đổi tương tự. (c) Cột Thao tác: thêm nhánh `'Môi trường' === $group` **TRƯỚC** các nhánh khác → PHP: "Đổi ở hosting — đọc kỹ Ghi chú trước"; WPBakery: "Cập nhật plugin WPBakery"; còn lại: "Cần cấu hình ở hosting". Dòng ngoài nhóm Môi trường vẫn mời Smart Optimize như cũ.

Kiểm chứng 4 tình huống thật: PHP7.2+bom→Cảnh báo+chặn nâng; PHP7.2+lành→Cảnh báo thường; PHP7.4+bom→Đạt; PHP8.1→Đạt. 5/5 assert đạt. ZIP: `outputs\qcv-origin-optimizer-0.1.82-gridfix.zip`.

**NGUYÊN TẮC RÚT RA**: đừng chấm 'fail' cho thứ đang chạy tốt; và **nếu biết trước một khuyến nghị sẽ phá cái gì thì phải nói ra NGAY TẠI CHỖ khuyến nghị**, trước khi user bấm — không phải sau khi web vỡ.

## 2026-07-17 (tiếp 6) — BẢNG SỨC KHOẺ LÀ ẢNH CHỤP CŨ. 0.1.83
User: "mau04 vẫn đang dùng PHP 7.2.34, không phải 7.4" + hỏi optimizer có ngầm giả định PHP 7.4 không.

**ĐO ĐƯỢC (2 câu trả lời dứt khoát cho user)**:
1. **Không bản optimizer nào từng ghi vào thư mục plugin** — bung & grep **17 bản ZIP** từ 0.1.58 → 0.1.83 tìm `file_put_contents|rename|unlink|copy` gần `js_composer|plugins/|PLUGIN_DIR`: **0 kết quả**. Optimizer chưa bao giờ có khả năng thay file js_composer.
2. **Optimizer không dùng cú pháp/hàm nào cần PHP > 7.2** — viết `outputs\ra-soat-php-moi.php` (quét `fn(`, `??=`, `[...$`, `?->`, `match(`, `enum`, `readonly`, + hàm 7.3/7.4/8.x). Optimizer: **0**. qcv-chat-assistant: 2 hit `match(` nhưng **đều là báo nhầm** (`QCV_Chat_Matcher::match()` — phương thức tên match). Bộ rà soát ban đầu cũng báo nhầm `fn(` trong chuỗi/chú thích → đã sửa bằng cách xoá nội dung T_CONSTANT_ENCAPSED_STRING/T_COMMENT trước khi quét (giữ số dòng).

**PHÁT HIỆN LỚN**: `class-admin.php:557,711` render bảng sức khoẻ từ `Health_Check::last()` = **`get_option(HEALTH_KEY)`** — **ẢNH CHỤP CŨ**, chỉ đổi khi ai đó bấm Smart Optimize. Nên dòng "PHP 7.2.34" trong ảnh user gửi **có thể đã vài tháng tuổi**. `generated_at` CÓ hiển thị ("Lần kiểm tra:" dòng 1182) nhưng user cắt ảnh sát nên không thấy — và cả tôi lẫn user đều đã suy luận sai dựa trên con số cũ đó.

**0.1.83**: `last()` giờ **luôn đọc lại tươi các mục nhóm 'Môi trường'** (PHP/WordPress/WebP/WPBakery — đều chỉ đọc hằng số + function_exists, rẻ như cho), thay vào chỗ mục cũ; các mục khác + `score` + `generated_at` giữ nguyên của lần chạy thật. Kiểm chứng 5/5 assert.

**CÒN TREO — CẦN USER XÁC NHẬN**: mau04 THẬT SỰ đang chạy PHP nào (WP Admin → Công cụ → Sức khoẻ trang web → Thông tin → Máy chủ)?
- Nếu **7.2.34 thật** → `[\w-_]` hỏng cả trên PCRE1 → **giả thuyết "nâng PHP làm vỡ grid" của tôi SAI** → phải gỡ cảnh báo "ĐỪNG NÂNG PHP" ở 0.1.82 và tìm nguyên nhân khác cho "trước đó không hỏng".
- Nếu **7.4** → giả thuyết đứng vững.
Không thử được PCRE1 tại máy: chỉ có PHP 7.4.25 (PCRE 10.35) và C:\xampp = PHP 8.2.12 (PCRE 10.40) — đều PCRE2.

## 2026-07-17 (tiếp 7) — GIẢI QUYẾT XONG grid + LỖI TÔI GÂY RA cho logo. 0.1.84
**GRID: 2 LỚP CHẶN ĐỘC LẬP — cả hai đều có thật, tôi cứ đuổi lớp này rồi bỏ lớp kia:**
- **Lớp 1 — PHP 7.4 (PCRE2)**: `[\w-_]` thành lỗi biên dịch → `failed_to_get_id` → grid chết với MỌI người. **Đã CHỨNG MINH bằng thực nghiệm của user**: gạt mau04 về PHP 7.2.34 → đo lại → `failed_to_get_id` từ 10 xuống **0**. → **PCRE1 CHẤP NHẬN `[\w-_]`, PCRE2 KHÔNG.** Giả thuyết PCRE ĐÚNG.
- **Lớp 2 — Tadu WAF chặn `vc_get_vc_grid_data`** cho khách ẩn danh → grid hiện khi ĐĂNG NHẬP (có cookie), mất khi ẨN DANH. Vẫn còn sau khi hạ PHP.
**Chứng minh dứt điểm**: gọi AJAX với **đúng tên tham số** (`data[shortcode_id]=…` dạng MẢNG như trình duyệt gửi, KHÔNG phải `vc_grid_data` cũng không phải chuỗi JSON — tôi sai 2 lần liên tiếp ở đây) + set cookie `__uip` vượt thử thách WAF → trả về **4581 byte, 3 `vc_grid-item`, ảnh áo dài thật**. Không cookie → WAF chặn.
**Vì sao chỉ Media Grid chết mà cả trang chủ WPBakery vẫn ổn**: chỉ `vc_media_grid` bắt buộc qua AJAX (template `vc_basic_grid.php` dòng ~50 chỉ preload cho `vc_basic_grid`). → **11 site kia (PHP 7.2, failed=0) VẪN mất Media Grid với khách ẩn danh vì WAF** — user không nhận ra vì luôn xem lúc đã đăng nhập.
**Bản vá 0.1.80+ chữa CẢ HAI LỚP** vì nó dựng server-side: không AJAX (thoát WAF) + không tra grid_id (thoát PCRE). **User xác nhận grid đã hiện.**

**LỖI TÔI GÂY RA — logo trắng**: `collect_derived_webp()` duyệt `array('.jpg','.jpeg','.png',…)` rồi `break` ở cái ĐẦU TIÊN. Trên mau04 có CẢ `logo.png` (RGBA, 53% trong suốt, CÓ logo) lẫn `logo.jpg` (RGB, **100% trắng**, bản bẹt nền — logo là chữ TRẮNG nên bẹt lên nền trắng là vô hình). Cả hai cùng sinh ra `logo.webp` → nút "Tạo lại WebP" của tôi lấy `.jpg` → `logo.webp` trắng tinh 0KB (Last-Modified 04:28 = đúng lúc nút chạy).
**0.1.84 sửa**: `chon_anh_nguon()` — xếp **PNG trước JPG**, và khi có nhiều ứng viên thì hỏi `_wp_attached_file` xem cái nào là **attachment thật** (`la_attachment()`); vẫn hoà thì lấy PNG + log `image_webp_nguon_nhap_nhang`. Kiểm chứng bằng **file thật tải từ mau04**: bản cũ chọn `logo.jpg` (tái hiện lỗi), bản mới chọn `logo.png`. 4/4 assert.
**Đã thử và BỎ**: đổi `imagealphablending(true→false)` — **đo ra KHÔNG khác gì** (cả hai đều 2688 byte RGBA 53% trong suốt); `imagesavealpha()` mới là thứ giữ nền trong. Giữ `false` cho đúng chuẩn nhưng **đã sửa chú thích** vì bản đầu tôi viết sai sự thật trong code.

**BÀI HỌC**: một tên `.webp` có thể có NHIỀU ảnh nguồn (`logo.png` + `logo.jpg` → cùng `logo.webp`). Không được vơ lấy cái đầu tiên.

## 2026-07-17 (tiếp 8) — XÁC NHẬN BẢN VÁ CHẠY + 2 lỗi hàng đợi. 0.1.85
**ĐO ĐƯỢC trên mau04 (ẩn danh, không cookie) sau khi user cài 0.1.84**:
- **3/3 Media Grid có 3 item dựng sẵn NGAY TRONG HTML** (ảnh áo dài thật) → **bản vá server-side CHẠY ĐÚNG**.
- **`failed_to_get_id` vẫn = 10** → mau04 **đã quay lại PHP 7.4** mà grid VẪN hiện → bản vá vô hiệu hoá **cả hai lớp** (PCRE + WAF) đúng như thiết kế. **User KHÔNG cần ở lại PHP 7.2.**
- **WAF vẫn chặn `vc_get_vc_grid_data` như cũ** — không ai "fix" nó cả; bản vá chỉ **không gọi AJAX nữa** nên WAF không còn chỗ chặn. (Phân biệt quan trọng: nếu sau này dùng grid có phân trang/load-more thì vẫn sẽ dính WAF.)
- `logo.webp` **đã sửa**: RGBA 53% trong suốt, Last-Modified 06:51 (sau khi cài 0.1.84) → `chon_anh_nguon()` chạy đúng.
- **mau01/mau03 có 0 `vc_media_grid`** → lo lắng trước đó của tôi rằng "11 site kia cũng mất media grid" là **SAI**: trang chủ chúng không dùng media grid.

**CÒN SÓT `logo-300x87.webp`** (RGB, bẹt trắng, Last-Modified 05:04 = CHƯA được tạo lại) → phơi ra **2 lỗi trong mã tôi**:
1. **Nút luôn quét lại TỪ ĐẦU**: `purge_and_rebuild_webp(null)` gọi `collect_derived_webp()` mới toanh. Vòng lặp có hạn chót nên mỗi lần bấm chỉ làm N ảnh ĐẦU → **đuôi hàng đợi không bao giờ tới lượt**. Cron có chạy tiếp `WEBP_QUEUE_KEY` nhưng **WP-Cron chỉ nổ khi có người truy cập, mà web mẫu thì vắng khách**. → Sửa: nếu còn hàng đợi thì **CHẠY TIẾP**, hết thì mới quét lại từ đầu.
2. **Hàng đợi cũ trỏ SAI nguồn**: `WEBP_QUEUE_KEY` nằm trong CSDL, được lập bởi mã 0.1.79–0.1.83 (vơ lấy `.jpg` đầu tiên) → khoá là `logo.jpg`. Chạy tiếp hàng đợi đó = **sinh lại logo trắng lần nữa**. → Sửa: **thẩm định lại nguồn bằng `chon_anh_nguon()` ngay lúc xử lý**, log `image_webp_sua_nguon`; hàng đợi cũ tự sửa, user không phải xoá gì.
`logo-300x87` cũng có đủ cặp: `.png` (RGBA 51% trong suốt, có logo) + `.jpg` (bẹt trắng) — đúng bẫy cũ.
Kiểm chứng 5/5: bản cũ tái hiện đúng cả 2 lỗi (anh3 không bao giờ tới lượt; logo sinh từ .jpg), bản mới sửa cả hai. ZIP: `outputs\qcv-origin-optimizer-0.1.85-logofix.zip`.

## 2026-07-17 (tiếp 9) — Tự chạy hàng đợi + WAF nằm ở đâu. 0.1.86-autorun
**Phản hồi user: "người dùng phải canh rồi bấm vài lần chứ nó không tự động chạy à, thế thì không hợp lý" — ĐÚNG.** Tôi đã đẩy việc của máy sang cho người. Nguyên nhân: phần dư hàng đợi trông chờ WP-Cron, mà **WP-Cron chỉ nổ khi CÓ NGƯỜI TRUY CẬP** — web mẫu vắng khách nên nằm đó mãi.
**0.1.86 sửa**: thêm `assets/admin.js` + endpoint `wp_ajax_qcv_origin_webp_step` (`check_ajax_referer` + `current_user_can('manage_options')`). Trình duyệt tự gọi từng lô cho tới khi `remaining=0`, có thanh tiến độ "còn N ảnh (đã xong X/Y)", nghỉ 1200ms giữa các lô để máy chủ còn phục vụ khách, **dừng hẳn sau 3 lỗi liên tiếp** (mất mạng/hết phiên) thay vì gọi mãi. Cron giữ làm lưới an toàn nếu user đóng tab. Ô hiển thị dùng `data-qcv-webp-left`; JS lint sạch (`node --check`).

**WAF Ở ĐÂU (user hỏi: đã bỏ hosting Tadu, sang nhà cung cấp khác, sao vẫn Tadu WAF?)**: đo lại — `mau04` phân giải ra **103.179.173.247 = CHÍNH máy DirectAdmin của họ**. Không có proxy từ xa. DirectAdmin báo "Apache 2.4.61 Running" nhưng web trả `Server: Tadu WAF 2.0.52` → **một MODULE Apache cài ngay trên máy đang ghi đè header**. Tức phần mềm WAF được cài trên server (Tadu bán/cấp phép cho các hosting VN), và **theo máy khi migrate**, chứ không phải Tadu đang đứng trước. → Họ có quyền admin DirectAdmin nên **tự kiểm tra/gỡ được**, không cần Tadu hỗ trợ.

**KHÔNG khuyến nghị lách WAF**: template có filter `vc_grid_request_url` (dòng ~60 `include/templates/shortcodes/vc_basic_grid.php`) cho phép đổi endpoint AJAX sang URL khác để luật WAF không khớp — NHƯNG luật đó nhiều khả năng chặn `vc_get_vc_grid_data` vì action này từng có lỗ hổng, mà js_composer của họ thì CŨ → lách = tự mở lại lỗ hổng. Bản vá server-side (0.1.80+) an toàn hơn vì **không phơi endpoint đó ra chút nào**. Cách đúng: cập nhật WPBakery, rồi mới xin nới luật nếu cần grid phân trang/load-more.

## 2026-07-17 (tiếp 10) — WAF đi theo bản clone server; nó KHÔNG phải blocklist bừa
User đoán: chuyển từ hosting Tadu sang nhà cung cấp mới, họ **clone nguyên server** nên WAF đi theo. **Khớp với mọi bằng chứng**: WAF là module Apache cài trên chính máy (mau04 → 103.179.173.247 = máy DirectAdmin của họ, không có proxy từ xa); DirectAdmin báo "Apache 2.4.61" nhưng header trả `Server: Tadu WAF 2.0.52` → module ghi đè header. Clone đĩa thì mang theo tất cả. Nhà cung cấp mới nhiều khả năng không biết nó tồn tại → **không ai bảo trì, luật không bao giờ cập nhật**.

**LUẬT WAF KHÔNG PHẢI BỪA — nó nhắm đúng các action từng có CVE**:
| action (admin-ajax) | kết quả |
|---|---|
| `heartbeat` | qua |
| `woocommerce_get_refreshed_fragments` | qua |
| **`woocommerce_add_to_cart`** | **BỊ CHẶN** |
| **`vc_get_vc_grid_data`** | **BỊ CHẶN** |
| `wc_ajax_add_to_cart`, `revslider_ajax_action`, `wpcf7_submit` | HTTP 400 (WordPress trả, không phải WAF) |

**SUÝT BÁO ĐỘNG NHẦM — đã kiểm tra và giỏ hàng KHÔNG hỏng**: WooCommerce thật sự dùng `/?wc-ajax=add_to_cart` (**qua được**), không dùng `admin-ajax.php?action=woocommerce_add_to_cart`. Đo thêm: trang chủ và trang danh mục đều có **`ajax_add_to_cart` = 0** (14 nút `add_to_cart_button` trên trang danh mục nhưng là **liên kết thường**, không gọi AJAX). → Luật chặn đó vô hại với các site này. **Bài học: đừng hô hoán trước khi kiểm đường mà phần mềm THẬT SỰ dùng.**

**KHUYẾN NGHỊ CUỐI**: đừng gỡ WAF, đừng lách WAF. Nó đang che đúng một lỗ hổng có thật (js_composer bản cũ). Thứ tự đúng: **cập nhật WPBakery** → lỗ hổng biến mất → lúc đó luật kia không còn che gì cần thiết nữa. Bản vá server-side (0.1.80+) đã cho grid chạy mà không cần đụng tới WAF.

## 2026-07-17 (tiếp 11) — TADU LÀ REVERSE PROXY CÓ CACHE TĨNH (T-Cache), không chỉ WAF
**Phát hiện lớn**: file tĩnh trên mau04 trả header **`T-Cache: Hit`**, KHÔNG có `Server`, KHÔNG có `Cache-Control`, KHÔNG có `Expires`. → **Tadu phục vụ file tĩnh từ cache riêng, Apache CHƯA TỪNG thấy request** → **toàn bộ khối "QCV Origin Optimizer Static Cache" trong .htaccess là VÔ TÁC DỤNG** (mọi `ExpiresByType`, `Header set Cache-Control ... immutable`, `Header unset ETag` đều không tới được trình duyệt cho file tĩnh). Trang HTML thì KHÔNG bị T-Cache (`Server: Tadu WAF`, T-Cache vắng).
**T-Cache bỏ qua MỌI cách phá cache**: `?x=<timestamp>` → Hit; `Cache-Control: no-cache` (F5) → Hit; `Pragma: no-cache` (Ctrl+F5) → Hit. Không bust được từ trình duyệt.
**NHƯNG nó CÓ theo dõi mtime**: logo.webp (06:51), logo-300x87.webp (07:53), logo-1-…-173x50.webp (07:58) đều được phục vụ bản MỚI ngay sau khi sinh lại → **T-Cache không phải thủ phạm phát bản cũ**.

**LỖI CỦA TÔI ĐÃ TỰ PHÁT HIỆN**: suốt nhiều lượt tôi dùng "không thấy header `X-Qcv-Origin-Cache`" làm bằng chứng "page cache không chạy". Grep ra: header thật tên **`X-QCV-Origin-Cache`**, do `cache_status_header()` đặt, mà **`Cache::init()` thoát ngay nếu `enable_cache` tắt** → cache tắt thì KHÔNG có header nào → "không thấy header" chứng minh được RẤT ÍT. May là kết luận vẫn đúng nhờ bằng chứng khác: **3 lần tải → 3 md5 khác nhau** (bản phục vụ từ cache phải giống hệt từng byte).

**ĐÃ LOẠI TRỪ cho lỗi "sửa xong F5 ra bản cũ"** (đo trên mau04): page cache của optimizer **TẮT**; HTML **sinh mới mỗi request**; T-Cache **theo dõi thay đổi**; WAF **KHÔNG chặn** `vc_save`/`vc_edit_form`/`vc_load_shortcode`/`wp_autosave` (HTTP 400 là WordPress trả vì chưa đăng nhập). → **Chưa tìm ra nguyên nhân phía server. Cần user nói rõ: site nào, sửa cái gì (chữ/màu/ảnh/cài đặt), đăng nhập hay ẩn danh.**

**LOGO ĐÃ SỬA XONG cả 3 bản** (RGBA, ~50% trong suốt, CÓ LOGO) — hàng đợi đã rút hết.

## 2026-07-17 (tiếp 12) — ⚠️ ĐÍNH CHÍNH LỚN: WAF VÔ TỘI. Tôi đuổi theo bóng ma nhiều lượt.
**BẰNG CHỨNG QUYẾT ĐỊNH**: **trang chủ mau04 CÓ SẴN đoạn thử thách** (`'__uip' in html` = **True**, `'function run(' in html` = **True**). → Trình duyệt thật tải trang chủ → JS chạy → **có cookie `__uip` TRƯỚC khi bất kỳ XHR nào bắn** → mọi lời gọi AJAX sau đó **QUA được**. **Chỉ python của tôi (không chạy JS) mới bị thử thách.** → **WAF CHƯA BAO GIỜ chặn grid với khách thật.** Toàn bộ chẩn đoán "Tadu WAF chặn `vc_get_vc_grid_data`" của tôi là **hiện vật do chính công cụ đo của tôi tạo ra**.
Bằng chứng phụ khớp: `waf_stats.json` **không có một sự kiện nào dính `admin-ajax`** (chỉ 95 "DDoS Protection" + 5 "Blacklisted User-Agent"); `strings` trên nhị phân **không tìm thấy** `vc_get_vc_grid_data`/`__uip`/`woocommerce_add_to_cart`. Nghĩa là **không hề có luật nào nhắm vào grid** — cái tôi gặp là **thử thách cookie chống bot**, và nó không được đếm là "chặn".
→ Lý do "woocommerce_add_to_cart bị chặn" cũng vậy: WAF chèn thử thách vào **response text/html** cho client không có cookie; `heartbeat` trả JSON nên không dính. **Không phải luật theo tên action.**

**HẬU QUẢ**: nguyên nhân THẬT của grid trống chỉ có MỘT — **PCRE2 (PHP 7.3+) làm `[\w-_]` hỏng** → `failed_to_get_id`. Đã chứng minh: PHP 7.4→7.2 thì failed_to_get_id 10→0. Bản vá server-side vẫn đúng (gỡ phụ thuộc PCRE), nhưng lý lẽ "nó còn thoát WAF" của tôi **dựa trên tiền đề sai**.

**tproxy — thông tin đã lấy được (vẫn hữu ích, họ sở hữu máy)**: `/usr/local/tproxy/tproxy --mode PROD`, giữ cổng 80+443, Apache ở 8080. **Supervisor quản lý**: `/etc/supervisord.d/tproxy.ini` (autostart/autorestart=true), dùng `supervisorctl restart tproxy` (KHÔNG phải systemctl). Log: `/var/log/tproxy.log`, `/var/log/tproxy.err.log`. Cache tĩnh: `/usr/local/tproxy/cache/`. Cấu hình `tproxy.conf` **265 byte, CÓ `disabled_rules` + `disabled_domains`** → cấu hình được (tôi từng nói sai là "không sửa được"). Thống kê từ 19/04/2026: 3.202.738 request, chặn 635.300 (DDoS 482.435 là chính).

**BÀI HỌC ĐẮT**: công cụ đo không chạy JS thì **không đại diện cho trình duyệt thật**. Trước khi kết luận "X chặn người dùng", phải hỏi: người dùng thật có đi qua đường này giống công cụ của mình không? Tôi đã để user tốn thời gian SSH vào server đuổi theo một nghi phạm vô tội.

## 2026-07-17 (tiếp 13) — 🔴 LỖI NẶNG NHẤT CỦA OPTIMIZER: cache HTML 30 NGÀY vào trình duyệt khách
**Đây là nguyên nhân THẬT của "sửa xong F5 ra bản cũ" — và của "một số người vào mau04 vẫn không thấy grid".**

**Bản 0.1.58 → 0.1.72** ghi vào .htaccess `ExpiresActive On` + `ExpiresDefault "access plus 1 month"` **KHÔNG có dòng miễn trừ `ExpiresByType text/html`** → Apache bảo mọi trình duyệt **giữ trang HTML 30 NGÀY**. **0.1.73 mới thêm** `ExpiresByType text/html "access plus 0 seconds"` + `Header always set Cache-Control "no-cache,must-revalidate,max-age=0"` cho text/html.

**ĐO ĐƯỢC bằng TRÌNH DUYỆT THẬT trên mau85** (python vô dụng cho việc này): điều hướng URL thường → `transferSize: **0**`, `deliveryType: **"cache"**` → **trình duyệt KHÔNG hề gọi ra mạng**. DOM 148.818 byte CÓ luật hỏng, trong khi **máy chủ trả về 129.588 byte KHÔNG có luật đó**. Thêm `?qcv_thu=987654` (khoá cache khác) → 138.980 byte, luật biến mất, thẻ từ **585px → 454px**. → F5 vô dụng vì trình duyệt coi bản lưu vẫn "còn hạn".

**QUÉT TOÀN DÀN (17/07)**: **mau01, 02, 05, 06, 07, 08, 09, 10, 11, 12 vẫn trả `Cache-Control: max-age=2592000` + `Expires` +30 ngày cho HTML** → **ĐANG gieo lỗi vào trình duyệt mọi khách ghé thăm ngay lúc này**. Chỉ mau03, mau04, mau82, mau85 đã sạch (`no-cache, must-revalidate, max-age=0`).

**LỖI THỨ HAI (bản cũ, đã bỏ từ 0.1.68)**: `.vc_gitem-zone,.vc-gitem-zone-height-mode-auto-4-3{aspect-ratio:4/3;}` — selector quét CẢ zone-c (vùng CHỮ), không chỉ zone ảnh → ép vùng chữ cao 377×3/4 = 282.5px trong khi chữ chỉ cần 175px → **dư 108px trắng mỗi thẻ**. Đã chứng minh trực tiếp trong trình duyệt: chèn `.vc_gitem-zone-b,.vc_gitem-zone-c{aspect-ratio:auto}` → zone-c 283→175px, thẻ 585→477px. Có trong 0.1.58–0.1.67, **0.1.68 đã bỏ**.

**KHÔNG CỨU ĐƯỢC từ máy chủ**: trình duyệt đã lưu thì không hỏi lại → không header nào với tới. Chỉ hết khi (lần tải cuối + 30 ngày), hoặc khách tự Ctrl+Shift+R, hoặc vào bằng URL có tham số (`?fbclid=`… → khoá cache khác → tươi).

**BÀI HỌC**: `ExpiresDefault` mà không miễn trừ text/html là **tự bắn vào chân ở quy mô toàn bộ khách truy cập**. Và: python KHÔNG thay được trình duyệt thật — `performance.getEntriesByType('navigation')[0].transferSize` mới là thứ chứng minh được cache trình duyệt.

## 2026-07-17 (tiếp 14) — CHỐT: thủ phạm là T-Cache của Tadu, khoá theo COOKIE. Đã xoá xong.
**BẰNG CHỨNG DỨT ĐIỂM (cùng URL, cùng UA Chrome, khác đúng một thứ — cookie)**:
| | T-Cache | byte | Cache-Control |
|---|---|---|---|
| KHÔNG cookie | miss | 129.588 | `no-cache, must-revalidate, max-age=0` |
| **CÓ cookie `__uip`** | **Hit** | **139.331** | **`max-age=2592000`** |
→ **Tadu CACHE CẢ TRANG HTML và chỉ phát bản cũ cho client CÓ cookie `__uip`** = **mọi trình duyệt thật** (trang chủ tự đặt cookie đó). python không bao giờ có cookie → luôn nhận bản tươi → **đó là lý do suốt buổi tôi báo "mọi thứ sạch" trong khi khách thật thấy bản cũ**. Ctrl+Shift+R vô dụng vì nó chỉ bỏ qua cache TRÌNH DUYỆT, request vẫn tới Tadu.
Đo bằng trình duyệt thật: `fetch(url,{cache:'reload'})` → vẫn `T-Cache: Hit`, vẫn bản cũ. `performance...transferSize=0, deliveryType='cache'` cho điều hướng thường.

**CHUỖI ĐẦY ĐỦ**: optimizer cũ (0.1.58–0.1.72) đặt `max-age=2592000` lên HTML → **Tadu tin và cất 30 ngày** → cập nhật plugin xong Tadu vẫn phát bản cũ → khách kẹt.

**ĐÃ XOÁ**: `rm -rf /usr/local/tproxy/cache/*` (~9MB, mỗi domain một thư mục con: mau03, mau04, mau05, mau101…). Sau khi xoá, mau85 trả `no-cache` cho client có cookie → **đã sửa**. **LỖI CỦA TÔI: tôi đặt lệnh xoá TRƯỚC rồi mới cảnh báo "phải update plugin trước"** → user xoá trước khi update → 10 site chạy bản cũ sẽ cache lại 30 ngày kể từ khách tiếp theo. Khắc phục: update rồi xoá lại.

**HAI LỖI ĐO CỦA TÔI (ghi để không lặp)**:
1. `grep 'gitem-zone-height-mode-auto-4-3'` trong HTML **bắt nhầm CLASS của WPBakery** (`class="... vc-gitem-zone-height-mode-auto-4-3 ..."` trên zone-a — hoàn toàn bình thường), chứ không phải luật CSS của tôi. Cột "luật hỏng" của tôi vô nghĩa. Phải tìm bằng regex `\.vc_gitem-zone[^{]*\{[^}]*aspect-ratio\s*:\s*4\s*/\s*3`.
2. Đo lại đúng cách: **cả 13 site đều SẠCH luật CSS 4/3** — nó chỉ tồn tại trong **bản HTML cũ nằm trong cache Tadu/trình duyệt**, không site nào còn phát ra nữa.

**HIỆN TRẠNG (17/07 sau khi xoá cache)**: mau03, mau04, mau82, mau85 → `no-cache` ✅. **mau01,02,05,06,07,08,09,10,11,12 → vẫn `max-age=2592000`** 🔴 cần cài 0.1.86 rồi xoá cache Tadu lần nữa. (mau85+mau82+mau04 hiện chạy 0.1.84, chưa phải 0.1.86.)

## 2026-07-17 (CHỐT) — mau85 ĐÃ THÔNG. Trạng thái cuối + việc còn lại
**Xác nhận bằng trình duyệt thật** (fetch `cache:'reload'`, cookie `__uip` thật): `T-Cache: miss`, 130.398 byte, **49 `vc_row`** → khối user vừa thêm ĐÃ tới khách. User xác nhận "đã nhận rồi".

**QUY TRÌNH ĐÚNG khi sửa nội dung mà không thấy đổi** (cache Tadu có **1 thư mục con mỗi domain** → xoá được riêng, không đụng site khác):
```bash
rm -rf /usr/local/tproxy/cache/<domain>/*      # xoá cache Tadu của riêng site đó
# rồi Ctrl+Shift+R (giờ mới có tác dụng, vì Tadu không còn bản cũ để đưa)
```
**KIỂM CHỨNG ĐÚNG CÁCH**: đừng đếm `vc_row`. Tìm thẳng chữ trong khối mới:
`curl -s -H 'Cookie: __uip=x' https://<site>/ | grep -c 'chữ trong khối mới'`

**HAI LỆNH TÔI ĐƯA SAI HÔM NAY (đừng lặp)**:
1. Đặt lệnh `rm -rf cache` TRƯỚC cảnh báo "phải update plugin trước" → user xoá sớm. **Cảnh báo phải nằm TRÊN lệnh.**
2. `grep -c vc_row` đếm **số DÒNG**, không phải số lần xuất hiện → user thấy 33 thay vì 49 và tưởng hỏng. Phải dùng `grep -o vc_row | wc -l`. **Tự chạy lệnh trước khi đưa.**

**CÒN LẠI (2 việc)**:
1. **16 site cần cài 0.1.86** rồi **mới** xoá cache Tadu từng site: mau01, 02, 05, 06, 07, 08, 09, 10, 11, 12, 13 (trả `max-age=2592000`) + **mau101, 102, 103, 104, 119** (tệ nhất — còn phát cả luật CSS 4/3 hỏng ⇒ bản ≤0.1.67).
2. **Tắt hẳn cache HTML của Tadu** để không phải SSH xoá sau mỗi lần sửa. Cần chạy:
   `strings /usr/local/tproxy/tproxy | grep -iE 'disabled_|cache|ttl|purge' | sort -u | head -40`
   Nếu lộ khoá kiểu `disabled_cache` → thêm vào `/usr/local/tproxy/tproxy.conf` → `supervisorctl restart tproxy`.

**0.1.84 vs 0.1.86**: 1.84 ĐỦ cho lỗi cache+grid (fix nằm ở 0.1.73 và 0.1.80). 1.85/1.86 chỉ sửa nút "Tạo lại toàn bộ WebP" (chạy tiếp hàng đợi thay vì quét lại từ đầu; tự sửa hàng đợi cũ trỏ nhầm `logo.jpg`; tự chạy có thanh tiến độ). → **Không cần nâng 3 site đang chạy 1.84.**

## 2026-07-17 — CÔNG CỤ KIỂM TRA + user quyết định thu hẹp phạm vi
User: "tập trung vào một số site thôi, test thật kỹ trước khi triển khai rộng" — **đúng, và là bài học lớn nhất hôm nay**: optimizer triển khai rộng trước khi kiểm kỹ, nên một dòng `ExpiresDefault` sai lan ra 20 site và cắm vào trình duyệt khách 30 ngày.

**ĐÃ TẠO `outputs\kiem-tra-site.py`** — gói toàn bộ lỗi tìm ra 17/07 thành kiểm tra tự động, chạy: `python kiem-tra-site.py <domain> [<domain>...]`. Kiểm 6 thứ: (1) header cache HTML có `no-cache` không (lỗi nặng nhất); (2) `T-Cache: Hit` → Tadu đang phát bản cũ; (3) luật CSS `aspect-ratio:4/3` (regex `\.vc_gitem-zone[^{]*\{[^}]*aspect-ratio\s*:\s*4\s*/\s*3` — **KHÔNG** dùng chuỗi `gitem-zone-height-mode-auto-4-3` vì đó là CLASS của WPBakery, bắt nhầm); (4) `failed_to_get_id` + đếm item → phân biệt "grid trống" với "bản vá đang che"; (5) webp xám (2 tầng, đối chứng ảnh nguồn để không kết tội oan logo/icon nền trơn); (6) logo bẹt trắng.
**LUÔN gửi cookie `__uip`** — Tadu khoá cache theo cookie đó; không gửi thì luôn nhận bản tươi và báo "sạch" trong khi khách thật xem bản cũ (sai lầm đã ngốn cả ngày 17/07).

**ĐÃ KIỂM CHỨNG CHÍNH CÔNG CỤ**: mau85 → "DẠT - sạch"; mau04 → 1 cảnh báo đúng ("10 grid failed_to_get_id NHƯNG có 126 item dựng sẵn → bản vá đang che; gốc: js_composer cũ + PHP 7.3+"); **mau101 → bắt đúng 2 lỗi** (cache 30 ngày + luật CSS 4/3); mau01 → bắt đúng 1 lỗi (cache 30 ngày). Không báo nhầm.

**GIỚI HẠN GHI RÕ TRONG CÔNG CỤ**: chỉ đọc HTML, grid dựng bằng JS → **phải mở cửa sổ ẩn danh kiểm tra bằng mắt** mới kết luận được. (Bài học: python không thay được trình duyệt thật.)

## 2026-07-17 — CHẤT LƯỢNG WEBP: tách webp_quality khỏi image_quality. 0.1.87
User: "webp giảm chất lượng quá nhiều; đã TẮT webp ở mau04 (1.84) mà chất lượng vẫn thế, hình như vẫn dùng webp".

**ĐO ĐƯỢC — user hiểu nhầm 2 chỗ, cả 2 đều do tôi chưa nói rõ**:
1. **mau04 KHÔNG còn dùng webp chút nào**: đo bằng trình duyệt → cả trang chỉ có **1 chuỗi `.webp`**, và **0** ở mọi vị trí ảnh (`<img src>`, `srcset`, `data-src`, CSS `background-image`, `<source>`, `<style>`, RevSlider `data-*`). Tắt WebP CÓ tác dụng hoàn toàn. → chất lượng kém **không phải do webp**.
2. Ảnh JPG đang phục vụ vốn đã nén sẵn: `20251231_h789P7nH-scaled.jpg` 2560×973 chỉ **0.115 byte/px**; trong khi `20251204_Y07Js77Y.jpg` (ảnh TÔI khôi phục từ backup) là **0.886 byte/px, ~q95**. `-scaled.jpg` do **WordPress** tự tạo ở `jpeg_quality`=82 khi upload >2560px — **optimizer KHÔNG hook `jpeg_quality`** (đã grep: `set_quality()` chỉ ở 2 chỗ — nhánh resize và nhánh tạo webp).

**LỖI THẬT CỦA OPTIMIZER (đã sửa)**: `image_quality`=82 được dùng CHUNG cho cả JPEG resize lẫn WebP. **82 của JPEG ≠ 82 của WebP** — WebP nén mạnh tay hơn nhiều ở cùng con số. **Đo trên ảnh slider Dottie thật (1024px)**: JPEG q95 gốc = 173KB · **WebP q82 = 72KB, PSNR 37.2dB (thấy rõ mất nét)** · WebP q85 = 83KB/38.2dB · WebP q88 = 98KB/39.3dB · **WebP q90 = 111KB, PSNR 40.0dB (rất khó phân biệt), vẫn nhẹ hơn gốc 36%**.

**0.1.87**: thêm `webp_quality()` (mặc định **90**, chặn 1..100), tách khỏi `image_quality`. Chuyển **4 đường sinh webp** sang dùng nó (`optimize_attachment`→`create_webp_variants`, folder-scan ~442, `scan_uploads_for_webp` ~650, `purge_and_rebuild_webp` ~1654); **đường thu nhỏ JPEG VẪN dùng `image_quality`**. Kiểm chứng 8/8 assert + đếm: chỉ còn **1** chỗ dùng `$settings['image_quality']` (đúng = nhánh resize JPEG). Admin: 2 ô riêng + ghi chú "hai con số không cùng thang đo" + nhắc bấm ♻ Tạo lại WebP sau khi đổi (ảnh webp cũ KHÔNG tự làm mới — chốt `file_exists()`).
ZIP: `outputs\qcv-origin-optimizer-0.1.87-webpquality.zip`.

## 2026-07-17 — User bắt được lỗi thật: nút Khôi phục xoá webp mà KHÔNG sinh lại. 0.1.88
User: "ảnh trong backup chất lượng cao hơn, giờ tạo lại webp cũng chả ăn thua gì?" → **ĐÚNG**: webp sinh TỪ file gốc đang nằm trên đĩa; gốc đã nén 0.115 byte/px thì webp để mức 100 cũng vô ích. **Thứ tự bắt buộc: KHÔI PHỤC ảnh gốc TRƯỚC → rồi mới TẠO LẠI webp.**

**LỖI THẬT PHÁT HIỆN KHI KIỂM TRA CÂU HỎI ĐÓ**: `restore_all_from_backup()` gọi `purge_webp_files()` **xoá sạch webp**, rồi chỉ xếp vào `REBUILD_KEY` → `cron_rebuild()`. Nhưng `cron_rebuild()` **bật cờ `$dang_dung_lai = true`** (để ảnh vừa khôi phục không bị `optimize_upload` thu nhỏ lại ngay) → **chặn luôn việc sinh webp**. Kết quả: **webp bị xoá mà không có gì sinh lại**, trong khi URL webp nằm sẵn trong CSDL → **ảnh 404 toàn site**. Nếu user bấm nút Khôi phục là web mất ảnh.
**0.1.88 sửa**: thêm `$webp_cho[$file] = array()` (mảng rỗng = không xoá gì nữa, chỉ sinh mới) → ghi vào **`WEBP_QUEUE_KEY`** + hẹn `WEBP_HOOK` +30s → bộ tự chạy của 0.1.86 (admin.js) sẽ sinh lại webp ngay. **Hai hàng đợi làm hai việc khác nhau, phải xếp vào CẢ HAI**: `REBUILD_KEY` = dựng lại kích thước phái sinh (-1024x389.jpg); `WEBP_QUEUE_KEY` = sinh lại webp. Kiểm chứng 7/7 assert trên mã thật.

**Giới hạn phải nói với user**: chỉ ảnh CÓ backup mới khôi phục được (`backup_original()` chỉ chạy khi `width > image_max_width` → mau04 chỉ có 8). Ảnh `-scaled.jpg` 0.115 byte/px do **WordPress** tạo (jpeg_quality=82 khi upload >2560px), optimizer không đụng → **không có backup → chỉ upload lại ảnh gốc mới cứu được**, hoặc nâng `image_max_width` lên 2560 để WP bớt thu nhỏ.
ZIP: `outputs\qcv-origin-optimizer-0.1.88-webpquality.zip`

## 2026-07-17 — MINH OAN cơ chế backup: ảnh gốc VỐN ĐÃ q82. Tôi đo sai lần đầu.
User lập luận: "tất cả site mẫu đều có ảnh gốc trước, không cập nhật gì, chỉ chạy optimizer — optimizer có backup thì phải còn chứ" → **ĐÚNG, và kết luận ngược lại điều tôi tưởng.**

**LỖI ĐO CỦA TÔI**: dùng **byte/pixel** để đánh giá chất lượng → **vô nghĩa khi so giữa các ảnh KHÁC NHAU** (ảnh nền phẳng nén nhẹ hơn ảnh chi tiết dù cùng quality). Tôi đã kết luận "-scaled.jpg chất lượng xấu" chỉ vì nó 0.115 byte/px.
**THƯỚC ĐO ĐÚNG**: đọc **bảng lượng tử hoá (quantization table)** trong file JPEG — nằm trong file, **độc lập với nội dung ảnh**. Hiệu chuẩn bằng cách nén cùng 1 ảnh ở các mức đã biết: q60→7347, q70→5495, q75→4638, q80→3698, **q82→3326**, q85→2775, q90→1846, q95→927, q100→128.

**KẾT QUẢ ĐO**: cả 3 file `-scaled.jpg` đều có tổng bảng = **3326 = ĐÚNG KHÍT q82**. Và **ẢNH GỐC (không có `-scaled`) VẪN CÒN và CŨNG q82**: `20251106_NP9S6TV0.jpg` 3586×1364 q82 · `20251119_VGo5RHny.jpg` 4098×1558 q82 · `20251231_h789P7nH.jpg` 3123×1187 q82. WordPress **giữ nguyên ảnh gốc byte-for-byte**, không nén lại → **ảnh ĐÃ LÀ q82 TỪ LÚC UPLOAD** (người thiết kế xuất ra như vậy).
→ **Không có backup vì optimizer CHƯA TỪNG sửa mấy file này** (chúng vẫn 2560px; nếu optimizer đụng thì đã thu về `image_max_width`=1920). **Cơ chế backup nguyên vẹn.** (Ảnh `20251204_Y07Js77Y.jpg` q~100 là ca riêng — ảnh đó vốn được upload ở q100.)

**OPTIMIZER CÓ LÀM GIẢM CHẤT LƯỢNG — nhưng ở chỗ khác: NÉN HAI LẦN.** Nguồn đã q82, optimizer nén thêm lần nữa thành WebP q82. Đo trên ảnh thật (`20251106_NP9S6TV0-scaled.jpg` → 1024px), PSNR so với chính ảnh nguồn q82: **WebP q82 = 90KB / 37.6dB (mất thêm RÕ)** · q85 = 99KB/38.7dB · **q90 = 126KB/41.2dB** · q95 = 171KB/44.4dB. → **0.1.88 đặt mặc định 90 là đúng liều**: chặn được phần lớn mất mát lần hai mà vẫn nhẹ hơn JPEG q95 (199KB).

**TRẢ LỜI CHO USER**: tắt webp xong "chất lượng vẫn thế" là **ĐÚNG** — q82 JPEG chính là chất lượng nguồn, không gì làm tốt hơn được. Muốn nét hơn thật sự thì phải **upload ảnh gốc chất lượng cao hơn**; optimizer chỉ có thể **đừng làm tệ thêm** (webp 90).

**BÀI HỌC**: đừng đánh giá chất lượng ảnh bằng byte/pixel giữa các ảnh khác nhau. Đọc bảng lượng tử hoá.

## 2026-07-17 — CHỨNG MINH: optimizer nén ĐÚNG MỘT LẦN. Sửa bẫy tự phá khôi phục. 0.1.89
**User hỏi: "chạy optimizer nhiều lần thì mỗi lần lại tự nén lại → ảnh gốc mất luôn?"** → **KHÔNG.** Tái hiện đúng logic `optimize_attachment()` trên ảnh THẬT của mau04 (2049px), chạy 3 lần:
| lần | kích thước | bảng lượng tử | md5 |
|---|---|---|---|
| gốc | 2049×779 | **264** (q~100) | 0c843e45 |
| **1** | 1920×730 | **3326** (q82) | d9c075fc ← **có nén lại** |
| 2 | 1920×730 | 3326 | d9c075fc ← **bỏ qua, y hệt** |
| 3 | 1920×730 | 3326 | d9c075fc ← **bỏ qua, y hệt** |
→ Sau lần 1, `width == max` nên điều kiện **`width > max` thành SAI** → không đụng vào file nữa. **KHÔNG có xuống cấp tích luỹ.** Backup (chụp TRƯỚC lần resize đầu tiên) chính là ảnh gốc của gốc, vẫn nguyên.
**NHƯNG dòng đầu chứng minh: optimizer ĐÃ hạ q100 → q82** với các ảnh rộng hơn max. Với 8 ảnh có backup ở mau04, đúng là optimizer làm giảm chất lượng thật.

**BẪY TỰ PHÁ (đã sửa ở 0.1.89)**: `restore_all_from_backup()` **xoá cờ `_qcv_origin_image_optimized`** → ảnh thành "chưa xử lý" → ảnh khôi phục rộng lại như gốc (2049 > max 1920) → **lần cron kế tiếp resize + nén q82 y hệt cũ** → user quay về vạch xuất phát mà không hiểu vì sao. Tôi tự phá công khôi phục của chính mình. **0.1.89: GIỮ NGUYÊN cờ, tuyệt đối không xoá** — ảnh khôi phục được để yên; webp vẫn có nhờ `WEBP_QUEUE_KEY` riêng (thêm ở 0.1.88).
Thêm cảnh báo ngay trong hộp confirm của nút Khôi phục: đọc `image_max_width` hiện tại và nhắc "ảnh gốc thường rộng hơn mức này — nếu sau này bấm tối ưu ảnh thủ công chúng sẽ bị nén lại; muốn giữ vĩnh viễn hãy nâng Chiều rộng ảnh tối đa trước". (`$settings` CÓ trong `render_overview()` ở dòng 751 — grep của tôi bỏ sót vì khoảng trắng, không phải lỗi.)

**QUY TRÌNH ĐÚNG cho user**: (1) nâng `image_max_width` lên ≥ chiều rộng ảnh gốc (vd 2560) HOẶC tắt `enable_image_optimize` → (2) bấm **↺ Khôi phục toàn bộ ảnh gốc** → (3) đặt `webp_quality`=90 → (4) bấm **♻ Tạo lại toàn bộ ảnh WebP** → (5) xem bằng mắt ở cửa sổ ẩn danh. **Bỏ bước 1 là bước 2 vô nghĩa.**
ZIP: `outputs\qcv-origin-optimizer-0.1.89-restore.zip`

## 2026-07-17 — CHỐT HẲN VẤN ĐỀ CHẤT LƯỢNG ẢNH: nguồn khách giao VỐN LÀ q82
So ảnh mau04 với **ảnh gốc khách giao** ở `D:\dev\qcv-builder\goi-du-lieu-khach.mau04\hinh-anh\slider\`:
| local | kích thước | quality |
|---|---|---|
| 1.jpg | 1920×750 | **q82** |
| 2.jpg | 2049×779 | **q100** ← DUY NHẤT |
| 3.jpg | 2560×974 | q82 |
| 4.jpg | 2560×973 | q82 |
| 5.jpg | 2560×973 | q82 |
| 24 ảnh `san-pham/` | | **q82 toàn bộ** |

**SO TỪNG BYTE (md5) — mau04 KHỚP KHÍT bản gốc khách giao**: `20251204_Y07Js77Y.jpg`=**2.jpg** (0c843e45) · `20251106_NP9S6TV0-scaled.jpg`=**3.jpg** (25739df9) · `20251119_VGo5RHny-scaled.jpg`=**5.jpg** (47fd503c) · `20251231_h789P7nH-scaled.jpg`=**4.jpg** (1c376d75).
→ **Ảnh trên mau04 ĐANG Ở CHẤT LƯỢNG TỐI ĐA CÓ THỂ** — bằng đúng bản khách giao, không suy suyển một byte. (Các file `*.jpg` không `-scaled` trên server có md5 khác vì đó là bản WP giữ lại của lần upload gốc trước khi tạo `-scaled`.)
→ Ảnh `2.jpg` (q100) từng bị optimizer hạ xuống q82, nhưng **ĐÃ khôi phục xong** — md5 trên mau04 trùng khít bản local q100.

**KẾT LUẬN CUỐI**: **q82 là TRẦN, do khách xuất file ở mức đó.** Không nút khôi phục, không tham số, không công cụ nào vượt được nguồn. Optimizer/WordPress/WebP đều KHÔNG làm hỏng mấy ảnh này. Chỗ optimizer THẬT SỰ làm giảm chất lượng là **nén lần hai thành WebP q82** → 0.1.89 đặt `webp_quality`=90 chặn được phần lớn.
**Muốn nét hơn: BẮT BUỘC phải có ảnh nguồn tốt hơn** (yêu cầu khách/thiết kế xuất q95+). Không có đường nào khác.

## 2026-07-17 — "Viết module tăng độ nét?" → ĐÃ THỬ, ĐO RA PHẢN TÁC DỤNG. Nhưng tìm ra lỗi thật. 0.1.90
**Không thể khôi phục chi tiết đã mất** (JPEG q82 vứt bỏ vĩnh viễn tần số cao). AI upscale cần GPU, không chạy nổi trên shared hosting.

**LỖI THẬT TÌM RA**: đo thu nhỏ 2049px→1024px trên ảnh slider Dottie, độ nét = phương sai Laplacian:
| cách | độ nét | PSNR vs Lanczos |
|---|---|---|
| PIL/Imagick **Lanczos** | **1226** | mốc |
| **GD `imagecopyresampled`** | **878 (−25%)** | 38.75 |
→ Và **`create_responsive_webp_files()` LUÔN gọi thẳng `create_resized_webp_file_with_gd()`** (dòng 255 cũ) — **không bao giờ dùng Imagick dù máy có cài**. Trong khi `optimize_attachment` (dòng 83) và `maybe_create_webp_file` (dòng 276) thì CÓ dùng `wp_get_image_editor`. **Mà chính các bản `-qcv-480/768/1024/1366` mới là thứ trình duyệt tải về** → khách luôn nhận ảnh mềm hơn 25%.
**0.1.90 sửa**: thêm `create_resized_webp()` — thử `wp_get_image_editor()` trước (Imagick→Lanczos), chỉ lui về GD khi không có/lỗi. Ghi file tạm→`finalize_written_image()`→rename như các đường khác.
Thêm mục health-check "Imagick (ảnh thu nhỏ nét hơn)" — `extension_loaded('imagick') && class_exists('Imagick')`; nếu thiếu → cảnh báo "nhờ hosting cài phần mở rộng PHP imagick là ảnh nét lên ngay".

**ĐÃ THỬ VÀ BỎ — làm nét bằng GD `imageconvolution`** (nhân 3×3, tổng=1): PSNR so với Lanczos — GD trần **38.75dB**; a=0.10→**38.12** (−0.64); a=0.15→35.87 (−2.88); a=0.20→33.80; a=0.25→32.06 (−6.69); a=0.35→29.31. **MỌI liều đều XẤU ĐI** vì nhân 3×3 khuếch đại nhiễu + vết nén JPEG. (Unsharp mask THẬT dựa trên mờ Gauss thì tốt — PIL USM r=0.8 p=25 cho độ nét 1173≈Lanczos 1226 và PSNR **39.51 > 38.75** — nhưng GD không có sẵn, viết tay trong PHP quá chậm cho hàng loạt.) → **KHÔNG viết module làm nét.**

**BÀI HỌC**: đo "độ nét" bằng phương sai Laplacian là chưa đủ — làm nét quá tay cho độ nét CAO HƠN cả Lanczos mà ảnh lại XẤU đi. Thước đo đúng: **PSNR so với bản Lanczos chuẩn** (làm nét đúng liều thì PSNR TĂNG, quá liều thì GIẢM).
ZIP: `outputs\qcv-origin-optimizer-0.1.90-sharper.zip`

## 2026-07-17 — ⚠️ ĐÍNH CHÍNH LỚN: khuyến nghị webp_quality=90 của tôi LÀM WEB CHẬM HƠN
User hỏi "để webp_quality=100 luôn cho đỡ nghĩ, có kém hơn JPEG q82 không?" → đo ra kết quả **lật ngược khuyến nghị 0.1.88 của tôi**.

**MỐC PHẢI THẮNG**: bản JPEG q82 mà WordPress phục vụ nếu KHÔNG dùng webp. Đo trên ảnh THẬT (`3.jpg`, nguồn q82, thu nhỏ 1024px): **JPEG q82 = 105 KB**.
| WebP | KB | vs JPEG q82 | PSNR |
|---|---|---|---|
| q82 | 90 | **−14%** | 37.6 |
| **q90** | **126** | **+20% NẶNG HƠN** | 41.2 |
| q95 | 171 | +63% | 44.4 |
| **q100** | **213** | **+103% GẤP ĐÔI** | 46.3 |
| lossless | 467 | +347% | 99 |

**→ webp_quality=90 (mặc định tôi đặt ở 0.1.88) khiến file NẶNG HƠN JPEG 20% → web CHẬM HƠN là không dùng webp.** Đặt 100 thì nặng gấp đôi.

**LÝ DO GỐC**: WebP chỉ thắng khi **ảnh NGUỒN còn tốt**. Nguồn của QCV đã q82 (khách xuất vậy) → WebP phải mã hoá lại một ảnh đã mất chi tiết, lợi thế nén biến mất. Kiểm chứng cả trên nguồn q100 (`2.jpg`): JPEG q82=84KB · WebP q82=72KB (−14%) · q90=111KB (+33%) · q95=159KB (+90%) → **cùng một hình dạng**: chỉ q82 mới nhẹ hơn, và chỉ 14%.

**KHUYẾN NGHỊ ĐÚNG cho dàn site QCV (nguồn q82)**:
- **WebP gần như VÔ ÍCH**: q82 nhẹ hơn 14% nhưng mất nét thấy rõ (37.6dB); q90+ thì nặng hơn JPEG.
- **Việc user TẮT WebP ở mau04 là ĐÚNG.** JPEG q82 vừa nét nhất vừa nhẹ.
- WebP chỉ đáng bật khi khách giao ảnh **q95+**.
→ Cần sửa mặc định `webp_quality` (0.1.88 đặt 90) và/hoặc cảnh báo trong admin: "nguồn đã nén sẵn thì WebP không lợi".

**BÀI HỌC**: đo PSNR mà quên đo KÍCH THƯỚC so với phương án thay thế = tối ưu sai mục tiêu. Chất lượng cao hơn mà file to hơn thì đó không phải "tối ưu", đó là bỏ luôn lý do dùng WebP.

## 2026-07-17 — 🔴 TÌM RA: CHÍNH TÔI làm ảnh mất nét sáng nay (q90→q82). 0.1.91
User nói 2 lần "ảnh không nét như cũ dù đã tắt WebP". Tôi bác bỏ 2 lần vì chỉ kiểm **ẢNH GỐC** (đúng là nguyên vẹn, md5 khớp bản khách giao). **Tôi không kiểm thứ đang HIỂN THỊ.**

**BẰNG CHỨNG (so backup tháng 6 ở `D:\dev\qcv-builder\mau04-anh-slider-phuc-hoi\` với mau04 hiện nay)**:
| file | backup T6 | mau04 nay |
|---|---|---|
| `20251204_Y07Js77Y.jpg` (gốc) | q~100 1381KB | q~100 1381KB — y hệt |
| `-scaled.jpg` | q~82 280KB | q~82 280KB — y hệt |
| **`-768x292.jpg`** ← **ĐANG HIỂN THỊ** | **q~90, 61KB** | **q~82, 46KB** ← **TÔI LÀM HỎNG** |

**NGUYÊN NHÂN**: sáng nay `restore_all_from_backup()` xếp hàng `REBUILD_KEY` → `cron_rebuild()` gọi **`wp_generate_attachment_metadata()`** → WordPress dựng lại MỌI kích thước phái sinh ở **`jpeg_quality` mặc định = 82**. Site QCV dựng từ trước **WordPress 4.5** (bản đó hạ mặc định 90→82) nên ảnh vốn là **q90**. → Tôi nén lại toàn bộ ảnh hiển thị của khách.
**Kiểm chứng cách sửa**: dựng lại `-768x292` từ ảnh gốc — q82 → 48KB/độ nét 1366; **q90 → 69KB/1425 = KHỚP bản cũ (61KB/1416)**.

**0.1.91 sửa**:
- Hook **`jpeg_quality` + `wp_editor_set_quality` ở priority 99** → `chat_luong_jpeg_wp()` đọc setting **`wp_jpeg_quality` (mặc định 90)**; đặt 0 = trả về mặc định WP. Hook đặt **TRƯỚC mọi return sớm** trong `init()`.
- **`queue_rebuild_all()`** + nút **"↻ Dựng lại kích thước ảnh (nét như cũ)"** — xếp hàng mọi attachment jpeg/png vào `REBUILD_KEY`.
- **`image_max_width` mặc định 1920 → 2560** (bằng ngưỡng `-scaled` của WP) để optimizer thôi thu nhỏ + nén lại thứ WP đã xử lý xong — chính là thứ đã hạ `2.jpg` q100→q82.
- Admin: ô `wp_jpeg_quality` đặt ĐẦU TIÊN + ghi chú "đây là con số đáng quan tâm nhất"; thêm cảnh báo WebP nguồn-đã-nén-thì-không-lợi.
- Kiểm tra bẫy: cờ `$dang_dung_lai` **KHÔNG** chạm tới filter `jpeg_quality` → filter vẫn chạy trong `cron_rebuild()`. 13/13 assert.

**QUY TRÌNH ĐƯA ẢNH VỀ NHƯ TRƯỚC**: cài 0.1.91 → `wp_jpeg_quality`=90 (mặc định sẵn) → bấm **↻ Dựng lại kích thước ảnh** → xong. Ảnh gốc không bị đụng.

**BÀI HỌC ĐẮT NHẤT NGÀY**: người dùng nói "không nét như cũ" **hai lần**, tôi bác bỏ cả hai vì đo **sai đối tượng** (ảnh gốc thay vì ảnh hiển thị). Khi user khăng khăng về thứ họ NHÌN THẤY, phải đo đúng thứ họ nhìn thấy.

## 2026-07-17 (CUỐI NGÀY) — Preload gắn cứng webp + CSS admin vỡ. 0.1.92
**User chỉ đúng chỗ**: "có link sản phẩm gắn cứng vào webp chứ không phải fallback". **ĐÚNG** — `class-resource-optimizer.php:480` sinh
`<link rel="preload" as="image" href="....webp" fetchpriority="high">` **VÔ ĐIỀU KIỆN**, không kiểm `enable_webp_delivery`. Khi user TẮT WebP: `<img>` giữ `.jpg` (13.8KB) còn preload vẫn `.webp` (6KB, tồn tại thật, HTTP 200) → **trình duyệt tải CẢ HAI, dùng một**. **0.1.92 sửa**: chỉ dùng URL webp khi `setting_enabled('enable_webp_delivery')`.
**CSS admin vỡ** (thấy trong ảnh user gửi): `.qcv-kpi strong { display:block; font-size:24px }` — luật dành cho CON SỐ KPI (53/61) nhưng quét MỌI `<strong>` bên trong, kể cả trong ghi chú → mỗi chữ nhấn mạnh phình thành tiêu đề 24px. Thêm `.qcv-kpi-note strong/code/em { display:inline; font-size:inherit; ... }`.

**VÙNG XÁM — đã truy xong (4/55 ảnh)**: 3 ảnh có **ẢNH GỐC CŨNG XÁM** (`0d0710...` 1365×2048 28% · `0t1176...` 1300×1950 68% · `0t1178...` 1300×1950 39%) → **KHÔNG có backup** vì rộng 1300–1365 < `image_max_width` 1920 nên optimizer chưa từng resize/backup chúng. **Lệnh "Dựng lại" của tôi KHÔNG tạo ra xám** — chỉ sao chép trung thực chỗ hỏng có sẵn. 1 ảnh (`0t1187...`) gốc lành → dựng lại được.
**Gói ảnh gốc khách giao (`san-pham/`, 24 file) đều 683×1024, 0% xám** — tên và kích thước KHÁC hẳn 3 ảnh xám → 3 ảnh đó **không nằm trong gói**, upload từ nguồn khác → **chỉ có thể xin khách gửi lại**.

**Nút "Khôi phục toàn bộ ảnh gốc (8)" bấm không thấy khác gì = ĐÚNG**: 8 ảnh đó đã được khôi phục từ trước, file hiện tại == bản backup → ghi đè bằng chính nó → không đổi. Không phải lỗi.

**User yêu cầu: "Đừng cố tối ưu ảnh nữa, để làm sau"** — dừng mọi việc tối ưu ảnh; chỉ khôi phục + trả link về jpg.
ZIP: `outputs\qcv-origin-optimizer-0.1.92-jpg.zip`

## 2026-07-17 — Nút "Dựng lại kích thước" KHÔNG CHẠY. Tôi lặp lại đúng lỗi đã sửa. 0.1.93
User: "bấm không thấy gì thay đổi, 53/61 đứng im, ảnh hỏng vẫn hỏng, bạn tự vào kiểm tra đi" → **tự đo và user ĐÚNG**.

**LỖI THẬT**: `queue_rebuild_all()` đổ ảnh vào `REBUILD_KEY` rồi **chỉ trông chờ `REBUILD_HOOK` của WP-Cron**. **KHÔNG có endpoint ajax nào cho hàng đợi này** — `admin.js` chỉ tự rút hàng đợi **WebP** (`qcv_origin_webp_step` / `data-qcv-webp-left`). WP-Cron chỉ nổ khi có khách → web mẫu vắng → hàng đợi nằm im ở 61. **Đây ĐÚNG cái bẫy tôi đã phát hiện và sửa cho WebP ở 0.1.86, rồi QUÊN áp dụng cho chính nút mình vừa viết ở 0.1.91.**
**Bằng chứng đo được**: `0d0710...-683x1024.jpg` Last-Modified **11:34** (sau khi user bấm → cron nổ vài lần nhờ user truy cập) nhưng `0t1187...-330x330.jpg` vẫn **06:51** — chưa hề được dựng lại, dù **ảnh gốc của nó SẠCH 0% xám**.
**0.1.93 sửa**: thêm `wp_ajax_qcv_origin_rebuild_step` → `ajax_rebuild_step()` gọi `cron_rebuild()` rồi trả `rebuild_pending()`; viết lại `assets/admin.js` thành hàm `rut(action, thuoc, nhãn)` dùng chung, rút **CẢ HAI** hàng đợi (`data-qcv-rebuild-left` + `data-qcv-webp-left`); gắn `data-qcv-rebuild-left` vào ô KPI.

**VÙNG XÁM — kết luận cuối (tự đo)**: `0d0710...` ảnh GỐC **28% xám** (07:08) → dựng lại bao nhiêu lần cũng xám, **vô phương**. `0t1187...` ảnh gốc **0% xám** → **0.1.93 sẽ sửa được**. 2 ảnh còn lại (`0t1176`, `0t1178`) không tải được lúc đo lại — cần kiểm lại sau.

**GIAO DIỆN VỠ**: `admin.css` **trên mau04 ĐÃ CÓ bản sửa** (`.qcv-kpi-note strong` = True, Last-Modified 11:25) → user thấy vỡ là do **trình duyệt họ giữ CSS cũ** → chỉ cần Ctrl+Shift+R trong wp-admin. `admin.js` trên server vẫn bản cũ 07:30 (2365 byte) vì 0.1.93 chưa cài.
ZIP: `outputs\qcv-origin-optimizer-0.1.93-chay-that.zip`
