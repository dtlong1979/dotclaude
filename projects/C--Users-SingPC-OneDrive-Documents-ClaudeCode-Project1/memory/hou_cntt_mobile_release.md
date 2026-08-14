---
name: hou-cntt-mobile-release
description: "Quy trình phát hành app mobile hou-cntt (Flutter) qua Codemagic — repo git RIÊNG, push master là tự build cả iOS+Android"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-14T12:09:14.850Z
---

App mobile Flutter của hou-cntt phát hành qua **Codemagic** (CI, không cần máy Mac). Claude **được phép tự chạy** git/PowerShell/CLI trên máy user (Bash tool = Git Bash trên Windows) để commit/push/phát hành — user đã đồng ý làm chủ động, không hỏi lại từng lần. Với git cần `export HOME=/c/Users/SingPC` và `git config --global --add safe.directory '*'`.

**BẪY quan trọng:** repo git của mobile là **RIÊNG**, gốc ở `D:\dev\hou-cntt\mobile` (KHÔNG phải `D:\dev\hou-cntt` — chạy git ở đó báo "not a git repository"). Remote: `github.com/dtlong1979/fithouone-mobile`, nhánh **master**. `codemagic.yaml` nằm ở gốc repo = `mobile/`.

**Phát hành = commit + `git push origin master`** (từ trong `mobile/`). Push lên master **tự kích hoạt** 2 workflow trong `mobile/codemagic.yaml`: `ios-testflight` (build IPA → TestFlight, integration App Store Connect `FithouOneASC`, tự tăng build number) và `android-release` (APK+AAB đã ký release). Cả hai lấy versionName từ `pubspec.yaml` (`version: X.Y.Z+build`); iOS auto-tăng build number theo TestFlight.

**Ký Android:** keystore `mobile/android/fithouone-upload.jks` + `mobile/android/key.properties` (đã .gitignore). Trên Codemagic (tài khoản CÁ NHÂN — biến global đã deprecated, đặt ở **App-level Environment variables**) có group **`android_signing`**: `CM_KEYSTORE` (base64 của .jks), `CM_KEYSTORE_PASSWORD`, `CM_KEY_ALIAS`, `CM_KEY_PASSWORD`. Workflow giải mã ra file .jks + sinh key.properties rồi build.

**Lịch sử lỗi đã gặp:** iOS từng kẹt ở 0.1.5 còn Android 0.1.10 vì trước đó Codemagic CHỈ build iOS (Android build tay cục bộ) → đã thêm workflow `android-release` để đồng bộ. Backend/web thì Claude deploy trực tiếp lên server (xem [[fithouone_deploy]], [[hou_cntt_paths]]); mobile thì KHÔNG build/deploy hộ được — chỉ sửa code cho `flutter analyze` sạch rồi push để Codemagic build.
