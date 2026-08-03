---
name: dissertation-to-practice
description: Phát triển luận án 2014 (tự tái cấu hình tế bào hệ đa xử lý chịu lỗi) thành các đề tài nghiên cứu ứng dụng có novelty; đã có 6 đề tài chính + 2 dự phòng + đề cương Đ4 (CertiHeal-Edge)
metadata: 
  node_type: memory
  type: project
  originSessionId: b2ac8b1a-f022-4b3d-8097-e7e79df865f3
---

Luận án gốc của user: Đinh Tuấn Long, MATI Moscow 2014 — *Mô hình & thuật toán tế bào tự tái cấu hình hệ đa xử lý chịu lỗi* (PDF: `C:\Users\SingPC\OneDrive\Luan an\Dissertation - Ban goc.pdf`, tiếng Nga). Nguyên thủy chuyển giao (P1–P5): tự chữa lành phi tập trung chỉ dùng dữ liệu cục bộ; biến liên tục từ **lưới dẫn dòng điện trở mô phỏng** (bộ giải Laplace/khuếch tán phân tán, spare=giếng, lỗi=nguồn); **tuyến đỉnh-rời**; hợp thành 3-automata; async/sync; metric "corrective capability".

Mục tiêu user: đưa lý thuyết này sang ứng dụng thực (UAV swarm, giao thông, IoT, xe tự lái, NoC/chiplet, vệ tinh, microgrid) — dùng pipeline nghiên cứu nhiều vòng (Workflow đa tác nhân) có kiểm chứng novelty đối kháng.

Kết quả (các file trong `C:\Users\SingPC\OneDrive\Luan an\`):
- `De-xuat-6-de-tai-ung-dung.md` — 6 đề tài chính (điểm 5–5.5): Đ1 TSN/FRER xe zonal, Đ2 Laplace in-fabric NoC, Đ3 aging-as-conductance chiplet, Đ4 chứng chỉ khả-sửa WSN/IoT, Đ5 chứng nhận chòm vệ tinh, Đ6 remap vai-trò zonal. Ưu tiên Đ1 + Đ4.
- `De-xuat-de-tai-BO-SUNG.md` — 2 dự phòng (UAV, giao thông; ~4.5); microgrid bị loại (power flow chính là lưới dẫn dòng → hết lợi thế).
- `De-cuong-D4-IoT-AI-CertiHeal-Edge.md` — đề cương chi tiết Đ4 hướng IoT/edge + AI = **CertiHeal-Edge**: trường điện trở đóng 3 vai (inductive bias GNN unrolled + chứng chỉ khả-sửa + fallback training-free), di trú chủ động theo RUL. Đối thủ gần nhất phải phân định: **arXiv 2011.02190** (self-stabilizing control plane edge/fog).
- `Kiem-chung-trich-dan-D4.md` — kiểm chứng 34 trích dẫn (đều thật, đúng ID); đã sửa mô tả SeLR (cổ điển, không phải learned), Kubernetes 2507.16109 (đừng dùng ngược chiều), SafePowerGraph, PI-GNN.

PoC thí nghiệm (CPU, `experiments\certiheal_poc\poc*.py`, `PHAT-HIEN.md`): tái lập được claim luận án (trường điều phối ≫ rời-rạc-naive ~30× dưới lỗi cụm); trường phi tập trung ≈ greedy tập trung ở comm thấp (Jacobi ~2.4× đường kính); chứng chỉ min-cut đơn điệu theo #spare (ĐG4 vững). Vòng 2: **ĐG1 nguyên bản bị BÁC** (oracle-conductance khép 0% dưới descent-argmin) → nút thắt là *luật routing*, không phải conductance. Vòng 3: đổi sang **soft/current-proportional routing** → κ 0.179→0.234 sát optimum 0.257 (trường phi tập trung ≈ OPTIMUM, không chỉ ≈ greedy), và oracle-conductance khép **100% vs random 63%** → **ĐG1 phục sinh dạng "learned soft-routing + learned conductance"**. **ĐG3 xác nhận**: proactive RUL migration bảo toàn ~100% vs ~84% reactive khi σ≤1.5, hoà vốn σ≈2.4.

VÒNG 4-6 (GNN + scale sweep 11.8h + RL): lớp AI YẾU hơn kỳ vọng. Learned-conductance GNN (AUC 0.94) chỉ khép ~10-20% khe hở tới optimum, KHÔNG tăng theo quy mô (khi kiểm soát độ khó); RL-router (REINFORCE, 15k ep) THUA cả soft-router thường (prior "đi theo dòng điện" của trường khó bị đánh bại). Oracle headroom (80%) có thật nhưng cả 2 hướng học tự nhiên KHÔNG bắt được → B là bài toán MỞ/khó. KẾT LUẬN CHỐT: hero = chứng chỉ khả-sửa (ĐG4) + phi tập trung ≈ optimum & ≫ naive (30-725×) + locality (P1) + proactive RUL (ĐG3); AI = phụ. Định vị bài dạng A "dependable decentralized self-healing with repairability certificate" → TDSC/TPDS/IoT-J Q1. Behavior-cloning tuần tự lời giải tối ưu = hướng chưa thử cho B.

2 workflow phản biện đối kháng (networking + UAV, ~93 agent): NETWORKING = ngõ cụt (0 sống sót, bị TI-LFA/MPLS-FRR/PEFT/Lightyear/Coral chiếm sạch; trường P2 chết vì `L2≠L1` + không thắng coordinated) → chỉ dùng làm related-work. UAV = CBBA/DRM chiếm ~80-85% nhưng còn 1 lát niche (score 4): coupling comm-connectivity ⊗ capability (mất mát cắt chính mạng điều phối P2P — thứ CBBA/DRM giả định vắng).

BÀI #2 = UAV-Edge (giữ bài #1 CertiHeal-Edge nguyên). Đóng góp = systems+safety-lemma: tái-gán per-component + BỎ nhiệm vụ có witness + soundness ("không bao giờ bỏ task mà UAV rảnh cùng component phục vụ được"). Thực nghiệm (experiments/uav_edge_poc/uav_edge.py, networkx min-cost-flow): soundness=0 tuyệt đối; partition-unaware OVERCLAIM tăng theo mất mát & theo tỉ lệ SVR/comm_r (tới ~22% khi service-range ~2× comm-range), ta hiện thực hơn naive ~17%. Trường P2 = chỉ warm-start (KHÔNG phải certificate). Venue RA-L/IROS/DARS (KHÔNG T-RO/AAMAS-main). Báo cáo: Tham-dinh-huong-{Networking,UAV-swarm}.md + DE-CUONG-UAV-EDGE.md. Code+báo cáo: experiments/certiheal_poc/ (poc*.py, gnn_certiheal.py, gnn_scale_sweep.py, rl_router.py, PHAT-HIEN.md 6 vòng).

Nguyên tắc user coi trọng: **novelty phải phòng thủ được** — over-claim bị hạ cấp (vd trường liên tục KHÔNG vượt ILP về tối ưu; lợi thế thật = phi tập trung + comm thấp + hội tụ bị chặn + chứng chỉ). Chạy CPU + GPU nhỏ, không cần HPC. Xem [[care_fusion_project]], [[emotion_anchors_paper]] cho các dự án NCKH khác.
