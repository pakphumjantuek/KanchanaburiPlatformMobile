import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';

class MerchantDashboardQuickActions extends StatelessWidget {
  const MerchantDashboardQuickActions({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'เมนูจัดการร้านค้า',
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildActionButton(
              title: 'จัดการสินค้า',
              subtitle: 'เพิ่ม/แก้ไขรายการสินค้า',
              icon: Icons.shopping_bag_rounded,
              color: const Color(0xFF059669),
              bg: const Color(0xFFECFDF5),
              onTap: () => Get.toNamed(AppRoutes.myShopProducts),
            ),
            _buildActionButton(
              title: 'จัดการคำสั่งซื้อ',
              subtitle: 'เตรียมแพ็กของ/แจ้งจัดส่ง',
              icon: Icons.assignment_rounded,
              color: const Color(0xFF2563EB),
              bg: const Color(0xFFEFF6FF),
              onTap: () => Get.toNamed(AppRoutes.myShopOrders),
            ),
            _buildActionButton(
              title: 'บทความร้านค้า',
              subtitle: 'โปรโมทร้าน/ข่าวสาร',
              icon: Icons.article_rounded,
              color: const Color(0xFF9333EA),
              bg: const Color(0xFFF5F3FF),
              onTap: () => Get.toNamed(AppRoutes.myShopContents),
            ),
            _buildActionButton(
              title: 'ส่งออกรายงาน',
              subtitle: 'รายงาน PDF & CSV',
              icon: Icons.download_rounded,
              color: const Color(0xFF047857),
              bg: const Color(0xFFECFDF5),
              onTap: () => Get.toNamed(AppRoutes.myShopExports),
            ),
            _buildActionButton(
              title: 'ข้อมูลร้านค้า',
              subtitle: 'แก้ไขที่อยู่/บัญชีธนาคาร',
              icon: Icons.storefront_rounded,
              color: const Color(0xFFD97706),
              bg: const Color(0xFFFFFBEB),
              onTap: () => Get.toNamed(AppRoutes.registerShop),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
