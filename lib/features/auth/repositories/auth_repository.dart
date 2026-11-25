import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Login with email and password
  /// API: POST /login
  /// Request body: { "email": email, "password": password }
  /// Response: AccessTokenResponse { accessToken, refreshToken, expiresIn }
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/login', {
        'email': email.trim(),
        'password': password,
      });

      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return response.body as Map<String, dynamic>;
        }
      } else {
        debugPrint(
          'Login failed: ${response.statusCode} - ${response.statusText}',
        );
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }
    return null;
  }

  /// Register with email and password
  /// API: POST /register
  /// Request body: { "email": email, "password": password }
  Future<bool> register(String email, String password) async {
    try {
      final response = await _apiClient.post('/register', {
        'email': email.trim(),
        'password': password,
      });

      if (response.isOk) {
        return true;
      } else {
        debugPrint(
          'Register failed: ${response.statusCode} - ${response.statusText}',
        );
      }
    } catch (e) {
      debugPrint('Error during register: $e');
    }
    return false;
  }

  /// Fetch current user DTO
  /// API: GET /account/me
  Future<UserModel?> fetchCurrentUser() async {
    try {
      final response = await _apiClient.get('/account/me');
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return UserModel.fromJson(response.body as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('Error fetching current user: $e');
    }
    return null;
  }

  /// Fetch profile DTO
  /// API: GET /account/profile
  Future<UserModel?> fetchProfile() async {
    try {
      final response = await _apiClient.get('/account/profile');
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return UserModel.fromJson(response.body as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
    return null;
  }

  /// Update profile DTO
  /// API: PUT /account/profile
  /// Request body: { "firstName": firstName, "lastName": lastName }
  Future<UserModel?> updateProfile(String firstName, String lastName) async {
    try {
      final response = await _apiClient.put('/account/profile', {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
      });

      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return UserModel.fromJson(response.body as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
    return null;
  }
}
