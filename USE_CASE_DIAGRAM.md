# 📊 SƠ ĐỒ USE CASE - HỆ THỐNG NHẬN DIỆN TRÁI CÂY VIỆT NAM

## 🎯 Tổng Quan Hệ Thống

Hệ thống gồm 3 actor chính:
- 👤 **Người Dùng (User)**: Sử dụng app di động để nhận diện trái cây
- 👨‍💼 **Quản Trị Viên (Admin)**: Quản lý và giám sát hệ thống
- 🤖 **Hệ Thống AI**: Xử lý nhận diện trái cây tự động

---

## 📱 SƠ ĐỒ USE CASE TỔNG THỂ

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    HỆ THỐNG NHẬN DIỆN TRÁI CÂY                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│   👤 NGƯỜI DÙNG              🎯 USE CASES                 👨‍💼 ADMIN     │
│                                                                           │
│                         ┌──────────────────────┐                         │
│                         │   Chụp/Chọn Ảnh     │                         │
│    ┌────────────────────┤   Trái Cây          │                         │
│    │                    └──────────┬───────────┘                         │
│    │                               │                                     │
│    │                    ┌──────────▼───────────┐                         │
│    │                    │  Nhận Diện Trái Cây │◄─────────────┐          │
│    │                    │  Bằng AI            │              │          │
│    │                    └──────────┬───────────┘              │          │
│    │                               │                    🤖 AI Model      │
│    │                    ┌──────────▼───────────┐              │          │
│    │                    │  Xem Kết Quả        │              │          │
│    │                    │  - Tên trái cây     │              │          │
│    └────────────────────┤  - Độ tin cậy       │              │          │
│                         │  - Dự đoán khác     │              │          │
│                         └──────────┬───────────┘              │          │
│                                    │                          │          │
│                         ┌──────────▼───────────┐              │          │
│    ┌────────────────────┤  Gửi Phản Hồi       │              │          │
│    │                    │  - Đánh giá đúng/sai│              │          │
│    │                    │  - Comment          │              │          │
│    │                    └─────────────────────┘              │          │
│    │                                                          │          │
│    │                    ┌─────────────────────┐              │          │
│    │                    │  Đăng Nhập Admin    │◄─────────────┤          │
│    │                    └──────────┬──────────┘              │          │
│    │                               │                         │          │
│    │                    ┌──────────▼──────────┐              │          │
│    │                    │  Xem Dashboard      │◄─────────────┤          │
│    │                    │  - Thống kê tổng    │              │          │
│    │                    │  - Biểu đồ          │              │          │
│    │                    └─────────────────────┘              │          │
│    │                                                          │          │
│    │                    ┌─────────────────────┐              │          │
│    │                    │  Quản Lý Lịch Sử    │◄─────────────┤          │
│    │                    │  Dự Đoán            │              │          │
│    │                    └─────────────────────┘              │          │
│    │                                                          │          │
│    │                    ┌─────────────────────┐              │          │
│    │                    │  Quản Lý Phản Hồi   │◄─────────────┤          │
│    │                    │  - Xem feedback     │              │          │
│    │                    │  - Đánh dấu đã xem  │              │          │
│    │                    │  - Thêm vào training│              │          │
│    │                    └─────────────────────┘              │          │
│    │                                                          │          │
│    │                    ┌─────────────────────┐              │          │
│    │                    │  Xem Training Logs  │◄─────────────┘          │
│    │                    │  - Lịch sử training │                         │
│    │                    │  - Độ chính xác     │                         │
│    │                    └─────────────────────┘                         │
│    │                                                                     │
│    │                    ┌─────────────────────┐                         │
│    └────────────────────┤  Đăng Xuất          │                         │
│                         └─────────────────────┘                         │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 CHI TIẾT USE CASES

### 🟦 **NHÓM 1: CHỨC NĂNG NGƯỜI DÙNG**

#### UC-01: Chụp/Chọn Ảnh Trái Cây
**Actor**: Người dùng  
**Mô tả**: Người dùng chụp ảnh mới hoặc chọn ảnh từ thư viện  
**Luồng chính**:
1. Người dùng mở ứng dụng Flutter
2. Chọn "Chụp ảnh" hoặc "Chọn từ thư viện"
3. Hệ thống hiển thị ảnh đã chọn
4. Chuyển sang UC-02

**Tiền điều kiện**: Không  
**Hậu điều kiện**: Ảnh được tải lên và hiển thị

---

#### UC-02: Nhận Diện Trái Cây Bằng AI
**Actor**: Người dùng, Hệ thống AI  
**Mô tả**: Hệ thống sử dụng mô hình CNN để nhận diện trái cây  
**Luồng chính**:
1. Người dùng nhấn nút "Nhận Diện"
2. Hệ thống tải ảnh lên server (POST /api/predict)
3. Backend lưu ảnh vào thư mục uploads/
4. Hệ thống AI xử lý ảnh:
   - Resize về 224x224
   - Chuẩn hóa dữ liệu
   - Dự đoán bằng mô hình CNN
5. Lưu kết quả vào database (bảng predictions)
6. Trả về kết quả cho người dùng
7. Chuyển sang UC-03

**Tiền điều kiện**: Có ảnh trái cây  
**Hậu điều kiện**: 
- Kết quả được lưu vào database
- Độ tin cậy > 0%

**Luồng ngoại lệ**:
- E1: File không phải ảnh → Hiển thị lỗi "Định dạng không hợp lệ"
- E2: Mô hình AI lỗi → Hiển thị lỗi "Dự đoán thất bại"
- E3: Kết nối server lỗi → Hiển thị lỗi "Không thể kết nối"

---

#### UC-03: Xem Kết Quả Nhận Diện
**Actor**: Người dùng  
**Mô tả**: Hiển thị kết quả dự đoán chi tiết  
**Luồng chính**:
1. Hệ thống hiển thị:
   - 🍎 Tên trái cây (tiếng Việt)
   - 📊 Độ tin cậy (%)
   - 🖼️ Ảnh đã nhận diện
   - 📋 Top 5 dự đoán thay thế
2. Người dùng có thể:
   - Xem thông tin chi tiết
   - Chuyển sang UC-04 để phản hồi
   - Nhận diện ảnh khác

**Tiền điều kiện**: Đã thực hiện nhận diện  
**Hậu điều kiện**: Kết quả được hiển thị

---

#### UC-04: Gửi Phản Hồi
**Actor**: Người dùng  
**Mô tả**: Người dùng đánh giá kết quả nhận diện  
**Luồng chính**:
1. Người dùng chọn "Gửi Phản Hồi"
2. Chọn đúng ✅ hoặc sai ❌
3. (Tùy chọn) Nhập comment
4. Nhấn "Gửi"
5. Hệ thống lưu vào database (bảng feedback)
6. Hiển thị thông báo "Cảm ơn đánh giá của bạn!"

**Tiền điều kiện**: Đã có kết quả dự đoán  
**Hậu điều kiện**: Feedback được lưu vào database

---

### 🟧 **NHÓM 2: CHỨC NĂNG QUẢN TRỊ**

#### UC-05: Đăng Nhập Admin
**Actor**: Quản trị viên  
**Mô tả**: Admin đăng nhập vào hệ thống quản lý  
**Luồng chính**:
1. Admin mở màn hình đăng nhập
2. Nhập username và password
3. Nhấn "Đăng Nhập"
4. Hệ thống xác thực (POST /api/auth/login_admin)
5. Kiểm tra role = 'admin'
6. Tạo JWT token (24h)
7. Chuyển đến Dashboard

**Tiền điều kiện**: Tài khoản admin đã tồn tại  
**Hậu điều kiện**: 
- JWT token được tạo
- Admin truy cập được các chức năng quản lý

**Luồng ngoại lệ**:
- E1: Sai username/password → Hiển thị lỗi
- E2: Không phải admin → Hiển thị "Không đủ quyền"

**Tài khoản mặc định**:
- Username: `admin`
- Password: `admin123`

---

#### UC-06: Xem Dashboard
**Actor**: Quản trị viên  
**Mô tả**: Xem thống kê tổng quan hệ thống  
**Luồng chính**:
1. Admin vào màn hình Dashboard
2. Hệ thống hiển thị (GET /api/admin/dashboard):
   - 📊 **Thống kê tổng quan**:
     - Tổng số dự đoán
     - Tổng số phản hồi
     - Phản hồi đúng/sai
     - Độ chính xác (%)
     - Độ tin cậy trung bình
   - 📈 **Biểu đồ**:
     - Phân bố theo loại trái cây (Pie Chart)
     - Xu hướng dự đoán 7 ngày (Line Chart)
   - 🏆 **Thông tin mô hình**:
     - Version mới nhất
     - Accuracy
     - Ngày train

**Tiền điều kiện**: Đã đăng nhập với role admin  
**Hậu điều kiện**: Dashboard được tải và hiển thị

---

#### UC-07: Quản Lý Lịch Sử Dự Đoán
**Actor**: Quản trị viên  
**Mô tả**: Xem tất cả lịch sử dự đoán của người dùng  
**Luồng chính**:
1. Admin chọn tab "Lịch Sử"
2. Hệ thống hiển thị (GET /api/admin/history):
   - ID dự đoán
   - Ảnh trái cây
   - Kết quả dự đoán
   - Độ tin cậy
   - Thời gian
   - User ID (nếu có)
3. Hỗ trợ phân trang (20 items/page)
4. Lọc theo loại trái cây (tùy chọn)
5. Sắp xếp theo thời gian (mới nhất → cũ nhất)

**Tiền điều kiện**: Đã đăng nhập với role admin  
**Hậu điều kiện**: Danh sách được hiển thị

---

#### UC-08: Quản Lý Phản Hồi
**Actor**: Quản trị viên  
**Mô tả**: Xem và quản lý phản hồi từ người dùng  
**Luồng chính**:
1. Admin chọn tab "Phản Hồi"
2. Hệ thống hiển thị (GET /api/admin/feedback):
   - Danh sách feedback
   - Thông tin dự đoán liên quan
   - Đúng/Sai
   - Comment
   - Trạng thái đã xem/chưa xem
   - Badge hiển thị số feedback chưa xem
3. Admin có thể:
   - **UC-08a**: Đánh dấu đã xem (PUT /api/admin/feedback/{id}/mark_read)
   - **UC-08b**: Đánh dấu tất cả đã xem (PUT /api/admin/feedback/mark_all_read)
   - **UC-08c**: Thêm ảnh vào training dataset (POST /api/admin/feedback/{id}/add_to_training)
4. Lọc theo:
   - Đúng/Sai
   - Đã xem/Chưa xem
5. Phân trang (20 items/page)

**Tiền điều kiện**: Đã đăng nhập với role admin  
**Hậu điều kiện**: Feedback được quản lý

---

#### UC-08c: Thêm Ảnh Vào Training Dataset
**Actor**: Quản trị viên  
**Mô tả**: Thêm ảnh từ feedback vào dataset để cải thiện mô hình  
**Luồng chính**:
1. Admin chọn feedback có kết quả sai
2. Nhấn "Thêm vào Training"
3. Chọn label đúng từ danh sách 10 loại trái cây
4. Hệ thống:
   - Lấy ảnh từ predictions
   - Xử lý ảnh (resize, convert RGB)
   - Lưu vào `data/train/{correct_label}/`
   - Đặt tên: `user_feedback_{id}_{timestamp}.jpg`
   - Cập nhật feedback.added_to_training = true
5. Hiển thị thông báo thành công

**Tiền điều kiện**: 
- Đã đăng nhập với role admin
- Feedback tồn tại và có ảnh
**Hậu điều kiện**: 
- Ảnh được thêm vào training folder
- Feedback được đánh dấu đã xử lý

---

#### UC-09: Xem Training Logs
**Actor**: Quản trị viên  
**Mô tả**: Xem lịch sử huấn luyện mô hình AI  
**Luồng chính**:
1. Admin chọn tab "Training Logs"
2. Hệ thống hiển thị (GET /api/admin/training_logs):
   - Model Version
   - Accuracy (%)
   - Loss
   - Validation Accuracy
   - Validation Loss
   - Số Epochs
   - Ngày train
   - Ghi chú
3. Sắp xếp theo thời gian (mới → cũ)
4. So sánh các phiên bản mô hình

**Tiền điều kiện**: Đã đăng nhập với role admin  
**Hậu điều kiện**: Training logs được hiển thị

---

#### UC-10: Đăng Xuất
**Actor**: Quản trị viên  
**Mô tả**: Đăng xuất khỏi hệ thống  
**Luồng chính**:
1. Admin nhấn "Đăng Xuất"
2. Client xóa JWT token
3. Chuyển về màn hình đăng nhập

**Tiền điều kiện**: Đã đăng nhập  
**Hậu điều kiện**: Token bị xóa, không thể truy cập chức năng admin

---

### 🟩 **NHÓM 3: CHỨC NĂNG HỆ THỐNG AI**

#### UC-11: Huấn Luyện Mô Hình
**Actor**: Hệ thống (chạy bởi lệnh)  
**Mô tả**: Training mô hình CNN với dataset  
**Luồng chính**:
1. Chạy lệnh: `python train_model.py`
2. Hệ thống:
   - Load dataset từ `data/train/` và `data/validation/`
   - Xây dựng mô hình CNN
   - Augmentation dữ liệu
   - Training với số epochs chỉ định
   - Validation
   - Lưu model vào `models/fruit_classifier.h5`
   - Lưu training log vào database
3. Hiển thị kết quả training

**Tiền điều kiện**: 
- Dataset đầy đủ (10 loại trái cây)
- TensorFlow/Keras đã cài đặt
**Hậu điều kiện**: 
- Model mới được lưu
- Training log được ghi nhận

---

## 🔄 **QUAN HỆ GIỮA CÁC USE CASES**

### Include Relationships (Bao gồm)
```
UC-02 (Nhận Diện) <<include>> UC-03 (Xem Kết Quả)
UC-08 (Quản Lý Feedback) <<include>> UC-08a (Đánh dấu đã xem)
UC-08 (Quản Lý Feedback) <<include>> UC-08c (Thêm vào Training)
```

### Extend Relationships (Mở rộng)
```
UC-03 (Xem Kết Quả) <<extend>> UC-04 (Gửi Phản Hồi)
UC-06 (Dashboard) <<extend>> UC-07 (Lịch Sử)
UC-06 (Dashboard) <<extend>> UC-08 (Quản Lý Feedback)
```

### Generalization (Tổng quát hóa)
```
UC-05 (Đăng Nhập) ──> Authentication (Parent)
UC-10 (Đăng Xuất) ──> Authentication (Parent)
```

---

## 📊 **BẢNG TỔNG HỢP USE CASES**

| ID | Use Case | Actor | Độ Ưu Tiên | Tần Suất |
|----|----------|-------|------------|----------|
| UC-01 | Chụp/Chọn Ảnh | User | Cao | Rất cao |
| UC-02 | Nhận Diện AI | User, AI | Cao | Rất cao |
| UC-03 | Xem Kết Quả | User | Cao | Rất cao |
| UC-04 | Gửi Phản Hồi | User | Trung bình | Trung bình |
| UC-05 | Đăng Nhập Admin | Admin | Cao | Thấp |
| UC-06 | Xem Dashboard | Admin | Cao | Trung bình |
| UC-07 | Quản Lý Lịch Sử | Admin | Trung bình | Trung bình |
| UC-08 | Quản Lý Feedback | Admin | Cao | Trung bình |
| UC-08a | Đánh dấu đã xem | Admin | Thấp | Cao |
| UC-08b | Đánh dấu tất cả | Admin | Thấp | Thấp |
| UC-08c | Thêm vào Training | Admin | Cao | Thấp |
| UC-09 | Xem Training Logs | Admin | Trung bình | Thấp |
| UC-10 | Đăng Xuất | Admin | Thấp | Trung bình |
| UC-11 | Huấn Luyện Model | System | Cao | Rất thấp |

---

## 🎨 **SƠ ĐỒ SEQUENCE CHO FLOW CHÍNH**

### 🔥 Flow 1: Người Dùng Nhận Diện Trái Cây

```
User          Flutter App      Flask API      AI Model      Database
  │                │               │             │              │
  │──Chọn ảnh──────>│               │             │              │
  │                │               │             │              │
  │──Nhấn "Nhận diện">│            │             │              │
  │                │──POST /api/predict──>       │              │
  │                │               │──Load ảnh──>│              │
  │                │               │             │              │
  │                │               │             │──Preprocess──>
  │                │               │             │──Predict─────>
  │                │               │             │<─Result──────┘
  │                │               │             │              │
  │                │               │──Save prediction──────────>│
  │                │               │<─────────────────────────┘│
  │                │<─JSON response─┘            │              │
  │<─Hiển thị kết quả┘             │             │              │
  │                │               │             │              │
  │──Gửi feedback──>│              │             │              │
  │                │──POST /api/feedback_user──>│              │
  │                │               │──Save feedback───────────>│
  │                │<─Success─────┘             │              │
  │<─"Cảm ơn!"────┘                │             │              │
```

### 🔥 Flow 2: Admin Xem Dashboard

```
Admin       Flutter App      Flask API      Database
  │               │               │             │
  │──Đăng nhập────>│               │             │
  │               │──POST /api/auth/login_admin─>│
  │               │               │──Check user─>│
  │               │               │<─User info──┘
  │               │<─JWT token───┘               │
  │<─Success─────┘                │             │
  │               │               │             │
  │──Vào Dashboard>│              │             │
  │               │──GET /api/admin/dashboard──>│
  │               │  (Authorization: Bearer...)   │
  │               │               │──Query stats>│
  │               │               │<─Statistics─┘
  │               │<─Dashboard data─┘            │
  │<─Hiển thị────┘                │             │
```

---

## 🗄️ **DATABASE SCHEMA (Liên Quan Use Cases)**

### Bảng: `users`
- Lưu thông tin admin và user
- Liên quan: UC-05 (Login), UC-10 (Logout)

### Bảng: `predictions`
- Lưu kết quả dự đoán
- Liên quan: UC-02 (Nhận diện), UC-03 (Xem kết quả), UC-07 (Lịch sử)

### Bảng: `feedback`
- Lưu phản hồi người dùng
- Liên quan: UC-04 (Gửi feedback), UC-08 (Quản lý feedback)

### Bảng: `training_logs`
- Lưu lịch sử training mô hình
- Liên quan: UC-09 (Xem training logs), UC-11 (Training)

---

## 🌐 **API ENDPOINTS (Ánh Xạ Use Cases)**

### Public APIs (Không cần JWT)
```
POST   /api/predict           → UC-02: Nhận diện AI
POST   /api/feedback_user     → UC-04: Gửi phản hồi
GET    /api/uploads/<file>    → UC-03: Xem ảnh
```

### Admin APIs (Cần JWT)
```
POST   /api/auth/login_admin         → UC-05: Đăng nhập
POST   /api/auth/logout_admin        → UC-10: Đăng xuất
GET    /api/admin/dashboard          → UC-06: Dashboard
GET    /api/admin/history            → UC-07: Lịch sử
GET    /api/admin/feedback           → UC-08: Quản lý feedback
PUT    /api/admin/feedback/{id}/mark_read     → UC-08a
PUT    /api/admin/feedback/mark_all_read      → UC-08b
POST   /api/admin/feedback/{id}/add_to_training → UC-08c
GET    /api/admin/training_logs      → UC-09: Training logs
```

---

## 🚀 **LUỒNG DỮ LIỆU TỔNG THỂ**

```
                    ┌─────────────────┐
                    │  Flutter App    │
                    │  (Mobile UI)    │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   Flask API     │
                    │  (Backend REST) │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
     ┌──────▼──────┐  ┌──────▼──────┐  ┌─────▼─────┐
     │   MySQL     │  │  CNN Model  │  │   File    │
     │  Database   │  │   (AI)      │  │  Storage  │
     └─────────────┘  └─────────────┘  └───────────┘
```

---

## ✅ **CHECKLIST TRIỂN KHAI USE CASES**

### ✅ Đã Hoàn Thành
- [x] UC-01: Chụp/Chọn Ảnh
- [x] UC-02: Nhận Diện AI
- [x] UC-03: Xem Kết Quả
- [x] UC-04: Gửi Phản Hồi
- [x] UC-05: Đăng Nhập Admin
- [x] UC-06: Xem Dashboard
- [x] UC-07: Quản Lý Lịch Sử
- [x] UC-08: Quản Lý Feedback
- [x] UC-08a: Đánh dấu đã xem
- [x] UC-08b: Đánh dấu tất cả
- [x] UC-08c: Thêm vào Training
- [x] UC-09: Xem Training Logs
- [x] UC-10: Đăng Xuất
- [x] UC-11: Huấn Luyện Model

### 🔜 Có Thể Mở Rộng
- [ ] Tìm kiếm lịch sử dự đoán
- [ ] Export dữ liệu ra Excel/CSV
- [ ] Notification khi có feedback mới
- [ ] Dark mode
- [ ] Multi-language support
- [ ] Social sharing kết quả

---

## 📝 **GHI CHÚ KỸ THUẬT**

### Công Nghệ
- **Frontend**: Flutter (Dart) - Cross-platform mobile
- **Backend**: Flask (Python) - RESTful API
- **Database**: MySQL - Quan hệ
- **AI**: TensorFlow/Keras - CNN Model
- **Auth**: JWT (JSON Web Token)
- **Storage**: File system (uploads/, data/)

### Độ Chính Xác Hệ Thống
- Model Accuracy: ~90%+
- Response Time: < 2s
- Max Image Size: 16MB
- Supported Formats: JPG, PNG, JPEG, GIF

### 10 Loại Trái Cây
1. Bưởi Da Xanh Bến Tre (`buoi_da_xanh`)
2. Cam Sành Hà Giang (`cam_sanh_ha_giang`)
3. Chôm Chôm Long Khánh (`chom_chom_long_khanh`)
4. Măng Cụt Lái Thiêu (`mang_cut_lai_thieu`)
5. Nhãn Lồng Hưng Yên (`nhan_long_hung_yen`)
6. Sầu Riêng Ri6 (`sau_rieng_ri6`)
7. Thanh Long Bình Thuận (`thanh_long_binh_thuan`)
8. Vải Thiều Lục Ngạn (`vai_thieu_luc_ngan`)
9. Vú Sữa Lò Rèn (`vu_sua_lo_ren`)
10. Xoài Cát Hòa Lộc (`xoai_cat_hoa_loc`)

---

## 📌 **KẾT LUẬN**

Hệ thống bao gồm **14 use cases chính** được phân thành 3 nhóm:
- 👤 **4 use cases** cho Người dùng (chức năng nhận diện)
- 👨‍💼 **9 use cases** cho Quản trị viên (quản lý và giám sát)
- 🤖 **1 use case** cho Hệ thống AI (training)

Tất cả use cases đã được triển khai đầy đủ trong code, với:
- ✅ Backend API hoàn chỉnh
- ✅ Frontend Flutter hoàn chỉnh
- ✅ Database schema đầy đủ
- ✅ Authentication & Authorization
- ✅ Error handling

---

**📅 Ngày tạo**: 26/10/2024  
**👨‍💻 Hệ thống**: AI Fruit Recognition System  
**🇻🇳 Made with ❤️ in Vietnam**

