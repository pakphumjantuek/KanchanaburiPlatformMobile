import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthRepository _authRepository = AuthRepository();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    populateUserData();
  }

  void populateUserData() {
    final user = _authService.currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailController.text = user.email;
    }
  }

  Future<void> saveProfile() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty) {
      Get.snackbar(
        'กรุณากรอกข้อมูล',
        'กรุณากรอกชื่อของคุณ',
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      final updatedUser = await _authRepository.updateProfile(
        firstName,
        lastName,
      );

      if (updatedUser != null) {
        _authService.currentUser.value = updatedUser;
        Get.back();
        Get.snackbar(
          'สำเร็จ',
          'อัปเดตข้อมูลส่วนตัวเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถอัปเดตข้อมูลส่วนตัวได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: const Color(0xFFE53935),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'เกิดข้อผิดพลาดในการอัปเดตข้อมูล: $e',
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
