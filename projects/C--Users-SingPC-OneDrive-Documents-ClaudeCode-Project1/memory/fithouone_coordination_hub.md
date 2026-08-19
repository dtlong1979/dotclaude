---
name: fithouone_coordination_hub
description: "Hub điều phối đa phiên FithouOne ở D:\\Dev\\FithouOne (.project/ + junction src/deploy) để chạy song song workload/hou-cntt/mobile"
metadata:
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-19T14:11:02.379Z
---

**Hub điều phối đa phiên** (dựng 2026-08-19) tại **`D:\Dev\FithouOne`** để chạy NHIỀU phiên Claude Code song song, mỗi phiên một phân hệ, chung context hạ tầng qua FILE (phiên không thấy chat của nhau).

**Cấu trúc:** `D:\Dev\FithouOne\` = hub governance (không di chuyển mã):
- `CLAUDE.md` (umbrella: mở phiên đọc .project theo thứ tự, khai báo phạm vi, kỷ luật deploy).
- `.project\` = **INFRA.md** (bản đồ hạ tầng: server `sscfit`, 3 container, lệnh deploy, DB, quy trình scp→rebuild, source-of-truth=SERVER), **STATE.md** (đang làm gì mỗi phân hệ), **STAFFING.md** (phiên nào sở hữu thư mục nào + ranh giới tránh đụng độ), **DECISIONS.md** (quyết định xuyên suốt), **TAXONOMY.md** (mô hình "mảng hoạt động" đang chờ user chốt).
- `src\` = **junction → `D:\Dev\hou-cntt`** (chứa cả 3: `workload/`, `backend/`+`web-admin/`+`web-sv/`+`db/`=hou-cntt, `mobile/`). `deploy\` = junction → `D:\Dev\fithouone-deploy`.
- Thêm `D:\Dev\hou-cntt\CLAUDE.md` (=src/CLAUDE.md) trỏ về hub để phiên mở ở mã thật hay junction đều tìm ra.

**Cách dùng (mở 3 phiên):** WORKLOAD mở tại `D:\Dev\FithouOne\src\workload` (sở hữu src/workload, rebuild `workload`); HOU-CNTT mở tại `D:\Dev\FithouOne\src` (sở hữu backend/web-admin/web-sv/db, rebuild `hou-cntt-api`); MOBILE mở tại `D:\Dev\FithouOne\src\mobile` (push master→Codemagic). Mỗi phiên gõ câu khai báo phạm vi (ghi sẵn trong STAFFING.md), chỉ sửa thư mục mình, cập nhật STATE.md khi xong, vùng chung (schema/gateway/nginx) ghi DECISIONS.md trước khi làm. LƯU Ý: phải mở qua đường `D:\Dev\FithouOne\...` để umbrella CLAUDE.md nạp.

Liên quan [[fithouone_deploy]] [[hou_cntt_paths]] [[agent_company_model]] [[workload_redesign]] [[hou_cntt_dang_ky_tin_chi]].
