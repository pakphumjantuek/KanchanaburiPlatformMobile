import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/services/auth_service.dart';

class ProfileDialogs {
  static Future<void> showAuthRequired(
    BuildContext context,
    String featureName,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Color(0xFFD96C2C)),
            const SizedBox(width: 8),
            Text(
              'ต้องเข้าสู่ระบบ',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'กรุณาเข้าสู่ระบบเพื่อใช้งานส่วน "$featureName"',
          style: GoogleFonts.krub(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'เข้าสู่ระบบ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo(
    BuildContext context,
    String title,
    String content,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          title,
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          content,
          style: GoogleFonts.krub(fontSize: 14, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ตกลง',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showSettings(
    BuildContext context,
    AuthService authService,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'การตั้งค่าทั่วไป',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: Color(0xFFD96C2C),
              ),
              title: Text('ภาษา / Language', style: GoogleFonts.krub()),
              subtitle: Text(
                'ภาษาไทย (TH)',
                style: GoogleFonts.krub(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context),
            ),
            if (authService.currentUser.value?.isAdmin == true)
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Color(0xFFC8952F),
                ),
                title: Text(
                  'จัดการแอดมิน (Admin Dashboard)',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'เข้าสู่แดชบอร์ดผู้ดูแลระบบ (13 ระบบ)',
                  style: GoogleFonts.krub(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.admin);
                },
              ),
            ListTile(
              leading: const Icon(
                Icons.dark_mode_outlined,
                color: Color(0xFFD96C2C),
              ),
              title: Text('โหมดการแสดงผล', style: GoogleFonts.krub()),
              subtitle: Text(
                'โหมดสว่าง (Light Theme)',
                style: GoogleFonts.krub(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showLogout(AuthService authService) async {
    await Get.dialog<void>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'ยืนยันการออกจากระบบ',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'คุณต้องการออกจากระบบใช่หรือไม่?',
          style: GoogleFonts.krub(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              authService.logout();
              Get.back();
              Get.snackbar(
                'ออกจากระบบแล้ว',
                'คุณได้ออกจากระบบเรียบร้อยแล้ว',
                backgroundColor: const Color(0xFF2B1F17),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ออกจากระบบ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
