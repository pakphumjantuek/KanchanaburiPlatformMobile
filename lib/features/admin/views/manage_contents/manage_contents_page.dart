import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_contents_controller.dart';
import '../../models/admin_category_model.dart';
import '../../models/admin_content_model.dart';
import 'widgets/manage_content_category_form_dialog.dart';
import 'widgets/manage_content_tag_binding_sheet.dart';
import 'widgets/manage_contents_body.dart';
import 'widgets/manage_contents_tabs.dart';

class ManageAdminContentsPage extends GetView<AdminContentsController> {
  const ManageAdminContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminContentsController>()) {
      Get.put(AdminContentsController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AdminColors.headerGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'จัดการบทความ & ท่องเที่ยว',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17.5,
                color: Colors.white,
              ),
            ),
            Text(
              'ระบบจัดการบทความ แหล่งท่องเที่ยว และหมวดหมู่เนื้อหา',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'รีเฟรชข้อมูล',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              if (controller.activeTab.value == 0) {
                controller.loadContents();
              } else {
                controller.loadContentCategories();
              }
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: Obx(() {
        final isCategoryTab = controller.activeTab.value == 1;
        if (!isCategoryTab) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          backgroundColor: AdminColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          icon: const Icon(
            Icons.create_new_folder_outlined,
            size: 20,
          ),
          label: Text(
            'สร้างหมวดหมู่ใหม่',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          onPressed: () {
            ManageContentCategoryFormDialog.show(
              context,
              controller: controller,
            );
          },
        );
      }),
      body: Column(
        children: [
          // 1. Executive Metric Summary Banner
          _buildMetricBanner(),

          // 2. Segmented Pill Tabs
          ManageContentsTabs(controller: controller),

          // 3. Tab Contents
          Expanded(
            child: ManageContentsBody(
              controller: controller,
              onEditCategory: (ContentCategoryAdmin? category) =>
                  ManageContentCategoryFormDialog.show(
                    context,
                    controller: controller,
                    category: category,
                  ),
              onBindTags: (AdminContentItem item) =>
                  ManageContentTagBindingSheet.show(
                    context,
                    controller: controller,
                    contentId: item.contentId,
                    title: item.title,
                  ),
              onCreateCategory: () => ManageContentCategoryFormDialog.show(
                context,
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final contentCount = controller.contents.length;
        final catCount = controller.contentCategories.length;
        final tagCount = controller.activeTags.length;

        return Row(
          children: [
            _buildMetricItem(
              label: 'บทความทั้งหมด',
              value: '$contentCount',
              icon: Icons.article_rounded,
              color: AdminColors.primary,
            ),
            Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
            _buildMetricItem(
              label: 'หมวดหมู่เนื้อหา',
              value: '$catCount',
              icon: Icons.folder_rounded,
              color: const Color(0xFF0284C7),
            ),
            Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
            _buildMetricItem(
              label: 'แท็กที่เปิดใช้',
              value: '$tagCount',
              icon: Icons.label_rounded,
              color: const Color(0xFF8338EC),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 10.5,
              color: AdminColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
