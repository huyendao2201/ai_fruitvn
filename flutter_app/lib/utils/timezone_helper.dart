import 'package:intl/intl.dart';

/// Helper class để xử lý múi giờ Hồ Chí Minh (UTC+7)
class TimezoneHelper {
  // Múi giờ Hồ Chí Minh: UTC+7
  static const int hoChiMinhOffset = 7;
  
  /// Lấy thời gian hiện tại theo múi giờ Hồ Chí Minh
  static DateTime getCurrentTime() {
    return DateTime.now().toUtc().add(const Duration(hours: hoChiMinhOffset));
  }
  
  /// Chuyển đổi DateTime từ UTC sang múi giờ Hồ Chí Minh
  static DateTime utcToLocal(DateTime utcTime) {
    return utcTime.toUtc().add(const Duration(hours: hoChiMinhOffset));
  }
  
  /// Chuyển đổi DateTime từ múi giờ Hồ Chí Minh sang UTC
  static DateTime localToUtc(DateTime localTime) {
    return localTime.subtract(const Duration(hours: hoChiMinhOffset));
  }
  
  /// Format datetime thành chuỗi hiển thị (dd/MM/yyyy HH:mm:ss)
  static String formatDateTime(DateTime dateTime, {bool isUtc = true}) {
    final localTime = isUtc ? utcToLocal(dateTime) : dateTime;
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(localTime);
  }
  
  /// Format datetime thành chuỗi ngắn (dd/MM/yyyy)
  static String formatDate(DateTime dateTime, {bool isUtc = true}) {
    final localTime = isUtc ? utcToLocal(dateTime) : dateTime;
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(localTime);
  }
  
  /// Format datetime thành chuỗi giờ (HH:mm:ss)
  static String formatTime(DateTime dateTime, {bool isUtc = true}) {
    final localTime = isUtc ? utcToLocal(dateTime) : dateTime;
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(localTime);
  }
  
  /// Parse ISO string thành DateTime (múi giờ Hồ Chí Minh)
  static DateTime? parseIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    
    try {
      // Parse ISO string (thường là UTC)
      final utcTime = DateTime.parse(isoString);
      // Chuyển sang múi giờ Hồ Chí Minh
      return utcToLocal(utcTime);
    } catch (e) {
      return null;
    }
  }
  
  /// Format thời gian tương đối (vừa xong, 5 phút trước, 2 giờ trước, ...)
  static String formatRelativeTime(DateTime dateTime, {bool isUtc = true}) {
    final localTime = isUtc ? utcToLocal(dateTime) : dateTime;
    final now = getCurrentTime();
    final difference = now.difference(localTime);
    
    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years năm trước';
    }
  }
}

