---
name: workload_daily_report_sessions
description: "Báo cáo ngày workload tách theo buổi (sáng/chiều/tối/cả ngày); chỉ 'Cả ngày' bị chặn sau giờ báo cáo"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-31T13:32:42.365Z
---

Báo cáo trong ngày (`daily_reports`) của workload đã **tách theo buổi** (sang/chieu/toi/ngay) giống mục "Thêm" nhật ký. Liên quan [[fithou_websocket_realtime]].

**Quyết định sản phẩm (user chốt 2026-07-31):**
- Mỗi (user, ngày, buổi) = 1 báo cáo riêng. Schema `daily_reports` đổi UNIQUE(user_id,report_date) → **UNIQUE(user_id,report_date,session)**; migration ở `db.py init_db` dựng lại bảng (báo cáo cũ = buổi `ngay`). ĐÃ chạy trên prod (cột `session` có thật).
- **Chỉ buổi `ngay` (Cả ngày) mới bị chặn phải điền sau giờ báo cáo** (`report_time`, mặc định 16:00). Sáng/chiều/tối điền tự do bất cứ lúc nào.
- Áp dụng CẢ app lẫn web.

**Chỗ code:** backend `app_api.py::api_daily_report` + `api_diary` (days[].daily giờ là LIST báo cáo/buổi, sort theo `_SESSION_ORDER`); web `app.py::daily_report_save` (+ Form `session`) + read ở `/nhat-ky` (drep_by_day thành list) + `templates/diary.html` (for rp in d.daily); app `workload_api.dart::dailyReport(session)` + `_dailyReport` (SegmentedButton buổi, cảnh báo khi 'Cả ngày') + `_dayCard` (lặp list). SESSION_LABELS/_sessionLabel: sang=Sáng, chieu=Chiều, toi=Tối, ngay=Cả ngày.

**Lưu ý:** web KHÔNG có form nhập báo cáo ngày (endpoint `/ca-nhan/bao-cao-ngay` tồn tại nhưng không template nào render form) — nhập báo cáo ngày hiện CHỈ từ app; web chỉ HIỂN THỊ ở nhật ký.
