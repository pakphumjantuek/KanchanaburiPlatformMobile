import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardAlertsBanner extends StatelessWidget {
  const AdminDashboardAlertsBanner({super.key, required this.alerts});

  final AdminDashboardAlerts alerts;

  @override
  Widget build(BuildContext context) {
    final totalUrgent = alerts.pendingSlips + alerts.pendingPayoutOrders;

    if (totalUrgent == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AdminColors.infoBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AdminColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ทุกรายการได้รับการตรวจสอบเรียบร้อยแล้ว ไม่มีงานค้าง',
                style: GoogleFonts.krub(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE76F51).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE76F51).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE76F51).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Color(0xFFE76F51),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'รายการที่ต้องการการดำเนินการเร่งด่วน',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE76F51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalUrgent รายการ',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Actionable cards
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (alerts.pendingSlips > 0)
                _buildActionTile(
                  title: 'สลิปรอการตรวจสอบ',
                  count: alerts.pendingSlips,
                  icon: Icons.receipt_long_rounded,
                  color: const Color(0xFFE76F51),
                  bgTint: const Color(0xFFFDF2EE),
                  onTap: () => Get.toNamed(AppRoutes.adminOrders),
                ),
              if (alerts.pendingPayoutOrders > 0)
                _buildActionTile(
                  title: 'ร้านค้ารอโอนยอดเงิน',
                  count: alerts.pendingPayoutOrders,
                  icon: Icons.account_balance_wallet_rounded,
                  color: AdminColors.primary,
                  bgTint: AdminColors.infoBg,
                  onTap: () => Get.toNamed(AppRoutes.adminPayouts),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Color bgTint,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgTint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: color.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
