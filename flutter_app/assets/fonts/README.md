# Font Nunito

## Hướng dẫn tải font

1. Truy cập Google Fonts: https://fonts.google.com/specimen/Nunito

2. Tải font Nunito về máy

3. Sao chép 2 file sau vào thư mục này:
   - Nunito-Regular.ttf
   - Nunito-Bold.ttf

## Hoặc sử dụng font mặc định

Nếu không muốn tải font, bạn có thể xóa phần fonts trong `pubspec.yaml` và app sẽ sử dụng font mặc định của hệ thống.

Xóa đoạn này trong `pubspec.yaml`:
```yaml
fonts:
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Regular.ttf
      - asset: assets/fonts/Nunito-Bold.ttf
        weight: 700
```

Và thay đổi trong `lib/utils/constants.dart`:
```dart
static const String fontFamily = 'Nunito'; // Xóa dòng này hoặc đặt thành 'Roboto'
```


## Hướng dẫn tải font

1. Truy cập Google Fonts: https://fonts.google.com/specimen/Nunito

2. Tải font Nunito về máy

3. Sao chép 2 file sau vào thư mục này:
   - Nunito-Regular.ttf
   - Nunito-Bold.ttf

## Hoặc sử dụng font mặc định

Nếu không muốn tải font, bạn có thể xóa phần fonts trong `pubspec.yaml` và app sẽ sử dụng font mặc định của hệ thống.

Xóa đoạn này trong `pubspec.yaml`:
```yaml
fonts:
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Regular.ttf
      - asset: assets/fonts/Nunito-Bold.ttf
        weight: 700
```

Và thay đổi trong `lib/utils/constants.dart`:
```dart
static const String fontFamily = 'Nunito'; // Xóa dòng này hoặc đặt thành 'Roboto'
```



