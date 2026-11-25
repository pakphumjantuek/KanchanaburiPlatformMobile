import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';
import '../../../models/admin_tag_model.dart';
import 'admin_tag_delete_dialog.dart';

class ManageTagFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminTagsController controller,
    AdminTag? tag,
  }) async {
    final isEditing = tag != null;
    final nameCtrl = TextEditingController(text: tag?.tagName ?? '');
    final selectedStatus = (tag?.status ?? 'Active').obs;
    final liveTagName = (tag?.tagName ?? '').obs;
    final formKey = GlobalKey<FormState>();

    nameCtrl.addListener(() {
      liveTagName.value = nameCtrl.text;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width - 32,
            constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header with Gradient Accent
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
                    decoration: const BoxDecoration(
                      gradient: AdminColors.headerGradient,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEditing ? Icons.edit_note_rounded : Icons.add_circle_outline_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? 'แก้ไขแท็ก' : 'เพิ่มแท็กใหม่',
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                isEditing
                                    ? 'รหัสแท็ก: #${tag.tagId}'
                                    : 'สร้างคำค้นและป้ายกำกับสินค้า',
                                style: GoogleFonts.krub(
                                  fontSize: 11.5,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                        ),
                      ],
                    ),
                  ),

                  // 2. Form Content Body
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Live Preview Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 14,
                                      color: AdminColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'ตัวอย่างการแสดงผลแท็ก (Live Preview)',
                                      style: GoogleFonts.krub(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AdminColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Obx(() {
                                  final name = liveTagName.value.trim().isEmpty
                                      ? 'ชื่อแท็กตัวอย่าง'
                                      : liveTagName.value.trim();
                                  final isActive = selectedStatus.value == 'Active';

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isActive
                                            ? AdminColors.primaryLight.withValues(alpha: 0.4)
                                            : const Color(0xFFCBD5E1),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isActive
                                                ? AdminColors.success
                                                : AdminColors.textMuted,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '# $name',
                                          style: GoogleFonts.krub(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isActive
                                                ? AdminColors.textPrimary
                                                : AdminColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? AdminColors.successBg
                                                : const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isActive ? 'เปิดใช้งาน' : 'ปิดใช้งาน',
                                            style: GoogleFonts.krub(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isActive
                                                  ? AdminColors.success
                                                  : AdminColors.textMuted,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Tag Name Input Field
                          Text(
                            'ชื่อแท็ก (Tag Name) *',
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: nameCtrl,
                            maxLength: 50,
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AdminColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'เช่น สินค้าขายดี, ส่วนลด 50%, เมนูแนะนำ',
                              hintStyle: GoogleFonts.krub(
                                fontSize: 13,
                                color: AdminColors.textMuted,
                              ),
                              prefixIcon: const Icon(
                                Icons.tag_rounded,
                                color: AdminColors.primary,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  size: 16,
                                  color: AdminColors.textMuted,
                                ),
                                onPressed: () => nameCtrl.clear(),
                              ),
                              counterText: '',
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AdminColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AdminColors.error,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'กรุณาระบุชื่อแท็ก';
                              }
                              if (val.trim().length < 2) {
                                return 'ชื่อแท็กต้องมีอย่างน้อย 2 ตัวอักษร';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Status Selection Header
                          Text(
                            'สถานะการใช้งาน (Status)',
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Status Option Cards
                          Obx(() {
                            final currentStatus = selectedStatus.value;

                            return Row(
                              children: [
                                // Active Option Card
                                Expanded(
                                  child: _buildStatusCard(
                                    title: 'เปิดใช้งาน',
                                    description: 'แสดงให้เลือกใช้งาน',
                                    icon: Icons.check_circle_rounded,
                                    activeColor: AdminColors.success,
                                    bgColor: AdminColors.successBg,
                                    isSelected: currentStatus == 'Active',
                                    onTap: () => selectedStatus.value = 'Active',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Inactive Option Card
                                Expanded(
                                  child: _buildStatusCard(
                                    title: 'ปิดใช้งาน',
                                    description: 'ซ่อนจากระบบ',
                                    icon: Icons.pause_circle_rounded,
                                    activeColor: const Color(0xFF64748B),
                                    bgColor: const Color(0xFFF1F5F9),
                                    isSelected: currentStatus == 'Inactive',
                                    onTap: () => selectedStatus.value = 'Inactive',
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // 3. Actions Footer
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      border: Border(
                        top: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isEditing) ...[
                          IconButton(
                            tooltip: 'ลบแท็กนี้',
                            style: IconButton.styleFrom(
                              backgroundColor: AdminColors.errorBg,
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AdminColors.error,
                              size: 20,
                            ),
                            onPressed: () async {
                              final confirmed = await AdminTagDeleteDialog.show(
                                context,
                                tag: tag,
                              );
                              if (confirmed && context.mounted) {
                                final ok = await controller.deleteTag(tag.tagId);
                                if (ok && context.mounted) {
                                  Navigator.of(dialogCtx).pop();
                                }
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'ยกเลิก',
                            style: GoogleFonts.krub(
                              color: AdminColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(() {
                          final isSaving = controller.isSaving.value;

                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isSaving
                                ? null
                                : () async {
                                    if (formKey.currentState?.validate() ?? false) {
                                      final name = nameCtrl.text.trim();
                                      bool success = false;
                                      if (isEditing) {
                                        success = await controller.updateTag(
                                          tag.tagId,
                                          name,
                                          selectedStatus.value,
                                        );
                                      } else {
                                        success = await controller.createTag(
                                          name,
                                          status: selectedStatus.value,
                                        );
                                      }
                                      if (success && context.mounted) {
                                        Navigator.of(dialogCtx).pop();
                                      }
                                    }
                                  },
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.check_rounded, size: 18),
                            label: Text(
                              isEditing ? 'บันทึกการแก้ไข' : 'เพิ่มแท็ก',
                              style: GoogleFonts.krub(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    nameCtrl.dispose();
  }

  static Widget _buildStatusCard({
    required String title,
    required String description,
    required IconData icon,
    required Color activeColor,
    required Color bgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? activeColor : AdminColors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AdminColors.textPrimary
                            : AdminColors.textSecondary,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        color: AdminColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
