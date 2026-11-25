import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';

class ManageContentCategoryFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    ContentCategoryAdmin? category,
  }) async {
    final nameCtrl = TextEditingController(text: category?.categoryName ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final isEditing = category != null;

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AdminColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.folder_open_rounded,
                            color: AdminColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing
                                    ? 'แก้ไขหมวดหมู่เนื้อหา'
                                    : 'สร้างหมวดหมู่ใหม่',
                                style: GoogleFonts.krub(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.textPrimary,
                                ),
                              ),
                              Text(
                                isEditing
                                    ? 'แก้ไขชื่อและรายละเอียดของหมวดหมู่นี้'
                                    : 'เพิ่มหมวดหมู่เพื่อจัดกลุ่มบทความและสถานที่',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          color: AdminColors.textMuted,
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 18),

                    // Name Field
                    Text(
                      'ชื่อหมวดหมู่ (Category Name) *',
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'เช่น สถานที่ท่องเที่ยว, วัฒนธรรมและประเพณี...',
                        hintStyle: GoogleFonts.krub(fontSize: 13, color: AdminColors.textMuted),
                        prefixIcon: const Icon(
                          Icons.label_outline_rounded,
                          size: 18,
                          color: AdminColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AdminColors.primary, width: 1.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Description Field
                    Text(
                      'คำอธิบายเพิ่มเติม (Description)',
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'รายละเอียดหรือขอบเขตของเนื้อหาในหมวดหมู่นี้...',
                        hintStyle: GoogleFonts.krub(fontSize: 13, color: AdminColors.textMuted),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AdminColors.primary, width: 1.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                            child: Text(
                              'ยกเลิก',
                              style: GoogleFonts.krub(
                                color: AdminColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    final name = nameCtrl.text.trim();
                                    if (name.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('กรุณาระบุชื่อหมวดหมู่'),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => isSubmitting = true);
                                    bool ok;
                                    if (category == null) {
                                      ok = await controller.createContentCategory(
                                        name,
                                        descCtrl.text.trim(),
                                      );
                                    } else {
                                      ok = await controller.updateContentCategory(
                                        category.contentCategoryId,
                                        name,
                                        descCtrl.text.trim(),
                                        category.status,
                                      );
                                    }
                                    if (context.mounted && ok) {
                                      Navigator.pop(ctx);
                                    } else if (context.mounted) {
                                      setState(() => isSubmitting = false);
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditing ? 'บันทึกการแก้ไข' : 'สร้างหมวดหมู่',
                                    style: GoogleFonts.krub(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    nameCtrl.dispose();
    descCtrl.dispose();
  }
}
