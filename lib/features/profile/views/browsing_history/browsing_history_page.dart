import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/browsing_history_controller.dart';
import 'widgets/browsing_history_content.dart';

class BrowsingHistoryPage extends GetView<BrowsingHistoryController> {
  const BrowsingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BrowsingHistoryController>()) {
      Get.put(BrowsingHistoryController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'ประวัติการเข้าชม',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรช',
            onPressed: () => controller.fetchHistory(),
          ),
        ],
      ),
      body: BrowsingHistoryContent(controller: controller),
    );
  }
}
