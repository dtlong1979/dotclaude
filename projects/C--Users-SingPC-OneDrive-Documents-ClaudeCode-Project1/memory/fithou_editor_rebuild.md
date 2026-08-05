---
name: fithou-editor-rebuild
description: "Cải tổ editor soạn bài web fit.hou.edu.vn: bỏ block editor tự viết, dùng TipTap + AI trong editor"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-08-05T10:13:31.660Z
---

Cải tổ editor soạn bài viết website Fithou (Next.js 16/React 19 + Directus). Xem [[fithou-website-local]], [[fithou-ai-key-config]].

**Quyết định (user chốt):** bỏ toàn bộ block editor tự viết (`components/fithou-visual-editor.tsx` 1288 dòng) + toolbox rời, thay bằng **TipTap** (RTE); chèn link/ảnh/video/file NẰM TRONG editor. File inline: **PDF nhúng iframe, DOCX→HTML (mammoth), XLSX→bảng (sheetjs)**; PPTX tạm chỉ đính kèm. 4 nút AI trong editor: chèn ảnh AI (sinh 3 chọn 1), cải thiện vùng bôi đen, viết lại 800-1000 từ SEO, sinh ảnh đại diện.

**Đã cài:** `@tiptap/{react,pm,starter-kit,extension-image,extension-link,extension-placeholder,extension-underline,extension-text-align}@^2.27` (React 19 OK).

**BACKEND ĐÃ XONG + tsc sạch (0 lỗi):**
- `lib/fithou-editor.ts`: `EditorArticlePayload` thêm `content_html?`; `saveEditorArticle` + `validateEditorArticleWorkflow` dùng content_html trực tiếp khi có + `blocks` rỗng (sanitize bằng `sanitizeLegacyHtml`, tự lấy thumbnail từ `<img>` đầu). Bài cũ vẫn load qua content_html/blocks. Detail đã trả `content_html` sẵn.
- `lib/security.ts` `sanitizeLegacyHtml`: cho phép iframe PDF từ origin Directus (`${NEXT_PUBLIC_DIRECTUS_URL}/assets/`) — class `fithou-pdf-frame`; vẫn giữ YouTube/Vimeo. Bảng/figure/div không bị strip sẵn.
- `app/api/fithou-editor/ai/image/route.ts`: 2 chế độ — sinh 3 ảnh xem trước (data URI webp, KHÔNG upload, `count`≤3, 3 call song song) + `{saveDataUri}` để upload ảnh đã chọn → `{src}`.
- Route MỚI `ai/rewrite` (title+text → HTML bài 800-1000 từ SEO, JSON `{html}` sanitized), `ai/text` (cải thiện đoạn bôi đen text→text), `files/preview` (url Directus + kind docx/xlsx → HTML sanitized; docx=mammoth, xlsx=XLSX.sheet_to_html tối đa 5 sheet).
- **413**: nginx `fit.hou.edu.vn` ĐÃ có `client_max_body_size 25m` + Directus `MAX_PAYLOAD_SIZE 25mb` trong compose đã commit → 413 ở 4MB là do PROD chạy config CŨ (nginx mặc định 1MB); **deploy batch sẽ hết**. Route upload cho 25MB sẵn.

**FRONTEND ĐÃ XONG — build sạch (tsc 0, lint 0, `next build` ✓ 58/58 trang):**
- **`components/fithou-rich-editor.tsx`** (MỚI): editor TipTap. Extensions: StarterKit(h2-4)+Underline+Link+Placeholder+TextAlign+Table(+row/cell/header) + node tùy biến: `ResizableImage` (kéo góc đổi width, NodeView), `VideoEmbed` (youtube/vimeo iframe hoặc `<video>` tải lên; parseHTML `iframe[src]` trừ pdf), `PdfEmbed` (`iframe.fithou-pdf-frame`), `FileChip` (`a[data-file-chip]`, getAttrs khôi phục href+filename). Toolbar đầy đủ + chèn ảnh/video(URL+upload)/tệp/link. Tệp 2 chế độ qua modal: Đính kèm (chip tải) vs Hiển thị (PDF→pdfEmbed, DOCX/XLSX→gọi `files/preview` chèn HTML). 3 nút AI: cải thiện vùng chọn (`ai/text`), viết lại (`ai/rewrite` setContent), chèn ảnh AI (modal sinh 3 chọn 1 → save). Sync value↔getHTML.
- **`components/fithou-visual-editor.tsx`** (SỬA): giữ shell (tiêu đề/tóm tắt/danh mục/trạng thái/lưu/redirect); thêm state `contentHtml`; load `article.content_html`; `articlePayload` gửi `content_html`+`blocks:[]`; validate + wordCount theo HTML; **BỎ** nav toolbox thêm khối + dropdown "Trợ lý AI" cũ; render `<FithouRichEditor>`; preview dùng `dangerouslySetInnerHTML(contentHtml)`; thêm nút **"Sinh ảnh AI"** cạnh thumbnail (`generateThumbAi`: ai/image count:1 → save → setThumbnail). (JSX AI-panel cũ còn nhưng aiPanel luôn "" nên không hiện — dead code, warn thôi.)
- CSS `app/globals.css` (cuối file): `.rte-*` (toolbar/nút/modal/ảnh handle/ai-grid) + `.article-body/.rte-content .fithou-pdf-frame|.fithou-video|.fithou-file-chip|.fithou-doc-embed` + `.editor-thumb-ai`.
- Cài thêm `@tiptap/extension-table{,-row,-cell,-header}` (bảng để XLSX/DOCX inline round-trip).

**CÒN LẠI:** chỉ kiểm THỰC TẾ trên trình duyệt (chèn từng loại, mở lại bài cũ) khi chạy dev/deploy — chưa test runtime (cần full stack Directus+auth). 413 = deploy nginx 25m. Gói chung đợt deploy với [[app-workload-bridge]] + [[password-cas-vs-local]]. ĐÃ DEPLOY prod 2026-07-30 (server sscfit, build 3 image + up + verify xanh).

**TINH CHỈNH CÔNG CỤ AI (2026-08-05):**
- **`ai/rewrite` đổi HẲN hành vi**: trước là "viết lại toàn bài SEO 800-1000 từ" lấy `getText()` rồi `setContent` (mất cấu trúc/link/ảnh/file — user chê). Nay = **BIÊN TẬP VĂN PHONG giữ nguyên cấu trúc**: nhận `html` (`editor.getHTML()`), route `protect()` thay ảnh/iframe/video/`a[data-file-chip]` → `[[FMEDIA n]]` và href liên kết → `[[FHREF n]]` (AI KHÔNG sửa/xóa được), prompt yêu cầu giữ số/thứ tự đoạn+thẻ HTML, chỉ làm chữ phong phú, KHÔNG kéo dài máy móc, cân đối bullet, giữ giọng văn; `restore()` khôi phục nguyên trạng rồi `sanitizeLegacyHtml`. Frontend `aiRewrite` gửi html, đổi confirm/tooltip. (Thứ tự protect: file-chip → iframe → video → img → href; test round-trip OK: mọi src/href/data-filename giữ nguyên, chữ đổi, không sót placeholder.)
- **`ai/text`** (cải thiện đoạn bôi đen): nới cho "diễn đạt phong phú hơn" nhưng giữ ý + độ dài, không thêm số liệu.
- **`ai/image` đa phong cách + hướng SINH VIÊN**: `autoPrompt` mô tả CẢNH (đối tượng sinh viên đại học VN, bối cảnh học tập/công nghệ), KHÔNG cố định style; thêm `STYLE_VARIANTS` (ảnh thật/flat vector/3D/editorial) — khi prompt tự sinh thì 3 ảnh preview mỗi ảnh MỘT phong cách (`finalPrompt(i)`); khi user tự nhập prompt thì tôn trọng nguyên văn. Vẫn "no text/logo".
- Chỉ build lại `fithou-web`. Verify: tsc sạch, 2 route trả 401 (đã phục vụ), marker có trong build. E2E thật cần đăng nhập content_admin (chưa chạy).

**BUG SAU MIGRATION (đã sửa 2026-08-05):** đăng/xuất bản báo "Bài viết cần có ít nhất một khối nội dung" DÙ bài đủ nội dung. Nguyên nhân: editor TipTap LUÔN gửi `blocks:[]` (nội dung ở `content_html`, xem fithou-visual-editor.tsx ~L657), nhưng `app/api/fithou-editor/articles/route.ts` chặn cứng `!payload.blocks?.length` TRƯỚC khi tới `saveEditorArticle`/`validateEditorArticleWorkflow` (2 hàm này đã hỗ trợ HTML-mode). Sửa: đổi gate thành `hasContent` = có blocks HOẶC content_html có chữ/ảnh/iframe/table/video/data-file-chip. Verify prod curl (gate nằm TRƯỚC auth, `isSameOriginRequest` trả true khi thiếu header origin): payload rỗng→400 "khối nội dung"; payload có content_html+blocks rỗng→401 auth (qua gate). Chỉ build lại `fithou-web` (context ../Fithou Website).
