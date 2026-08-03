---
name: fithou-editor-rebuild
description: "Cải tổ editor soạn bài web fit.hou.edu.vn: bỏ block editor tự viết, dùng TipTap + AI trong editor"
metadata: 
  node_type: memory
  type: project
  originSessionId: 27152e89-3b17-4747-9e4b-63e2a071cb90
  modified: 2026-07-30T04:37:45.587Z
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
