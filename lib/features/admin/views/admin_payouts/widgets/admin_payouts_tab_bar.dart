import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';

class AdminPayoutsTabBar extends StatelessWidget {
  const AdminPayoutsTabBar({super.key, required this.controller});

  final AdminPayoutsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Obx(
          () {
            final activeTab = controller.activeTab.value;
            final pendingCount = controller.pendingPayouts.length;
            final historyCount = controller.payoutHistory.length;

            return Row(
              children: [
                _buildTab(
                  label: 'รายการรอโอนเงิน',
                  count: pendingCount,
                  index: 0,
                  isSelected: activeTab == 0,
                  hasAlert: pendingCount > 0,
                ),
                _buildTab(
                  label: 'ประวัติการโอน',
                  count: historyCount,
                  index: 1,
                  isSelected: activeTab == 1,
                  hasAlert: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required int count,
    required int index,
    required bool isSelected,
    required bool hasAlert,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.switchTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AdminColors.primaryDark.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AdminColors.primary : AdminColors.textSecondary,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (hasAlert ? const Color(0xFFE76F51) : AdminColors.primary)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AdminColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
