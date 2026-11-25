import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/controllers/admin_shops_controller.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'admin_shop_card.dart';

class ManageShopsList extends StatelessWidget {
  const ManageShopsList({super.key, required this.controller});

  final AdminShopsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.shops.isEmpty) {
        return const Center(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AdminColors.primaryLight,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'กำลังโหลดข้อมูลร้านค้า...',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }


      if (controller.shops.isEmpty) {
        final isSearching = controller.searchQuery.value.isNotEmpty;
        final hasStatusFilter = controller.selectedStatus.value.isNotEmpty;

        return Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                          : Icons.storefront_outlined,
                      size: 36,
                      color: AdminColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isSearching
                        ? 'ไม่พบร้านค้าที่ตรงกับคำค้นหา'
                        : hasStatusFilter
                            ? 'ไม่มีร้านค้าในสถานะ "${AdminShopsController.getStatusThai(controller.selectedStatus.value)}"'
                            : 'ไม่พบรายการร้านค้าในระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSearching
                        ? 'ลองตรวจสอบคำค้นหาหรือพิมพ์ชื่อร้านค้าใหม่อีกครั้ง'
                        : 'คุณสามารถลองเปลี่ยนตัวกรองสถานะหรือรีเฟรชหน้าจอ',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  if (isSearching || hasStatusFilter)
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.clearSearch();
                        controller.selectStatus('');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 15),
                      label: Text(
                        'ล้างการค้นหาและตัวกรอง',
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => controller.loadData(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AdminColors.primary,
                        side: const BorderSide(color: AdminColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 15),
                      label: Text(
                        'รีเฟรชข้อมูล',
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                ],
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.shops.length + (controller.totalPages.value > 1 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.shops.length) {
            return AdminShopCard(
              shop: controller.shops[index],
              controller: controller,
            );
          }

          // Bottom Pagination Bar
          return _buildPaginationBar();
        },
      );
    });
  }

  Widget _buildPaginationBar() {
    final currentPage = controller.currentPage.value;
    final totalPages = controller.totalPages.value;
    final totalCount = controller.totalCount.value;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Page Button
          InkWell(
            onTap: currentPage > 1 ? () => controller.previousPage() : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: currentPage > 1
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 16,
                    color: currentPage > 1
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'ก่อนหน้า',
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: currentPage > 1
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current Page & Total
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'หน้า $currentPage จาก $totalPages',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (totalCount > 0)
                    Text(
                      'ทั้งหมด $totalCount ร้าน',
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),

          // Next Page Button
          InkWell(
            onTap: currentPage < totalPages ? () => controller.nextPage() : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: currentPage < totalPages
                    ? AdminColors.primary
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ถัดไป',
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: currentPage < totalPages
                          ? Colors.white
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: currentPage < totalPages
                        ? Colors.white
                        : const Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

