---
name: shadowing-build-env
description: Môi trường build Flutter/Android trên máy user cho app shadowing — vị trí công cụ và ràng buộc RAM
metadata: 
  node_type: memory
  type: project
  originSessionId: 50fedf4e-27af-4071-920a-eee5f5c408c0
---

Môi trường build của app [[shadowing-app]] trên máy Windows của user (xác lập 2026-05-25):

- **Flutter 3.44.0** giải nén tại `C:\flutter` nhưng **KHÔNG có trên PATH** → gọi bằng `C:\flutter\bin\flutter.bat`. (Bash tool không thấy flutter; dùng PowerShell.)
- **Android Studio** tại `C:\Program Files\Android\Android Studio` (có JBR Java 21). Android SDK tại `%LOCALAPPDATA%\Android\sdk` — đã có platforms/build-tools/platform-tools/emulator, **thiếu cmdline-tools** (chỉ ảnh hưởng `flutter doctor --android-licenses`, không cản build/run trên emulator).
- Working dir của Flutter project: `shadowing_app/` (PowerShell tool giữ cwd ở đó sau lần `Set-Location` đầu — không cần Set-Location lại).

**RAM chỉ 15GB.** Template Flutter mặc định đặt `org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G` → Gradle daemon **crash OOM** (JVM mmap failed) khi build cùng lúc với Android Studio/Chrome.

**Why:** Tổng heap yêu cầu (8G + 4G metaspace) vượt RAM trống.

**How to apply:** Đã sửa `android/gradle.properties` xuống `-Xmx2048m -XX:MaxMetaspaceSize=1g -XX:ReservedCodeCacheSize=256m`. Giữ heap Gradle ≤2-3GB cho máy này; nếu vẫn OOM, đóng bớt app hoặc giảm thêm. Emulator cũng ngốn RAM → cân nhắc khi chạy đồng thời.

**Đĩa C: từng gần đầy** (237GB, có lúc chỉ 2.6GB trống) → emulator cần ~7.4GB, build cần vài GB. User đã dọn (Topaz Labs ~40GB là thủ phạm chính). Emulator AVD tên `Pixel_10_Pro` (android-37 playstore). Cache Gradle hỏng sau OOM → xóa `~/.gradle/caches/9.1.0/transforms` (stop daemon bằng `android\gradlew.bat --stop` trước).

**Whisper (whisper_ggml) — các fix build bắt buộc (2026-05-26):**
- Yêu cầu **NDK 29.0.13113456** (bản rc/preview). Đã set `ndkVersion = "29.0.13113456"` trong `android/app/build.gradle.kts`.
- License NDK preview chưa chấp nhận và **thiếu cmdline-tools** → đã ghi tay hash chuẩn vào `sdk/licenses/`: file `android-sdk-license` (3 hash chuẩn) + tạo `android-sdk-preview-license` = `84831b9409646a918e30573bab4c9c91346d8abd`. Sau đó Gradle (AGP) tự tải NDK 29.
- `whisper_ggml` hard-code `compileSdk 34` nhưng ffmpeg_kit đòi ≥35 → lỗi `checkReleaseAarMetadata`. Fix trong `android/build.gradle.kts`: trong block `subprojects {}` (đăng ký TRƯỚC khi evaluate), dùng `afterEvaluate { }` + reflection `setCompileSdk(36)` để ép mọi subproject Android lên 36. Lưu ý: KHÔNG dùng `plugins.withId` (bị plugin ghi đè lại 34) và KHÔNG đặt afterEvaluate ở block subprojects sau `evaluationDependsOn(":app")` (lỗi "already evaluated").
- Ghi âm dùng `record` định dạng m4a (aacLc) + noiseSuppress/echoCancel/autoGain; whisper_ggml tự convert sang wav bằng ffmpeg khi nhận diện. Model `base.en` (~142MB) tải lần đầu về `getApplicationSupportDirectory`, sau đó offline.
- APK release kèm Whisper+ffmpeg ~**107MB** (đa ABI). Có thể giảm bằng `flutter build apk --split-per-abi` (bản arm64-v8a nhỏ hơn nhiều cho điện thoại thật).

**⚠️ ĐÃ GỠ whisper_ggml (2026-05-26) — KHÔNG dùng lại.** whisper_ggml kéo theo `ffmpeg_kit_flutter_new_min`, mà native `libffmpegkit_abidetect.so` lỗi `UnsatisfiedLinkError: Bad JNI version returned from JNI_OnLoad ...: 0` (hỏng trên CẢ x86_64 emulator lẫn arm64 điện thoại thật). Lỗi này xảy ra lúc `GeneratedPluginRegistrant.registerWith` → **mọi plugin chết theo** → biểu hiện ra ngoài là `PlatformException(channel-error, Unable to establish connection on channel ... shared_preferences ... getAll)` và app văng ngay khi mở. Phát hiện qua `adb logcat`. → Đã `flutter pub remove whisper_ggml`, xóa `recognition_service.dart`, hoàn nguyên `ndkVersion = flutter.ndkVersion` và bỏ override compileSdk trong `android/build.gradle.kts`. APK trở lại ~46.7MB và chạy ổn.

**Bài học:** bản release có thể lỗi dù debug chạy được; **luôn test APK release trên thiết bị + đọc logcat** trước khi giao. Lỗi "Unable to establish connection on channel" thường là TRIỆU CHỨNG của một plugin khác làm hỏng toàn bộ đăng ký plugin — đọc logcat để tìm plugin thực sự lỗi.

**ĐÃ CHUYỂN DỰ ÁN RA NGOÀI ONEDRIVE (2026-05-27):** Dự án copy sang `C:\Dev\ClaudeCode\Project1\shadowing_app` (bỏ build/.gradle/.dart_tool). Build release tại đây **thành công, không còn lỗi khóa file**. Đây là VỊ TRÍ LÀM VIỆC MỚI — mở Claude Code tại `C:\Dev\ClaudeCode\Project1` (key memory mới `C--Dev-ClaudeCode-Project1`). Bản OneDrive cũ deprecated (có thể xóa sau). Mọi đường dẫn build/command từ giờ dùng `C:\Dev\...`.

**⚠️ OneDrive khóa file build (2026-05-26) — đã khắc phục bằng cách chuyển ra C:\Dev:** project nằm trong `OneDrive\Documents` → OneDrive đồng bộ thư mục `build/` và `.dart_tool/` gây `java.nio.file.AccessDeniedException` ở task `mergeReleaseNativeLibs` (lib/arm64-v8a) — build release fail lặp lại; `flutter clean` cũng không xóa được `.dart_tool`. KHẮC PHỤC: **dừng OneDrive trước khi build**: `Get-Process OneDrive | Stop-Process -Force` (OneDrive tự chạy lại khi đăng nhập; user mở lại bất cứ lúc nào). Lâu dài nên **chuyển project ra ngoài OneDrive** hoặc loại trừ thư mục build khỏi sync.

**Bước 4 = Azure Pronunciation Assessment (REST) — đã chốt & chạy (2026-05-26).**
- Tích hợp qua **REST short-audio** (không SDK native → tránh lỗi build): `POST https://{region}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=detailed`. Header `Pronunciation-Assessment` = base64(JSON config: ReferenceText, GradingSystem=HundredMark, Granularity=Phoneme, Dimension=Comprehensive, EnableProsodyAssessment=true, EnableMiscue=true). Content-Type `audio/wav; codecs=audio/pcm; samplerate=16000`. **Bắt buộc `format=detailed`** mới có NBest+Words.
- **CẤU TRÚC RESPONSE REST khác SDK**: điểm nằm PHẲNG ngay trên `NBest[0]` (AccuracyScore, FluencyScore, ProsodyScore, CompletenessScore, PronScore) và mỗi `Words[i]` có `AccuracyScore`/`ErrorType` trực tiếp — KHÔNG nằm trong object `PronunciationAssessment`. (Đã từng parse sai theo kiểu SDK → điểm rỗng.) `lib/services/pronunciation_service.dart` parse phẳng.
- Ghi âm đổi sang **WAV 16kHz mono PCM** (`AudioEncoder.wav`, sampleRate 16000, numChannels 1) cho đúng định dạng Azure.
- Key/Region: `lib/services/azure_config.dart` đọc qua `String.fromEnvironment('AZURE_SPEECH_KEY'/'AZURE_SPEECH_REGION')`. Build truyền `--dart-define=AZURE_SPEECH_KEY=... --dart-define=AZURE_SPEECH_REGION=southeastasia` (KHÔNG ghi key vào source). Region của user = **southeastasia**, gói **Free F0** (~5h/tháng free). Key đã lộ trong chat → user nên Regenerate trước khi phát hành + chuyển sang backend giữ key.
- Mẹo verify nhanh không cần đọc thật: dùng Azure TTS tạo WAV mẫu rồi POST lên endpoint chấm để kiểm tra request/parse. issueToken endpoint `https://{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken` để test key hợp lệ.
- APK release ~47MB (không native nặng). Vẫn còn tùy chọn sherpa-onnx offline nếu sau này muốn bản không cần mạng/tài khoản.

**Pack general-L1 ĐÃ SINH (2026-05-26):** 396 câu A1 (6 sublevel × ~66), audio **OGG Opus** (`ogg-16khz-16bit-mono-opus`, ~8MB tổng) + timeline từng từ + IPA (PhonemeAlphabet=IPA) + EN/VI. Nguồn: `content_src/general_A1.json` + `general_A1_part2.json` (mỗi câu {en,vi}). Pack tại `assets/packs/general-L1/` (manifest.json, passages.json ~1MB, audio/*.ogg). Item: {id ga1_<sublevel>_<seq>, sublevel, seq, en, vi, ipa, audio, timings:[{w,s,e,ipa}]}. Pipeline: TTS OGG → STT (ogg, format=detailed, Pronunciation-Assessment header) lấy Offset/Duration + Phonemes IPA. Resumable qua %TEMP%\packwork\general-L1\<id>.json.

**⚠️ GOTCHA encoding PowerShell 5.1:** `Get-Content -Raw` KHÔNG đọc UTF‑8 (không BOM) đúng → tiếng Việt/IPA bị mojibake. PHẢI đọc bằng `[IO.File]::ReadAllText($path,[Text.Encoding]::UTF8)` và ghi bằng `[IO.File]::WriteAllText($p,$json,(New-Object Text.UTF8Encoding $false))`. (Lần đầu sinh pack đã dính lỗi này, phải đọc lại source + record bằng UTF‑8 rồi ghi lại passages.json.)

**App-side pack ĐÃ tích hợp (2026-05-26):** models Passage/WordTiming/PackManifest; ContentService.load() đọc `assets/packs/general-L1/`; Home chọn sublevel A1.1-6 (ProgressStore.getLevel/setLevel tái dùng làm sublevel hiện tại). SessionScreen dùng **just_audio phát OGG asset + highlight theo timings** (positionStream → word index → KaraokeText): bước 1 hiện theo câu (tốc độ player 0.7/0.85/1.0), bước 2 karaoke + IPA + VI, bước 3 ghi âm với guide pace theo timings (Stopwatch). ResultScreen "Bản gốc" phát audio pack (bỏ TtsService). Đã verify trên emulator: home render OK, OGG Opus phát OK (c2.android.opus.decoder + AudioTrack, không lỗi). APK release ~**57MB** (kèm pack ~9.4MB) build với --dart-define key Azure. pubspec khai báo `assets/packs/general-L1/` + `/audio/`. tts_service.dart + models/topic.dart + assets/content/* giờ KHÔNG dùng (có thể dọn sau).

**CÒN LẠI (chưa làm):** màn Kho nội dung + Quản lý gói (tải/cập nhật/xóa pack online), tải pack từ index.json (host-agnostic, Drive), nhiều category/level, placement test, auto lên cấp, lịch sử/tiến độ.
