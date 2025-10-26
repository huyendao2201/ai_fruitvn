# 🌐 Web App - Nhận Diện Trái Cây Việt Nam

## 🚀 Quick Start

### 0. Cài đặt dependencies (nếu chưa)
```bash
pip install cryptography
```

### 1. Chạy Backend
```bash
python app.py
```
Backend sẽ chạy tại: `http://localhost:5000`

### 2. Chạy Web Server (Terminal mới)
```bash
cd web_app
python -m http.server 8000
```
Web app sẽ chạy tại: `http://localhost:8000`

### 3. Truy cập
```
http://localhost:8000/login.html
```

### 4. Đăng nhập
**Admin:** `admin` / `admin123`  
**User:** `user1` / `password123`

> **Lưu ý:** Nếu gặp lỗi encoding khi chạy backend, đảm bảo bạn đã cài `cryptography` package.

---

## ✨ Các Cải Tiến Mới

### 🎨 Giao Diện Hiện Đại
- ✅ Gradient màu sắc đẹp mắt (Purple/Blue theme)
- ✅ Animations mượt mà (fade-in, slide-up, bounce)
- ✅ Shadows và depth effects
- ✅ Hover effects trên tất cả interactive elements
- ✅ Responsive design tốt hơn

### 🐛 Sửa Lỗi
- ✅ Loại bỏ duplicate code trong tất cả files
- ✅ Sửa lỗi đăng nhập không hoạt động
- ✅ Sửa lỗi upload ảnh không hoạt động
- ✅ Cải thiện error handling và logging

### 📱 UI/UX Improvements
- ✅ Upload area với drag & drop animation
- ✅ Preview ảnh với hover effect
- ✅ Result card với gradient background
- ✅ Confidence bar với smooth animation
- ✅ Feedback buttons với gradient colors
- ✅ Loading overlay với backdrop blur

---

## 📁 Cấu Trúc

```
web_app/
├── css/
│   └── style.css          # Modern CSS với gradients & animations
├── js/
│   ├── api.js            # API service (đã sửa lỗi)
│   ├── utils.js          # Utilities
│   └── main.js           # Main logic (đã sửa lỗi)
├── pages/
│   └── admin.html        # Admin dashboard
├── index.html            # Trang chủ (UI mới)
├── login.html            # Login page (UI mới)
├── register.html         # Register page
├── history.html          # History page
└── README.md             # File này
```

---

## 🎯 Tính Năng

### Cho User
- 📷 Upload & nhận diện trái cây
- 📊 Xem độ tin cậy với animated progress bar
- 💬 Gửi feedback (đúng/sai + comment)
- 📜 Xem lịch sử dự đoán
- 🎨 Giao diện đẹp, hiện đại

### Cho Admin
- 📊 Dashboard thống kê
- 💬 Quản lý feedback
- 📚 Thêm ảnh vào training dataset
- 🔍 Lọc feedback theo trạng thái

---

## 🔧 Troubleshooting

### Backend không chạy?
```bash
# Kiểm tra
curl http://127.0.0.1:5000/api/health

# Nếu lỗi, chạy lại
python app.py
```

### CORS Error?
Đừng mở file HTML trực tiếp. Phải chạy qua HTTP server:
```bash
python -m http.server 8000
```

### Đăng nhập không được?
1. Mở Console (F12) để xem lỗi
2. Kiểm tra backend đang chạy
3. Xóa localStorage: `localStorage.clear()`
4. Thử lại

### Upload ảnh không được?
1. Kiểm tra file < 10MB
2. Chỉ dùng JPG, JPEG, PNG
3. Kiểm tra Console (F12) để xem lỗi
4. Kiểm tra backend đang chạy

---

## 📚 Documentation

Xem tài liệu đầy đủ tại: `../DOCUMENTATION.md`

---

## 🎉 Hoàn Tất!

Web app đã được cải thiện với:
- ✅ Giao diện hiện đại, đẹp mắt
- ✅ Animations mượt mà
- ✅ Sửa tất cả lỗi
- ✅ Code sạch, không duplicate
- ✅ Better UX

**Chúc bạn sử dụng vui vẻ!** 🚀🍎🥭🍊


