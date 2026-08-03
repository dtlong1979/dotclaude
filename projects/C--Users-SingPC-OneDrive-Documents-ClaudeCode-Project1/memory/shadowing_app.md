---
name: shadowing-app
description: "Mục tiêu, phạm vi và quyết định công nghệ của app học Tiếng Anh theo phương pháp shadowing (nghe/nói)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 50fedf4e-27af-4071-920a-eee5f5c408c0
---

Dự án thứ hai (khác với [[project-overview]] là app chat/quản lý công việc): app di động dạy kỹ năng **nghe & nói Tiếng Anh chuẩn Anh-Mỹ** theo phương pháp shadowing. Android trước, iOS sau.

**Luồng học cốt lõi:** chọn chủ đề → hệ thống đưa 1 đoạn văn → 3 hoạt động liên tiếp: (1) nghe, (2) nghe + đọc theo, (3) tự đọc có ghi âm → nghe lại + AI chấm/góp ý phát âm. Xếp cấp theo 6 mức ánh xạ CEFR (A1→C2); chọn cấp thủ công hoặc làm placement test. Tự động điều chỉnh cấp theo kết quả từng buổi.

**Quyết định công nghệ (chốt 2026-05-25):**
- **Flutter + Firebase** (Auth/Firestore/Storage/Cloud Functions) — một codebase cho Android & iOS.
- **Nội dung: sinh sẵn** cho MVP — dùng LLM sinh trước thư viện đoạn văn theo cấp độ + chủ đề, render TTS (giọng Anh-Mỹ) sẵn, lưu cloud → runtime rẻ, chạy offline. "Sinh động theo yêu cầu" để dành phase sau (hybrid).
- **Chấm phát âm: Azure Pronunciation Assessment** (accuracy/fluency/completeness/prosody tới từng âm vị), kết hợp Claude API để diễn giải thành góp ý dễ hiểu. Tích hợp ngay từ MVP vì đây là tính năng lõi tạo khác biệt.

**Why:** Quy mô nhỏ, ưu tiên ra MVP nhanh, chi phí runtime thấp, kiểm soát chất lượng nội dung. Chất lượng giọng TTS và độ chính xác chấm phát âm là yếu tố quyết định trải nghiệm shadowing.

**How to apply:** MVP = 1-2 chủ đề × 6 cấp × ~20-30 đoạn sinh sẵn, ghi âm lưu local (riêng tư). Phase 2 thêm chủ đề, sinh động, iOS. Khi đề xuất kiến trúc/tính năng, bám sát stack đã chốt và ưu tiên đơn giản.

**Cập nhật chiến lược nội dung (chốt 2026-05-26): chuyển sang CONTENT PACK.**
- Nội dung dạng **audio sinh sẵn (cloud TTS) + timeline mốc từng từ** để đồng bộ tô chữ khi phát (không phụ thuộc TTS máy). Pack nào không có audio thì fallback TTS máy + highlight realtime.
- **Đơn vị pack = category × level** (vd `daily_life-L1`). Người học tải đúng cấp/lĩnh vực cần.
- **Định dạng pack** = file zip (đuôi vd `.shpack`): `manifest.json` (packId, category, categoryNameVi, level, cefr, version, passageCount, sizeBytes, checksum, voice) + `passages.json` (mỗi đoạn: id,title,text,vocab[],audio,timings[{w,s,e}]) + `audio/*.mp3`.
- **Host: Google Drive** (user chọn, tiện + dung lượng lớn). LƯU Ý: link tải trực tiếp `https://drive.google.com/uc?export=download&id=FILE_ID`; file >~100MB bị trang xác nhận virus (cần confirm token) → giữ pack <100MB (per level là ổn). Drive không có listing → app đọc `index.json`.
- **Thiết kế HOST-AGNOSTIC**: app đọc `index.json` từ 1 URL cấu hình được; mỗi pack entry có URL tải trực tiếp + version + sizeBytes + sha256. Đổi host (Drive/GitHub/jsDelivr) không cần sửa app.
- App có **Kho nội dung** (duyệt index, tải, cập nhật theo version) + **Quản lý gói** (liệt kê đã cài + dung lượng, xóa để nhẹ máy). Có **nhúng sẵn 1 pack mẫu** (daily_life-L1) để học ngay khi chưa tải.
- **Pipeline tạo pack** (script phía tác giả): text → Azure TTS REST (mp3) → chạy audio qua Azure STT detailed lấy Offset/Duration từng từ → timings → đóng .shpack → upload. (WordBoundary thật cần Speech SDK; dùng STT-detailed offsets là cách thay thế qua REST.)
- Kế hoạch theo phase: (1) định dạng pack + pack mẫu nhúng + ContentService đọc pack + sổ đăng ký; (2) pipeline tạo audio+timeline; (3) phát + highlight theo timeline (just_audio position); (4) màn Kho nội dung + Quản lý gói (tải/giải nén/verify/xóa).

**Luồng học mới (chốt 2026-05-26):** sau bước ghi âm → bước 4 Kết quả (tự chấm Azure) có 2 nút: **Tiếp theo** (pack normal: chọn câu khác, nếu PronScore≥90 và có sublevel cao hơn thì nâng độ khó, ngược lại giữ; pack **series** = câu kế tiếp theo thứ tự — đã cấu trúc `packType` trong manifest) và **Kết thúc** → màn **Tổng kết** (số câu, thời gian, điểm TB từng tiêu chí, sao, tiến bộ, XP, nhận xét, nút Chia sẻ sao chép thẻ).

**Công thức điểm (chốt 2026-05-26):**
- **Điểm chất lượng** = PronScore (Azure) → trung bình buổi → sao 1–5. Để tự so.
- **Điểm tiến bộ** = trung bình chênh lệch điểm so với **baseline EMA cá nhân** (α=0.4, lưu xuyên buổi). Tụt điểm phạt **×2 (k=2)**; sàn ≥0 ở tổng (chống cố tụt-tăng để cày). Lần đầu chưa có baseline thì không tính.
- **XP buổi** = `(tiến_bộ + số_câu) × hệ_số_chất_lượng × hệ_số_độ_khó`, hệ_số_chất_lượng = `0.5 + điểmTB/100` (cùng tiến bộ thì điểm chất lượng cao hơn → XP cao hơn — yêu cầu của user), hệ_số_độ_khó = `1.0+(sublevel-1)*0.08`.
- Lưu **lịch sử buổi** cục bộ (ProgressStore: ema + sessions[{t,xp,count,avgPron,progress}]) → thống kê **streak / XP tuần / XP tổng / tổng câu** hiển thị ở Trang chủ. Bảng xếp hạng nhiều người cần backend (chưa làm).
