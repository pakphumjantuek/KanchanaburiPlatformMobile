import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../models/admin_tag_model.dart';

class AdminTagChip extends StatelessWidget {
  const AdminTagChip({
    super.key,
    required this.tag,
    required this.onEdit,
    this.onDelete,
  });

  final AdminTag tag;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = tag.status == 'Active';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isActive
                  ? AdminColors.primaryLight.withValues(alpha: 0.35)
                  : const Color(0xFFCBD5E1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status indicator dot
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AdminColors.success : AdminColors.textMuted,
                ),
              ),
              const SizedBox(width: 6),

              // Hashtag Icon
              Text(
                '#',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? AdminColors.primaryLight
                      : AdminColors.textMuted,
                ),
              ),
              const SizedBox(width: 2),

              // Tag Name
              Text(
                tag.tagName,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AdminColors.textPrimary
                      : AdminColors.textSecondary,
                ),
              ),

              const SizedBox(width: 6),

              // Edit Action
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AdminColors.primaryLight.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 13,
                    color: AdminColors.primaryLight,
                  ),
                ),
              ),

              if (onDelete != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AdminColors.errorBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 13,
                      color: AdminColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
