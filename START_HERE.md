# 🎯 BẮT ĐẦU TỪ ĐÂY

## 👋 Chào Mừng!

Đây là hệ thống nhận diện trái cây Việt Nam sử dụng AI và Flutter.

**Hệ thống đã được cấu hình sẵn để dùng MySQL!**

---

## ⚡ Chạy Nhanh (10 phút)

### Bước 1: Cài MySQL

**Chọn 1 trong 2:**

**A. XAMPP (Đơn giản nhất)** ⭐
1. Tải: https://www.apachefriends.org/
2. Cài đặt và mở XAMPP Control Panel
3. Click "Start" cho MySQL
4. ✅ Xong!

**B. MySQL Installer**
1. Tải: https://dev.mysql.com/downloads/installer/
2. Cài đặt và đặt mật khẩu root
3. ✅ Xong!

### Bước 2: Cấu Hình

```bash
# Tạo file .env
copy env_example.txt .env

# Sửa file .env:
# - XAMPP: DB_PASSWORD= (để trống)
# - MySQL Installer: DB_PASSWORD=your_password
```

### Bước 3: Setup Backend

```bash
# Kích hoạt virtual environment (nếu có)
venv\Scripts\activate

# Cài packages
pip install -r requirements.txt

# Khởi tạo database
python init_mysql_db.py

# Chạy server
python app.py
```

✅ Mở browser: `http://localhost:5000`

### Bước 4: Chạy Flutter (Optional)

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 📚 Tài Liệu Theo Nhu Cầu

### 🟢 Người Mới Bắt Đầu

**Đọc theo thứ tự:**

1. **MYSQL_INFO.md** (5 phút)
   - Tại sao dùng MySQL?
   - Cài đặt cơ bản
   - Troubleshooting nhanh

2. **MYSQL_QUICKSTART_VI.md** (10 phút)
   - Hướng dẫn chi tiết 3 bước
   - Cách sửa lỗi thường gặp
   - Checklist đầy đủ

3. **flutter_app/QUICKSTART_VI.md** (10 phút)
   - Chạy Flutter app
   - Cấu hình kết nối
   - Test tính năng

**Tổng thời gian:** ~25 phút

### 🟡 Người Có Kinh Nghiệm

**Đọc để hiểu sâu:**

1. **PROJECT_OVERVIEW_VI.md**
   - Kiến trúc hệ thống
   - Công nghệ sử dụng
   - API endpoints
   - Database schema

2. **MYSQL_SETUP.md**
   - Setup chi tiết
   - Cấu hình nâng cao
   - Troubleshooting đầy đủ
   - Bảo mật

3. **flutter_app/SETUP.md**
   - Cấu trúc Flutter app
   - Customization
   - Build & Deploy

### 🔴 Advanced Users

**Đọc để tối ưu:**

1. **GETTING_STARTED_VI.md**
   - Hướng dẫn theo level
   - Customization guide
   - Deploy production
   - Best practices

2. **README.md**
   - Tổng quan toàn bộ
   - Contributing
   - Roadmap

---

## 🗺️ Sơ Đồ Tài Liệu

```
START_HERE.md (Bạn đang ở đây)
    │
    ├─── 🟢 Người Mới
    │    ├── MYSQL_INFO.md ⭐ (Đọc đầu tiên)
    │    ├── MYSQL_QUICKSTART_VI.md
    │    └── flutter_app/QUICKSTART_VI.md
    │
    ├─── 🟡 Có Kinh Nghiệm
    │    ├── PROJECT_OVERVIEW_VI.md
    │    ├── MYSQL_SETUP.md
    │    └── flutter_app/SETUP.md
    │
    └─── 🔴 Advanced
         ├── GETTING_STARTED_VI.md
         └── README.md
```

---

## 🎯 Theo Mục Đích

### Mục Đích 1: Chạy Demo Nhanh

**Đọc:**
1. MYSQL_QUICKSTART_VI.md
2. flutter_app/QUICKSTART_VI.md

**Thời gian:** 20 phút

### Mục Đích 2: Hiểu Hệ Thống

**Đọc:**
1. PROJECT_OVERVIEW_VI.md
2. MYSQL_SETUP.md
3. Code trong `backend/` và `flutter_app/lib/`

**Thời gian:** 2 giờ

### Mục Đích 3: Tùy Chỉnh & Deploy

**Đọc:**
1. GETTING_STARTED_VI.md (Level 2 & 3)
2. MYSQL_SETUP.md (phần Bảo mật)
3. flutter_app/SETUP.md (phần Build)

**Thời gian:** 1 ngày

### Mục Đích 4: Đồ Án/Luận Văn

**Đọc:**
1. PROJECT_OVERVIEW_VI.md (để viết báo cáo)
2. MYSQL_SETUP.md (để hiểu database)
3. GETTING_STARTED_VI.md (Case 1)

**Thời gian:** 1-2 ngày

---

## 🔧 Scripts Hữu Ích

| Script | Mô Tả | Khi Nào Dùng |
|--------|-------|--------------|
| `test_mysql_connection.py` | Test kết nối MySQL | Trước khi chạy app |
| `init_mysql_db.py` | Khởi tạo database | Lần đầu setup |
| `train_model.py` | Huấn luyện AI model | Khi thêm data mới |
| `app.py` | Chạy Flask server | Chạy backend |

**Cách dùng:**
```bash
# Test connection
python test_mysql_connection.py

# Init database
python init_mysql_db.py

# Run app
python app.py
```

---

## 🆘 Gặp Vấn Đề?

### Lỗi MySQL

**Đọc:** `MYSQL_SETUP.md` → Phần 5: Troubleshooting

**Hoặc:**
```bash
# Test connection
python test_mysql_connection.py
```

### Lỗi Flutter

**Đọc:** `flutter_app/QUICKSTART_VI.md` → Phần "Sửa Lỗi Nhanh"

### Lỗi Khác

**Đọc:** `GETTING_STARTED_VI.md` → Phần "Monitoring & Debugging"

---

## ✅ Checklist Nhanh

### Backend
- [ ] MySQL đã cài và chạy
- [ ] File `.env` đã tạo và cấu hình
- [ ] `python test_mysql_connection.py` → ✅
- [ ] `python init_mysql_db.py` → ✅
- [ ] `python app.py` → Server chạy port 5000

### Frontend (Optional)
- [ ] Flutter SDK đã cài
- [ ] `flutter pub get` → ✅
- [ ] Cấu hình URL trong `constants.dart`
- [ ] `flutter run` → App chạy

---

## 🎓 Học Thêm

### Công Nghệ Sử Dụng

- **Flask**: https://flask.palletsprojects.com/
- **MySQL**: https://dev.mysql.com/doc/
- **Flutter**: https://flutter.dev/docs
- **TensorFlow**: https://www.tensorflow.org/

### Video Tutorials

- Flask + MySQL: YouTube "Flask MySQL Tutorial"
- Flutter: YouTube "Flutter Course"
- Deep Learning: Coursera "Deep Learning Specialization"

---

## 💡 Tips Quan Trọng

### 1. Luôn Backup

```bash
# Backup database
mysqldump -u root -p fruit_recognition_db > backup.sql
```

### 2. Dùng Virtual Environment

```bash
python -m venv venv
venv\Scripts\activate
```

### 3. Git Ignore

Đảm bảo `.env` trong `.gitignore`:
```
.env
*.pyc
__pycache__/
venv/
```

### 4. Test Trước Khi Deploy

```bash
# Test backend
python test_mysql_connection.py
curl http://localhost:5000/api/health

# Test Flutter
flutter analyze
flutter test
```

---

## 🎉 Bắt Đầu Ngay!

### Lộ Trình Khuyến Nghị

**Ngày 1: Setup (1 giờ)**
1. Đọc `MYSQL_INFO.md` (5 phút)
2. Cài MySQL (10 phút)
3. Setup backend theo `MYSQL_QUICKSTART_VI.md` (20 phút)
4. Test API (5 phút)
5. Setup Flutter (20 phút)

**Ngày 2: Hiểu Hệ Thống (2 giờ)**
1. Đọc `PROJECT_OVERVIEW_VI.md` (30 phút)
2. Đọc code backend (45 phút)
3. Đọc code Flutter (45 phút)

**Ngày 3: Tùy Chỉnh (3 giờ)**
1. Thay đổi UI (1 giờ)
2. Thêm tính năng (1 giờ)
3. Test và debug (1 giờ)

**Ngày 4: Deploy (2 giờ)**
1. Build APK (30 phút)
2. Setup production database (1 giờ)
3. Deploy backend (30 phút)

---

## 📞 Liên Hệ & Hỗ Trợ

- **GitHub Issues**: Báo lỗi và góp ý
- **Email**: support@fruitai.com
- **Documentation**: Các file .md trong project

---

## 🌟 Đóng Góp

Nếu bạn thấy project hữu ích:
- ⭐ Star trên GitHub
- 🐛 Báo lỗi qua Issues
- 💡 Đóng góp code qua Pull Requests
- 📝 Cải thiện documentation

---

<div align="center">

## 🚀 Sẵn Sàng Bắt Đầu?

### Bước Tiếp Theo:

**Người Mới** → Đọc [MYSQL_INFO.md](MYSQL_INFO.md)

**Có Kinh Nghiệm** → Đọc [PROJECT_OVERVIEW_VI.md](PROJECT_OVERVIEW_VI.md)

**Advanced** → Đọc [GETTING_STARTED_VI.md](GETTING_STARTED_VI.md)

---

**Made with ❤️ in Vietnam 🇻🇳**

**Chúc bạn thành công! 🎉**

</div>


## 👋 Chào Mừng!

Đây là hệ thống nhận diện trái cây Việt Nam sử dụng AI và Flutter.

**Hệ thống đã được cấu hình sẵn để dùng MySQL!**

---

## ⚡ Chạy Nhanh (10 phút)

### Bước 1: Cài MySQL

**Chọn 1 trong 2:**

**A. XAMPP (Đơn giản nhất)** ⭐
1. Tải: https://www.apachefriends.org/
2. Cài đặt và mở XAMPP Control Panel
3. Click "Start" cho MySQL
4. ✅ Xong!

**B. MySQL Installer**
1. Tải: https://dev.mysql.com/downloads/installer/
2. Cài đặt và đặt mật khẩu root
3. ✅ Xong!

### Bước 2: Cấu Hình

```bash
# Tạo file .env
copy env_example.txt .env

# Sửa file .env:
# - XAMPP: DB_PASSWORD= (để trống)
# - MySQL Installer: DB_PASSWORD=your_password
```

### Bước 3: Setup Backend

```bash
# Kích hoạt virtual environment (nếu có)
venv\Scripts\activate

# Cài packages
pip install -r requirements.txt

# Khởi tạo database
python init_mysql_db.py

# Chạy server
python app.py
```

✅ Mở browser: `http://localhost:5000`

### Bước 4: Chạy Flutter (Optional)

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 📚 Tài Liệu Theo Nhu Cầu

### 🟢 Người Mới Bắt Đầu

**Đọc theo thứ tự:**

1. **MYSQL_INFO.md** (5 phút)
   - Tại sao dùng MySQL?
   - Cài đặt cơ bản
   - Troubleshooting nhanh

2. **MYSQL_QUICKSTART_VI.md** (10 phút)
   - Hướng dẫn chi tiết 3 bước
   - Cách sửa lỗi thường gặp
   - Checklist đầy đủ

3. **flutter_app/QUICKSTART_VI.md** (10 phút)
   - Chạy Flutter app
   - Cấu hình kết nối
   - Test tính năng

**Tổng thời gian:** ~25 phút

### 🟡 Người Có Kinh Nghiệm

**Đọc để hiểu sâu:**

1. **PROJECT_OVERVIEW_VI.md**
   - Kiến trúc hệ thống
   - Công nghệ sử dụng
   - API endpoints
   - Database schema

2. **MYSQL_SETUP.md**
   - Setup chi tiết
   - Cấu hình nâng cao
   - Troubleshooting đầy đủ
   - Bảo mật

3. **flutter_app/SETUP.md**
   - Cấu trúc Flutter app
   - Customization
   - Build & Deploy

### 🔴 Advanced Users

**Đọc để tối ưu:**

1. **GETTING_STARTED_VI.md**
   - Hướng dẫn theo level
   - Customization guide
   - Deploy production
   - Best practices

2. **README.md**
   - Tổng quan toàn bộ
   - Contributing
   - Roadmap

---

## 🗺️ Sơ Đồ Tài Liệu

```
START_HERE.md (Bạn đang ở đây)
    │
    ├─── 🟢 Người Mới
    │    ├── MYSQL_INFO.md ⭐ (Đọc đầu tiên)
    │    ├── MYSQL_QUICKSTART_VI.md
    │    └── flutter_app/QUICKSTART_VI.md
    │
    ├─── 🟡 Có Kinh Nghiệm
    │    ├── PROJECT_OVERVIEW_VI.md
    │    ├── MYSQL_SETUP.md
    │    └── flutter_app/SETUP.md
    │
    └─── 🔴 Advanced
         ├── GETTING_STARTED_VI.md
         └── README.md
```

---

## 🎯 Theo Mục Đích

### Mục Đích 1: Chạy Demo Nhanh

**Đọc:**
1. MYSQL_QUICKSTART_VI.md
2. flutter_app/QUICKSTART_VI.md

**Thời gian:** 20 phút

### Mục Đích 2: Hiểu Hệ Thống

**Đọc:**
1. PROJECT_OVERVIEW_VI.md
2. MYSQL_SETUP.md
3. Code trong `backend/` và `flutter_app/lib/`

**Thời gian:** 2 giờ

### Mục Đích 3: Tùy Chỉnh & Deploy

**Đọc:**
1. GETTING_STARTED_VI.md (Level 2 & 3)
2. MYSQL_SETUP.md (phần Bảo mật)
3. flutter_app/SETUP.md (phần Build)

**Thời gian:** 1 ngày

### Mục Đích 4: Đồ Án/Luận Văn

**Đọc:**
1. PROJECT_OVERVIEW_VI.md (để viết báo cáo)
2. MYSQL_SETUP.md (để hiểu database)
3. GETTING_STARTED_VI.md (Case 1)

**Thời gian:** 1-2 ngày

---

## 🔧 Scripts Hữu Ích

| Script | Mô Tả | Khi Nào Dùng |
|--------|-------|--------------|
| `test_mysql_connection.py` | Test kết nối MySQL | Trước khi chạy app |
| `init_mysql_db.py` | Khởi tạo database | Lần đầu setup |
| `train_model.py` | Huấn luyện AI model | Khi thêm data mới |
| `app.py` | Chạy Flask server | Chạy backend |

**Cách dùng:**
```bash
# Test connection
python test_mysql_connection.py

# Init database
python init_mysql_db.py

# Run app
python app.py
```

---

## 🆘 Gặp Vấn Đề?

### Lỗi MySQL

**Đọc:** `MYSQL_SETUP.md` → Phần 5: Troubleshooting

**Hoặc:**
```bash
# Test connection
python test_mysql_connection.py
```

### Lỗi Flutter

**Đọc:** `flutter_app/QUICKSTART_VI.md` → Phần "Sửa Lỗi Nhanh"

### Lỗi Khác

**Đọc:** `GETTING_STARTED_VI.md` → Phần "Monitoring & Debugging"

---

## ✅ Checklist Nhanh

### Backend
- [ ] MySQL đã cài và chạy
- [ ] File `.env` đã tạo và cấu hình
- [ ] `python test_mysql_connection.py` → ✅
- [ ] `python init_mysql_db.py` → ✅
- [ ] `python app.py` → Server chạy port 5000

### Frontend (Optional)
- [ ] Flutter SDK đã cài
- [ ] `flutter pub get` → ✅
- [ ] Cấu hình URL trong `constants.dart`
- [ ] `flutter run` → App chạy

---

## 🎓 Học Thêm

### Công Nghệ Sử Dụng

- **Flask**: https://flask.palletsprojects.com/
- **MySQL**: https://dev.mysql.com/doc/
- **Flutter**: https://flutter.dev/docs
- **TensorFlow**: https://www.tensorflow.org/

### Video Tutorials

- Flask + MySQL: YouTube "Flask MySQL Tutorial"
- Flutter: YouTube "Flutter Course"
- Deep Learning: Coursera "Deep Learning Specialization"

---

## 💡 Tips Quan Trọng

### 1. Luôn Backup

```bash
# Backup database
mysqldump -u root -p fruit_recognition_db > backup.sql
```

### 2. Dùng Virtual Environment

```bash
python -m venv venv
venv\Scripts\activate
```

### 3. Git Ignore

Đảm bảo `.env` trong `.gitignore`:
```
.env
*.pyc
__pycache__/
venv/
```

### 4. Test Trước Khi Deploy

```bash
# Test backend
python test_mysql_connection.py
curl http://localhost:5000/api/health

# Test Flutter
flutter analyze
flutter test
```

---

## 🎉 Bắt Đầu Ngay!

### Lộ Trình Khuyến Nghị

**Ngày 1: Setup (1 giờ)**
1. Đọc `MYSQL_INFO.md` (5 phút)
2. Cài MySQL (10 phút)
3. Setup backend theo `MYSQL_QUICKSTART_VI.md` (20 phút)
4. Test API (5 phút)
5. Setup Flutter (20 phút)

**Ngày 2: Hiểu Hệ Thống (2 giờ)**
1. Đọc `PROJECT_OVERVIEW_VI.md` (30 phút)
2. Đọc code backend (45 phút)
3. Đọc code Flutter (45 phút)

**Ngày 3: Tùy Chỉnh (3 giờ)**
1. Thay đổi UI (1 giờ)
2. Thêm tính năng (1 giờ)
3. Test và debug (1 giờ)

**Ngày 4: Deploy (2 giờ)**
1. Build APK (30 phút)
2. Setup production database (1 giờ)
3. Deploy backend (30 phút)

---

## 📞 Liên Hệ & Hỗ Trợ

- **GitHub Issues**: Báo lỗi và góp ý
- **Email**: support@fruitai.com
- **Documentation**: Các file .md trong project

---

## 🌟 Đóng Góp

Nếu bạn thấy project hữu ích:
- ⭐ Star trên GitHub
- 🐛 Báo lỗi qua Issues
- 💡 Đóng góp code qua Pull Requests
- 📝 Cải thiện documentation

---

<div align="center">

## 🚀 Sẵn Sàng Bắt Đầu?

### Bước Tiếp Theo:

**Người Mới** → Đọc [MYSQL_INFO.md](MYSQL_INFO.md)

**Có Kinh Nghiệm** → Đọc [PROJECT_OVERVIEW_VI.md](PROJECT_OVERVIEW_VI.md)

**Advanced** → Đọc [GETTING_STARTED_VI.md](GETTING_STARTED_VI.md)

---

**Made with ❤️ in Vietnam 🇻🇳**

**Chúc bạn thành công! 🎉**

</div>



