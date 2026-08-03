---
name: hou-sentiment-monitor
description: "phần mềm demo NCKH giám sát & phân loại cảm xúc bình luận fanpage HOU; FastAPI+SQLite+React, ở D:\\Dev\\hou-sentiment-monitor"
metadata: 
  node_type: memory
  type: project
  originSessionId: 098983c5-111d-4c37-8f4b-0192c1ed7235
---

Phần mềm demo cho đề tài NCKH "Phát hiện tin xấu, tin giả liên quan đến trường đại học". Giám sát fanpage → tiền xử lý → phân loại sắc thái 3 nhãn (positive/negative/neutral) → dashboard → cảnh báo tiêu cực → phân tích tình huống.

- **Vị trí:** `D:\Dev\hou-sentiment-monitor` (git đã init). Đặc tả gốc: `docs/REQUIREMENTS.md`.
- **Stack (Mục 4 đặc tả):** backend FastAPI + SQLModel + SQLite (`backend/`, venv `.venv`), frontend React+Vite+Tailwind+Recharts (`frontend/`).
- **Triển khai theo mốc M0..M5** (Mục 16) — **M0–M5 ĐÃ XONG** 2026-06-26, mỗi mốc test thật đạt. Backend chạy `uvicorn app.main:app --port 8000` (venv `.venv`, PYTHONIOENCODING=utf-8 khi in tiếng Việt ra console cp1252). Frontend `npm run dev` (cổng 5173, proxy /api→8000). Test: `pytest tests/` (15 pass), `python -m scripts.evaluate` (heuristic ~79.7% trên gold). Còn lại M6 tùy chọn (Docker).
- **Quyết định người dùng (2026-06-26):**
  - Node.js đã cài qua winget (OpenJS.NodeJS.LTS, v24.18.0, npm 11.16.0) tại `C:\Program Files\nodejs` — NHƯNG chưa chắc có trong PATH của shell mới; nếu `node` không nhận, prefix `export PATH="/c/Program Files/nodejs:$PATH"`. Frontend đã `npm install` xong (173 gói) và build sạch.
  - Classifier demo: KHÔNG cài PhoBERT thật. Mặc định heuristic từ điển (chạy ngay, không key); có engine LLM/**Gemini** bật khi có `LLM_API_KEY`. Kiến trúc vẫn chừa `MODEL_PATH` để nạp PhoBERT sau.
- **Mặc định `DATA_SOURCE=mock`** — dùng `backend/mock_data/{posts,comments,gold_labels}.json` để demo không cần token Facebook. gold_labels.json là nhãn vàng để đánh giá độ chính xác.
- Yêu cầu: ẩn danh người bình luận (`author_hash`), không commit secret (chỉ `.env.example`), 3 nhãn đúng tên positive/negative/neutral.

- **Báo cáo NCKH:** `Bao_cao_tong_ket_de_tai_NCKH.docx` (trong outputs phiên). Đã thêm tiểu mục **4.3.4** vào Chương 4 với 6 ảnh chụp màn hình demo thật (Hình 4.7–4.12) + mô tả + kết quả → xuất `Bao_cao_tong_ket_de_tai_NCKH_demo.docx` (đặt cạnh bản gốc, KHÔNG ghi đè). Ảnh nguồn ở `docs/screenshots/`. Lưu ý báo cáo: mô hình chính là PhoBERT 2 luồng (F1 98,33% Chương 3); demo offline dùng classifier heuristic (79,7%) — phải nói rõ tách biệt.
- **Gotcha cấu hình frontend:** Tailwind `content` + Tailwind tự dò `tailwind.config.js` đều theo **cwd**; khi chạy vite từ thư mục khác (vd Preview tool chạy ở cwd phiên) thì Tailwind không sinh utility (CSS chỉ có preflight). Đã sửa: `postcss.config.js` import thẳng config object, `tailwind.config.js` dùng đường dẫn tuyệt đối forward-slash. Chụp ảnh app bằng Playwright (cài ở `.shots/`, gitignored) trỏ vào dev server.
- **Công cụ máy này:** không có pandoc/LibreOffice; skill docx cần `pip install defusedxml lxml` vào venv; pack.py/validate.py lỗi cp1252 khi in ra console (đặt PYTHONIOENCODING=utf-8, và validator báo lỗi giả do tự đọc file bằng cp1252 → dùng `--validate false`).

Liên quan: [[care_fusion_project]] (cùng chủ đề phân loại cảm xúc tiếng Việt).
