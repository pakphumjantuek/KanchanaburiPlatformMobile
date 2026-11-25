import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsPagination extends StatelessWidget {
  const ManageContentsPagination({super.key, required this.controller});

  final AdminContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.currentPage.value;
      final total = controller.totalPages.value;
      if (total <= 1 && controller.contents.isEmpty) {
        return const SizedBox.shrink();
      }

      final canPrev = current > 1;
      final canNext = current < total;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AdminColors.primaryDark.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canPrev
                      ? AdminColors.primary
                      : const Color(0xFFF1F5F9),
                  foregroundColor: canPrev ? Colors.white : AdminColors.textMuted,
                  elevation: canPrev ? 1 : 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 13),
                label: Text(
                  'ก่อนหน้า',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: canPrev ? controller.previousPage : null,
              ),

              // Page Indicator Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'หน้า ',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$current',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primary,
                      ),
                    ),
                    Text(
                      ' / $total',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Next Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canNext
                      ? AdminColors.primary
                      : const Color(0xFFF1F5F9),
                  foregroundColor: canNext ? Colors.white : AdminColors.textMuted,
                  elevation: canNext ? 1 : 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                label: Text(
                  'ถัดไป',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: canNext ? controller.nextPage : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
