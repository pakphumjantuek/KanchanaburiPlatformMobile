import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageProductsEmptyState extends StatelessWidget {
  const ManageProductsEmptyState({super.key, required this.controller});

  final ManageProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isNoShop = controller.myShop.value == null;
      final isSearching = controller.searchQuery.value.isNotEmpty;
      final isFiltered = controller.selectedFilter.value != 'all';

      String title = 'ยังไม่มีสินค้าในร้านของคุณ';
      String subtitle =
          'เพิ่มสินค้าเข้าสู่ร้านค้าเพื่อให้ลูกค้าสามารถเลือกชมและสั่งซื้อได้ทันที';
      IconData icon = Icons.inventory_2_outlined;
      String btnText = 'เพิ่มสินค้าชิ้นแรก';
      Color btnColor = MerchantColors.primary;

      if (isNoShop) {
        title = 'ยังไม่ได้ลงทะเบียนร้านค้า';
        subtitle = 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าก่อนเริ่มจัดการรายการสินค้า';
        icon = Icons.storefront_outlined;
        btnText = 'ลงทะเบียนร้านค้าใหม่';
        btnColor = MerchantColors.warning;
      } else if (isSearching) {
        title = 'ไม่พบสินค้าตามคำค้นหา';
        subtitle =
            'ไม่พบสินค้าตรงกับ "${controller.searchQuery.value}" ลองค้นหาด้วยคำอื่น';
        icon = Icons.search_off_rounded;
        btnText = 'ล้างคำค้นหา';
      } else if (isFiltered) {
        title = 'ไม่มีสินค้าในสถานะนี้';
        subtitle = 'ไม่พบสินค้าที่ตรงกับตัวกรองที่เลือกไว้ ลองเลือกตัวกรองอื่น';
        icon = Icons.filter_alt_off_rounded;
        btnText = 'ดูสินค้าทั้งหมด';
      }

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isNoShop
                      ? MerchantColors.warningBg
                      : MerchantColors.successBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isNoShop
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFA7F3D0),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 52,
                  color: isNoShop
                      ? MerchantColors.warning
                      : MerchantColors.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: MerchantColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: MerchantColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: () async {
                  if (isSearching) {
                    controller.searchQuery.value = '';
                  } else if (isFiltered) {
                    controller.setFilter('all');
                  } else if (isNoShop) {
                    Get.toNamed(AppRoutes.registerShop);
                  } else {
                    final result = await Get.toNamed(AppRoutes.myShopProductForm);
                    if (result == true) controller.loadProducts();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  (isSearching || isFiltered)
                      ? Icons.refresh_rounded
                      : (isNoShop ? Icons.edit_document : Icons.add_rounded),
                  size: 19,
                ),
                label: Text(
                  btnText,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
