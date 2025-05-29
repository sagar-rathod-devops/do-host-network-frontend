import 'package:flutter/material.dart';
import '../../model/user/user_model.dart';
import '../storage/local_storage.dart'; // Ensure this path is correct

class SessionController {
  final LocalStorage _storage = LocalStorage();

  static final SessionController _instance = SessionController._internal();

  static bool isLogin = false;
  static UserModel user = UserModel();

  SessionController._internal();

  factory SessionController() => _instance;

  /// Save user data (token, userID, fullName) to local storage
  Future<void> saveUserInPreference(Map<String, dynamic> userData) async {
    try {
      final token = userData['token']?.toString();
      final userId = userData['userID']?.toString();
      final fullName = userData['fullName']?.toString();

      if (token != null && userId != null) {
        await _storage.setValue('token', token);
        await _storage.setValue('user_id', userId);
        await _storage.setValue('full_name', fullName ?? '');
        await _storage.setValue('isLogin', 'true');

        user = user.copyWith(token: token, userID: userId, fullName: fullName);
        isLogin = true;
      } else {
        debugPrint("Invalid user data: missing token or userID.");
      }
    } catch (e) {
      debugPrint('Error saving user in preferences: $e');
    }
  }

  /// Retrieve user data from local storage
  Future<void> getUserFromPreference() async {
    try {
      final token = await _storage.readValue('token') ?? '';
      final userId = await _storage.readValue('user_id') ?? '';
      final fullName = await _storage.readValue('full_name') ?? '';
      final isLoginStatus = await _storage.readValue('isLogin') ?? 'false';

      user = user.copyWith(token: token, userID: userId, fullName: fullName);
      isLogin = isLoginStatus == 'true';
    } catch (e) {
      debugPrint('Error retrieving session data: $e');
    }
  }

  /// Save full name separately (optional method)
  Future<void> saveFullName(String fullName) async {
    await _storage.setValue('full_name', fullName);
    user = user.copyWith(fullName: fullName);
  }

  /// Get stored full name
  Future<String?> getFullName() async {
    return await _storage.readValue('full_name');
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _storage.readValue('token');
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.readValue('user_id');
  }

  /// Clear only the stored full name
  Future<void> clearFullName() async {
    await _storage.clearValue('full_name');
    user = user.copyWith(fullName: '');
  }

  /// Clear session data
  Future<void> clearSession() async {
    await _storage.clearValue('token');
    await _storage.clearValue('user_id');
    await _storage.clearValue('full_name');
    await _storage.setValue('isLogin', 'false');

    user = UserModel();
    isLogin = false;
  }
}
