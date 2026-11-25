import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../models/admin_tag_model.dart';

class AdminTagCard extends StatelessWidget {
  const AdminTagCard({
    super.key,
    required this.tag,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final AdminTag tag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final isActive = tag.status == 'Active';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFCBD5E1).withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Tag Icon, Name, and Status Switch
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tag Icon Avatar
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isActive
                            ? [
                                AdminColors.primary.withValues(alpha: 0.12),
                                AdminColors.primaryLight.withValues(alpha: 0.2),
                              ]
                            : [
                                Colors.grey.withValues(alpha: 0.12),
                                Colors.grey.withValues(alpha: 0.2),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.tag_rounded,
                        color: isActive
                            ? AdminColors.primaryLight
                            : AdminColors.textMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tag Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tag.tagName,
                          style: GoogleFonts.krub(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? AdminColors.textPrimary
                                : AdminColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        if (tag.tagId.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${tag.tagId}',
                              style: GoogleFonts.robotoMono(
                                fontSize: 10,
                                color: AdminColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Switch for rapid active/inactive toggle
                  Tooltip(
                    message: isActive ? 'คลิกเพื่อปิดใช้งาน' : 'คลิกเพื่อเปิดใช้งาน',
                    child: Transform.scale(
                      scale: 0.85,
                      child: Switch.adaptive(
                        value: isActive,
                        activeThumbColor: AdminColors.primaryLight,
                        activeTrackColor: AdminColors.primaryLight.withValues(alpha: 0.35),
                        inactiveThumbColor: Colors.grey.shade400,
                        inactiveTrackColor: Colors.grey.shade200,
                        onChanged: onToggleStatus,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),

              // Bottom Row: Status Badge and Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Badge
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? AdminColors.successBg : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AdminColors.success.withValues(alpha: 0.3)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AdminColors.success
                                  : AdminColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              isActive ? 'เปิดใช้งาน' : 'ปิดใช้งาน',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? AdminColors.success
                                    : AdminColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action Buttons (Edit / Delete)
                  Row(
                    children: [
                      // Edit Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AdminColors.primaryLight.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: AdminColors.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'แก้ไข',
                                  style: GoogleFonts.krub(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Delete Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onDelete,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AdminColors.errorBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                              color: AdminColors.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
