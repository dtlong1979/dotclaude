---
name: workload_redesign
description: "Thiết kế lại UX phần Giao việc của workload (action-first, 4 trạng thái, 3 vai) — bản mới, phiên bản cũ đã backup; đang triển khai theo pha"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-18T13:00:03.168Z
---

Cải tổ UX phần **Công việc (giao/nhận/nghiệm thu)** của workload sau đánh giá 5-vai ("mạnh tính năng, YẾU khả dụng ~3/5") + nghiên cứu 4-agent (Trello/Asana/Planner/Basecamp; triết lý "underdo the competition", "đối thủ thật là Zalo"). Bản thử artifact: `scratchpad/viec-khoa-prototype.html`. Định hướng đầy đủ trong lịch sử phiên (đọc transcript nếu cần).

**Nguyên tắc chốt:** GIỮ mô hình lõi (cổng nghiệm thu, 2 vai phụ_trach/tham_gia, minh chứng) nhưng ĐƠN GIẢN HÓA bề mặt: 4 trạng thái hiển thị (Mới giao→Đang làm→Chờ nghiệm thu→Xong), mỗi màn 1 nút chính, nhãn tiếng người, mobile-first. BỎ/ẨN: job con nhiều cấp→checklist 1 cấp, mỗi-người-1-trạng-thái (ẩn mặc định), versioning minh chứng, người ngoài (→text), bảng khen sớm. ĐỪNG THÊM: automation/custom field/phân quyền nhiều tầng/dashboard nặng/nhiều view/tích hợp ngoài.

**Mô hình thật (workload SQLite /data/data.db):** `groups`(kind: to/...)=bộ phận · `memberships.role` thanh_vien/pho/**truong** = trưởng bộ phận · `users.role` admin=ban chủ nhiệm · `tasks`(status: chua_giao|dang_mo|cho_nghiem_thu|hoan_thanh|tam_dung|huy; group_id, assigner_id, due_date, parent_id) · `task_assignees`(role phu_trach/tham_gia; status cho_nhan|dang_lam|tu_choi|hoan_thanh|da_roi) · `resources`+`resource_versions` · `progress_reports`. Route nghiệp vụ: `/tasks/accept /decline /complete /approve(nghiệm thu) /reopen(trả lại) /assign /join`. `recompute_task_status` đẩy việc lên cho_nghiem_thu khi MỌI người nhận đã hoan_thanh.

**BACKUP bản cũ (2026-08-18):** `/home/fitadm/code/fithouone/_backup_workload/workload_code_20260818_125033.tar.gz` (994K) + `data_20260818_125033.db` (1.8M). ROLLBACK: giải nén tar về workload/ + rebuild.

**PHA 1 ĐÃ DEPLOY (2026-08-18):** Trang chủ MỚI "Hôm nay" action-first tại **`/`** (route `hom_nay`, template `templates/hom_nay.html`); dashboard cũ chuyển sang **`/bang-dieu-hanh`** (route `home` cũ). Thêm `app.status4()` (gom trạng thái→4 nhóm) + `hom_nay_items(conn,user)` (việc TÔI cần làm: cho_nhan→"Tôi nhận", dang_lam→"✓ Báo xong"; việc chờ TÔI duyệt: assigner_id=tôi & cho_nghiem_thu→"Đạt ✓"/"Cần sửa"; quá hạn ghim đỏ). Thêm param `next` cho `/tasks/approve` + `/tasks/reopen` (quay lại `/`). Nav base.html thêm "Hôm nay". Verify render OK.

**CÒN LẠI (chưa làm):** Pha 2 vai Trưởng bộ phận (tổng quát nhóm + bảng "ai gánh gì", dùng groups+memberships.role=truong) · Pha 3 vai Ban chủ nhiệm (tổng thể toàn khoa theo bộ phận) · Pha 4 gọn màn chi tiết task (1 nút chính, ẩn thứ thừa) + sửa lỗi nhãn `STATUS_LABELS`→`ASSIGNEE_STATUS_LABELS` ở task_detail.html:63/task_panel.html:167 + bỏ bẫy "Đã hoàn thành" trong báo cáo tiến độ. Liên quan [[workload_app]] [[fithouone_deploy]].
