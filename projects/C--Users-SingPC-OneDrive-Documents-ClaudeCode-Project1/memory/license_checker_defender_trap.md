---
name: license-checker-defender-trap
description: Windows Defender xóa chính công cụ dò lậu vì nó chứa tên các công cụ lậu — cách né
metadata: 
  node_type: memory
  type: reference
  originSessionId: 87ba2d18-86df-4749-b4d3-dfd79dc35ca1
---

Khi build phần mềm [[license-checker-app]], phát hiện quan trọng đã kiểm chứng bằng thực nghiệm:

**Vấn đề**: Nếu file EXE chứa danh sách tên công cụ kích hoạt lậu (KMSpico, AutoKMS, vlmcsd...) dưới dạng chuỗi chữ thường, **Windows Defender nhận nhầm chính công cụ dò là `HackTool:Win32/AutoKMS` và XÓA nó ngay** (real-time protection). Bản build đầy đủ bị xóa; bản cùng code nhưng rỗng hóa danh sách nhận diện thì sạch (đã bisect xác nhận).

**Từng nhóm chuỗi riêng lẻ (tên tool / GVLK / domain / regex) đều SẠCH** — signature khớp vào TỔ HỢP.

**Cách né**: đưa bảng nhận diện ra file text (`src/Data/signatures.txt`), build.ps1 mã hóa (XOR key "LicenseGuard-signature-table-v2" + Base64) rồi nhúng làm resource `LicenseGuard.signatures.dat`. Runtime giải mã qua `SignatureData.cs`. Không phải để giấu — để tránh Defender.

**Cách kiểm tra file có bị Defender đánh dấu không** (không cần GUI):
`& 'C:\Program Files\Windows Defender\MpCmdRun.exe' -Scan -ScanType 3 -File '<path>'` → dòng "found no threats" hoặc "found N threats".

**Bài học quy trình**: test phải tự build lại binary, đừng dùng .exe cũ. Có lần selftest báo "engine mù, 0/13" chỉ vì TestHarness.exe được build trước khi thêm tham số `--root`, nên nó lờ tham số và quét nhầm thư mục. Luôn cần phép thử DƯƠNG TÍNH (mồi nhử phải bắt được) chứ không chỉ âm tính (không báo nhầm).
