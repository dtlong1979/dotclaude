---
name: license-checker-app
description: phần mềm kiểm tra bản quyền Windows/Office + dò công cụ kích hoạt lậu (viết lại từ bản Codex)
metadata: 
  node_type: memory
  type: project
  originSessionId: 87ba2d18-86df-4749-b4d3-dfd79dc35ca1
---

**Tên sản phẩm: QCV SecuCheck** — "Phần mềm kiểm tra an ninh máy tính QCV SecuCheck". Bản quyền © Công ty TNHH Công nghệ QCV Việt Nam (thietkewebqcv.com.vn / webtrongoi.vn). Tên/công ty/link cấu hình một chỗ ở src/Branding.cs.

**Kiểm tra crack phần mềm thương mại** (CommercialCheck.cs): với Adobe/Autodesk/Corel/MATLAB, phát hiện dấu hiệu bẻ khóa qua (1) tên miền hãng bị chặn trong hosts, (2) công cụ crack đặc trưng (X-Force/GenP...). Trung thực: chỉ báo "có dấu hiệu bẻ khóa" khi có tín hiệu chắc chắn; không thì "không thấy dấu hiệu, nhưng KHÔNG khẳng định có bản quyền". App bị flag có InstalledApp.Cracked=true, hiện đỏ đậm ở tab Phần mềm.

**Định vị: AN NINH máy tính là chính** (không phải "kiểm tra bản quyền"). Cơ chế: phần mềm gián điệp/điều khiển từ xa, lỗ hổng bảo mật, cấu hình không an toàn, phần mềm không bản quyền (công cụ kích hoạt lậu = nguồn mã độc) — tất cả là an ninh. Thứ tự tab & thẻ kết luận: An ninh trước, rồi Công cụ lậu, Phần mềm, bản quyền Windows/Office, máy tính cuối. Có link "Tìm hiểu thêm" theo từng hạng mục (Branding.ArticleFor) mở bài trên webtrongoi.vn.

Phần mềm desktop kiểm tra an ninh + bản quyền trên máy Windows, cho người dùng KHÔNG rành máy tính. Viết lại hoàn toàn từ bản Codex cũ (LicenseComplianceScanner v9) vì bản cũ báo động sai tràn lan.

**Vị trí**: `C:\Users\SingPC\Documents\Codex\2026-07-16\to`
- Mã nguồn mới: `src/` (C# WinForms, biên dịch bằng csc .NET Framework 4, KHÔNG có Visual Studio/SDK)
- **HAI phiên bản** (một mã nguồn, cờ build `/define:PUBLIC` qua `src/Edition.cs`):
  - `outputs/KiemTraBanQuyen-NoiBo.exe`: đủ tính năng, có Dọn dẹp, Gemini bật sẵn + nhúng được khóa cứng (đặt khóa vào `src/Data/internal-gemini-key.txt`, có file `.example`). Dùng riêng, không phát tán.
  - `outputs/KiemTraBanQuyen-CongKhai.exe`: BỎ Dọn dẹp (tránh mang tiếng xóa dấu vết vi phạm), Gemini tắt mặc định, không nhúng khóa.
- Build: `build.ps1 -Edition Both|Internal|Public`. Test engine: `tools/selftest.ps1` (22 phép thử), `tools/build-test.ps1`. Render UI: `tools/build-uishot.ps1 -Edition Internal|Public`
- Gemini (bản nội bộ) còn dùng để phân loại phần mềm lạ (Category "Chưa phân loại") qua search grounding — GeminiClient.ClassifyApp.
- Bản Codex cũ vẫn còn: `outputs/LicenseComplianceScanner*.exe/.ps1/.cs`

**6 mảng**: Máy tính (OEM key trong BIOS), Windows, Office/M365, Dấu vết+lịch sử, **An ninh hệ thống**, Phần mềm đã cài. Mỗi mảng ra 1 câu kết luận + việc cần làm (model `Verdict` trong Model.cs).

**Định vị lại**: gọi là "Rà soát tuân thủ bản quyền & AN NINH hệ thống" (không phải chỉ "kiểm tra bản quyền"). SecurityScanner.cs kiểm tra: antivirus (WMI root/SecurityCenter2), tường lửa, Windows Update, UAC, RDP, SMBv1, Guest account, cổng mạng mở ra 0.0.0.0 (netstat, có danh sách cổng nguy hiểm), phần mềm điều khiển từ xa (TeamViewer/AnyDesk/UltraViewer/VNC...). Có tuyên bố "KHÔNG thay thế antivirus". Bản công khai có màn hình chấp thuận lần đầu (Settings.ConsentAccepted) + About ghi rõ không liên kết hãng. KHÔNG ngụy trang thành antivirus (misrepresentation) — chỉ mở rộng khung mô tả cho đúng thực chất.

**3 lỗi đã sửa (bản trước)**: (1) Windows so KHÓA thật (OA3xOriginalProductKey vs PartialProductKey) không chỉ so kênh OEM — máy này BIOS ...3PFTG khác khóa đang chạy ...WFG6P; (2) Office M365 đọc cache token vNext (%LOCALAPPDATA%\Microsoft\Office\Licenses) + tài khoản đăng nhập thay vì tin OSPP (OSPP báo Grace nhưng thực tế activated); (3) phân loại phần mềm chi tiết + tab riêng.

**Quyết định của user** (2026-07-16):
- Dọn dẹp: cảnh báo rõ → xác nhận → sao lưu/cách ly → thực hiện; có hoàn tác + điểm khôi phục Windows; nói rõ hoàn tác không đảm bảo 100%, user tự chịu trách nhiệm.
- Gemini: giữ ở mức nâng cao, có hướng dẫn lấy key trong UI, dùng Google Search grounding để giảm false alarm, ưu tiên LLM khi có key.

**Bài học kỹ thuật quan trọng** (xem [[license-checker-defender-trap]]):
- Bản cũ báo 3 High+37 Medium trên máy này gần như toàn SAI (ssh-keygen.exe, boto/kms, patch*.js). Nguyên nhân: so khớp chuỗi con trên tên file.
- Cách chống false alarm: chỉ xét file chạy được (.exe/.dll), kiểm tra chữ ký số thật (WinVerifyTrust), so khớp từ trọn vẹn.
- .NET 4 mặc định TLS 1.0 → mọi call Gemini bản cũ đều fail. Phải set SecurityProtocol thủ công.
- Bảng nhận diện ở `src/Data/signatures.txt` (sửa ở đây, không sửa code).
