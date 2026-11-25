import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';

class ManageTagsMetricBanner extends StatelessWidget {
  const ManageTagsMetricBanner({super.key, required this.controller});

  final AdminTagsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(
        gradient: AdminColors.headerGradient,
      ),
      child: Obx(() {
        final total = controller.totalCount;
        final active = controller.activeCount;
        final inactive = controller.inactiveCount;
        final selected = controller.selectedStatusFilter.value;

        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'แท็กทั้งหมด',
                value: '$total',
                subText: 'แท็กในระบบ',
                icon: Icons.sell_rounded,
                iconColor: const Color(0xFF38BDF8),
                isSelected: selected.isEmpty,
                onTap: () => controller.setStatusFilter(''),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'เปิดใช้งาน',
                value: '$active',
                subText: 'พร้อมใช้งาน',
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF34D399),
                isSelected: selected == 'Active',
                onTap: () => controller.setStatusFilter('Active'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'ปิดใช้งาน',
                value: '$inactive',
                subText: 'ซ่อนชั่วคราว',
                icon: Icons.pause_circle_rounded,
                iconColor: const Color(0xFFFBBF24),
                isSelected: selected == 'Inactive',
                onTap: () => controller.setStatusFilter('Inactive'),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.14),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, size: 14, color: iconColor),
                ],
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subText,
                style: GoogleFonts.krub(
                  fontSize: 9.5,
                  color: isSelected
                      ? const Color(0xFFBAE6FD)
                      : Colors.white.withValues(alpha: 0.65),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
