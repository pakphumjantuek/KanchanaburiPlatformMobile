import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_content_model.dart';

class ManageContentFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    AdminContentItem? item,
  }) async {
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final summaryCtrl = TextEditingController(text: item?.summary ?? '');
    final ytCtrl = TextEditingController(text: item?.youtubeUrl ?? '');
    String selectedStatus = item?.status ?? 'Published';
    String? selectedCategoryId = item?.contentCategoryId.isNotEmpty == true
        ? item!.contentCategoryId
        : (controller.contentCategories.isNotEmpty
            ? controller.contentCategories.first.contentCategoryId
            : null);

    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: SingleChildScrollView(
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
                              Icons.article_rounded,
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
                                  'แก้ไขบทความ',
                                  style: GoogleFonts.krub(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'ปรับปรุงข้อมูลบทความและเนื้อหาการท่องเที่ยว',
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

                      // Title Field
                      _buildLabel('หัวข้อบทความ (Title) *'),
                      TextField(
                        controller: titleCtrl,
                        decoration: _buildInputDecoration(
                          hintText: 'เช่น 10 จุดเช็คอินสุดชิคในปัตตานี...',
                          prefixIcon: Icons.title_rounded,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Category Dropdown
                      _buildLabel('หมวดหมู่เนื้อหา (Category)'),
                      if (controller.contentCategories.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategoryId,
                          decoration: _buildInputDecoration(
                            prefixIcon: Icons.folder_open_rounded,
                          ),
                          items: controller.contentCategories.map((c) {
                            return DropdownMenuItem<String>(
                              value: c.contentCategoryId,
                              child: Text(
                                c.categoryName,
                                style: GoogleFonts.krub(fontSize: 13.5),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedCategoryId = val);
                            }
                          },
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            'ยังไม่มีหมวดหมู่ในระบบ (สามารถสร้างได้ในแท็บหมวดหมู่)',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),

                      // Status Selector Chips
                      _buildLabel('สถานะการเผยแพร่ (Status)'),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildStatusChoice(
                            label: 'เผยแพร่ทันที (Published)',
                            value: 'Published',
                            color: AdminColors.success,
                            isSelected: selectedStatus == 'Published',
                            onSelect: () => setState(() => selectedStatus = 'Published'),
                          ),
                          _buildStatusChoice(
                            label: 'ฉบับร่าง (Draft)',
                            value: 'Draft',
                            color: const Color(0xFF64748B),
                            isSelected: selectedStatus == 'Draft',
                            onSelect: () => setState(() => selectedStatus = 'Draft'),
                          ),
                          _buildStatusChoice(
                            label: 'รอตรวจสอบ (Pending)',
                            value: 'Pending',
                            color: AdminColors.warning,
                            isSelected: selectedStatus == 'Pending',
                            onSelect: () => setState(() => selectedStatus = 'Pending'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Summary / Body Field
                      _buildLabel('เรื่องย่อ / เนื้อหาบทความ (Summary / Body)'),
                      TextField(
                        controller: summaryCtrl,
                        maxLines: 4,
                        decoration: _buildInputDecoration(
                          hintText: 'รายละเอียดหรือเรื่องราวโดยย่อของบทความ...',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // YouTube URL Field
                      _buildLabel('ลิงก์คลิปวิดีโอ YouTube (ถ้ามี)'),
                      TextField(
                        controller: ytCtrl,
                        decoration: _buildInputDecoration(
                          hintText: 'https://www.youtube.com/watch?v=...',
                          prefixIcon: Icons.video_library_rounded,
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
                                      final title = titleCtrl.text.trim();
                                      if (title.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('กรุณาระบุหัวข้อบทความ'),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() => isSubmitting = true);
                                      final ok = await controller.saveContent(
                                        id: item?.contentId,
                                        data: ContentFormData(
                                          title: title,
                                          summary: summaryCtrl.text.trim(),
                                          contentCategoryId: selectedCategoryId,
                                          youtubeUrl: ytCtrl.text.trim(),
                                          status: selectedStatus,
                                        ),
                                      );
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
                                      'บันทึกการแก้ไข',
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
            ),
          );
        },
      ),
    );

    titleCtrl.dispose();
    summaryCtrl.dispose();
    ytCtrl.dispose();
  }

  static Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.krub(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: AdminColors.textPrimary,
        ),
      ),
    );
  }

  static InputDecoration _buildInputDecoration({
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.krub(fontSize: 13, color: AdminColors.textMuted),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 18, color: AdminColors.textSecondary)
          : null,
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
    );
  }

  static Widget _buildStatusChoice({
    required String label,
    required String value,
    required Color color,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? color : AdminColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : AdminColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
