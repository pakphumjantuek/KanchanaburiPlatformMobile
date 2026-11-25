import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageContentsEmptyState extends GetView<ManageContentsController> {
  const ManageContentsEmptyState({super.key, required this.isShopNull});

  final bool isShopNull;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSearching = controller.searchQuery.value.isNotEmpty;
      final isFiltered = controller.selectedFilter.value != 'all';

      String title = 'ยังไม่มีเรื่องราวหรือข่าวสารในร้าน';
      String subtitle =
          'เล่าเรื่องราวความเป็นมา ประชาสัมพันธ์โปรโมชันพิเศษ หรือบอกเล่าสินค้าชุมชนเพื่อดึงดูดลูกค้า';
      IconData icon = Icons.auto_stories_rounded;
      String btnText = 'เขียนเรื่องราวแรกของร้าน';
      Color btnColor = MerchantColors.primary;

      if (isShopNull) {
        title = 'ยังไม่ได้ลงทะเบียนร้านค้า';
        subtitle =
            'กรุณากรอกข้อมูลเพื่อเปิดร้านค้าก่อนเริ่มเขียนเรื่องราวและประชาสัมพันธ์สินค้า';
        icon = Icons.storefront_rounded;
        btnText = 'ลงทะเบียนร้านค้าใหม่';
        btnColor = MerchantColors.warning;
      } else if (isSearching) {
        title = 'ไม่พบเรื่องราวตามคำค้นหา';
        subtitle =
            'ไม่พบเนื้อหาตรงกับ "${controller.searchQuery.value}" ลองค้นหาด้วยคำอื่น';
        icon = Icons.search_off_rounded;
        btnText = 'ล้างคำค้นหา';
      } else if (isFiltered) {
        title = 'ไม่มีเรื่องราวในหมวดหมู่นี้';
        subtitle = 'ไม่พบบทความที่ตรงกับตัวกรองที่เลือกไว้ ลองเลือกตัวกรองอื่น';
        icon = Icons.filter_alt_off_rounded;
        btnText = 'ดูเรื่องราวทั้งหมด';
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
                  color: isShopNull
                      ? MerchantColors.warningBg
                      : MerchantColors.successBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isShopNull
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFA7F3D0),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 52,
                  color: isShopNull
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
                  } else if (isShopNull) {
                    Get.toNamed(AppRoutes.registerShop);
                  } else {
                    final res = await Get.toNamed(AppRoutes.myShopContentForm);
                    if (res == true) controller.loadContents();
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
                      : (isShopNull ? Icons.edit_document : Icons.add_rounded),
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
