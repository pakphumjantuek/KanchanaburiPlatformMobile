import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsFilterPanel extends StatelessWidget {
  const ManageContentsFilterPanel({super.key, required this.controller});

  final AdminContentsController controller;

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
                    value: 'Published',
                    label: 'เผยแพร่แล้ว',
                    icon: Icons.check_circle_outline_rounded,
                    activeColor: AdminColors.success,
                  ),
                  _filterChip(
                    value: 'Draft',
                    label: 'แบบร่าง',
                    icon: Icons.edit_note_rounded,
                    activeColor: const Color(0xFF64748B),
                  ),
                  _filterChip(
                    value: 'Pending',
                    label: 'รอตรวจสอบ',
                    icon: Icons.hourglass_top_rounded,
                    activeColor: AdminColors.warning,
                  ),
                  _filterChip(
                    value: 'Archived',
                    label: 'เก็บกรุ',
                    icon: Icons.archive_outlined,
                    activeColor: AdminColors.error,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Meta Row: Current Page & Page Size Selector
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AdminColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.layers_outlined,
                          size: 14,
                          color: AdminColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'หน้า ${controller.currentPage.value} จาก ${controller.totalPages.value} หน้า',
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
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'แสดง: ',
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: AdminColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: controller.pageSize.value,
                          isDense: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AdminColors.textSecondary,
                          ),
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          items: const [
                            DropdownMenuItem(value: 10, child: Text('10 รายการ')),
                            DropdownMenuItem(value: 20, child: Text('20 รายการ')),
                            DropdownMenuItem(value: 50, child: Text('50 รายการ')),
                            DropdownMenuItem(value: 100, child: Text('100 รายการ')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.loadContents(page: 1, size: value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            controller.loadContents(page: 1);
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? activeColor
                  : const Color(0xFFF1F5F9),
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
