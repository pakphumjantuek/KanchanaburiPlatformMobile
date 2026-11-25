import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_section_card.dart';

class MerchantExportTypeSelector extends StatelessWidget {
  const MerchantExportTypeSelector({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MerchantExportSectionCard(
          stepNumber: '1',
          title: 'เลือกประเภทรายงาน',
          subtitle: 'เลือกข้อมูลที่ต้องการนำออกเป็นรายงาน',
          icon: Icons.analytics_outlined,
          children: [
            Obx(() {
              return Column(
                children: controller.exportTypes.map((type) {
                  final val = type['value'] as String;
                  final isSelected = controller.selectedExportType.value == val;
                  final icon = type['icon'] as IconData;
                  final color = type['color'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.selectedExportType.value = val,
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.05)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : MerchantColors.border,
                              width: isSelected ? 1.8 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type['title'] as String,
                                      style: GoogleFonts.krub(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? color
                                            : MerchantColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      type['subtitle'] as String,
                                      style: GoogleFonts.krub(
                                        fontSize: 11.5,
                                        color: MerchantColors.textSecondary,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? color : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : const Color(0xFF94A3B8),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
