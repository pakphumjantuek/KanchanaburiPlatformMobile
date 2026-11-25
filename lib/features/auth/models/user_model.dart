import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? firstName;
  final String? lastName;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.firstName,
    this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? fallbackEmail}) {
    final parsedRole = _extractRole(json, emailFallback: fallbackEmail);
    return UserModel(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? json['sub']?.toString() ?? '',
      email: json['email']?.toString() ?? json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']?.toString() ?? fallbackEmail ?? '',
      name: json['name']?.toString() ?? json['username']?.toString(),
      role: parsedRole,
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
    );
  }

  factory UserModel.fromJwtToken(String token, {String fallbackEmail = ''}) {
    final payload = parseJwtPayload(token) ?? {};
    final email = payload['email']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']?.toString() ??
        fallbackEmail;
    final id = payload['sub']?.toString() ??
        payload['id']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']?.toString() ??
        '1';
    final parsedRole = _extractRole(payload, emailFallback: email);

    return UserModel(
      id: id,
      email: email,
      name: payload['name']?.toString() ?? (email.isNotEmpty ? email.split('@').first : null),
      role: parsedRole,
    );
  }

  static String _extractRole(Map<String, dynamic> json, {String? emailFallback}) {
    // 1. Check direct role fields
    final roleVal = json['role'] ?? json['roles'] ?? json['userRole'] ?? json['roleName'] ?? json['Role'] ?? json['Roles'];
    if (roleVal != null) {
      if (roleVal is List && roleVal.isNotEmpty) {
        return roleVal.first.toString();
      }
      if (roleVal is String && roleVal.isNotEmpty) {
        return roleVal;
      }
    }

    // 2. Check claim URIs in JWT payload
    for (final entry in json.entries) {
      final keyLower = entry.key.toLowerCase();
      if (keyLower.endsWith('/role') || keyLower == 'role' || keyLower == 'roles') {
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          return val.first.toString();
        }
        if (val != null && val.toString().isNotEmpty) {
          return val.toString();
        }
      }
    }

    // 3. Fallback based on email
    final emailStr = (json['email'] ??
            json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
            emailFallback ??
            '')
        .toString()
        .toLowerCase();

    if (emailStr.contains('admin')) {
      return 'Admin';
    }

    return 'User';
  }

  static Map<String, dynamic>? parseJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(resp);
      if (payloadMap is Map<String, dynamic>) {
        return payloadMap;
      }
    } catch (e) {
      debugPrint('Error parsing JWT payload: $e');
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName';
      }
      return firstName!;
    }
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return email.contains('@') ? email.split('@').first : email;
  }

  bool get isAdmin {
    if (role != null && role!.isNotEmpty) {
      final r = role!.toLowerCase();
      if (r == 'admin' || r == 'administrator' || r.contains('admin')) {
        return true;
      }
    }
    return email.toLowerCase().contains('admin');
  }
}
