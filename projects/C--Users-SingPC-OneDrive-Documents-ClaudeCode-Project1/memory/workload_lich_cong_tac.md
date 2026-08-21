---
name: workload_lich_cong_tac
description: Lịch công tác toàn khoa trong workload (họp nhóm + hoạt động chung + lịch giảng + nghỉ lễ; 2 chế độ chung/cá nhân; họp tự vào nhật ký)
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-21T06:17:00.472Z
---

Tính năng **Lịch công tác toàn khoa** trong workload (deploy 2026-08-21). Xem [[workload_redesign]], [[workload_hou_cntt_teaching_bridge]] (lịch giảng), [[fithouone_lich_module]] (nghỉ lễ/âm lịch).

**Các lớp trên lịch:** Giảng dạy (từ `gv_lich_giang`, `_lesson_occurs` khớp thứ+khoảng ngày+tuần chẵn/lẻ) · Họp nhóm · Hoạt động chung · Nghỉ lễ (`lich_of`/`lich_ngay`).

**Bảng `su_kien`** (db.py): title, loai (`hop_nhom`|`hoat_dong_chung`), ngay, gio_bd/gio_kt (HH:MM) hoặc ca_ngay, dia_diem, group_id, pham_vi (`nhom`=thành viên đơn vị | `khoa`=toàn khoa), ghi_chu, created_by.

**Quyền (user chốt):** Họp nhóm — **chỉ tổ trưởng/phó** của đơn vị đó (hoặc admin). Hoạt động chung — **Văn phòng (trưởng/phó tổ unit_type='van_phong') + Trưởng khoa đăng THẲNG**, không cần duyệt (`can_post_chung`). Xóa: người tạo hoặc admin.

**2 chế độ xem (`scope`):** `canhan` = sự kiện CHỊU TÁC ĐỘNG đến tôi (họp nhóm tôi ở + hoạt động chung + lịch giảng của TÔI + nghỉ lễ); `chung` = toàn khoa (mọi họp + hoạt động + nghỉ lễ + số buổi giảng/ngày). `su_kien_attendee()` = pham_vi khoa → mọi người; nhom → is_member. **2 kiểu hiển thị (`view`):** `thang` (lưới 6 tuần) / `agenda` (danh sách theo ngày trong tháng), chuyển đổi.

**HỌP TỰ VÀO NHẬT KÝ:** `materialize_meetings(conn,user_id,day)` ghi activity_logs source='hop', buổi+giờ suy từ gio_bd/gio_kt (`su_kien_buoi_muc`: <12h→sáng,<17h30→chiều,else tối; thời lượng→30p/1h/2h/3h/ca_buoi). Chạy khi mở /log + `sweep_meetings` trong `maybe_daily_sweep` + ngay khi tạo sự kiện (ngày ≤ hôm nay). log.html có mục "Họp / Hoạt động hôm nay" (đọc-thôi); bỏ qua source 'hop' ở touch-list.

**Routes:** `GET /lich-cong-tac?m=YYYY-MM&scope=&view=`, `POST /su-kien/create`, `POST /su-kien/delete`. Template `lich_cong_tac.html`, CSS `.lct-*`/`.lg-*` (họp=xanh dương, chung=cam, giảng=xanh lá, lễ=đỏ). Nav "Lịch công tác" (icon i-calendar) sau "Giao việc", active='lich'. Backup `*.bak_lich_*`.

**Verify:** hoạt động chung → nhật ký mọi người; họp nhóm → chỉ thành viên; quy giờ đúng.

**CÒN CÓ THỂ THÊM (chưa làm):** lịch giảng của TỪNG cán bộ khi xem 'chung' (hiện chỉ đếm số buổi/ngày); duyệt/mời thành phần cụ thể (pham_vi 'chon'); nhắc trước giờ họp; hạn công việc lên lịch; báo vắng họp.
