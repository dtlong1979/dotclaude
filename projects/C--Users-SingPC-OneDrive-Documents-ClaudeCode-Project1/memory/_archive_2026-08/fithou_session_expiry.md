---
name: fithou_session_expiry
description: "Xử lý hết phiên (JWT 401) ở app + web-admin hou-cntt: tự đăng xuất về màn đăng nhập + báo 'Phiên hết hạn'"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-03T02:04:57.446Z
---

Trước đây token JWT hết hạn giữa chừng thì KHÔNG có gì báo — app chỉ hiện "Thử lại" ở tab, web-admin thì trống dữ liệu. Đã thêm bắt 401 để đăng xuất + yêu cầu đăng nhập lại có thông báo rõ.

**App (hou-cntt/mobile):**
- `core/api_client.dart`: Dio interceptor thêm `onError` — nếu `statusCode==401 && _token!=null` (đang có phiên, bỏ qua 401 lúc login sai mật khẩu) thì gọi callback `onUnauthorized`.
- `core/auth.dart`: `Auth(this.api){ api.onUnauthorized = _onUnauthorized; }`; `_onUnauthorized` (guard `_loggingOut` chống gọi trùng khi nhiều request 401) đặt `sessionExpired=true` rồi `logout()` → notifyListeners → gate `app.dart` Consumer<Auth> tự về `LoginScreen`. `login()` đặt lại `sessionExpired=false`.
- `login_screen.dart`: `context.watch<Auth>().sessionExpired` → banner cam "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại." Dùng chung Dio nên cả gateway workload 401 cũng kích hoạt.

**Web-admin (hou-cntt/web-admin/app.js):**
- Hàm `api()`: sau fetch, `if (r.status===401 && token){ handleSessionExpired(); throw }`. `handleSessionExpired()` xóa token localStorage + `sessionExpired=true` + `render()` (→ loginHTML vì !token). `login()` đặt `sessionExpired=false`. `loginHTML()` chèn banner khi `sessionExpired`. Bump `index.html` app.js?v=8→**v=9**.
- Lưu ý: các nút UPLOAD dùng raw fetch (không qua `api()`) nên chưa bắt 401 — chấp nhận (chỉ báo lỗi tải).

Deploy: web-admin baked trong image hou-cntt (không bind-mount) → sync web-admin/ + `docker compose build hou-cntt-api` (đã làm, serve v=9). App: build release APK (FithouOne-android-<ngày>.apk).
