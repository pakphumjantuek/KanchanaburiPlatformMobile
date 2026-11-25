import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_reports_controller.dart';
import 'admin_report_card.dart';

class ManageReportsList extends StatelessWidget {
  const ManageReportsList({super.key, required this.controller});

  final AdminReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AdminColors.primary),
        );
      }

      if (controller.reports.isEmpty) {
        final hasFilter = controller.selectedStatusFilter.value.isNotEmpty;

        return RefreshIndicator(
          color: AdminColors.primary,
          onRefresh: () => controller.loadReports(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: hasFilter
                        ? AdminColors.primary.withValues(alpha: 0.08)
                        : AdminColors.successBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasFilter
                        ? Icons.filter_alt_off_outlined
                        : Icons.verified_user_outlined,
                    size: 36,
                    color: hasFilter
                        ? AdminColors.primary
                        : AdminColors.success,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  hasFilter
                      ? 'ไม่พบรายงานในสถานะที่เลือก'
                      : 'ไม่มีรายงานการร้องเรียนในขณะนี้',
                  style: GoogleFonts.krub(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasFilter
                      ? 'ลองเลือกดูสถานะอื่น หรือแตะปุ่มด้านล่างเพื่อแสดงทั้งหมด'
                      : 'ระบบเรียบร้อยดี ไม่พบข้อร้องเรียนหรือการละเมิดที่ค้างอยู่',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: AdminColors.textSecondary,
                  ),
                ),
                if (hasFilter) ...[
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.all_inclusive_rounded, color: Colors.white, size: 16),
                    label: Text(
                      'ดูรายงานทั้งหมด',
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      controller.selectedStatusFilter.value = '';
                      controller.loadReports();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AdminColors.primary,
        onRefresh: () => controller.loadReports(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: controller.reports.length,
          itemBuilder: (context, index) => AdminReportCard(
            report: controller.reports[index],
            controller: controller,
          ),
        ),
      );
    });
  }
}
