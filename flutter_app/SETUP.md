# Hướng Dẫn Cài Đặt Chi Tiết

## 📋 Yêu Cầu Hệ Thống

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio hoặc VS Code với Flutter extension
- Git
- Python 3.9+ (cho backend)

## 🔧 Cài Đặt Backend API

### 1. Chuẩn bị môi trường Python

```bash
# Tạo virtual environment
python -m venv venv

# Kích hoạt virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt
```

### 2. Khởi tạo database

```bash
# Chạy script khởi tạo
python init_db.py
```

### 3. Chạy backend server

```bash
# Chạy Flask server
python app.py
```

Server sẽ chạy tại: http://localhost:5000

## 📱 Cài Đặt Flutter App

### 1. Cài đặt dependencies

```bash
cd flutter_app
flutter pub get
```

### 2. Tải font Nunito (Tùy chọn)

**Cách 1: Tải font từ Google Fonts**

1. Truy cập: https://fonts.google.com/specimen/Nunito
2. Tải font về
3. Copy `Nunito-Regular.ttf` và `Nunito-Bold.ttf` vào thư mục `assets/fonts/`

**Cách 2: Sử dụng font mặc định**

Nếu không muốn tải font, xóa phần fonts trong `pubspec.yaml`:

```yaml
# Xóa hoặc comment phần này
# fonts:
#   - family: Nunito
#     fonts:
#       - asset: assets/fonts/Nunito-Regular.ttf
#       - asset: assets/fonts/Nunito-Bold.ttf
#         weight: 700
```

Và trong `lib/utils/constants.dart` đổi:
```dart
static const String fontFamily = 'Roboto'; // Hoặc '' để dùng font mặc định
```

### 3. Cấu hình API URL

Mở file `lib/utils/constants.dart` và cấu hình URL:

**Nếu chạy trên emulator Android:**
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
```

**Nếu chạy trên thiết bị thật:**
```dart
static const String baseUrl = 'http://YOUR_IP:5000/api';
// Ví dụ: 'http://192.168.1.100:5000/api'
```

Để tìm IP của bạn:
- Windows: `ipconfig`
- Mac/Linux: `ifconfig` hoặc `ip addr`

### 4. Chạy ứng dụng

```bash
# Kiểm tra devices có sẵn
flutter devices

# Chạy app
flutter run

# Hoặc chọn device cụ thể
flutter run -d <device_id>
```

## 🏗️ Build APK

### Debug APK (để test)

```bash
flutter build apk --debug
```

### Release APK (cho production)

```bash
flutter build apk --release
```

APK sẽ được tạo tại: `build/app/outputs/flutter-apk/app-release.apk`

## 🔍 Kiểm Tra Kết Nối

### 1. Test Backend API

```bash
# Test endpoint health check
curl http://localhost:5000/

# Hoặc mở browser và truy cập
http://localhost:5000/
```

### 2. Test từ thiết bị Android

Đảm bảo:
- Backend đang chạy
- Thiết bị và máy tính cùng mạng WiFi
- Firewall không chặn port 5000
- URL trong app đã đúng

## 🐛 Xử Lý Lỗi

### Lỗi "Unable to connect"

1. Kiểm tra backend có đang chạy không
2. Kiểm tra URL trong `constants.dart`
3. Kiểm tra firewall
4. Thử ping IP từ thiết bị

### Lỗi "Image picker failed"

1. Kiểm tra permissions trong `AndroidManifest.xml`
2. Đảm bảo đã cấp quyền Camera và Storage
3. Restart app sau khi cấp quyền

### Lỗi Font

1. Kiểm tra file font có tồn tại không
2. Kiểm tra đường dẫn trong `pubspec.yaml`
3. Chạy `flutter clean` và `flutter pub get`

### Lỗi Build

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run again
flutter run
```

## 📊 Test với Dữ Liệu Mẫu

### 1. Tạo tài khoản admin

```python
# Chạy script Python
python create_admin.py
```

Hoặc thêm vào database thủ công:
- Username: admin
- Password: admin123

### 2. Upload ảnh test

Tải một số ảnh trái cây Việt Nam để test:
- Bưởi
- Cam
- Xoài
- v.v.

### 3. Kiểm tra kết quả

1. Mở app
2. Chọn hoặc chụp ảnh trái cây
3. Xem kết quả nhận diện
4. Đánh giá phản hồi

## 🔐 Bảo Mật

### Production Checklist

- [ ] Đổi mật khẩu admin mặc định
- [ ] Cấu hình CORS đúng cách
- [ ] Sử dụng HTTPS
- [ ] Thêm rate limiting
- [ ] Validate input
- [ ] Secure secret keys

## 📱 Permissions

### Android

File `android/app/src/main/AndroidManifest.xml` cần có:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS

File `ios/Runner/Info.plist` cần có:

```xml
<key>NSCameraUsageDescription</key>
<string>Cần quyền camera để chụp ảnh trái cây</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Cần quyền truy cập thư viện ảnh</string>
```

## 🎯 Lộ Trình Phát Triển Tiếp

- [ ] Thêm dark mode
- [ ] Offline mode với caching
- [ ] Multi-language support
- [ ] Push notifications
- [ ] User authentication
- [ ] Social sharing
- [ ] History search
- [ ] Export reports

## 💡 Tips

1. **Phát triển nhanh hơn**: Sử dụng hot reload (press `r` trong terminal)
2. **Debug UI**: Sử dụng Flutter DevTools
3. **Test trên nhiều devices**: Sử dụng emulators và thiết bị thật
4. **Optimize images**: Compress ảnh trước khi upload
5. **Monitor performance**: Sử dụng Flutter Performance tools

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra logs: `flutter logs`
2. Kiểm tra backend logs
3. Search GitHub issues
4. Tạo issue mới với đầy đủ thông tin

## 📚 Tài Liệu Tham Khảo

- [Flutter Documentation](https://flutter.dev/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [TensorFlow Documentation](https://www.tensorflow.org/)
- [Material Design Guidelines](https://material.io/design)

---

Chúc bạn coding vui vẻ! 🚀


## 📋 Yêu Cầu Hệ Thống

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio hoặc VS Code với Flutter extension
- Git
- Python 3.9+ (cho backend)

## 🔧 Cài Đặt Backend API

### 1. Chuẩn bị môi trường Python

```bash
# Tạo virtual environment
python -m venv venv

# Kích hoạt virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt
```

### 2. Khởi tạo database

```bash
# Chạy script khởi tạo
python init_db.py
```

### 3. Chạy backend server

```bash
# Chạy Flask server
python app.py
```

Server sẽ chạy tại: http://localhost:5000

## 📱 Cài Đặt Flutter App

### 1. Cài đặt dependencies

```bash
cd flutter_app
flutter pub get
```

### 2. Tải font Nunito (Tùy chọn)

**Cách 1: Tải font từ Google Fonts**

1. Truy cập: https://fonts.google.com/specimen/Nunito
2. Tải font về
3. Copy `Nunito-Regular.ttf` và `Nunito-Bold.ttf` vào thư mục `assets/fonts/`

**Cách 2: Sử dụng font mặc định**

Nếu không muốn tải font, xóa phần fonts trong `pubspec.yaml`:

```yaml
# Xóa hoặc comment phần này
# fonts:
#   - family: Nunito
#     fonts:
#       - asset: assets/fonts/Nunito-Regular.ttf
#       - asset: assets/fonts/Nunito-Bold.ttf
#         weight: 700
```

Và trong `lib/utils/constants.dart` đổi:
```dart
static const String fontFamily = 'Roboto'; // Hoặc '' để dùng font mặc định
```

### 3. Cấu hình API URL

Mở file `lib/utils/constants.dart` và cấu hình URL:

**Nếu chạy trên emulator Android:**
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
```

**Nếu chạy trên thiết bị thật:**
```dart
static const String baseUrl = 'http://YOUR_IP:5000/api';
// Ví dụ: 'http://192.168.1.100:5000/api'
```

Để tìm IP của bạn:
- Windows: `ipconfig`
- Mac/Linux: `ifconfig` hoặc `ip addr`

### 4. Chạy ứng dụng

```bash
# Kiểm tra devices có sẵn
flutter devices

# Chạy app
flutter run

# Hoặc chọn device cụ thể
flutter run -d <device_id>
```

## 🏗️ Build APK

### Debug APK (để test)

```bash
flutter build apk --debug
```

### Release APK (cho production)

```bash
flutter build apk --release
```

APK sẽ được tạo tại: `build/app/outputs/flutter-apk/app-release.apk`

## 🔍 Kiểm Tra Kết Nối

### 1. Test Backend API

```bash
# Test endpoint health check
curl http://localhost:5000/

# Hoặc mở browser và truy cập
http://localhost:5000/
```

### 2. Test từ thiết bị Android

Đảm bảo:
- Backend đang chạy
- Thiết bị và máy tính cùng mạng WiFi
- Firewall không chặn port 5000
- URL trong app đã đúng

## 🐛 Xử Lý Lỗi

### Lỗi "Unable to connect"

1. Kiểm tra backend có đang chạy không
2. Kiểm tra URL trong `constants.dart`
3. Kiểm tra firewall
4. Thử ping IP từ thiết bị

### Lỗi "Image picker failed"

1. Kiểm tra permissions trong `AndroidManifest.xml`
2. Đảm bảo đã cấp quyền Camera và Storage
3. Restart app sau khi cấp quyền

### Lỗi Font

1. Kiểm tra file font có tồn tại không
2. Kiểm tra đường dẫn trong `pubspec.yaml`
3. Chạy `flutter clean` và `flutter pub get`

### Lỗi Build

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run again
flutter run
```

## 📊 Test với Dữ Liệu Mẫu

### 1. Tạo tài khoản admin

```python
# Chạy script Python
python create_admin.py
```

Hoặc thêm vào database thủ công:
- Username: admin
- Password: admin123

### 2. Upload ảnh test

Tải một số ảnh trái cây Việt Nam để test:
- Bưởi
- Cam
- Xoài
- v.v.

### 3. Kiểm tra kết quả

1. Mở app
2. Chọn hoặc chụp ảnh trái cây
3. Xem kết quả nhận diện
4. Đánh giá phản hồi

## 🔐 Bảo Mật

### Production Checklist

- [ ] Đổi mật khẩu admin mặc định
- [ ] Cấu hình CORS đúng cách
- [ ] Sử dụng HTTPS
- [ ] Thêm rate limiting
- [ ] Validate input
- [ ] Secure secret keys

## 📱 Permissions

### Android

File `android/app/src/main/AndroidManifest.xml` cần có:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS

File `ios/Runner/Info.plist` cần có:

```xml
<key>NSCameraUsageDescription</key>
<string>Cần quyền camera để chụp ảnh trái cây</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Cần quyền truy cập thư viện ảnh</string>
```

## 🎯 Lộ Trình Phát Triển Tiếp

- [ ] Thêm dark mode
- [ ] Offline mode với caching
- [ ] Multi-language support
- [ ] Push notifications
- [ ] User authentication
- [ ] Social sharing
- [ ] History search
- [ ] Export reports

## 💡 Tips

1. **Phát triển nhanh hơn**: Sử dụng hot reload (press `r` trong terminal)
2. **Debug UI**: Sử dụng Flutter DevTools
3. **Test trên nhiều devices**: Sử dụng emulators và thiết bị thật
4. **Optimize images**: Compress ảnh trước khi upload
5. **Monitor performance**: Sử dụng Flutter Performance tools

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra logs: `flutter logs`
2. Kiểm tra backend logs
3. Search GitHub issues
4. Tạo issue mới với đầy đủ thông tin

## 📚 Tài Liệu Tham Khảo

- [Flutter Documentation](https://flutter.dev/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [TensorFlow Documentation](https://www.tensorflow.org/)
- [Material Design Guidelines](https://material.io/design)

---

Chúc bạn coding vui vẻ! 🚀



