---
name: ui_copy_style
description: "Quy ước văn phong cho MỌI copy giao diện phần mềm nội bộ (workload/hou-cntt/website) — trang trọng, thuần Việt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-19T06:40:03.689Z
---

User yêu cầu (2026-08-18) mọi ngôn từ trên giao diện dùng **văn phong TRANG TRỌNG, THUẦN VIỆT**, không quá thân mật/khẩu ngữ.

**Why:** phần mềm dùng trong môi trường công tác của khoa/trường (giảng viên, cán bộ) — giọng thân mật kiểu app tiêu dùng làm giảm tính nghiêm túc, chuyên nghiệp.

**How to apply:**
- KHÔNG emoji trang trí trong nút/tiêu đề/thông báo (biểu tượng chức năng như 📎 minh chứng có thể chấp nhận, hạn chế). Dùng chấm màu/viền màu thay emoji để chỉ trạng thái.
- Tránh khẩu ngữ / giọng cổ vũ: ~~"Hôm nay bạn rảnh việc khoa 🎉"~~ → "Hôm nay bạn không có việc cần xử lý"; ~~"Tôi nhận việc này"~~ → "Nhận việc"; ~~"Báo xong việc"~~ → "Báo cáo hoàn thành"; ~~"Đạt ✓"~~ → "Nghiệm thu đạt"; ~~"Cần sửa"~~ → "Yêu cầu chỉnh sửa"; ~~"được nhờ"~~ → "được giao".
- Xưng hô lịch sự: "Kính chào [họ tên đầy đủ]". Nhãn dùng danh từ chuẩn: "Người giao", "Người thực hiện", "Hạn", "Minh chứng", "Nghiệm thu".
- **XƯNG HÔ TRUNG TÍNH GIỚI TÍNH (2026-08-19):** KHÔNG mặc định gọi người dùng là "thầy" — cán bộ có cả **thầy (nam) và cô (nữ)**, gọi "thầy" cho tất cả là misgender phái nữ. Với ngôi hai (nói với chính người dùng) dùng **"bạn"** trung tính (vd "việc chờ **bạn** duyệt", "Hôm nay **bạn**…"). Chỉ dùng "thầy"/"cô" khi ĐÃ BIẾT CHẮC giới tính người cụ thể (dữ liệu có trường giới tính, hoặc tên người thứ ba đã xác định). Đã sửa Artifact "Việc Khoa CNTT" (5be31a70) theo quy tắc này.
- Vẫn ưu tiên NGẮN GỌN + tiếng người (không thuật ngữ kỹ thuật nội bộ như "da_roi", "cho_nghiem_thu" lộ ra UI) — trang trọng nhưng dễ hiểu.
- Áp cho cả các pha còn lại của [[workload_redesign]] và mọi màn mới. Liên quan [[research_writing_standards]].
