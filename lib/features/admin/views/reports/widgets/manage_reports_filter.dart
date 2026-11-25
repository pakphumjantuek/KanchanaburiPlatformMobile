import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_reports_controller.dart';

class ManageReportsFilter extends StatelessWidget {
  const ManageReportsFilter({super.key, required this.controller});

  final AdminReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Obx(
              () => Row(
                children: [
                  _filterChip(
                    value: '',
                    label: 'ทั้งหมด',
                    icon: Icons.all_inclusive_rounded,
                    activeColor: AdminColors.primary,
                  ),
                  _filterChip(
                    value: 'Pending',
                    label: 'รอดำเนินการ',
                    icon: Icons.hourglass_top_rounded,
                    activeColor: AdminColors.error,
                  ),
                  _filterChip(
                    value: 'InProgress',
                    label: 'กำลังตรวจสอบ',
                    icon: Icons.sync_rounded,
                    activeColor: AdminColors.info,
                  ),
                  _filterChip(
                    value: 'Resolved',
                    label: 'แก้ไขแล้ว',
                    icon: Icons.check_circle_outline_rounded,
                    activeColor: AdminColors.success,
                  ),
                  _filterChip(
                    value: 'Dismissed',
                    label: 'ยกเลิกคำร้อง',
                    icon: Icons.cancel_outlined,
                    activeColor: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // Count Summary Row
          Obx(() {
            final count = controller.reports.length;
            final filter = controller.selectedStatusFilter.value;
            String statusText = 'ทั้งหมด';
            if (filter == 'Pending') statusText = 'รอดำเนินการ';
            if (filter == 'InProgress') statusText = 'กำลังตรวจสอบ';
            if (filter == 'Resolved') statusText = 'แก้ไขแล้ว';
            if (filter == 'Dismissed') statusText = 'ยกเลิกคำร้อง';

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AdminColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    size: 14,
                    color: AdminColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'สถานะ: $statusText • พบ $count รายการ',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String value,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final selected = controller.selectedStatusFilter.value == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.selectedStatusFilter.value = value;
            controller.loadReports();
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? activeColor : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? activeColor : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : AdminColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                    color: selected ? Colors.white : AdminColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
