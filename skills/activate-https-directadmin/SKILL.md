---
name: activate-https-directadmin
description: Kích hoạt HTTPS (Let's Encrypt) + HTTP/2 + force redirect cho một website WordPress trên hosting DirectAdmin (hệ QCV, sau Tadu WAF). Dùng khi cần bật SSL/HTTPS/chuyển http sang https cho một site mauXX (hoặc bất kỳ domain nào) trên DirectAdmin 103.179.173.247:4444. Bao gồm cấp cert, sửa wp-config, force redirect và verify toàn diện.
---

# Kích hoạt HTTPS cho một site trên DirectAdmin (hệ QCV)

Quy trình đã kiểm chứng trên `mau21` và `mau22`. Mục tiêu: site đang **http** → có **HTTPS hợp lệ + HTTP/2 + tự chuyển http→https**, không loop, không mixed-content, không fatal.

Thời gian: ~5–10 phút/site. Rủi ro thấp (reversible).

## Thông tin cần trước khi bắt đầu

- **DirectAdmin**: `http://103.179.173.247:4444/` — user `admin`, mật khẩu do người dùng cung cấp (không lưu vào file). Mỗi site là 1 user tên `mauXX` (mau1..mauNN); domain là `mauXX.thuvienwebqcv.vn`.
- Đặt biến để dùng lại: `DOMAIN=mauXX.thuvienwebqcv.vn`, `USER=mauXX`.
- Trình duyệt cần **claude-in-chrome extension đã kết nối** (kiểm tra bằng `list_connected_browsers`). Nếu chưa, nhờ người dùng mở Chrome + kết nối.
- Lưu ý: `file_upload` của trình duyệt bị chặn; mọi thao tác trong DirectAdmin làm qua UI/JS. Curl để verify chạy tốt (trừ khi WAF đang challenge — xem Gotchas).

## Trình tự thao tác

### B1 — Đăng nhập admin rồi "Login as" user
1. Navigate `http://103.179.173.247:4444/CMD_SHOW_USER?user=<USER>`. Nếu ra trang login → điền `admin` + mật khẩu, submit (click nút Login theo toạ độ nếu ref không ăn).
2. Nếu đang kẹt ở session user cũ (footer hiện `none`/user khác) → `CMD_LOGOUT` rồi vào lại `/` (admin session vẫn còn), sau đó mở `CMD_SHOW_USER?user=<USER>`.
3. Ở trang "Details for User <USER>", click nút **"Login as <USER>"** (toạ độ ~`(528, 227)`; ref hay không ăn, dùng toạ độ). Verify: mở một trang user-level thấy "Current Domain: <DOMAIN>".

### B2 — Cấp Let's Encrypt (CHỈ domain chính)
1. Navigate `http://103.179.173.247:4444/CMD_SSL?domain=<DOMAIN>`.
2. Chọn radio `type=create` + `request=letsencrypt`, **bỏ chọn** www/subdomain/wildcard (chỉ giữ domain chính) để validation chắc chắn thành công, điền email. JS:
   ```js
   (function(){
     function setRadio(n,v){var e=document.querySelectorAll('input[type=radio][name="'+n+'"]');for(var i=0;i<e.length;i++)if(e[i].value===v){e[i].checked=true;e[i].click();e[i].dispatchEvent(new Event('change',{bubbles:true}));return}}
     setRadio('type','create'); setRadio('request','letsencrypt');
     ['le_select1','le_select2','le_select3','le_select4','le_select5','le_wc_select0','le_wc_select1','wildcard','force_ssl'].forEach(function(n){var c=document.querySelector('input[name="'+n+'"]');if(c)c.checked=false});
     var m=document.querySelector('input[name="le_select0"]');if(m)m.checked=true;
     var em=document.querySelector('input[name="email"]');if(em)em.value='dinhtuanlong@gmail.com';
   })();
   ```
3. Submit form cấp cert: click `input[type=submit][name="submit"][value="Save"]`.
4. Chờ ~8–10s. Kết quả mong đợi: **"LetsEncrypt request successful for: <DOMAIN>"**.
   - Nếu fail: thường do một hostname phụ không resolve → đảm bảo chỉ tick `le_select0`. Không dùng wildcard (cần DNS-01).

### B3 — Verify cert bằng curl
```bash
D=<DOMAIN>
echo | timeout 15 openssl s_client -connect "$D:443" -servername "$D" 2>/dev/null | openssl x509 -noout -issuer -subject -dates
# Mong đợi: issuer Let's Encrypt, subject CN=<DOMAIN>, dates hợp lệ
curl -s -o /dev/null -w "https %{http_code}\n" --max-time 25 "https://$D/"          # 200
echo | timeout 15 openssl s_client -connect "$D:443" -servername "$D" -alpn h2,http/1.1 2>/dev/null | grep -a -i "ALPN protocol"  # => h2
```
(`curl --http2` trên máy này không có; kiểm HTTP/2 bằng ALPN như trên.)

### B4 — Thêm WP_HOME/WP_SITEURL https vào wp-config.php
1. Navigate editor: `CMD_FILE_MANAGER/domains/<DOMAIN>/public_html/wp-config.php?action=edit`.
2. Chèn khối sau ngay sau `<?php` bằng JS (xử lý cả trường hợp đã có WP_HOME/WP_SITEURL). **Nhớ đổi domain trong chuỗi.**
   ```js
   (function(){var t=document.querySelector('textarea');var v=t.value;
     if(v.indexOf('QCV_HTTPS_START')!==-1)return 'already';
     var c=v.replace(/define\(\s*['"]WP_(HOME|SITEURL)['"]\s*,[^;]*\);[ \t]*\r?\n?/g,'');
     var b="/* QCV_HTTPS_START */ define('WP_HOME','https://<DOMAIN>'); define('WP_SITEURL','https://<DOMAIN>'); $_SERVER['HTTPS']='on'; /* QCV_HTTPS_END */\n";
     t.value=c.replace(/<\?php/, "<?php\n"+b); return 'injected';})();
   ```
   **QUAN TRỌNG:** ép `$_SERVER['HTTPS']='on'` **VÔ ĐIỀU KIỆN** (không gate theo `HTTP_X_FORWARDED_PROTO`). Sau WAF Tadu (terminate SSL, forward HTTP về WP mà KHÔNG gửi X-Forwarded-Proto), nếu gate theo header đó thì `is_ssl()`=false → `plugins_url()`/`content_url()` sinh link `http://` → mixed-content chặn CSS/JS trên trang https ("giao diện tan hoang"). Ép vô điều kiện thì `is_ssl()`=true → mọi link https. Site đã Force-SSL nên an toàn, không loop.
3. Click **"Save As"** (giữ nguyên filename `wp-config.php`). Verify textarea sau reload còn `QCV_HTTPS_START`.
4. Verify site vẫn chạy: `curl -s -o /dev/null -w "%{http_code}\n" --max-time 40 "https://$D/?t=$RANDOM"` = 200, không có "critical error".

### B5 — Bật Force SSL (chuyển http→https ở tầng server)
1. Navigate `CMD_SSL?domain=<DOMAIN>`.
2. JS: tick `force_ssl` rồi submit form của nó (POST tới `/CMD_DOMAIN`):
   ```js
   (function(){var f=document.querySelector('input[name="force_ssl"]');f.checked=true;(f.form||f.closest('form')).submit();})();
   ```
3. **Chờ ~12–20s** (server reload config; lần đầu http có thể vẫn 200, chờ thêm rồi test lại).

### B6 — Verify toàn diện (curl)
```bash
D=<DOMAIN>
curl -s -I --max-time 25 "http://$D/" | grep -iE "^(HTTP|location)"          # 301 -> https
curl -s -o /dev/null -w "redirects=%{num_redirects} final=%{url_effective} code=%{http_code}\n" -L --max-time 40 "http://$D/"  # redirects=1, final https, code 200 (KHÔNG loop)
curl -s -L --max-time 40 "http://$D/" | grep -oiE "canonical[^>]*https://[^\"' ]+" | head -1   # canonical https
curl -s -L --max-time 40 "http://$D/" | grep -ciE "http://$D"                # 0 mixed-content nội bộ (plugin normalize)
curl -s -I --max-time 20 "https://$D/wp-content/themes/megastore/style.css" | grep -i cache-control  # asset cache 1 năm
curl -s -o /dev/null -w "wp-admin %{http_code}\n" -L --max-time 30 "https://$D/wp-admin/"   # 200, cert OK
```
Đạt yêu cầu khi: http→**301**→https (1 hop, không loop), trang cuối 200 không fatal, canonical https, 0 link http nội bộ, asset có `max-age=31536000, immutable`, wp-admin vào được.

## Gotchas (đã gặp thực tế)

- **Session DirectAdmin hết hạn nhanh** giữa chừng → thao tác "Save" có thể âm thầm không lưu. **Luôn verify sau mỗi Save** (đọc lại textarea / curl). Nếu textarea trống hoặc title "DirectAdmin Login" → đăng nhập lại.
- **"Login as" hay không ăn** → dùng click toạ độ `(528, 227)` trên trang CMD_SHOW_USER; verify bằng "Current Domain".
- **Tadu WAF challenge**: khi có nhiều request test (curl/PageSpeed) + cache nguội, WAF trả trang thử thách `__uip` (body rỗng) cho client không cookie → curl thấy ~16KB, PageSpeed **NO_FCP**. Đây là WAF của hosting, KHÔNG phải plugin/cert. Cách giảm: NGƯNG test 30–60 phút cho rate-limit hạ nhiệt; để traffic thật làm ấm cache (trang HIT không bị challenge). Nếu kéo dài → báo hosting chỉnh chế độ challenge (nó không auto-reload sau khi set cookie).
- **HTTPS trước, cài/chạy plugin sau**: bật HTTPS TRƯỚC khi plugin QCV localize font → font ghi thẳng ở https, tránh mixed-content. Nếu đã localize ở http rồi mới lên https, plugin ≥0.1.66 tự sửa (URL font protocol-relative + đổi tên CSS `-s2`) nhưng **phải Xoá cache** để trang tái tạo link mới.
- **Không loop**: vì set `WP_HOME=https` (WP không canonical-redirect ngược) + server là origin trực tiếp (Tadu WAF là module trên origin, không phải proxy tách SSL). Nếu site sau proxy tách SSL thì cần `HTTP_X_FORWARDED_PROTO` (đã có trong khối wp-config).
- **Chỉ domain chính** khi cấp LE: không tick www/mail/ftp/pop/smtp/wildcard (dễ fail validation vì chưa chắc resolve). Cần www thì thêm sau khi đã có record.

## Rollback (nếu cần tắt HTTPS)

1. `CMD_SSL?domain=<DOMAIN>` → **bỏ tick** Force SSL → submit (site hết ép https).
2. wp-config.php → xoá khối `/* QCV_HTTPS_START */ … /* QCV_HTTPS_END */`.
3. (Tuỳ) SSL Certificates → chọn lại "Use the server's certificate".
4. Xoá cache plugin để trang tái tạo link http.

## Nhân rộng nhiều site

Lặp B1–B6 cho từng `mauXX`, chỉ đổi `DOMAIN`/`USER` và domain trong khối wp-config. Có thể làm tuần tự; sau mỗi site verify B6 trước khi sang site kế.
