import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/profile_controller.dart';

class EditProfileActions extends StatelessWidget {
  const EditProfileActions({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoading.value;
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: loading ? null : controller.saveProfile,
              icon: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                loading ? 'กำลังบันทึก...' : 'บันทึกการเปลี่ยนแปลง',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF786B62),
              ),
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
