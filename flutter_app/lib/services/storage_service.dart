import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Access Token
  static Future<void> saveAccessToken(String token) async {
    print('💾 [Storage] Saving access token: ${token.substring(0, 20)}...');
    await _prefs?.setString(StorageKeys.accessToken, token);
    print('✅ [Storage] Access token saved successfully');
  }

  static String? getAccessToken() {
    final token = _prefs?.getString(StorageKeys.accessToken);
    if (token != null) {
      print('🔑 [Storage] Retrieved access token: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ [Storage] No access token found');
    }
    return token;
  }

  static Future<void> removeAccessToken() async {
    await _prefs?.remove(StorageKeys.accessToken);
  }

  // Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    print('💾 [Storage] Saving refresh token: ${token.substring(0, 20)}...');
    await _prefs?.setString(StorageKeys.refreshToken, token);
    print('✅ [Storage] Refresh token saved successfully');
  }

  static String? getRefreshToken() {
    final token = _prefs?.getString(StorageKeys.refreshToken);
    if (token != null) {
      print('🔄 [Storage] Retrieved refresh token: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ [Storage] No refresh token found');
    }
    return token;
  }

  static Future<void> removeRefreshToken() async {
    await _prefs?.remove(StorageKeys.refreshToken);
  }

  // User ID
  static Future<void> saveUserId(int userId) async {
    await _prefs?.setInt(StorageKeys.userId, userId);
  }

  static int? getUserId() {
    return _prefs?.getInt(StorageKeys.userId);
  }

  static Future<void> removeUserId() async {
    await _prefs?.remove(StorageKeys.userId);
  }

  // Username
  static Future<void> saveUsername(String username) async {
    await _prefs?.setString(StorageKeys.username, username);
  }

  static String? getUsername() {
    return _prefs?.getString(StorageKeys.username);
  }

  static Future<void> removeUsername() async {
    await _prefs?.remove(StorageKeys.username);
  }

  // User Role
  static Future<void> saveUserRole(String role) async {
    await _prefs?.setString(StorageKeys.userRole, role);
  }

  static String? getUserRole() {
    return _prefs?.getString(StorageKeys.userRole);
  }

  static Future<void> removeUserRole() async {
    await _prefs?.remove(StorageKeys.userRole);
  }

  // Check if logged in
  static bool isLoggedIn() {
    return getAccessToken() != null;
  }

  // Clear all data
  static Future<void> clearAll() async {
    await removeAccessToken();
    await removeRefreshToken();
    await removeUserId();
    await removeUsername();
    await removeUserRole();
  }
}