---
name: workload_hou_cntt_teaching_bridge
description: "Liên thông lịch giảng + lớp CVHT từ hou-cntt sang workload (cache theo kỳ); Tầng 1 (panel) + Tầng 2 (tự ghi nhật ký, báo nghỉ) đã deploy; Tầng 3 (định mức) chưa làm"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-21T09:48:59.873Z
---

Liên thông **nhiệm vụ giảng dạy** hou-cntt → workload cho nhóm giảng viên (tổ bộ môn), vì lịch giảng + số lớp cố vấn học tập cũng là nhiệm vụ cần đối chiếu với công việc được giao. Xem [[workload_redesign]], [[app_workload_bridge]], [[hou_cntt_lich_giang_import]], [[fithouone_coordination_hub]].

**Kiến trúc CHỐT (user chốt 2026-08-21):** KHÔNG đọc trực tiếp DB bên kia (workload=SQLite, hou-cntt=PostgreSQL — 2 engine/2 container, không có bảng chung). Dữ liệu giảng dạy/CVHT **tĩnh cả học kỳ** → **cache sang bảng riêng bên workload, đồng bộ THƯA** (nút thủ công + sau này bắn tín hiệu khi TKB đổi + cron ngày tùy chọn); đọc lúc mở trang là LOCAL.

**Khóa nối SẠCH (không cần ánh xạ):** workload `users.ma_cb` == hou-cntt `lich_hoc.ma_gv` == `co_van_lop.username_cv` (đều dạng CH0xxx). 26/26 cán bộ workload đã có ma_cb.

**Nguồn dữ liệu hou-cntt:** `lich_hoc` (thu/ca_hoc/tu_tiet-den_tiet/tu_tuan-den_tuan/tu_ngay-den_ngay/ma_phong/ma_gv/ma_lop_tc) JOIN `lop_tin_chi` (ten_hp/ma_hp/hoc_ky/nam_hoc); `co_van_lop` (username_cv→lop). thu: 2=T2..8=CN.

**Đã build + DEPLOY (Tầng 1):**
- **hou-cntt** `backend/app/api/routes/internal.py`: endpoint `POST /api/internal/gv-nhiem-vu` (bảo vệ `_check_svc` = service token dùng chung X-Workload-Service-Token), nhận `{ma_cbs:[...]}` → trả `{lich_giang:{ma_cb:[...]}, cvht:{ma_cb:[...]}}`. Additive/read-only, student portal không ảnh hưởng. **LƯU Ý: server `/home/fitadm/code/fithouone/hou-cntt` ĐI TRƯỚC bản local D:\dev\hou-cntt** (server có thêm endpoint `/audit` audit-central mà local chưa có) → sửa file phải KÉO bản server về, chèn, đẩy lại; KHÔNG scp đè bản local. Deploy: `docker compose --env-file .env up -d --build --no-deps hou-cntt-api`.
- **workload** `db.py`: 3 bảng `gv_lich_giang`, `gv_cvht`, `gv_sync_meta`. `app.py`: `_fetch_gv_nhiem_vu()`, `sync_gv_nhiem_vu(conn)` (xóa+nạp toàn bộ, upsert meta), `gv_nhiem_vu_of(conn,ma_cb)` (đọc lịch ĐANG HIỆU LỰC: hôm nay trong [tu_ngay,den_ngay], gom theo thứ + list CVHT + last_synced), route `POST /gv/dong-bo` (admin), panel gắn ở home `/`. `hom_nay.html`: section "Nhiệm vụ giảng dạy" (nút "Đồng bộ từ hệ đào tạo" cho admin). `style.css`: .gv-day/.gv-slot/.gv-cvht/.gv-synced (xanh brand, dark-aware).
- **Verify prod:** sync thật kéo **106 buổi giảng + 69 lớp CVHT** cho 26 cán bộ. VD CH0162 (Lê Hữu Dũng): 8 buổi hiệu lực + CVHT 2210A06..., có slot "T2 Tối tiết 9-12 Lập trình Web nâng cao P32" — khớp buổi **Tối** vừa thêm.

**Đã build + DEPLOY (Tầng 2):** user chốt lại mô hình — **KHÔNG có nút "Đã dạy"**: có lịch + không báo nghỉ = đương nhiên đã dạy; **thời lượng LUÔN cả buổi** (nhiều lớp cùng buổi vẫn chỉ 1 "cả buổi", không cộng quá 4h/buổi). Chỉ thao tác **Báo nghỉ / Hủy báo nghỉ** từng lớp.
- `db.py`: thêm cột `gv_lich_giang.tuan_kieu` (migration `_addcol`) + bảng `gv_nghi(ma_cb,ngay,ma_lop_tc,buoi,ly_do)`.
- hou-cntt endpoint bổ sung trả `tuan_kieu` (deploy lần 2).
- `app.py`: `teaching_on(conn,ma_cb,day)` (khớp thứ=isoweekday+1, trong [tu_ngay,den_ngay], tuần chẵn/lẻ, trừ báo nghỉ) + `materialize_teaching()` (mỗi buổi có ≥1 lớp đã dạy → 1 dòng activity_logs source='giang_day' muc_tg='ca_buoi'; buổi nghỉ hết → xóa) + route `POST /log/gv-nghi` (action nghi|day). `/log` render: materialize khi ngày còn sửa được + bỏ qua source giang_day ở vòng touch-picker.
- `log.html`: mục "Giảng dạy hôm nay" (gom theo buổi, tag "Đã dạy · cả buổi" / "Đã báo nghỉ", nút Báo nghỉ). `style.css`: .gv-jrow/.gv-nghi/.gv-tag-day...
- **Verify prod:** CH0162 ngày T5 20/08 buổi Sáng tự thành "Giảng dạy: Lập trình Web nâng cao · cả buổi (4h)"; báo nghỉ → mất; hủy → khôi phục. ca_hoc Sáng/Chiều/Tối→sang/chieu/toi. Backup `*.bak_gv2_*`.

**TINH CHỈNH (deploy 2026-08-21, user chốt thêm):**
- **Giảng dạy TỰ GHI mọi ngày đã đến, KHÔNG cần mở /log** (chưa tới ngày thì chưa ghi). Thêm `gv_sync_meta.last_swept` + `sweep_teaching(conn,from,to)` (mọi user có ma_cb × mọi ngày, materialize idempotent, `materialize_teaching` chặn `day>today_str()`) + `maybe_daily_sweep(conn)` (1 lần/ngày, incremental từ last_swept+1; lần đầu backfill từ min(tu_ngay) giới hạn 120 ngày). Gọi ở route `/` (home, try/except) + trong `sync_gv_nhiem_vu` (reset last_swept=NULL rồi sweep). Bỏ chặn `_diary_editable` ở /log materialize. **Verify: sweep tự tạo 84 dòng giang_day 10/08→21/08 cho 14 GV, 0 dòng tương lai, không mở /log.** LƯU Ý múi giờ: today_str()=VN(+7) nhưng SQLite date('now')=UTC → khi test đừng so bằng date('now').
- **CVHT TÁCH khỏi giảng dạy** (là loại nội dung khác, KHÔNG auto-log nhật ký): Trang Hôm nay tách 2 khối — "Cố vấn học tập" (mỗi lớp là link `/to-admin?sv=<lop>` → SSO web-admin, giảng viên tự vào trang 'students' Quản lý Sinh viên; web-admin dòng 4243 `adminRole==='giangvien'→page='students'`, KHÔNG cần sửa web-admin) + "Lịch giảng dạy" (tham chiếu). `/to-admin` nhận thêm `sv` truyền qua fragment (`#code=..&sv=<lop>`) để sau này web-admin mở đúng lớp — hiện web-admin bỏ qua vẫn về trang SV. CSS .gv-cvht-link. Backup `*.bak_gv3_*`.

**TINH CHỈNH đợt 2 (deploy 2026-08-21):** (1) bớt các dòng hướng dẫn ở panel Hôm nay + mục Giảng dạy /log. (2) CVHT hiện **một dòng** "Lớp bạn cố vấn: …" + **tự lọc lớp quá 8 năm** kể từ khóa nhập (`_cvht_con_han`: 2 số đầu mã lớp = năm 20xx; 2026−năm>8 → bỏ; vd 1510→bỏ, 1810→giữ). (3) **Tự đồng bộ khi đăng nhập, BỎ nút bấm**: `maybe_daily_sync(conn)` (guard last_synced[:10]==today, gọi ở route `/`, kèm sweep). (4) **Thanh tiêu đề (hn-zonetitle/hz-*) nền bão hòa + chữ trắng** (hz-do #0e7c66, hz-review #b9700a, hz-late #c62828, hz-note #2563eb, hz-link #64748b) để phân biệt rõ với nội dung; hn-count→chip đen mờ chữ trắng; .opt/.btn-tiny trong header chỉnh theo. Backup `app.py.bak_gv4_*`.

**LIÊN THÔNG ĐĂNG BÀI WEBSITE (deploy 2026-08-21):** ghi nhận đăng bài lên website vào nhật ký, **1 bài/ngày = 30 phút**. Nguồn: `fit_hou_cms.fithou_admin_logs` (action='content.publish', có actor_email+timestamp+target=tiêu đề+#id). Khóa nối: **actor_email == workload users.email** (@hou.edu.vn). hou-cntt endpoint mới `/api/internal/website-posts` (đọc fit_hou_cms qua `WEBSITE_DATABASE_URL`=creds fit_hou trong deploy .env + compose hou-cntt-api; user hou_cntt KHÔNG có SELECT fithou_admin_logs nên phải dùng fit_hou; SQLAlchemy text đừng dùng `:bind::date` mà `CAST(:bind AS date)`), GOM theo bài/ngày (GROUP BY target, giờ VN). workload `sweep_website_posts` (source='website', muc='30p', buổi theo giờ đăng) trong `maybe_daily_sweep` + nút **"↻ Làm mới"** ở /log (route `/log/lam-moi`, throttle 30s toàn hệ, chạy lại cả website+giảng+họp). log.html mục "Đăng bài website hôm nay". **LƯU Ý server hou-cntt đi trước local** — sửa phải kéo bản server về. Backup `internal.py.bak_web_*`, workload `app.py.bak_web_*`.

**BUỒNG LÁI "Lớp của tôi" — Phase A nền tảng (deploy 2026-08-21):** user chốt kiến trúc **buồng lái** (workload UI → hou-cntt xử lý, KHÔNG sao chép/viết lại; dữ liệu SV ở hou-cntt là nguồn sự thật), làm A+B+C, A xem **đầy đủ như QLSV nhưng CHỈ ĐỌC không sửa**. **A-foundation xong:** hou-cntt endpoints nội bộ (server internal.py) `/api/internal/gv-lop` (lớp CVHT co_van_lop.username_cv=ma_cb + lớp giảng lich_hoc), `/lop-sv` (SV của lớp CVHT: sinh_vien.lop, kiểm quyền lop∈lớp CVHT của ma_cb), `/sv-chi-tiet` (hồ sơ SV cơ bản + điểm rèn luyện `diem_ren_luyen(ky,diem)`; kiểm quyền). workload `_hc_post()` generic + route `/lop-cua-toi` (3 trạng thái: DS lớp→DS SV→hồ sơ), template lop_cua_toi.html, nav "Lớp của tôi" (i-grad, active='lopsv'). Verify CH0162: 4 CVHT+12 giảng, lớp 2210A06=31 SV. **A ĐẦY ĐỦ (deploy 2026-08-21):** thêm endpoint `/api/internal/sv-hoc-tap` (ket_qua_hoc_phan: ma_hp_goc/hoc_ky/diem_he4/diem_so/diem_chu/so_tc/dat + ten_hp qua lop_tin_chi; tổng GPA có trọng số so_tc + TC đạt/tổng); hồ sơ SV workload hiện bảng kết quả học tập (môn chưa đạt tô đỏ). Verify SV 37 môn GPA 2.31. CHỈ CÒN "tiến độ CTĐT theo khối" (block-credit phức tạp) tạm link QLSV.
**B + C ĐÃ DỰNG (deploy 2026-08-21):** hou-cntt internal endpoints (write, ký service-token, resolve `_tk_by_ma_cb` = TaiKhoan theo ma_cb, kiểm quyền lớp):
- **B thông báo lớp CVHT** `/api/internal/cvht-thong-bao` {ma_cb,lop,tieu_de,noi_dung} → ThongBao doi_tuong='LOP' + `_push_noti` (bg). Chỉ lớp CVHT của mình.
- **B nhắn nhóm lớp** `/api/internal/nhan-nhom-lop` {ma_cb,loai(lop_ql|lop_tc),ref,noi_dung} → `chat.gui_tin_nhom('LOP_QL'|'LOP_TC',ref,...)` + `giang_vien._push_chat_nhom` (bg). Quyền: lop_ql∈CVHT / lop_tc∈lich_hoc.ma_gv.
- **C GV báo nghỉ** `/api/internal/gv-bao-nghi` {ma_cb,ma_lop_tc,ngay,ly_do} → `diem_danh_gv._so_huu` + `bao_bu_svc.bao_nghi`. (Báo BÙ chưa làm — bao_bu.py có goi_y.)
- workload routes `/lop/thong-bao`,`/lop/nhan`,`/gv/bao-nghi` (dùng `_hc_post`), UI trong lop_cua_toi.html (nút ở DS SV lớp CVHT + mỗi lớp giảng dạy), flash `_LOPSV_FLASH`. **LƯU Ý: chưa test gửi THẬT (tránh làm phiền SV) — user bấm lần đầu.** Verify đường TỪ CHỐI/quyền OK.
- **CÒN LÀM:** báo BÙ; danh sách SV lớp tín chỉ; tiến độ CTĐT theo khối (block-credit) nhúng workload (đang link QLSV).

**ĐANG BÀN (#2 — audit → nghiệp vụ, chờ user duyệt mapping):** kho `audit` DB `audit_log` (ts/action_code/action_label/actor_id/phan_he) ghi thao tác hou-cntt. Kế hoạch: lọc phan_he='hou-cntt' + cán bộ (bỏ SV + login), gom action_code → vài NGHIỆP VỤ (Duyệt SV đăng ký / Xếp lớp / Tạo đợt đăng ký / Xử lý SV vượt cảnh báo / Cập nhật dữ liệu…), chỉ GHI NHẬN việc, giờ tính theo TỪ ĐIỂN workload sau. actor_id=username CAS → cas_canbo → ma_cb. CHƯA build — chờ user chốt danh sách nghiệp vụ + mapping.

**CÒN LÀM (Tầng 3 — chưa duyệt chi tiết):** quy số tiết + số lớp CVHT thành ĐỊNH MỨC nhiệm vụ để đối chiếu công việc/đánh giá; ngòi nổ tự đồng bộ khi giáo vụ sửa TKB bên hou-cntt (hiện phải bấm "Đồng bộ từ hệ đào tạo"); (tùy chọn) web-admin đọc `sv` để mở đúng lớp CVHT.

**Backup:** hou-cntt `internal.py.bak_gv_*`, workload `app.py.bak_gv_* / db.py.bak_gv_*`.
