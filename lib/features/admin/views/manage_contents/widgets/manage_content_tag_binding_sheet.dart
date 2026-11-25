import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentTagBindingSheet {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    required String contentId,
    required String title,
  }) async {
    controller.loadContentTags(contentId);
    final searchCtrl = TextEditingController();
    final searchQuery = ''.obs;
    bool isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8338EC).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.label_outline_rounded,
                          color: Color(0xFF8338EC),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ผูกแท็กให้กับบทความ',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            Text(
                              title,
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: AdminColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search Field
                  TextField(
                    controller: searchCtrl,
                    onChanged: (val) => searchQuery.value = val.trim(),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาแท็ก...',
                      hintStyle: GoogleFonts.krub(
                        fontSize: 12.5,
                        color: AdminColors.textMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AdminColors.textSecondary,
                      ),
                      suffixIcon: Obx(
                        () => searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  searchCtrl.clear();
                                  searchQuery.value = '';
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                        borderSide: const BorderSide(
                          color: Color(0xFF8338EC),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Selected Count Summary
                  Obx(() {
                    final count = controller.selectedContentTagIds.length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'แตะเพื่อเลือกหรือยกเลิกแท็ก:',
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8338EC).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'เลือกแล้ว $count แท็ก',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8338EC),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),

                  // Tag Chips Grid/Wrap
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Obx(() {
                        final query = searchQuery.value.toLowerCase();
                        final filteredTags = controller.activeTags.where((t) {
                          if (query.isEmpty) return true;
                          return t.tagName.toLowerCase().contains(query);
                        }).toList();

                        if (filteredTags.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                controller.activeTags.isEmpty
                                    ? 'ไม่มีแท็กที่เปิดใช้งานในระบบ'
                                    : 'ไม่พบแท็กที่ตรงกับคำค้นหา',
                                style: GoogleFonts.krub(
                                  fontSize: 12.5,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: filteredTags.map((tag) {
                            final isSelected = controller.selectedContentTagIds
                                .contains(tag.tagId);

                            return FilterChip(
                              label: Text(
                                tag.tagName,
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF8338EC)
                                      : AdminColors.textPrimary,
                                ),
                              ),
                              selected: isSelected,
                              showCheckmark: true,
                              checkmarkColor: const Color(0xFF8338EC),
                              backgroundColor: const Color(0xFFF1F5F9),
                              selectedColor: const Color(0xFF8338EC)
                                  .withValues(alpha: 0.15),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF8338EC)
                                    : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.2 : 0.8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  controller.selectedContentTagIds.add(tag.tagId);
                                } else {
                                  controller.selectedContentTagIds
                                      .remove(tag.tagId);
                                }
                              },
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8338EC),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setState(() => isSubmitting = true);
                              final saved =
                                  await controller.saveContentTags(contentId);
                              if (saved && context.mounted) {
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
                              'บันทึกการผูกแท็ก',
                              style: GoogleFonts.krub(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    searchCtrl.dispose();
  }
}
