import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';
import '../../../models/admin_content_model.dart';
import 'admin_content_card.dart';
import 'admin_content_category_card.dart';
import 'manage_contents_filter_panel.dart';
import 'manage_contents_pagination.dart';

class ManageContentsBody extends StatelessWidget {
  const ManageContentsBody({
    super.key,
    required this.controller,
    required this.onEditCategory,
    required this.onBindTags,
    required this.onCreateCategory,
  });

  final AdminContentsController controller;
  final ValueChanged<ContentCategoryAdmin?> onEditCategory;
  final ValueChanged<AdminContentItem> onBindTags;
  final VoidCallback onCreateCategory;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.activeTab.value;
      if (active == 0) {
        return Column(
          children: [
            ManageContentsFilterPanel(controller: controller),
            Expanded(
              child: RefreshIndicator(
                color: AdminColors.primary,
                onRefresh: () => controller.loadContents(),
                child: _buildContentList(),
              ),
            ),
            ManageContentsPagination(controller: controller),
          ],
        );
      }
      return RefreshIndicator(
        color: AdminColors.primary,
        onRefresh: () => controller.loadContentCategories(),
        child: _buildCategoryList(),
      );
    });
  }

  Widget _buildContentList() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AdminColors.primary),
      );
    }

    if (controller.contents.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AdminColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.article_outlined,
                  size: 36,
                  color: AdminColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ไม่พบบทความในระบบ',
                style: GoogleFonts.krub(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                controller.selectedStatusFilter.value.isNotEmpty
                    ? 'ไม่พบบทความในสถานะที่เลือก ลองเปลี่ยนตัวกรองดูครับ'
                    : 'บทความและแหล่งท่องเที่ยวจะแสดงที่นี่เมื่อมีข้อมูลในระบบ',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: controller.contents.length,
      itemBuilder: (context, index) {
        final item = controller.contents[index];
        return AdminContentCard(
          item: item,
          controller: controller,
          onBindTags: () => onBindTags(item),
        );
      },
    );
  }

  Widget _buildCategoryList() {
    if (controller.isCatLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AdminColors.primary),
      );
    }

    if (controller.contentCategories.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AdminColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  size: 36,
                  color: AdminColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ยังไม่มีหมวดหมู่บทความ',
                style: GoogleFonts.krub(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'สร้างหมวดหมู่เพื่อจัดระเบียบบทความและสถานที่ท่องเที่ยวให้เป็นหมวดหมู่',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                label: Text(
                  'สร้างหมวดหมู่แรก',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: onCreateCategory,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: controller.contentCategories.length,
      itemBuilder: (context, index) {
        final category = controller.contentCategories[index];
        return AdminContentCategoryCard(
          category: category,
          controller: controller,
          onEdit: () => onEditCategory(category),
        );
      },
    );
  }
}
