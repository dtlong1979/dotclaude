# PROJECT.md — Kiến trúc & quy ước (đổi chậm)

> Nguồn sự thật về "project này LÀ GÌ và làm việc theo lối nào". Cập nhật khi kiến trúc/quy ước đổi.

## Mục tiêu
<Project giải quyết vấn đề gì, cho ai.>

## Mô hình chạy & tính di động (chốt lúc khởi tạo)
- **Mô hình:** < local-only (chỉ máy này) | đa-máy (local-first + sync) | remote-workhorse (SSH) >
- **Lý do chọn:** <tín hiệu: cần GPU? có DB? dữ liệu lớn? dùng nhiều máy? dài hơi/throwaway?>
- **Tái tạo môi trường:** <lệnh dựng: Docker/devcontainer/setup script — để máy mới productive nhanh; hoặc "không, gắn máy này">
- **Dữ liệu lớn / weights:** <ở đâu: Drive/MinIO/LFS + cách fetch; hoặc "không có">
- **GPU / compute nặng:** <chạy ở đâu: máy này / Colab / máy workhorse; hoặc "không cần">
- **Secret/.env:** <kênh lấy secret ngoài git>

## Stack & công nghệ
- Ngôn ngữ/Framework:
- CSDL:
- Hạ tầng/triển khai:
- Công cụ build/chạy:

## Cấu trúc thư mục (điểm chính)
```
<thư mục quan trọng và vai trò>
```

## Cách chạy / build / test
```bash
<lệnh chạy dev>
<lệnh build>
<lệnh test>
```

## Quy ước
- Code style / đặt tên:
- Ngôn ngữ nội dung (UI/comment):
- Nhánh git / quy trình deploy:

## Bề mặt nhạy cảm (bảo mật / dữ liệu)
<auth, dữ liệu cá nhân, secret nằm ở đâu, môi trường thật vs test.>
