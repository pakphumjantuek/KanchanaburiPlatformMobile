import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_routes.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_reports_controller.dart';
import 'widgets/manage_reports_filter.dart';
import 'widgets/manage_reports_list.dart';

class ReportsPage extends GetView<AdminReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminReportsController>()) {
      Get.put(AdminReportsController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AdminColors.headerGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ศูนย์จัดการข้อร้องเรียน',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'ตรวจสอบการละเมิดและข้อพิพาท',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.loadReports(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
            tooltip: 'ส่งออกรายงาน (Exports)',
            onPressed: () => Get.toNamed(AppRoutes.adminExports),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // 1. Executive Metric Summary Banner
          _buildMetricBanner(),

          // 2. Filter Bar
          ManageReportsFilter(controller: controller),

          // 3. Reports List
          Expanded(child: ManageReportsList(controller: controller)),
        ],
      ),
    );
  }

  Widget _buildMetricBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final reports = controller.reports;
        final pendingCount = reports
            .where((r) => r.status.toLowerCase() == 'pending')
            .length;
        final inProgressCount = reports
            .where((r) => r.status.toLowerCase() == 'inprogress')
            .length;
        final resolvedCount = reports
            .where((r) => r.status.toLowerCase() == 'resolved')
            .length;

        return Row(
          children: [
            _buildMetricItem(
              label: 'รอดำเนินการ',
              value: '$pendingCount',
              icon: Icons.hourglass_top_rounded,
              color: AdminColors.error,
              isAlert: pendingCount > 0,
            ),
            Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
            _buildMetricItem(
              label: 'กำลังตรวจสอบ',
              value: '$inProgressCount',
              icon: Icons.sync_rounded,
              color: AdminColors.info,
            ),
            Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
            _buildMetricItem(
              label: 'แก้ไขแล้ว',
              value: '$resolvedCount',
              icon: Icons.check_circle_rounded,
              color: AdminColors.success,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    bool isAlert = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAlert ? AdminColors.error : AdminColors.textPrimary,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 10.5,
              color: isAlert ? AdminColors.error : AdminColors.textSecondary,
              fontWeight: isAlert ? FontWeight.bold : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
