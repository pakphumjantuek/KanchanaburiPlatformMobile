import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/my_contents_controller.dart';
import 'widgets/my_contents_content.dart';

class MyContentsPage extends StatelessWidget {
  const MyContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyContentsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'กิจกรรมและคอนเทนต์ของคุณ',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: controller.fetchMyContents,
          ),
        ],
      ),
      body: MyContentsContent(controller: controller),
    );
  }
}
