import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsTabs extends StatelessWidget {
  const ManageContentsTabs({super.key, required this.controller});

  final AdminContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
        ),
        child: Obx(() {
          final active = controller.activeTab.value;
          final contentsCount = controller.contents.length;
          final categoriesCount = controller.contentCategories.length;

          return Row(
            children: [
              _buildTabItem(
                title: 'บทความทั้งหมด',
                icon: Icons.article_rounded,
                count: contentsCount,
                isSelected: active == 0,
                onTap: () => controller.switchTab(0),
              ),
              _buildTabItem(
                title: 'หมวดหมู่เนื้อหา',
                icon: Icons.category_rounded,
                count: categoriesCount,
                isSelected: active == 1,
                onTap: () => controller.switchTab(1),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required IconData icon,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AdminColors.primaryDark.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AdminColors.primary
                    : AdminColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? AdminColors.primaryDark
                        : AdminColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AdminColors.primary
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.krub(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AdminColors.textPrimary,
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
