import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_export_controller.dart';
import 'widgets/admin_export_hero_header.dart';
import 'widgets/admin_export_type_selector.dart';
import 'widgets/admin_export_date_range_selector.dart';
import 'widgets/admin_export_format_selector.dart';
import 'widgets/admin_export_filters.dart';
import 'widgets/admin_export_summary_preview.dart';
import 'widgets/admin_export_submit_button.dart';

class AdminExportPage extends GetView<AdminExportController> {
  const AdminExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminExportController>()) {
      Get.put(AdminExportController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รายงานและส่งออกข้อมูล',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Admin Export Center',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFBAE6FD),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top Executive Hero Header
              const AdminExportHeroHeader(),

              // Body Content Form
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminExportTypeSelector(controller: controller),

                    AdminExportDateRangeSelector(controller: controller),

                    AdminExportFormatSelector(controller: controller),

                    AdminExportFilters(controller: controller),

                    AdminExportSummaryPreview(controller: controller),

                    AdminExportSubmitButton(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
