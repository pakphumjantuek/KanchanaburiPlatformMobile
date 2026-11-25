import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/auth_service.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/edit_profile_actions.dart';
import 'widgets/edit_profile_fields_card.dart';
import 'widgets/edit_profile_header_card.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          children: [
            EditProfileHeaderCard(authService: authService),
            const SizedBox(height: 16),
            EditProfileFieldsCard(controller: controller),
            const SizedBox(height: 24),
            EditProfileActions(controller: controller),
          ],
        ),
      ),
    );
  }
}
