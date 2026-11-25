import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../models/admin_tag_model.dart';

class AdminTagDeleteDialog {
  static Future<bool> show(
    BuildContext context, {
    required AdminTag tag,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AdminColors.errorBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AdminColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AdminColors.error,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ยืนยันการลบแท็ก?',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Tag Name Highlight Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    size: 16,
                    color: AdminColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      tag.tagName,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'การลบแท็กนี้อาจส่งผลต่อการค้นหาและตัวกรองของสินค้าหรือคอนเทนต์ที่ผูกกับแท็กนี้อยู่ คุณแน่ใจหรือไม่ที่จะลบรายการนี้?',
              style: GoogleFonts.krub(
                fontSize: 12,
                color: AdminColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'ยกเลิก',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.w600,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_rounded, size: 16),
                  label: Text(
                    'ลบแท็ก',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
