import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/auth_service.dart';
import 'widgets/profile_content.dart';
import 'widgets/profile_dialogs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'บัญชีของฉัน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'การตั้งค่า',
            onPressed: () => ProfileDialogs.showSettings(context, authService),
          ),
        ],
      ),
      body: ProfileContent(
        authService: authService,
        onAuthRequired: (feature) =>
            ProfileDialogs.showAuthRequired(context, feature),
        onInfo: (title, content) =>
            ProfileDialogs.showInfo(context, title, content),
        onLogout: () => ProfileDialogs.showLogout(authService),
      ),
    );
  }
}
