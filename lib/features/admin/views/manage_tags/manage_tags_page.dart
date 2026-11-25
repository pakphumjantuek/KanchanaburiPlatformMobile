import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_tags_controller.dart';
import '../../models/admin_tag_model.dart';
import 'widgets/manage_tag_form_dialog.dart';
import 'widgets/manage_tags_filter_bar.dart';
import 'widgets/manage_tags_list.dart';
import 'widgets/manage_tags_metric_banner.dart';

class ManageTagsPage extends GetView<AdminTagsController> {
  const ManageTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminTagsController>()) {
      Get.put(AdminTagsController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Executive Metric Summary Banner
            ManageTagsMetricBanner(controller: controller),

            // 2. Search & Filter Bar
            ManageTagsFilterBar(controller: controller),

            // 3. Tags List / Cloud with Pagination
            Expanded(
              child: ManageTagsList(
                controller: controller,
                onEdit: (AdminTag tag) =>
                    ManageTagFormDialog.show(context, controller: controller, tag: tag),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AdminColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'จัดการแท็ก',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: AdminColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'TAGS',
                  style: GoogleFonts.robotoMono(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF93C5FD),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'จัดหมวดหมู่คำค้น ป้ายกำกับสินค้า และคอนเทนต์',
            style: GoogleFonts.krub(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        // Refresh Button
        Obx(
          () => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
            ),
            tooltip: 'รีเฟรชข้อมูลแท็ก',
            onPressed: () => controller.loadTags(page: controller.currentPage.value),
          ),
        ),
        // Add Tag Quick Button in AppBar
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AdminColors.primaryLight.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          tooltip: 'เพิ่มแท็กใหม่',
          onPressed: () =>
              ManageTagFormDialog.show(context, controller: controller),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        backgroundColor: AdminColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        onPressed: () =>
            ManageTagFormDialog.show(context, controller: controller),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
        label: Text(
          'เพิ่มแท็กใหม่',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
