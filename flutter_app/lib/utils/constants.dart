import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Cấu hình API
class ApiConstants {
  // Đọc API URL từ file .env
  // Mỗi developer có thể cấu hình riêng mà không ảnh hưởng đến người khác
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000/api';
  }
  
  // Endpoints
  static const String predict = '/predict';
  static const String feedbackUser = '/feedback_user';
  static const String loginAdmin = '/auth/login_admin';
  static const String logoutAdmin = '/auth/logout_admin';
  static const String registerAdmin = '/auth/register_admin';
  static const String dashboard = '/admin/dashboard';
  static const String history = '/admin/history';
  static const String feedback = '/admin/feedback';
  static const String trainingLogs = '/admin/training_logs';
}

// Màu sắc chủ đề
class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Xanh lá
  static const Color secondary = Color(0xFFFFB74D); // Cam
  static const Color background = Color(0xFFFAFAFA);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF212121);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  
  // Màu gradient
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFFFCC80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Kiểu chữ
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );
  
  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}

// Ánh xạ tên trái cây
class FruitNames {
  static const Map<String, String> vietnamese = {
    'buoi_da_xanh': 'Bưởi Da Xanh Bến Tre',
    'cam_sanh_ha_giang': 'Cam Sành Hà Giang',
    'chom_chom_long_khanh': 'Chôm Chôm Long Khánh',
    'mang_cut_lai_thieu': 'Măng Cụt Lái Thiêu',
    'nhan_long_hung_yen': 'Nhãn Lồng Hưng Yên',
    'sau_rieng_ri6': 'Sầu Riêng Ri6',
    'thanh_long_binh_thuan': 'Thanh Long Bình Thuận',
    'vai_thieu_luc_ngan': 'Vải Thiều Lục Ngạn',
    'vu_sua_lo_ren': 'Vú Sữa Lò Rèn',
    'xoai_cat_hoa_loc': 'Xoài Cát Hòa Lộc',
  };
  
  static String getVietnameseName(String key) {
    return vietnamese[key] ?? key;
  }
}

// Khóa lưu trữ cục bộ
class StorageKeys {
  static const String userId = 'user_id';
  static const String username = 'username';
  static const String userRole = 'user_role';
}
