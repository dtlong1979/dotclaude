---
name: hou-cntt-mobile-release
description: "Quy trình phát hành app mobile hou-cntt (Flutter) qua Codemagic — repo git RIÊNG, push master là tự build cả iOS+Android"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-16T08:37:40.472Z
---

App mobile Flutter của hou-cntt phát hành qua **Codemagic** (CI, không cần máy Mac). Claude **được phép tự chạy** git/PowerShell/CLI trên máy user (Bash tool = Git Bash trên Windows) để commit/push/phát hành — user đã đồng ý làm chủ động, không hỏi lại từng lần. Với git cần `export HOME=/c/Users/SingPC` và `git config --global --add safe.directory '*'`.

**BẪY quan trọng:** repo git của mobile là **RIÊNG**, gốc ở `D:\dev\hou-cntt\mobile` (KHÔNG phải `D:\dev\hou-cntt` — chạy git ở đó báo "not a git repository"). Remote: `github.com/dtlong1979/fithouone-mobile`, nhánh **master**. `codemagic.yaml` nằm ở gốc repo = `mobile/`.

**Phát hành = commit + `git push origin master`** (từ trong `mobile/`), RỒI **GỌI API TRIGGER** (xem dưới). ⚠ Push KHÔNG tự kích hoạt build (auto-trigger trên UI Codemagic chưa bật, user tìm không thấy chỗ thiết lập — 2026-08-16 xác nhận lại). 2 workflow trong `mobile/codemagic.yaml`: `ios-testflight` (build IPA → TestFlight, integration App Store Connect `FithouOneASC`, tự tăng build number) và `android-release` (APK+AAB đã ký release + **publish Google Play Closed Test**). Cả hai lấy versionName từ `pubspec.yaml` (`version: X.Y.Z+build`); iOS auto-tăng build number theo TestFlight — nhưng **Android versionCode = số +N trong pubspec**, phải BUMP +N mỗi lần (trùng code đã có trên Play sẽ bị từ chối).

**Publish Google Play (từ 2026-08-16):** `android-release` có `publishing.google_play` — `credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` (biến Codemagic, group `android_signing`, Secure = nội dung JSON service account `codemagic_publish@hou-calendar-sync...iam.gserviceaccount.com`, đã cấp quyền "Release to testing tracks"+"Release to production" ở Play Console → Users and permissions), `track: alpha` (Closed Test), `submit_as_draft: false`. App id Play = `vn.edu.hou.fit.fithouone`. Service account key tạo ở Google Cloud project "hou-calendar-sync" (menu API access đã bị Google gỡ → tạo SA qua IAM & Admin/Credentials + Add key JSON; org policy có thể chặn tạo key).

**Ký Android:** keystore `mobile/android/fithouone-upload.jks` + `mobile/android/key.properties` (đã .gitignore). Trên Codemagic (tài khoản CÁ NHÂN — biến global đã deprecated, đặt ở **App-level Environment variables**) có group **`android_signing`**: `CM_KEYSTORE` (base64 của .jks), `CM_KEYSTORE_PASSWORD`, `CM_KEY_ALIAS`, `CM_KEY_PASSWORD`. Workflow giải mã ra file .jks + sinh key.properties rồi build.

**Trigger build KHÔNG cần vào web CM (dùng REST API):** token ở file `D:\dev\hou-cntt\.cm_token.txt` (đọc, ĐỪNG in ra; ngoài repo mobile nên không bị commit). `appId` = `6a761ad69f91075762599b28`. Lệnh: đọc token → `POST https://api.codemagic.io/builds` với header `x-auth-token` và body `{"appId":"6a761ad69f91075762599b28","workflowId":"<ios-testflight|android-release>","branch":"master"}` → trả `buildId`; xem trạng thái `GET /builds/<id>` (field `build.status`: queued/building/finished/failed, `build.message` khi fail). Auto-trigger trên UI CM chưa bật (user không tìm thấy) → cứ push xong thì gọi API trigger cả 2 workflow.

**Bẫy instance:** gói billing hiện chỉ có **`mac_mini_m2`** — đặt `instance_type: linux_x2`/windows sẽ fail ngay "instance type is not available". Cả 2 workflow phải dùng `mac_mini_m2` (Android build trên Mac vẫn ổn).

**Lịch sử lỗi đã gặp:** iOS từng kẹt ở 0.1.5 còn Android 0.1.10 vì trước đó Codemagic CHỈ build iOS (Android build tay cục bộ) → đã thêm workflow `android-release` để đồng bộ. Backend/web thì Claude deploy trực tiếp lên server (xem [[fithouone_deploy]], [[hou_cntt_paths]]); mobile thì KHÔNG build/deploy hộ được — chỉ sửa code cho `flutter analyze` sạch rồi push để Codemagic build.

**NÂNG CẤP UI/UX + tính năng theo web (bắt đầu 2026-08-26):** user chốt làm CẢ 4 PHA rồi mới đẩy Store MỘT LẦN (KHÔNG release lẻ → KHÔNG push master tới khi xong). Frontend là chính (backend hou-cntt đã sẵn endpoint). Kế hoạch (artifact) 4 pha: (1) nền UI/UX, (2) App SV, (3) App GV buồng lái, (4) Workload — đặc biệt nhật ký ngày khớp web.
- **Pha 1 XONG + verify (`flutter analyze lib` sạch):** đổi hệ thiết kế app sang ĐÚNG web fit.hou.edu.vn: xanh dương đậm #0B4F8A + nhấn vàng #D99A2B + font **Be Vietnam Pro** (thêm dep `google_fonts`) + thẻ/nav/appbar/input bo 8–14, sáng+tối. `core/theme.dart` viết lại (brandBlue thay brandCyan, GIỮ alias `const brandCyan=brandBlue` để ~15 file cũ tự đón màu mới; ThemeExtension `AppColors` cho token accent/ink/muted/soft/line/ok/warn/danger). Bộ widget chung mới `core/ui.dart`: AppCard, SectionHeader, Pill(PillKind), InfoRow, EmptyState, SoftHeader.
- **Đích màu web:** primary #0b4f8a, primary-dark #082f49, accent #d99a2b, ink #17202a, muted #64748b, soft #eef5fb, radius 8, font Be Vietnam Pro (lấy từ website app/globals.css).
- **CÒN Pha 2/3/4:** app SV thiếu điểm rèn luyện/đăng ký tín chỉ/cổng SV; GV có gv_advisee/class_list/student_detail/gv_bao_bu/gv_notify (cần dựng lại theo buồng lái web + cảnh báo học thừa + ghi nhận tình trạng SV + đổi phòng); workload app ĐÃ có `_DiaryTab` (workload_home.dart:1587) khớp cơ bản — cần tinh chỉnh accordion/tự-ghi giống web. Flutter 3.44.0 ở /c/flutter/bin.
