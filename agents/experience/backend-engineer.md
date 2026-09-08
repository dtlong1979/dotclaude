# Sổ kinh nghiệm — backend-engineer
> Bài học nghề TỔNG QUÁT (đúng ở nhiều project). Đọc trước khi làm; coi là gợi ý, kiểm chứng trước khi áp (có thể lỗi thời).
> Mỗi mục: **Khi** <bối cảnh> → <nên làm> · vì <sự cố gốc> · độ tin · ngày. Trần ~30 mục / ~3KB; vượt thì cô đọng.

> **Khi** thêm JSON Schema vào một API mà máy khách đọc **khoá đường dẫn** của lỗi → cấm một trường bằng `"properties": { "<tên>": false }`, đừng bằng `additionalProperties: false` · vì `additionalProperties` gắn lỗi vào **đối tượng cha** còn `properties: false` gắn đúng vào trường, nên giao diện im lặng không hiện lỗi nào dù 422 vẫn "đúng" · cao · 2026-09-08

> **Khi** thêm bộ kiểm dữ liệu vào một endpoint đã có kiểm xung đột phiên bản → đặt kiểm **xung đột (409) TRƯỚC** kiểm lược đồ (422) · vì bản vá dựa trên bản cũ sẽ bị bỏ dù hợp lệ hay không; báo lỗi lược đồ khiến người dùng đi sửa nội dung trong khi việc phải làm là nạp lại · cao · 2026-09-08

> **Khi** đo giá phải trả của một lớp kiểm/nạp có cache → báo **chi phí cố định mỗi yêu cầu**, đừng báo trung bình đã khấu hao qua nhiều lượt · vì lượt đầu (nạp + phân tích) và lượt sau lệch nhau cả chục lần, mà mỗi yêu cầu HTTP thật thường chỉ chạy lượt đầu — con số khấu hao dễ dùng để tự trấn an · cao · 2026-09-08
