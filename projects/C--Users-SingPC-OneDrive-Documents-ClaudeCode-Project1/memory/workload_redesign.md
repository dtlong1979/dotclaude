---
name: workload_redesign
description: "Thiết kế lại UX phần Giao việc của workload (action-first, 4 trạng thái, 3 vai) — bản mới, phiên bản cũ đã backup; đang triển khai theo pha"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-18T16:59:17.770Z
---

Cải tổ UX phần **Công việc (giao/nhận/nghiệm thu)** của workload sau đánh giá 5-vai ("mạnh tính năng, YẾU khả dụng ~3/5") + nghiên cứu 4-agent (Trello/Asana/Planner/Basecamp; triết lý "underdo the competition", "đối thủ thật là Zalo"). Bản thử artifact: `scratchpad/viec-khoa-prototype.html`. Định hướng đầy đủ trong lịch sử phiên (đọc transcript nếu cần).

**Nguyên tắc chốt:** GIỮ mô hình lõi (cổng nghiệm thu, 2 vai phụ_trach/tham_gia, minh chứng) nhưng ĐƠN GIẢN HÓA bề mặt: 4 trạng thái hiển thị (Mới giao→Đang làm→Chờ nghiệm thu→Xong), mỗi màn 1 nút chính, nhãn tiếng người, mobile-first. BỎ/ẨN: job con nhiều cấp→checklist 1 cấp, mỗi-người-1-trạng-thái (ẩn mặc định), versioning minh chứng, người ngoài (→text), bảng khen sớm. ĐỪNG THÊM: automation/custom field/phân quyền nhiều tầng/dashboard nặng/nhiều view/tích hợp ngoài.

**Mô hình thật (workload SQLite /data/data.db):** `groups`(kind: to/...)=bộ phận · `memberships.role` thanh_vien/pho/**truong** = trưởng bộ phận · `users.role` admin=ban chủ nhiệm · `tasks`(status: chua_giao|dang_mo|cho_nghiem_thu|hoan_thanh|tam_dung|huy; group_id, assigner_id, due_date, parent_id) · `task_assignees`(role phu_trach/tham_gia; status cho_nhan|dang_lam|tu_choi|hoan_thanh|da_roi) · `resources`+`resource_versions` · `progress_reports`. Route nghiệp vụ: `/tasks/accept /decline /complete /approve(nghiệm thu) /reopen(trả lại) /assign /join`. `recompute_task_status` đẩy việc lên cho_nghiem_thu khi MỌI người nhận đã hoan_thanh.

**BACKUP bản cũ (2026-08-18):** `/home/fitadm/code/fithouone/_backup_workload/workload_code_20260818_125033.tar.gz` (994K) + `data_20260818_125033.db` (1.8M). ROLLBACK: giải nén tar về workload/ + rebuild.

**PHA 1 ĐÃ DEPLOY (2026-08-18):** Trang chủ MỚI "Hôm nay" action-first tại **`/`** (route `hom_nay`, template `templates/hom_nay.html`); dashboard cũ chuyển sang **`/bang-dieu-hanh`** (route `home` cũ). Thêm `app.status4()` (gom trạng thái→4 nhóm) + `hom_nay_items(conn,user)` (việc TÔI cần làm: cho_nhan→"Tôi nhận", dang_lam→"✓ Báo xong"; việc chờ TÔI duyệt: assigner_id=tôi & cho_nghiem_thu→"Đạt ✓"/"Cần sửa"; quá hạn ghim đỏ). Thêm param `next` cho `/tasks/approve` + `/tasks/reopen` (quay lại `/`). Nav base.html thêm "Hôm nay". Verify render OK.

**PALETTE (2026-08-18):** đổi toàn hệ xanh blue→**xanh lá** `--primary:#0e7c66` `--primary-d:#0b5f4f` `--primary-soft:#dcefe8` `--sidebar-bg:#0c4a3d`/`#0a3d33`; hn-*/bp-*/tk-* đều tông xanh lá. asset_ver tự bump khi rebuild.

**PHA 2 ĐÃ DEPLOY (2026-08-18) — vai Trưởng bộ phận `/bo-phan`:** route `bo_phan()` + `bo_phan_data(conn,user,group_id)` (dùng `assignable_groups`: admin=mọi nhóm, khác=nhóm mình phụ trách). Hiện: 4 thống kê (đang làm/chờ nghiệm thu/quá hạn/xong) + "Ai đang phụ trách công việc" (bp-people, mỗi người tải việc qh/đang làm/chờ duyệt/chưa nhận + nhãn ổn định/khá bận/có việc trễ) + "Công việc của bộ phận" (bp-tasks). Chip đổi nhóm nếu phụ trách >1. Template `bo_phan.html`, CSS bp-* trong style.css. Nav "Bộ phận" chỉ hiện cho admin hoặc trưởng/phó (global `is_bo_phan_lead(uid)` kiểm memberships role in truong/pho). Thành viên thường→empty state + nav ẩn. Verify render 2 vai OK.

**PHA 3 ĐÃ DEPLOY (2026-08-18) — vai Ban chủ nhiệm `/toan-khoa` (tổng quan):** route cũ (bảng liệt kê chi tiết) chuyển sang **`/toan-khoa/chi-tiet`** (fn `all_tasks_detail`, all_tasks.html repoint link + thêm nút "← Tổng quan toàn khoa"). `/toan-khoa` MỚI = tổng quan: `toan_khoa_data(conn)` → 4 thống kê toàn khoa + "Việc quá hạn cần chú ý" (top 20) + lưới thẻ 26 bộ phận (tk-dept: tên, số người, thanh **`<progress>`** %hoàn thành — dùng attr value KHÔNG inline style vì CSP, chip qh/nghiệm thu/đang làm/xong), sắp xếp ưu tiên quá hạn→open→total, bấm thẻ vào `/bo-phan?g=id`. Template `toan_khoa.html`, CSS tk-* trong style.css. Chỉ admin. Verify render + HTTP 200 OK.

**CÒN LẠI:** Pha 4 gọn màn chi tiết task (1 nút chính, ẩn thứ thừa) + sửa lỗi nhãn `STATUS_LABELS`→`ASSIGNEE_STATUS_LABELS` ở task_detail.html:63/task_panel.html:167 + bỏ bẫy "Đã hoàn thành" trong báo cáo tiến độ. Liên quan [[workload_app]] [[fithouone_deploy]] [[ui_copy_style]].
