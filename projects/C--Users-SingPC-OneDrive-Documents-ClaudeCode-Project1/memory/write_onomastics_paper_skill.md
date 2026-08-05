---
name: write-onomastics-paper-skill
description: "Skill viết bài Q2+ ngôn ngữ học/onomastics (nghiên cứu về tên) theo từng phần, tuned tiếng Việt"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 10f52cab-5b52-4c22-8c8e-667442039952
  modified: 2026-08-05T17:58:50.075Z
---

Skill viết bài **ngôn ngữ học, trọng tâm ONOMASTICS** (địa danh, nhân danh, từ nguyên, phân loại tên) nhắm Q2+ open access. Ở `~/.claude/skills/` (user-level, sync đa máy). **TÁCH LÀM 4 SKILL** (để mỗi description ≤1024 cho hợp giới hạn upload tài khoản, và gọn theo cụm việc):
- `write-onomastics-paper` = **MASTER điều phối**: 8 nguyên tắc trùm, nhánh **E vs H**, "spine" phân tích, hệ ký hiệu tên, thẻ Việt, venue; **bảng định tuyến** sang 3 skill con. Refs dùng chung: `08` (quy ước nghề: thuật ngữ *-onym*, ký hiệu in nghiêng/`' '`/`< >`//`/`/`[ ]`/`*`, chuỗi từ nguyên, typology, chuyển tự, đạo đức GDPR), `09` (venue + định vị Việt), `GUIDELINE`.
- `write-onomastics-intro-related` → Introduction + Related work/Theory (refs 02, 03).
- `write-onomastics-method-discussion` → Data & Methodology + Discussion (refs 04, 06).
- `write-onomastics-core` → Abstract + Analysis + Conclusion (refs 01, 05, 07).
Skill con đều [[write-onomastics-paper]] để lấy nền dùng chung. Bundle upload (5 zip gồm cả write-nlp-paper) ở `Project1/skill-bundles/`.
- Do 9 subagent `researcher` chạy song song, grounding >100 bài OA thật (Problems of Onomastics, Names, Onomàstica, LD&C… + nhiều bài tên tiếng Việt: Nguyen-Viet Khoa/*Names*&*Genealogy*, địa danh Bình Dương/Khánh Hòa/Quảng Nam, Lê Trung Hoa).
- **Cốt onomastics:** dạng chứng thực TRƯỚC nghĩa SAU (chống folk etymology); biến âm CÓ QUY LUẬT; hedge tỉ lệ nghịch độ chắc; cấm over-claim bản sắc/chủ quyền; giữ ĐỦ DẤU = giữ dữ liệu; tầng nền Chăm/Khmer trước Hán–Việt.
- **Venue đích:** Problems of Onomastics (Diamond OA, Scopus Q2, Anh–Nga), Names (Gold không APC, Q1), LD&C (Diamond). Onoma/Beiträge KHÔNG OA free.
- Bản gốc + raw 9 file ở `Project1/onomastics-writing-guideline/`. Bổ trợ [[research_writing_standards]]; khác [[write_nlp_paper_skill]] (IT/thực nghiệm) và [[it_paper_default_skill]].
