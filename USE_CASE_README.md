# 📊 Hướng Dẫn Xem Sơ Đồ Use Case

## 📁 Các File Sơ Đồ

Dự án có 4 file sơ đồ chính:

| File | Mô Tả | Cách Xem |
|------|-------|----------|
| **USE_CASE_DIAGRAM.md** | 📄 Tài liệu chi tiết về tất cả use cases (Text) | Đọc trực tiếp trong VS Code/GitHub |
| **USE_CASE_DIAGRAM.puml** | 🎨 Sơ đồ Use Case (PlantUML) | Cần tool render PlantUML |
| **SEQUENCE_DIAGRAMS.puml** | 🔄 Sơ đồ Sequence cho các luồng chính | Cần tool render PlantUML |
| **USE_CASE_README.md** | 📖 File này - Hướng dẫn | Đọc trực tiếp |

---

## 🎨 Cách Xem Sơ Đồ PlantUML

### Cách 1: VS Code Extension (Khuyến Nghị) ⭐

1. **Cài Extension**:
   - Mở VS Code
   - Vào Extensions (Ctrl+Shift+X)
   - Tìm kiếm: "PlantUML"
   - Cài đặt extension của **jebbs**

2. **Xem Sơ Đồ**:
   - Mở file `.puml`
   - Nhấn `Alt+D` hoặc `Ctrl+Shift+P` → "PlantUML: Preview Current Diagram"
   - Sơ đồ sẽ hiển thị bên cạnh

3. **Export Ảnh** (Tùy chọn):
   - `Ctrl+Shift+P` → "PlantUML: Export Current Diagram"
   - Chọn format: PNG, SVG, PDF...

### Cách 2: Online Viewer

1. Truy cập: https://www.planttext.com/ hoặc http://www.plantuml.com/plantuml/uml/
2. Copy nội dung file `.puml`
3. Paste vào editor
4. Nhấn "Refresh" hoặc "Generate"
5. Tải về ảnh nếu cần

### Cách 3: Command Line (Advanced)

```bash
# Cài đặt PlantUML
npm install -g node-plantuml

# Render sơ đồ
puml generate USE_CASE_DIAGRAM.puml -o USE_CASE_DIAGRAM.png
puml generate SEQUENCE_DIAGRAMS.puml -o SEQUENCE_DIAGRAMS.png
```

---

## 📖 Nội Dung Các Sơ Đồ

### 1️⃣ USE_CASE_DIAGRAM.md

**Nội dung**:
- ✅ Tổng quan 14 use cases
- ✅ Chi tiết từng use case (Actors, Luồng, Điều kiện...)
- ✅ Bảng API endpoints
- ✅ Sequence diagrams dạng text
- ✅ Database schema
- ✅ Checklist triển khai

**Khi nào dùng**:
- Viết báo cáo/tài liệu
- Trình bày đồ án
- Onboarding thành viên mới

### 2️⃣ USE_CASE_DIAGRAM.puml

**Nội dung**:
- 🎨 Sơ đồ Use Case trực quan
- 👤 3 Actors: User, Admin, AI
- 📦 3 Packages: Người dùng, Quản trị, Hệ thống
- 🔗 Quan hệ giữa các use cases (include, extend, precedes)
- 📝 Notes giải thích

**Khi nào dùng**:
- Trình chiếu presentation
- Báo cáo có hình ảnh
- Documentation website

### 3️⃣ SEQUENCE_DIAGRAMS.puml

**Nội dung**:
- 🔄 5 Sequence Diagrams cho các flow quan trọng:
  1. Người dùng nhận diện trái cây
  2. Gửi feedback
  3. Admin đăng nhập
  4. Xem dashboard
  5. Thêm ảnh vào training dataset

**Khi nào dùng**:
- Hiểu luồng xử lý
- Debug lỗi
- Design review
- Onboarding developers

---

## 🎯 Use Cases Tổng Quan

### 👤 Người Dùng (4 Use Cases)

| ID | Use Case | Mô Tả Ngắn |
|----|----------|------------|
| UC-01 | Chụp/Chọn Ảnh | Chọn ảnh từ camera hoặc thư viện |
| UC-02 | Nhận Diện AI | AI dự đoán loại trái cây |
| UC-03 | Xem Kết Quả | Hiển thị tên, độ tin cậy, top 5 |
| UC-04 | Gửi Phản Hồi | Đánh giá đúng/sai, comment |

### 👨‍💼 Quản Trị Viên (9 Use Cases)

| ID | Use Case | Mô Tả Ngắn |
|----|----------|------------|
| UC-05 | Đăng Nhập Admin | Xác thực với JWT token |
| UC-06 | Xem Dashboard | Thống kê tổng quan + biểu đồ |
| UC-07 | Quản Lý Lịch Sử | Xem tất cả dự đoán |
| UC-08 | Quản Lý Phản Hồi | Xem và xử lý feedback |
| UC-08a | Đánh Dấu Đã Xem | Mark 1 feedback là đã xem |
| UC-08b | Đánh Dấu Tất Cả | Mark tất cả là đã xem |
| UC-08c | Thêm Vào Training | Thêm ảnh sai vào dataset |
| UC-09 | Xem Training Logs | Lịch sử huấn luyện mô hình |
| UC-10 | Đăng Xuất | Xóa JWT token |

### 🤖 Hệ Thống AI (1 Use Case)

| ID | Use Case | Mô Tả Ngắn |
|----|----------|------------|
| UC-11 | Huấn Luyện Model | Train CNN với dataset mới |

---

## 🔗 Quan Hệ Giữa Use Cases

### 📌 Include (Bao gồm - Bắt buộc)

```
UC-01 (Chọn Ảnh) ──include──> UC-02 (Nhận Diện)
UC-02 (Nhận Diện) ──include──> UC-03 (Xem Kết Quả)
UC-08 (Quản Lý Feedback) ──include──> UC-08a (Mark Read)
UC-08 (Quản Lý Feedback) ──include──> UC-08c (Add Training)
```

**Ý nghĩa**: Use case A **bắt buộc** phải thực hiện use case B

### 📌 Extend (Mở rộng - Tùy chọn)

```
UC-03 (Xem Kết Quả) ──extend──> UC-04 (Gửi Feedback)
UC-06 (Dashboard) ──extend──> UC-07 (Lịch Sử)
UC-06 (Dashboard) ──extend──> UC-08 (Feedback)
```

**Ý nghĩa**: Use case B là **tùy chọn**, có thể hoặc không thực hiện từ use case A

### 📌 Precedes (Đi trước)

```
UC-05 (Đăng Nhập) ──precedes──> UC-06 (Dashboard)
```

**Ý nghĩa**: Use case A phải hoàn thành trước khi thực hiện use case B

---

## 🛠️ Chi Tiết Use Cases Quan Trọng

### 🔥 UC-02: Nhận Diện Trái Cây Bằng AI

**Actors**: Người dùng, Hệ thống AI

**Luồng chính**:
1. User nhấn "Nhận Diện"
2. App gửi ảnh lên server (POST /api/predict)
3. Backend lưu ảnh vào `uploads/`
4. AI Model:
   - Resize ảnh về 224x224
   - Normalize (chia 255)
   - Predict với CNN
   - Trả về top 5 dự đoán
5. Lưu vào database (bảng `predictions`)
6. Trả kết quả về app
7. Hiển thị kết quả cho user

**Thời gian**: < 2 giây

**Độ chính xác**: ~90%+

---

### 🔥 UC-06: Xem Dashboard

**Actor**: Quản trị viên

**Dữ liệu hiển thị**:

1. **Thống kê tổng quan**:
   - 📊 Tổng số dự đoán
   - 💬 Tổng số phản hồi
   - ✅ Phản hồi đúng
   - ❌ Phản hồi sai
   - 🎯 Độ chính xác (%)
   - 📈 Độ tin cậy trung bình

2. **Biểu đồ**:
   - 🥧 Pie Chart: Phân bố theo loại trái cây
   - 📈 Line Chart: Xu hướng 7 ngày gần đây

3. **Thông tin mô hình**:
   - 🏷️ Version mới nhất
   - ✅ Accuracy
   - 📅 Ngày train

**API**: `GET /api/admin/dashboard`

**Yêu cầu**: JWT token (role = admin)

---

### 🔥 UC-08c: Thêm Ảnh Vào Training Dataset

**Actor**: Quản trị viên

**Mục đích**: Cải thiện mô hình bằng cách thêm ảnh bị nhận diện sai vào dataset

**Luồng**:
1. Admin chọn feedback có kết quả sai
2. Nhấn "Thêm vào Training"
3. Chọn label đúng (1 trong 10 loại)
4. Hệ thống:
   - Lấy ảnh từ `uploads/`
   - Convert sang RGB nếu cần
   - Resize giữ tỷ lệ
   - Lưu vào `data/train/{correct_label}/`
   - Tên file: `user_feedback_{id}_{timestamp}.jpg`
   - Update `feedback.added_to_training = true`
5. Hiển thị thông báo thành công

**Sau đó**: Admin có thể chạy `python train_model.py` để train lại mô hình

---

## 📊 Bảng API Endpoints

### Public APIs (Không cần JWT)

| Method | Endpoint | Use Case | Mô Tả |
|--------|----------|----------|-------|
| POST | `/api/predict` | UC-02 | Nhận diện trái cây |
| POST | `/api/feedback_user` | UC-04 | Gửi phản hồi |
| GET | `/api/uploads/<file>` | UC-03 | Lấy ảnh |
| GET | `/api/health` | - | Health check |

### Admin APIs (Cần JWT)

| Method | Endpoint | Use Case | Mô Tả |
|--------|----------|----------|-------|
| POST | `/api/auth/login_admin` | UC-05 | Đăng nhập |
| POST | `/api/auth/logout_admin` | UC-10 | Đăng xuất |
| GET | `/api/admin/dashboard` | UC-06 | Dashboard |
| GET | `/api/admin/history` | UC-07 | Lịch sử |
| GET | `/api/admin/feedback` | UC-08 | Danh sách feedback |
| PUT | `/api/admin/feedback/{id}/mark_read` | UC-08a | Đánh dấu 1 feedback |
| PUT | `/api/admin/feedback/mark_all_read` | UC-08b | Đánh dấu tất cả |
| POST | `/api/admin/feedback/{id}/add_to_training` | UC-08c | Thêm vào training |
| GET | `/api/admin/training_logs` | UC-09 | Training logs |
| GET | `/api/admin/users` | - | Danh sách users |

---

## 🗄️ Database Schema

```sql
-- Bảng users (Liên quan: UC-05, UC-10)
users
├── id (PK)
├── username (UNIQUE)
├── password (HASHED)
├── role (user/admin)
└── created_at

-- Bảng predictions (Liên quan: UC-02, UC-03, UC-07)
predictions
├── id (PK)
├── user_id (FK → users.id, nullable)
├── image_path
├── predicted_label
├── confidence
└── created_at

-- Bảng feedback (Liên quan: UC-04, UC-08)
feedback
├── id (PK)
├── prediction_id (FK → predictions.id)
├── comment
├── is_correct
├── is_read
├── added_to_training
├── training_label
├── added_to_training_at
└── created_at

-- Bảng training_logs (Liên quan: UC-09, UC-11)
training_logs
├── id (PK)
├── model_version
├── accuracy
├── loss
├── val_accuracy
├── val_loss
├── epochs
├── date_trained
└── notes
```

---

## 🎨 10 Loại Trái Cây

| STT | Tên Tiếng Việt | Label (Key) | Mã Code |
|-----|----------------|-------------|---------|
| 1 | Bưởi Da Xanh Bến Tre | buoi_da_xanh | 0 |
| 2 | Cam Sành Hà Giang | cam_sanh_ha_giang | 1 |
| 3 | Chôm Chôm Long Khánh | chom_chom_long_khanh | 2 |
| 4 | Măng Cụt Lái Thiêu | mang_cut_lai_thieu | 3 |
| 5 | Nhãn Lồng Hưng Yên | nhan_long_hung_yen | 4 |
| 6 | Sầu Riêng Ri6 | sau_rieng_ri6 | 5 |
| 7 | Thanh Long Bình Thuận | thanh_long_binh_thuan | 6 |
| 8 | Vải Thiều Lục Ngạn | vai_thieu_luc_ngan | 7 |
| 9 | Vú Sữa Lò Rèn | vu_sua_lo_ren | 8 |
| 10 | Xoài Cát Hòa Lộc | xoai_cat_hoa_loc | 9 |

---

## 🚀 Luồng Sử Dụng Chính

### Flow 1: Người Dùng Nhận Diện Trái Cây

```
1. Mở App Flutter
2. [UC-01] Chụp hoặc chọn ảnh
3. [UC-02] Nhấn "Nhận Diện"
   → Server nhận ảnh
   → AI xử lý
   → Lưu database
4. [UC-03] Xem kết quả:
   - Tên trái cây
   - Độ tin cậy
   - Top 5 dự đoán khác
5. [UC-04] (Tùy chọn) Gửi feedback
```

### Flow 2: Admin Quản Lý Hệ Thống

```
1. [UC-05] Đăng nhập với admin/admin123
2. [UC-06] Xem Dashboard:
   - Thống kê tổng quan
   - Biểu đồ phân tích
3. Chuyển tab:
   → [UC-07] Lịch Sử: Xem tất cả dự đoán
   → [UC-08] Phản Hồi: 
      • [UC-08a] Đánh dấu đã xem
      • [UC-08c] Thêm ảnh vào training
   → [UC-09] Training Logs: Xem lịch sử training
4. [UC-10] Đăng xuất
```

### Flow 3: Cải Thiện Mô Hình

```
1. User nhận diện sai → Gửi feedback
2. Admin xem feedback → Chọn ảnh sai
3. [UC-08c] Thêm vào training dataset với label đúng
4. [UC-11] Chạy: python train_model.py
5. Mô hình cải thiện → Accuracy tăng
6. [UC-09] Admin xem training logs mới
```

---

## 💡 Tips Khi Sử Dụng Sơ Đồ

### Cho Sinh Viên/Developer

1. **Viết báo cáo**: Sử dụng `USE_CASE_DIAGRAM.md`
2. **Trình chiếu**: Export ảnh từ `.puml` files
3. **Coding**: Tham khảo sequence diagrams để hiểu flow
4. **Testing**: Dựa vào use cases để viết test cases

### Cho Giảng Viên/Reviewer

1. **Review kiến trúc**: Xem use case diagram tổng thể
2. **Kiểm tra logic**: Xem sequence diagrams
3. **Đánh giá completeness**: Check bảng tổng hợp 14 use cases

### Cho Product Manager

1. **Feature planning**: Dựa vào bảng độ ưu tiên
2. **Sprint planning**: Nhóm use cases theo package
3. **User story**: Chuyển đổi use cases thành user stories

---

## 📞 Hỗ Trợ

Nếu có câu hỏi về sơ đồ:

1. Đọc chi tiết trong `USE_CASE_DIAGRAM.md`
2. Xem code implementation trong `backend/routes/`
3. Test API với Postman/curl
4. Xem Flutter screens trong `flutter_app/lib/screens/`

---

## 📚 Tài Liệu Liên Quan

- 📖 **README.md**: Tổng quan dự án
- 📖 **PROJECT_OVERVIEW_VI.md**: Kiến trúc hệ thống
- 📖 **START_HERE.md**: Hướng dẫn bắt đầu
- 📖 **MYSQL_SETUP.md**: Setup database
- 📖 **flutter_app/QUICKSTART_VI.md**: Setup Flutter app

---

**📅 Cập nhật**: 26/10/2024  
**👨‍💻 Hệ thống**: AI Fruit Recognition System  
**🇻🇳 Made with ❤️ in Vietnam**

