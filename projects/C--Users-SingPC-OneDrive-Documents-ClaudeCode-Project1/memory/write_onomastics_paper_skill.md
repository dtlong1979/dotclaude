---
name: write-onomastics-paper-skill
description: "Skill viết bài Q2+ ngôn ngữ học/onomastics (nghiên cứu về tên) theo từng phần, tuned tiếng Việt"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 10f52cab-5b52-4c22-8c8e-667442039952
  modified: 2026-08-05T17:17:29.103Z
---

Skill **`write-onomastics-paper`** ở `~/.claude/skills/write-onomastics-paper/` (user-level, sync đa máy) — viết/soát TỪNG PHẦN bài **ngôn ngữ học, trọng tâm ONOMASTICS** (địa danh, nhân danh, từ nguyên, phân loại tên) nhắm Q2+ open access.

- `SKILL.md` = điểm vào: xác định nhánh **E (empirical/corpus) vs H (humanities/descriptive)** trước; 8 nguyên tắc trùm; "spine" phân tích; hệ ký hiệu tên; thẻ onomastics Việt; venue OA/Q2+.
- `references/01..07` = 7 phần bài; `references/08-onomastics-conventions.md` = quy ước nghề (thuật ngữ *-onym*, ký hiệu in nghiêng/`' '`/`< >`//`/`/`[ ]`/`*`, chuỗi từ nguyên, typology, chuyển tự ISO/ALA-LC/IPA, đạo đức tên/GDPR); `references/09-venues-vietnamese.md` = bản đồ tạp chí + định vị bài Việt; `references/GUIDELINE.md` = tổng hợp xuyên phần.
- Do 9 subagent `researcher` chạy song song, grounding >100 bài OA thật (Problems of Onomastics, Names, Onomàstica, LD&C… + nhiều bài tên tiếng Việt: Nguyen-Viet Khoa/*Names*&*Genealogy*, địa danh Bình Dương/Khánh Hòa/Quảng Nam, Lê Trung Hoa).
- **Cốt onomastics:** dạng chứng thực TRƯỚC nghĩa SAU (chống folk etymology); biến âm CÓ QUY LUẬT; hedge tỉ lệ nghịch độ chắc; cấm over-claim bản sắc/chủ quyền; giữ ĐỦ DẤU = giữ dữ liệu; tầng nền Chăm/Khmer trước Hán–Việt.
- **Venue đích:** Problems of Onomastics (Diamond OA, Scopus Q2, Anh–Nga), Names (Gold không APC, Q1), LD&C (Diamond). Onoma/Beiträge KHÔNG OA free.
- Bản gốc + raw 9 file ở `Project1/onomastics-writing-guideline/`. Bổ trợ [[research_writing_standards]]; khác [[write_nlp_paper_skill]] (IT/thực nghiệm) và [[it_paper_default_skill]].
