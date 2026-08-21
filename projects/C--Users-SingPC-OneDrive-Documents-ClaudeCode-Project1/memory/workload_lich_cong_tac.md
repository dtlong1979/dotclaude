---
name: workload_lich_cong_tac
description: Lịch công tác toàn khoa trong workload (họp nhóm + hoạt động chung + lịch giảng + nghỉ lễ; 2 chế độ chung/cá nhân; họp tự vào nhật ký)
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-21T07:41:53.018Z
---

Tính năng **Lịch công tác toàn khoa** trong workload (deploy 2026-08-21). Xem [[workload_redesign]], [[workload_hou_cntt_teaching_bridge]] (lịch giảng), [[fithouone_lich_module]] (nghỉ lễ/âm lịch).

**Các lớp trên lịch:** Giảng dạy (từ `gv_lich_giang`, `_lesson_occurs` khớp thứ+khoảng ngày+tuần chẵn/lẻ) · Họp nhóm · Hoạt động chung · Nghỉ lễ (`lich_of`/`lich_ngay`).

**Bảng `su_kien`** (db.py): title, loai (`hop_nhom`|`hoat_dong_chung`), ngay, gio_bd/gio_kt (HH:MM) hoặc ca_ngay, dia_diem, group_id, pham_vi (`nhom`=thành viên đơn vị | `khoa`=toàn khoa), ghi_chu, created_by.

**Quyền (user chốt):** Họp nhóm — **chỉ tổ trưởng/phó** của đơn vị đó (hoặc admin). Hoạt động chung — **Văn phòng (trưởng/phó tổ unit_type='van_phong') + Trưởng khoa đăng THẲNG**, không cần duyệt (`can_post_chung`). Xóa: người tạo hoặc admin.

**2 chế độ xem (`scope`):** `canhan` = sự kiện CHỊU TÁC ĐỘNG đến tôi (họp nhóm tôi ở + hoạt động chung + lịch giảng của TÔI + nghỉ lễ); `chung` = toàn khoa (mọi họp + hoạt động + nghỉ lễ + số buổi giảng/ngày). `su_kien_attendee()` = pham_vi khoa → mọi người; nhom → is_member. **2 kiểu hiển thị (`view`):** `thang` (lưới 6 tuần) / `agenda` (danh sách theo ngày trong tháng), chuyển đổi.

**HỌP TỰ VÀO NHẬT KÝ:** `materialize_meetings(conn,user_id,day)` ghi activity_logs source='hop', buổi+giờ suy từ gio_bd/gio_kt (`su_kien_buoi_muc`: <12h→sáng,<17h30→chiều,else tối; thời lượng→30p/1h/2h/3h/ca_buoi). Chạy khi mở /log + `sweep_meetings` trong `maybe_daily_sweep` + ngay khi tạo sự kiện (ngày ≤ hôm nay). log.html có mục "Họp / Hoạt động hôm nay" (đọc-thôi); bỏ qua source 'hop' ở touch-list.

**Routes:** `GET /lich-cong-tac?m=YYYY-MM&scope=&view=`, `POST /su-kien/create`, `POST /su-kien/delete`. Template `lich_cong_tac.html`, CSS `.lct-*`/`.lg-*` (họp=xanh dương, chung=cam, giảng=xanh lá, lễ=đỏ). Nav "Lịch công tác" (icon i-calendar) sau "Giao việc", active='lich'. Backup `*.bak_lich_*`.

**Verify:** hoạt động chung → nhật ký mọi người; họp nhóm → chỉ thành viên; quy giờ đúng.

**NÂNG CẤP v2 (deploy 2026-08-21):**
- **Quyền đề xuất lịch = CHỈ Văn phòng (trưởng/phó tổ unit_type='van_phong') + Trưởng khoa** (`can_post_chung`); tổ trưởng KHÔNG còn đăng ở trang lịch (đăng họp qua công việc thay thế).
- **Tạo lịch họp TỪ CÔNG VIỆC:** nút "Tạo lịch họp" trong task_panel (mọi người quản lý việc) → `/su-kien/tu-cong-viec` tự lấy tên việc + toàn bộ người tham gia (pham_vi='chon', su_kien.task_id), chỉ nhập ngày/giờ/phòng/link/nội dung; thông báo người dự.
- **Phạm vi 'chon' (người cụ thể):** bảng `su_kien_nguoi`; form đề xuất chọn Toàn khoa / Đơn vị (select cố định) / Nhóm người (picker checkbox có ô tìm — giống đưa người vào việc). `su_kien_attendee` + `su_kien_nguoi_du` xử lý 'chon'.
- **Ngày nghỉ tùy chỉnh:** bảng `ngay_nghi(tu_ngay,den_ngay,ly_do)` do Văn phòng/Khoa đặt (vd nghỉ 31/8→2/9); `off_days_in_range` gộp nghỉ lễ tĩnh (lich_ngay) + tùy chỉnh; routes `/ngay-nghi/create|delete`.
- **Chi tiết bấm-xem:** agenda dùng `<details>` mỗi mục — Giảng dạy hiện "Giảng dạy: N buổi", bấm ra ai/môn/lớp/phòng/buổi (join gv_lich_giang→users theo ma_cb, có tên GV khi xem 'chung'); Họp/hoạt động bấm ra nội dung+thành phần+địa điểm+link online+người đăng+nút xóa. Lưới tháng: mỗi ô là link sang agenda `#d-<iso>`.
- **Form sắp lại (bỏ Ghi chú→Nội dung):** Tiêu đề → Loại lịch → (đơn vị/người) → Nội dung → Link online → Địa điểm → Ngày → Giờ BĐ/KT + nút nhanh Sáng/Chiều/Tối (điền giờ) + Cả ngày. JS `initLichForm` (app.js): toggle theo loại, tìm người, nút buổi, cả-ngày. su_kien thêm cột `link`,`task_id`; ghi_chu=Nội dung.
- Backup `*.bak_lich2_*`.

**NÂNG CẤP v3 (deploy 2026-08-21):**
- **Bấm 1 ngày → LIGHTBOX chi tiết** (native `<dialog id="dlg-day">`), không đổi view. Nguồn: khối `.lct-daysrc[data-day]` ẩn (render qua macro `daydetail(c)`); JS đổ innerHTML vào dialog. Áp cho ô lưới tháng + cột/ô tuần (chỉ ngày có nội dung, class `.clickable`+`data-day`).
- **3 view: Tháng / Tuần / Danh sách.** Tuần (`view=tuan&d=<neo>`): 8 cột (nhãn + 7 ngày) × 4 hàng (Cả ngày, Sáng, Chiều, Tối); `build_cell` gom sự kiện theo buổi (`su_kien_buoi_muc`) + giảng dạy theo ca_hoc vào `cell.buoi`. Nav tuần dùng prev_d/nxt_d (±7 ngày).
- **Bật/tắt lịch âm:** nút `data-am-toggle` → JS thêm class `.no-am` lên `.lct-cal` (ẩn `.lct-am`), nhớ bằng localStorage `lct_am`.
- **Đề xuất lịch + Ngày nghỉ = 2 nút mở DIALOG** (không còn 2 hộp cạnh nhau chiếm chỗ; ngày nghỉ là cấu hình ít dùng). Form đề xuất + form ngày nghỉ nằm trong `<dialog>`. JS `initLich` (app.js): mở/đóng dialog (backdrop+×), lightbox ngày, toggle âm; `initLichForm` chạy trong đó.
- ctx thêm: cells (cho daysrc), week_cells, prev_d/nxt_d/wk_anchor, cur_label động. Backup `app.py.bak_lich3_*`.

**v4 (deploy 2026-08-21):** (A) chi tiết ngày (lightbox+agenda) **nhóm theo Buổi Sáng/Chiều/Tối** (+ Cả ngày) — macro `daydetail` dùng `c.buoi` + macro con `ev_detail`/`tea_detail`. (B) **Ngày nghỉ TỰ BÁO NGHỈ giảng dạy:** `build_cell` bỏ giảng dạy khi `offs.get(iso)`; `materialize_teaching` nếu `off_days_in_range(day,day)` → xóa giang_day + return (không ghi nhật ký); `ngay_nghi_create/delete` gọi `sweep_teaching` khoảng đó để gỡ/khôi phục ngay. Test: 1→0 khi đặt nghỉ, →1 khi bỏ.

**CÒN CÓ THỂ THÊM:** nhắc trước giờ họp; hạn công việc lên lịch; báo vắng họp.
