# 🍎 Hệ Thống Nhận Diện Trái Cây Việt Nam

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Python](https://img.shields.io/badge/python-3.9+-green.svg)
![Flutter](https://img.shields.io/badge/flutter-3.0+-blue.svg)
![MySQL](https://img.shields.io/badge/mysql-8.0+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**Hệ thống AI nhận diện 10 loại trái cây đặc sản Việt Nam**

[Tính Năng](#-tính-năng) • [Cài Đặt](#-cài-đặt-nhanh) • [Sử Dụng](#-sử-dụng) • [Documentation](#-documentation)

</div>

---

## 📖 Giới Thiệu

Hệ thống nhận diện trái cây sử dụng Deep Learning (CNN) và Flutter, giúp nhận diện 10 loại trái cây đặc sản Việt Nam qua hình ảnh với độ chính xác cao.

### 🍇 10 Loại Trái Cây

<table>
<tr>
<td>🍊 Bưởi Da Xanh Bến Tre</td>
<td>🍊 Cam Sành Hà Giang</td>
<td>🔴 Chôm Chôm Long Khánh</td>
</tr>
<tr>
<td>🟣 Măng Cụt Lái Thiêu</td>
<td>🟤 Nhãn Lồng Hưng Yên</td>
<td>🟡 Sầu Riêng Ri6</td>
</tr>
<tr>
<td>🔴 Thanh Long Bình Thuận</td>
<td>🔴 Vải Thiều Lục Ngạn</td>
<td>🟢 Vú Sữa Lò Rèn</td>
</tr>
<tr>
<td colspan="3">🟡 Xoài Cát Hòa Lộc</td>
</tr>
</table>

---

## ✨ Tính Năng

### 👤 Người Dùng
- ✅ Chụp hoặc chọn ảnh trái cây
- ✅ Nhận diện bằng AI với độ tin cậy cao (>90%)
- ✅ Xem các kết quả dự đoán khác
- ✅ Đánh giá và phản hồi kết quả
- ✅ Giao diện tiếng Việt thân thiện

### 👨‍💼 Admin
- ✅ Dashboard thống kê tổng quan
- ✅ Lịch sử dự đoán chi tiết
- ✅ Quản lý phản hồi người dùng
- ✅ Nhật ký huấn luyện mô hình
- ✅ Biểu đồ trực quan

---

## 🏗️ Kiến Trúc Hệ Thống

```
┌─────────────────┐
│  Flutter App    │  ← Mobile Application (Android/iOS)
│  (Frontend)     │
└────────┬────────┘
         │ HTTP/REST API
         ↓
┌─────────────────┐
│   Flask API     │  ← Backend Server
│   (Backend)     │
└────────┬────────┘
         │
    ┌────┴────┬──────────┐
    ↓         ↓          ↓
┌────────┐ ┌──────┐ ┌────────┐
│ MySQL  │ │ CNN  │ │ Files  │
│   DB   │ │Model │ │Storage │
└────────┘ └──────┘ └────────┘
```

### 🔧 Công Nghệ

**Backend:**
- Flask (Web Framework)
- TensorFlow/Keras (Deep Learning)
- MySQL (Database)
- JWT (Authentication)

**Frontend:**
- Flutter (Mobile Framework)
- Dart (Programming Language)
- Material Design (UI/UX)

**AI/ML:**
- CNN (Convolutional Neural Network)
- Image Classification
- Transfer Learning

---

## 🚀 Cài Đặt Nhanh

### Yêu Cầu Hệ Thống

- Python 3.9+
- Flutter SDK 3.0+
- MySQL 8.0+
- 8GB RAM (khuyến nghị)
- 10GB disk space

### Bước 1: Clone Repository

```bash
git clone https://github.com/yourusername/AI_Fruit.git
cd AI_Fruit
```

### Bước 2: Setup MySQL

**Cài đặt MySQL:**

- **Windows**: Tải [XAMPP](https://www.apachefriends.org/) hoặc [MySQL Installer](https://dev.mysql.com/downloads/installer/)
- **macOS**: `brew install mysql && brew services start mysql`
- **Linux**: `sudo apt install mysql-server && sudo systemctl start mysql`

**Cấu hình:**

```bash
# Tạo file .env
copy env_example.txt .env  # Windows
cp env_example.txt .env    # macOS/Linux

# Sửa file .env
DB_PASSWORD=your_mysql_password_here
```

### Bước 3: Setup Backend

```bash
# Tạo virtual environment
python -m venv venv

# Kích hoạt
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# Cài đặt dependencies
pip install -r requirements.txt

# Khởi tạo database
python init_mysql_db.py

# Chạy server
python app.py
```

✅ Backend chạy tại: `http://localhost:5000`

### Bước 4: Setup Flutter App

```bash
cd flutter_app

# Cài đặt dependencies
flutter pub get

# Cấu hình URL (lib/utils/constants.dart)
# Android Emulator: http://10.0.2.2:5000/api
# Thiết bị thật: http://YOUR_IP:5000/api

# Chạy app
flutter run
```

---

## 📱 Sử Dụng

### Người Dùng

1. **Mở App** → Màn hình chính
2. **Chọn Ảnh** → Chụp hoặc từ thư viện
3. **Nhận Diện** → Nhấn nút "Nhận Diện"
4. **Xem Kết Quả** → Tên trái cây + độ tin cậy
5. **Phản Hồi** → Đánh giá đúng/sai

### Admin

1. **Đăng Nhập** → Username: `admin`, Password: `admin123`
2. **Dashboard** → Xem thống kê tổng quan
3. **Lịch Sử** → Xem tất cả dự đoán
4. **Phản Hồi** → Quản lý feedback
5. **Training Logs** → Xem lịch sử huấn luyện

---

## 📚 Documentation

### 🌟 Bắt Đầu Từ Đây

| File | Mô Tả | Dành Cho |
|------|-------|----------|
| **MYSQL_QUICKSTART_VI.md** | ⚡ Hướng dẫn MySQL nhanh (3 bước) | Người mới |
| **flutter_app/QUICKSTART_VI.md** | ⚡ Hướng dẫn Flutter nhanh | Người mới |

### 📖 Chi Tiết

| File | Mô Tả |
|------|-------|
| **MYSQL_SETUP.md** | Hướng dẫn MySQL đầy đủ + Troubleshooting |
| **flutter_app/SETUP.md** | Hướng dẫn Flutter đầy đủ |
| **PROJECT_OVERVIEW_VI.md** | Tổng quan kiến trúc và tính năng |

### 🛠️ Scripts

| File | Mô Tả | Cách Dùng |
|------|-------|-----------|
| `init_mysql_db.py` | Khởi tạo database MySQL | `python init_mysql_db.py` |
| `test_mysql_connection.py` | Test kết nối MySQL | `python test_mysql_connection.py` |
| `train_model.py` | Huấn luyện mô hình AI | `python train_model.py` |

---

## 🗄️ Database Schema

```sql
users
├── id (PK)
├── username (UNIQUE)
├── password (HASHED)
├── role (user/admin)
└── created_at

predictions
├── id (PK)
├── user_id (FK → users.id)
├── image_path
├── predicted_label
├── confidence
└── created_at

feedback
├── id (PK)
├── prediction_id (FK → predictions.id)
├── comment
├── is_correct
└── created_at

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

## 🔌 API Endpoints

### Public

```http
POST /api/predict
Content-Type: multipart/form-data
Body: image (file)

POST /api/feedback_user
Content-Type: application/json
Body: { prediction_id, is_correct, comment }
```

### Admin (Requires JWT)

```http
POST   /api/auth/login_admin
POST   /api/auth/logout_admin
GET    /api/admin/dashboard
GET    /api/admin/history
GET    /api/admin/feedback
GET    /api/admin/training_logs
```

---

## 🧪 Testing

### Backend

```bash
# Test kết nối MySQL
python test_mysql_connection.py

# Test API
curl http://localhost:5000/api/health

# Test prediction
curl -X POST -F "image=@test.jpg" http://localhost:5000/api/predict
```

### Flutter

```bash
cd flutter_app
flutter test
flutter analyze
```

---

## 🐛 Troubleshooting

### ❌ MySQL Connection Error

```bash
# Kiểm tra MySQL đang chạy
# Windows: XAMPP Control Panel
# macOS: brew services list
# Linux: sudo systemctl status mysql

# Kiểm tra file .env
cat .env  # Xem DB_PASSWORD đúng chưa

# Test connection
python test_mysql_connection.py
```

### ❌ Flutter Connection Error

```dart
// Kiểm tra URL trong lib/utils/constants.dart
static const String baseUrl = 'http://10.0.2.2:5000/api';  // Android Emulator
// hoặc
static const String baseUrl = 'http://YOUR_IP:5000/api';  // Thiết bị thật
```

### ❌ Model Not Found

```bash
# Kiểm tra file model
ls models/fruit_classifier.h5

# Nếu không có, train lại
python train_model.py
```

**Xem thêm:** `MYSQL_SETUP.md` (phần Troubleshooting)

---

## 📊 Performance

- **Accuracy**: ~90%+
- **Response Time**: < 2s
- **Model Size**: ~50MB
- **Supported Formats**: JPG, PNG, JPEG
- **Max Image Size**: 16MB

---

## 🗂️ Cấu Trúc Project

```
AI_Fruit/
├── backend/                    # Backend code
│   ├── config/                # Configuration
│   ├── models/                # Database models
│   ├── routes/                # API routes
│   └── utils/                 # Utilities
├── flutter_app/               # Flutter mobile app
│   ├── lib/                   # Dart code
│   │   ├── models/           # Data models
│   │   ├── screens/          # UI screens
│   │   ├── services/         # API services
│   │   └── utils/            # Constants
│   └── assets/               # Images, fonts
├── models/                    # AI models
│   └── fruit_classifier.h5   # Trained model
├── data/                      # Training data
│   ├── train/                # Training set
│   ├── validation/           # Validation set
│   └── test/                 # Test set
├── uploads/                   # Uploaded images
├── app.py                     # Flask main app
├── init_mysql_db.py          # DB initialization
├── test_mysql_connection.py  # Connection test
├── train_model.py            # Model training
├── requirements.txt          # Python deps
└── README.md                 # This file
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Backend Development** - Flask API, Database, AI Model
- **Mobile Development** - Flutter App, UI/UX
- **AI/ML Engineering** - Model Training, Optimization

---

## 🙏 Acknowledgments

- TensorFlow/Keras for deep learning framework
- Flutter team for amazing mobile framework
- Vietnamese fruit farmers for inspiration
- Open source community

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/AI_Fruit/issues)
- **Email**: support@fruitai.com
- **Documentation**: [Wiki](https://github.com/yourusername/AI_Fruit/wiki)

---

## 🎯 Roadmap

### ✅ Phase 1 (Completed)
- [x] Backend API with Flask
- [x] MySQL Database
- [x] CNN Model Training
- [x] Flutter Mobile App
- [x] Admin Dashboard
- [x] Vietnamese UI

### 🔄 Phase 2 (In Progress)
- [ ] Improve model accuracy to 95%+
- [ ] Add more fruit types (20+)
- [ ] Offline mode support
- [ ] Push notifications
- [ ] User authentication

### 🚀 Phase 3 (Planned)
- [ ] Multi-language support (EN, CN)
- [ ] AR features
- [ ] Nutrition information
- [ ] Recipe suggestions
- [ ] E-commerce integration
- [ ] iOS version

---

<div align="center">

**Made with ❤️ in Vietnam 🇻🇳**

⭐ Star us on GitHub — it motivates us a lot!

[⬆ Back to Top](#-hệ-thống-nhận-diện-trái-cây-việt-nam)

</div>


<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Python](https://img.shields.io/badge/python-3.9+-green.svg)
![Flutter](https://img.shields.io/badge/flutter-3.0+-blue.svg)
![MySQL](https://img.shields.io/badge/mysql-8.0+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**Hệ thống AI nhận diện 10 loại trái cây đặc sản Việt Nam**

[Tính Năng](#-tính-năng) • [Cài Đặt](#-cài-đặt-nhanh) • [Sử Dụng](#-sử-dụng) • [Documentation](#-documentation)

</div>

---

## 📖 Giới Thiệu

Hệ thống nhận diện trái cây sử dụng Deep Learning (CNN) và Flutter, giúp nhận diện 10 loại trái cây đặc sản Việt Nam qua hình ảnh với độ chính xác cao.

### 🍇 10 Loại Trái Cây

<table>
<tr>
<td>🍊 Bưởi Da Xanh Bến Tre</td>
<td>🍊 Cam Sành Hà Giang</td>
<td>🔴 Chôm Chôm Long Khánh</td>
</tr>
<tr>
<td>🟣 Măng Cụt Lái Thiêu</td>
<td>🟤 Nhãn Lồng Hưng Yên</td>
<td>🟡 Sầu Riêng Ri6</td>
</tr>
<tr>
<td>🔴 Thanh Long Bình Thuận</td>
<td>🔴 Vải Thiều Lục Ngạn</td>
<td>🟢 Vú Sữa Lò Rèn</td>
</tr>
<tr>
<td colspan="3">🟡 Xoài Cát Hòa Lộc</td>
</tr>
</table>

---

## ✨ Tính Năng

### 👤 Người Dùng
- ✅ Chụp hoặc chọn ảnh trái cây
- ✅ Nhận diện bằng AI với độ tin cậy cao (>90%)
- ✅ Xem các kết quả dự đoán khác
- ✅ Đánh giá và phản hồi kết quả
- ✅ Giao diện tiếng Việt thân thiện

### 👨‍💼 Admin
- ✅ Dashboard thống kê tổng quan
- ✅ Lịch sử dự đoán chi tiết
- ✅ Quản lý phản hồi người dùng
- ✅ Nhật ký huấn luyện mô hình
- ✅ Biểu đồ trực quan

---

## 🏗️ Kiến Trúc Hệ Thống

```
┌─────────────────┐
│  Flutter App    │  ← Mobile Application (Android/iOS)
│  (Frontend)     │
└────────┬────────┘
         │ HTTP/REST API
         ↓
┌─────────────────┐
│   Flask API     │  ← Backend Server
│   (Backend)     │
└────────┬────────┘
         │
    ┌────┴────┬──────────┐
    ↓         ↓          ↓
┌────────┐ ┌──────┐ ┌────────┐
│ MySQL  │ │ CNN  │ │ Files  │
│   DB   │ │Model │ │Storage │
└────────┘ └──────┘ └────────┘
```

### 🔧 Công Nghệ

**Backend:**
- Flask (Web Framework)
- TensorFlow/Keras (Deep Learning)
- MySQL (Database)
- JWT (Authentication)

**Frontend:**
- Flutter (Mobile Framework)
- Dart (Programming Language)
- Material Design (UI/UX)

**AI/ML:**
- CNN (Convolutional Neural Network)
- Image Classification
- Transfer Learning

---

## 🚀 Cài Đặt Nhanh

### Yêu Cầu Hệ Thống

- Python 3.9+
- Flutter SDK 3.0+
- MySQL 8.0+
- 8GB RAM (khuyến nghị)
- 10GB disk space

### Bước 1: Clone Repository

```bash
git clone https://github.com/yourusername/AI_Fruit.git
cd AI_Fruit
```

### Bước 2: Setup MySQL

**Cài đặt MySQL:**

- **Windows**: Tải [XAMPP](https://www.apachefriends.org/) hoặc [MySQL Installer](https://dev.mysql.com/downloads/installer/)
- **macOS**: `brew install mysql && brew services start mysql`
- **Linux**: `sudo apt install mysql-server && sudo systemctl start mysql`

**Cấu hình:**

```bash
# Tạo file .env
copy env_example.txt .env  # Windows
cp env_example.txt .env    # macOS/Linux

# Sửa file .env
DB_PASSWORD=your_mysql_password_here
```

### Bước 3: Setup Backend

```bash
# Tạo virtual environment
python -m venv venv

# Kích hoạt
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# Cài đặt dependencies
pip install -r requirements.txt

# Khởi tạo database
python init_mysql_db.py

# Chạy server
python app.py
```

✅ Backend chạy tại: `http://localhost:5000`

### Bước 4: Setup Flutter App

```bash
cd flutter_app

# Cài đặt dependencies
flutter pub get

# Cấu hình URL (lib/utils/constants.dart)
# Android Emulator: http://10.0.2.2:5000/api
# Thiết bị thật: http://YOUR_IP:5000/api

# Chạy app
flutter run
```

---

## 📱 Sử Dụng

### Người Dùng

1. **Mở App** → Màn hình chính
2. **Chọn Ảnh** → Chụp hoặc từ thư viện
3. **Nhận Diện** → Nhấn nút "Nhận Diện"
4. **Xem Kết Quả** → Tên trái cây + độ tin cậy
5. **Phản Hồi** → Đánh giá đúng/sai

### Admin

1. **Đăng Nhập** → Username: `admin`, Password: `admin123`
2. **Dashboard** → Xem thống kê tổng quan
3. **Lịch Sử** → Xem tất cả dự đoán
4. **Phản Hồi** → Quản lý feedback
5. **Training Logs** → Xem lịch sử huấn luyện

---

## 📚 Documentation

### 🌟 Bắt Đầu Từ Đây

| File | Mô Tả | Dành Cho |
|------|-------|----------|
| **MYSQL_QUICKSTART_VI.md** | ⚡ Hướng dẫn MySQL nhanh (3 bước) | Người mới |
| **flutter_app/QUICKSTART_VI.md** | ⚡ Hướng dẫn Flutter nhanh | Người mới |

### 📖 Chi Tiết

| File | Mô Tả |
|------|-------|
| **MYSQL_SETUP.md** | Hướng dẫn MySQL đầy đủ + Troubleshooting |
| **flutter_app/SETUP.md** | Hướng dẫn Flutter đầy đủ |
| **PROJECT_OVERVIEW_VI.md** | Tổng quan kiến trúc và tính năng |

### 🛠️ Scripts

| File | Mô Tả | Cách Dùng |
|------|-------|-----------|
| `init_mysql_db.py` | Khởi tạo database MySQL | `python init_mysql_db.py` |
| `test_mysql_connection.py` | Test kết nối MySQL | `python test_mysql_connection.py` |
| `train_model.py` | Huấn luyện mô hình AI | `python train_model.py` |

---

## 🗄️ Database Schema

```sql
users
├── id (PK)
├── username (UNIQUE)
├── password (HASHED)
├── role (user/admin)
└── created_at

predictions
├── id (PK)
├── user_id (FK → users.id)
├── image_path
├── predicted_label
├── confidence
└── created_at

feedback
├── id (PK)
├── prediction_id (FK → predictions.id)
├── comment
├── is_correct
└── created_at

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

## 🔌 API Endpoints

### Public

```http
POST /api/predict
Content-Type: multipart/form-data
Body: image (file)

POST /api/feedback_user
Content-Type: application/json
Body: { prediction_id, is_correct, comment }
```

### Admin (Requires JWT)

```http
POST   /api/auth/login_admin
POST   /api/auth/logout_admin
GET    /api/admin/dashboard
GET    /api/admin/history
GET    /api/admin/feedback
GET    /api/admin/training_logs
```

---

## 🧪 Testing

### Backend

```bash
# Test kết nối MySQL
python test_mysql_connection.py

# Test API
curl http://localhost:5000/api/health

# Test prediction
curl -X POST -F "image=@test.jpg" http://localhost:5000/api/predict
```

### Flutter

```bash
cd flutter_app
flutter test
flutter analyze
```

---

## 🐛 Troubleshooting

### ❌ MySQL Connection Error

```bash
# Kiểm tra MySQL đang chạy
# Windows: XAMPP Control Panel
# macOS: brew services list
# Linux: sudo systemctl status mysql

# Kiểm tra file .env
cat .env  # Xem DB_PASSWORD đúng chưa

# Test connection
python test_mysql_connection.py
```

### ❌ Flutter Connection Error

```dart
// Kiểm tra URL trong lib/utils/constants.dart
static const String baseUrl = 'http://10.0.2.2:5000/api';  // Android Emulator
// hoặc
static const String baseUrl = 'http://YOUR_IP:5000/api';  // Thiết bị thật
```

### ❌ Model Not Found

```bash
# Kiểm tra file model
ls models/fruit_classifier.h5

# Nếu không có, train lại
python train_model.py
```

**Xem thêm:** `MYSQL_SETUP.md` (phần Troubleshooting)

---

## 📊 Performance

- **Accuracy**: ~90%+
- **Response Time**: < 2s
- **Model Size**: ~50MB
- **Supported Formats**: JPG, PNG, JPEG
- **Max Image Size**: 16MB

---

## 🗂️ Cấu Trúc Project

```
AI_Fruit/
├── backend/                    # Backend code
│   ├── config/                # Configuration
│   ├── models/                # Database models
│   ├── routes/                # API routes
│   └── utils/                 # Utilities
├── flutter_app/               # Flutter mobile app
│   ├── lib/                   # Dart code
│   │   ├── models/           # Data models
│   │   ├── screens/          # UI screens
│   │   ├── services/         # API services
│   │   └── utils/            # Constants
│   └── assets/               # Images, fonts
├── models/                    # AI models
│   └── fruit_classifier.h5   # Trained model
├── data/                      # Training data
│   ├── train/                # Training set
│   ├── validation/           # Validation set
│   └── test/                 # Test set
├── uploads/                   # Uploaded images
├── app.py                     # Flask main app
├── init_mysql_db.py          # DB initialization
├── test_mysql_connection.py  # Connection test
├── train_model.py            # Model training
├── requirements.txt          # Python deps
└── README.md                 # This file
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Backend Development** - Flask API, Database, AI Model
- **Mobile Development** - Flutter App, UI/UX
- **AI/ML Engineering** - Model Training, Optimization

---

## 🙏 Acknowledgments

- TensorFlow/Keras for deep learning framework
- Flutter team for amazing mobile framework
- Vietnamese fruit farmers for inspiration
- Open source community

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/AI_Fruit/issues)
- **Email**: support@fruitai.com
- **Documentation**: [Wiki](https://github.com/yourusername/AI_Fruit/wiki)

---

## 🎯 Roadmap

### ✅ Phase 1 (Completed)
- [x] Backend API with Flask
- [x] MySQL Database
- [x] CNN Model Training
- [x] Flutter Mobile App
- [x] Admin Dashboard
- [x] Vietnamese UI

### 🔄 Phase 2 (In Progress)
- [ ] Improve model accuracy to 95%+
- [ ] Add more fruit types (20+)
- [ ] Offline mode support
- [ ] Push notifications
- [ ] User authentication

### 🚀 Phase 3 (Planned)
- [ ] Multi-language support (EN, CN)
- [ ] AR features
- [ ] Nutrition information
- [ ] Recipe suggestions
- [ ] E-commerce integration
- [ ] iOS version

---

<div align="center">

**Made with ❤️ in Vietnam 🇻🇳**

⭐ Star us on GitHub — it motivates us a lot!

[⬆ Back to Top](#-hệ-thống-nhận-diện-trái-cây-việt-nam)

</div>



