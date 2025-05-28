import 'package:flutter/material.dart';
import '../../model/user/user_model.dart';
import '../storage/local_storage.dart'; // Make sure this path is correct

class SessionController {
  final LocalStorage _storage = LocalStorage();

  static final SessionController _instance = SessionController._internal();

  static bool isLogin = false;
  static UserModel user = UserModel();

  SessionController._internal();

  factory SessionController() => _instance;

  /// Save user token and ID to local storage
  Future<void> saveUserInPreference(Map<String, dynamic> userData) async {
    try {
      final token = userData['token']?.toString();
      final userId = userData['userID']?.toString();

      if (token != null && userId != null) {
        await _storage.setValue('token', token);
        await _storage.setValue('user_id', userId);
        await _storage.setValue('isLogin', 'true');

        user = user.copyWith(token: token, userID: userId);
        isLogin = true;
      } else {
        debugPrint("Invalid user data: missing token or userID.");
      }
    } catch (e) {
      debugPrint('Error saving user in preferences: $e');
    }
  }

  /// Load user token and ID from local storage
  Future<void> getUserFromPreference() async {
    try {
      final token = await _storage.readValue('token') ?? '';
      final userId = await _storage.readValue('user_id') ?? '';
      final isLoginStatus = await _storage.readValue('isLogin') ?? 'false';

      user = user.copyWith(token: token, userID: userId);
      isLogin = isLoginStatus == 'true';
    } catch (e) {
      debugPrint('Error retrieving session data: $e');
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _storage.readValue('token');
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.readValue('user_id');
  }

  /// Clear session data from storage
  Future<void> clearSession() async {
    await _storage.clearValue('token');
    await _storage.clearValue('user_id');
    await _storage.setValue('isLogin', 'false');

    user = UserModel();
    isLogin = false;
  }
}
