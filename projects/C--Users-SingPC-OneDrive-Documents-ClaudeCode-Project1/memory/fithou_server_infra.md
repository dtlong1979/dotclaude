---
name: fithou-server-infra
description: Sơ đồ hạ tầng VM FithouOne (ESXi/Zentyal/SSC) + cách cứu khi mất điện/không vào được từ ngoài
metadata: 
  node_type: memory
  type: reference
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-09T15:58:38.627Z
---

Hạ tầng chạy trên **VMware ESXi**, quản lý ở `https://118.70.222.142/ui` (user dungnd). Các VM:
- **zentyal-router** (Zentyal firewall, user zadmin): eth0=`118.70.222.141/27` (WAN, IP công cộng của cả hệ), eth1=`192.168.1.1` (gateway LAN). Làm NAT/port-forward + gateway ra ISP `.129`. Web admin `https://localhost:8443` (Firewall/Network).
- **SSC / sscfithou** (VM 20, user fitadm, sudo cần mật khẩu): `192.168.1.20`, chạy toàn bộ Docker (fithou-web, hou-cntt-api, workload, directus, postgres, minio...). DB workload ở volume `/data/data.db`.
- **nginx-proxy** (`192.168.1.2`): reverse proxy web. **Zentyal port-forward** `.141:443/80 → 192.168.1.2`, `.141:2222 → .1.2:22`.
- Virtualmin, Windows SVR NCKH, "Zentyal .1.1" (cũ, tắt — KHÔNG cần).

**SSH từ ngoài:** `ssh sscfit` (config có sẵn) = jump qua `zentyal-htec` (`.141:22`, zadmin) → `sscfit` (`192.168.1.20`, fitadm). Deploy web: sửa local `D:\dev\Fithou Website` → scp lên `/home/fitadm/code/fithouone/Fithou Website` → `docker compose build/up` ở `fithouone-deploy`. Workload KHÔNG có bản local/git — sửa thẳng trên server `/home/fitadm/code/fithouone/workload` (nhớ backup).

**SỰ CỐ MẤT ĐIỆN 2026-08-08 — gốc rễ & cách cứu (nếu ngoài không vào được nhưng `.142` sống):**
1. VM không tự bật → vào ESXi UI bật (đã đặt **Autostart** để tự lên: zentyal-router→nginx-proxy→SSC→Virtualmin).
2. **zentyal-router mất default route** — Zentyal Gateway để nhầm `.141` (IP của chính nó) thay vì `.129`. Sửa: Network→Gateways đổi IP=`118.70.222.129`, Save changes. (Tạm: `sudo ip route add default via 118.70.222.129 dev eth0`.)
3. **Đụng IP `.141`** — cloud-init trên SSC tự gán `.141` (vốn của zentyal-router) → ARP loạn, mất internet. Đã vá vĩnh viễn: gỡ `/etc/netplan/50-cloud-init.yaml` + `network:{config:disabled}` ở `/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg`. SSC chỉ nên có `192.168.1.20` + default `via 192.168.1.1`.
4. **SSH 22 chặn** — Zentyal Firewall thiếu luật external→Zentyal cho SSH. Thêm ở Firewall→"Filtering rules from external networks to Zentyal": ACCEPT SSH/22/Any → Save.

**Workload log (2026-08-09):** IP thật hiển thị sau khi Zentyal **bỏ tick "Replace source address" (SNAT)** cho port-forward 443/80. Container workload đã set `TZ=Asia/Ho_Chi_Minh`+tzdata trong Dockerfile (giờ VN). Middleware `_audit_log` bỏ log GET `/api/*` không đăng nhập (SSR nội bộ).

Liên quan: [[fithouone_deploy]] [[workload_app]]
