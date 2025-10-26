import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';
import '../models/admin_models.dart';
import '../utils/constants.dart';

// Exception cho lỗi xác thực
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  
  @override
  String toString() => message;
}

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  // Dự đoán trái cây
  Future<PredictionResult> predict(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.predict}');
      var request = http.MultipartRequest('POST', uri);
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return PredictionResult.fromJson(data);
      } else {
        throw Exception('Dự đoán thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi dự đoán: $e');
    }
  }

  // Gửi phản hồi
  Future<void> submitFeedback(FeedbackRequest feedback) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.feedbackUser}');
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode(feedback.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Gửi phản hồi thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi gửi phản hồi: $e');
    }
  }

  // Đăng nhập quản trị viên
  Future<LoginResponse> loginAdmin(String username, String password) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.loginAdmin}');
      print('🔍 [API] Calling login: $uri');
      
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('📊 [API] Login response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final loginResponse = LoginResponse.fromJson(data);
        
        print('✅ [API] Login successful');
        return loginResponse;
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        print('❌ [API] Login failed: ${error['error']}');
        throw Exception(error['error'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      print('💥 [API] Login exception: $e');
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  // Đăng xuất quản trị viên
  Future<void> logoutAdmin() async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.logoutAdmin}');
      await http.post(
        uri,
        headers: _getHeaders(),
      );
    } catch (e) {
      throw Exception('Lỗi đăng xuất: $e');
    }
  }

  // Lấy dữ liệu dashboard
  Future<DashboardData> getDashboard() async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.dashboard}');
      print('🔍 [API] Calling dashboard: $uri');
      
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      print('📊 [API] Dashboard response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ [API] Dashboard loaded successfully');
        return DashboardData.fromJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        final error = json.decode(utf8.decode(response.bodyBytes));
        print('❌ [API] Unauthorized: ${error['error']}');
        throw UnauthorizedException(error['error'] ?? 'Chưa đăng nhập');
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        print('❌ [API] Error ${response.statusCode}: ${error['error']}');
        throw Exception(error['error'] ?? 'Lấy dữ liệu dashboard thất bại');
      }
    } catch (e) {
      print('💥 [API] Exception: $e');
      if (e is UnauthorizedException) rethrow;
      throw Exception('Lỗi lấy dữ liệu dashboard: $e');
    }
  }

  // Lấy lịch sử dự đoán
  Future<List<PredictionHistory>> getHistory({
    int page = 1,
    int perPage = 20,
    String? label,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (label != null) 'label': label,
      };
      
      final uri = Uri.parse('$baseUrl${ApiConstants.history}')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return (data['predictions'] as List)
            .map((e) => PredictionHistory.fromJson(e))
            .toList();
      } else {
        throw Exception('Lấy lịch sử thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy lịch sử: $e');
    }
  }

  // Lấy danh sách phản hồi
  Future<List<FeedbackData>> getFeedback({
    int page = 1,
    int perPage = 20,
    bool? isCorrect,
    bool? isRead,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (isCorrect != null) 'is_correct': isCorrect.toString(),
        if (isRead != null) 'is_read': isRead.toString(),
      };
      
      final uri = Uri.parse('$baseUrl${ApiConstants.feedback}')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return (data['feedbacks'] as List)
            .map((e) => FeedbackData.fromJson(e))
            .toList();
      } else {
        throw Exception('Lấy danh sách phản hồi thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách phản hồi: $e');
    }
  }

  // Đánh dấu feedback đã xem/chưa xem
  Future<void> markFeedbackRead(int feedbackId, bool isRead) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.feedback}/$feedbackId/mark_read');
      final response = await http.put(
        uri,
        headers: _getHeaders(),
        body: json.encode({'is_read': isRead}),
      );

      if (response.statusCode != 200) {
        throw Exception('Cập nhật trạng thái thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi cập nhật trạng thái: $e');
    }
  }

  // Đánh dấu tất cả feedback là đã xem
  Future<void> markAllFeedbackRead() async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.feedback}/mark_all_read');
      final response = await http.put(
        uri,
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Cập nhật trạng thái thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi cập nhật trạng thái: $e');
    }
  }

  // Lấy nhật ký huấn luyện
  Future<List<TrainingLog>> getTrainingLogs() async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.trainingLogs}');
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return (data['training_logs'] as List)
            .map((e) => TrainingLog.fromJson(e))
            .toList();
      } else {
        throw Exception('Lấy nhật ký huấn luyện thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy nhật ký huấn luyện: $e');
    }
  }

  // Thêm hình ảnh feedback vào training dataset
  Future<Map<String, dynamic>> addFeedbackToTraining(
    int feedbackId,
    String correctLabel,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.feedback}/$feedbackId/add_to_training');
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode({'correct_label': correctLabel}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(error['error'] ?? 'Thêm vào training thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi thêm vào training: $e');
    }
  }
}