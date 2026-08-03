---
name: project-overview
description: "Mục tiêu, phạm vi và quyết định công nghệ của ứng dụng chat + quản lý công việc nội bộ (Project1)"
metadata: 
  node_type: memory
  type: project
  originSessionId: aab809f0-62f7-4cd7-9bf3-4d761b9d5f7d
---

Dự án: ứng dụng chat + quản lý công việc nội bộ, thay thế Zalo/Messenger/Email cho giao tiếp nội bộ. Yêu cầu cốt lõi: dễ theo dõi, có dấu vết (audit trail), tạo tài khoản, phân quyền (RBAC). Chạy trên Android, iOS và web.

**Why:** Muốn một công cụ nội bộ thống nhất, kiểm soát được, có truy vết — khác với chat ngoài (khó theo dõi) và email (nặng nề).

**How to apply:**
- Quy mô nhỏ (<50 người) → ưu tiên đơn giản, ra MVP nhanh, chưa cần kiến trúc microservice.
- Người dùng chọn lưu dữ liệu trên dịch vụ cloud sẵn (Supabase/Firebase) thay vì tự host (xác nhận 2026-05-25).
- Audit trail / phân quyền là yêu cầu quan trọng, không phải tùy chọn — luôn cân nhắc khi thiết kế.
- Tính tới 2026-05-25 mới ở giai đoạn lập kế hoạch & kiến trúc, chưa viết code.
