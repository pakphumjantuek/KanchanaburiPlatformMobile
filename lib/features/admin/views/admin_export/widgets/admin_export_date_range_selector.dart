import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_section_card.dart';

class AdminExportDateRangeSelector extends StatelessWidget {
  const AdminExportDateRangeSelector({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdminExportSectionCard(
          stepNumber: '2',
          title: 'ช่วงวันที่ของรายงาน',
          subtitle: 'เลือกช่วงเวลาที่ต้องการสรุปข้อมูล',
          icon: Icons.calendar_month_rounded,
          children: [
            // Quick Preset Chips
            Obx(() {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.datePresets.map((preset) {
                  final val = preset['value']!;
                  final isSelected = controller.datePreset.value == val;

                  return ChoiceChip(
                    label: Text(
                      preset['label']!,
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AdminColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AdminColors.primary,
                    backgroundColor: const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: isSelected ? AdminColors.primary : const Color(0xFFE2E8F0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    onSelected: (_) => controller.applyDatePreset(val),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 14),

            // Active Date Range Display Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectDateRange(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AdminColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.date_range_rounded,
                          color: AdminColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          final rangeLabel = controller.thaiDateRangeLabel;
                          final days = controller.dateRangeDays;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rangeLabel,
                                style: GoogleFonts.krub(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'รวมระยะเวลา $days วัน',
                                style: GoogleFonts.krub(
                                  fontSize: 11.5,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.edit_calendar_rounded,
                              size: 15,
                              color: AdminColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'เปลี่ยนวัน',
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
