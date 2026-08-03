---
name: qcv-xam-128
description: "Vùng ảnh hỏng trên site QCV luôn là RGB(128,128,128) chính xác — chữ ký nhận diện, không phải suy đoán"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9f34285f-7927-41e5-81c6-4c1b9e1b5527
---

Vùng "xám" trên ảnh hỏng của site QCV **luôn luôn là RGB(128,128,128) chính xác** — không phải 127, không phải 129, và không phải "một màu xám nào đó".

**Vì sao:** JPEG bị cắt → bộ giải mã hết dữ liệu → các khối còn lại không có hệ số DC → DC = 0 → cộng dịch mức (level shift) +128 → đúng xám giữa.

**Đã đo (17/07/2026):** cắt file ở 30/50/70/90% → mọi pixel vùng hỏng đều đúng `128,128,128`; ghi ra lại q82 vẫn đúng 128; qua webp 82/90/100 và png cũng đúng 128. GD **đọc được** file JPEG cụt (không báo lỗi) — đó là lý do ảnh xám bị "nướng" vào file hoàn chỉnh.

**Why:** đây là chữ ký xác định, thay được mọi heuristic kiểu "đo dải đáy có phẳng không". Đo độ phẳng **không phân biệt được** ảnh sản phẩm nền trắng / logo nền trơn với ảnh hỏng — dẫn tới hoặc kết tội oan (đắp ảnh nhỏ lên ảnh gốc còn tốt), hoặc phải bịa ngưỡng rồi vẫn không dám ra tay. Người dùng chỉ ra cách này; nó đúng và đơn giản hơn hẳn.

**How to apply:** nhận diện = dải liên tiếp từ đáy lên, mỗi hàng ≥90% pixel **gần 128 (±2) trên cả 3 kênh** — KHÔNG so bằng đúng 128. Dùng trong `class-image-salvage.php`.

**Đừng so bằng đúng 128** (0.1.101, người dùng gặp: cứu xong 4 ảnh trang chủ vẫn hỏng). Vùng xám GỐC là 128 chính xác, nhưng các bản phái sinh (`-683x1024`) bị **thu nhỏ (imagecopyresampled trộn pixel) + nén lại JPEG** nên lệch thành **126–130**. So `=== 128` chỉ bắt ~64% pixel/hàng → không đạt ngưỡng 90% → bỏ sót cả ảnh. Đo trên rổ ảnh thật mau04: dung sai 0–1 bắt 0 ảnh, **±2 bắt đúng 4 ảnh lỗi + không flag oan** slider/nền trắng. Cách sửa tối thiểu: đổi `128===R && ...` thành `abs(R-128)<=2 && ...`, giữ nguyên logic dải-từ-đáy. Quan trọng: một số bản webp phái sinh VẪN LÀNH (768x1152.webp) trong khi jpg xám → cứu được thật (không phải xin lại khách), nhưng bản cứu upscale từ webp nên mềm hơn.

**Cứu ảnh phải QUÉT Ổ ĐĨA, không truy vấn bảng attachment** (0.1.100, người dùng chỉ ra: "cứu thì phải quét hết trong upload"). Bản 0.1.96 chỉ `SELECT ... post_type='attachment' AND mime IN(jpeg,png)` → bỏ sót ảnh webp (mime image/webp bị loại), ảnh mồ côi (RevSlider/theme không có bản ghi attachment), bản phái sinh ngoài metadata. Cứu = cứu FILE trên đĩa nên phải duyệt `uploads/` đệ quy, gom file theo "gốc tên" (bỏ đuôi `-WxH`, `-qcv-N`, `-scaled`), mỗi nhóm = 1 tấm ảnh với đủ phiên bản; bản lành to nhất cứu bản xám. Tách `hoa` với `hoa-2` bằng so khớp gốc-tên KHÍT (đuôi `-2` không có chữ 'x' nên không bị bỏ). Xem [[qcv-optimizer-backup-holes]] và [[qcv_origin_optimizer]].
