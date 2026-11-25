import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';
import '../../../models/admin_tag_model.dart';
import 'admin_tag_card.dart';
import 'admin_tag_chip.dart';
import 'admin_tag_delete_dialog.dart';
import 'manage_tag_form_dialog.dart';

class ManageTagsList extends StatelessWidget {
  const ManageTagsList({
    super.key,
    required this.controller,
    required this.onEdit,
  });

  final AdminTagsController controller;
  final ValueChanged<AdminTag> onEdit;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Loading State (initial or empty list)
      if (controller.isLoading.value && controller.tags.isEmpty) {
        return const Center(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AdminColors.primaryLight,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูลแท็ก...',
                    style: TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final filtered = controller.filteredTags;
      final isSearching = controller.searchQuery.value.trim().isNotEmpty;
      final hasFilter = controller.selectedStatusFilter.value.isNotEmpty;

      // 2. Empty States
      if (filtered.isEmpty) {
        return Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AdminColors.primaryDark.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSearching
                          ? Icons.search_off_rounded
                          : hasFilter
                              ? Icons.filter_alt_off_rounded
                              : Icons.sell_outlined,
                      size: 36,
                      color: AdminColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSearching
                        ? 'ไม่พบแท็กที่ตรงกับ "${controller.searchQuery.value}"'
                        : hasFilter
                            ? 'ไม่มีแท็กในสถานะ "${controller.selectedStatusFilter.value == 'Active' ? 'เปิดใช้งาน' : 'ปิดใช้งาน'}"'
                            : 'ยังไม่มีแท็กในระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isSearching
                        ? 'ลองตรวจสอบคำสะกด หรือล้างคำค้นหาเพื่อดูแท็กทั้งหมด'
                        : hasFilter
                            ? 'คุณสามารถเปลี่ยนตัวกรอง หรือสร้างแท็กใหม่ได้ทันที'
                            : 'เริ่มต้นเพิ่มแท็กเพื่อจัดกลุ่มสินค้าและคอนเทนต์ให้ค้นหาได้ง่ายขึ้น',
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: AdminColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (isSearching || hasFilter)
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.clearSearch();
                        controller.setStatusFilter('');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(
                        'ล้างการค้นหาและตัวกรอง',
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () =>
                          ManageTagFormDialog.show(context, controller: controller),
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
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(
                        'เพิ่มแท็กใหม่ทันที',
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }

      final isCardsView = controller.viewMode.value == 'cards';

      // 3. Render Tag List / Cloud
      return RefreshIndicator(
        color: AdminColors.primaryLight,
        onRefresh: () => controller.loadTags(page: controller.currentPage.value),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isCardsView)
                // Card View Mode
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (ctx, index) {
                    final tag = filtered[index];
                    return AdminTagCard(
                      tag: tag,
                      onEdit: () => onEdit(tag),
                      onDelete: () async {
                        final confirmed = await AdminTagDeleteDialog.show(
                          context,
                          tag: tag,
                        );
                        if (confirmed) {
                          await controller.deleteTag(tag.tagId);
                        }
                      },
                      onToggleStatus: (_) => controller.toggleTagStatus(tag),
                    );
                  },
                )
              else
                // Cloud / Chips View Mode
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.bubble_chart_rounded,
                            size: 16,
                            color: AdminColors.primaryLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'มุมมองกลุ่มคำแท็ก (Tag Cloud)',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'แตะเพื่อแก้ไข',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              color: AdminColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: filtered.map((tag) {
                          return AdminTagChip(
                            tag: tag,
                            onEdit: () => onEdit(tag),
                            onDelete: () async {
                              final confirmed = await AdminTagDeleteDialog.show(
                                context,
                                tag: tag,
                              );
                              if (confirmed) {
                                await controller.deleteTag(tag.tagId);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

              // 4. Pagination Controls (if totalPages > 1)
              if (controller.totalPages.value > 1) ...[
                const SizedBox(height: 18),
                _buildPaginationControls(),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPaginationControls() {
    final current = controller.currentPage.value;
    final total = controller.totalPages.value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Page Button
          OutlinedButton.icon(
            onPressed: current > 1
                ? () => controller.loadTags(page: current - 1)
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              side: BorderSide(
                color: current > 1 ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.chevron_left_rounded, size: 18),
            label: Text(
              'ก่อนหน้า',
              style: GoogleFonts.krub(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),

          // Page Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'หน้า $current จาก $total',
              style: GoogleFonts.krub(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AdminColors.primary,
              ),
            ),
          ),

          // Next Page Button
          OutlinedButton.icon(
            onPressed: current < total
                ? () => controller.loadTags(page: current + 1)
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              side: BorderSide(
                color: current < total ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.chevron_right_rounded, size: 18),
            label: Text(
              'ถัดไป',
              style: GoogleFonts.krub(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
