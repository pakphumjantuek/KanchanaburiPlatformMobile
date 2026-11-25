import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';

class AdminContentCategoryCard extends StatelessWidget {
  const AdminContentCategoryCard({
    super.key,
    required this.category,
    required this.controller,
    required this.onEdit,
  });

  final ContentCategoryAdmin category;
  final AdminContentsController controller;
  final VoidCallback onEdit;

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AdminColors.errorBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline, color: AdminColors.error, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'ยืนยันการลบหมวดหมู่',
                style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'คุณต้องการลบหมวดหมู่ "${category.categoryName}" ใช่หรือไม่? โปรดตรวจสอบว่าไม่มีบทความผูกอยู่กับหมวดหมู่นี้',
          style: GoogleFonts.krub(fontSize: 13.5, color: AdminColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(
                color: AdminColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteContentCategory(category.contentCategoryId);
            },
            child: Text(
              'ยืนยันลบ',
              style: GoogleFonts.krub(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Category Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AdminColors.cardAccentGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AdminColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.folder_open_rounded, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: 14),

              // Category Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.categoryName,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              color: AdminColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AdminColors.successBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.status,
                            style: GoogleFonts.krub(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (category.description != null && category.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        category.description!,
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: AdminColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Action Buttons
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: AdminColors.primary),
                tooltip: 'แก้ไข',
                onPressed: onEdit,
                style: IconButton.styleFrom(
                  backgroundColor: AdminColors.primary.withValues(alpha: 0.08),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AdminColors.error),
                tooltip: 'ลบ',
                onPressed: () => _confirmDelete(context),
                style: IconButton.styleFrom(
                  backgroundColor: AdminColors.errorBg,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
