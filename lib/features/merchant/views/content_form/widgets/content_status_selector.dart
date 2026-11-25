import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/content_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ContentStatusSelector extends GetView<ContentFormController> {
  const ContentStatusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'สถานะการแสดงผลบทความ',
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: MerchantColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MerchantColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          final currentStatus = controller.selectedStatus.value;
          final isPublished = currentStatus == 'Published';

          return Row(
            children: [
              // Option 1: Published
              Expanded(
                child: _buildStatusCard(
                  title: 'เผยแพร่ทันที',
                  subtitle: 'แสดงบนระบบสาธารณะ',
                  icon: Icons.public_rounded,
                  isSelected: isPublished,
                  activeColor: MerchantColors.primary,
                  activeBgColor: MerchantColors.successBg,
                  activeBorderColor: const Color(0xFFA7F3D0),
                  onTap: () => controller.selectedStatus.value = 'Published',
                ),
              ),
              const SizedBox(width: 12),
              // Option 2: Draft
              Expanded(
                child: _buildStatusCard(
                  title: 'บันทึกฉบับร่าง',
                  subtitle: 'เก็บไว้แก้ไขภายหลัง',
                  icon: Icons.edit_note_rounded,
                  isSelected: !isPublished,
                  activeColor: MerchantColors.warning,
                  activeBgColor: MerchantColors.warningBg,
                  activeBorderColor: const Color(0xFFFDE68A),
                  onTap: () => controller.selectedStatus.value = 'Draft',
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required Color activeBgColor,
    required Color activeBorderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeBorderColor : MerchantColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : MerchantColors.textMuted,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? activeColor
                          : MerchantColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.8)
                          : MerchantColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? activeColor : const Color(0xFFCBD5E1),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

