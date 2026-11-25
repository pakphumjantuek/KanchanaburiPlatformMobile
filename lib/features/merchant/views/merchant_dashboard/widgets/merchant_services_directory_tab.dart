import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class MerchantServicesDirectoryTab extends StatelessWidget {
  const MerchantServicesDirectoryTab({super.key, required this.shop});

  final ShopModel? shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Sales & Order Management Group
        _buildServiceGroup(
          groupTitle: 'ระบบการขายและคำสั่งซื้อ (Sales & Orders)',
          icon: Icons.point_of_sale_rounded,
          items: [
            _ServiceItem(
              title: 'รายการคำสั่งซื้อทั้งหมด',
              desc: 'ตรวจสอบคำสั่งซื้อ ยืนยันชำระเงิน และอัปเดตการจัดส่งสินค้า',
              color: const Color(0xFF2563EB),
              route: AppRoutes.myShopOrders,
            ),
            _ServiceItem(
              title: 'ส่งออกรายงานการขาย (Excel/CSV)',
              desc: 'ดาวน์โหลดไฟล์สรุปข้อมูลออเดอร์และบัญชียอดขายเพื่อทำเอกสาร',
              color: const Color(0xFF059669),
              route: AppRoutes.myShopExports,
            ),
          ],
        ),

        const SizedBox(height: 18),

        // 2. Products Catalog Group
        _buildServiceGroup(
          groupTitle: 'ระบบสินค้า (Products)',
          icon: Icons.inventory_2_rounded,
          items: [
            _ServiceItem(
              title: 'สินค้าทั้งหมดในร้าน',
              desc: 'ดูรายการสินค้าในคลัง จัดการสต็อก ราคา และโปรโมชัน',
              color: MerchantColors.primary,
              route: AppRoutes.myShopProducts,
            ),
          ],
        ),

        const SizedBox(height: 18),

        // 3. Content & Stories Group
        _buildServiceGroup(
          groupTitle: 'ระบบคอนเทนต์และการตลาด (Content & Marketing)',
          icon: Icons.article_rounded,
          items: [
            _ServiceItem(
              title: 'คอนเทนต์และโพสต์ของร้าน',
              desc: 'จัดการบทความ รีวิว เรื่องเล่าชุมชน และภาพประชาสัมพันธ์ร้าน',
              color: const Color(0xFF0284C7),
              route: AppRoutes.myShopContents,
            ),
            _ServiceItem(
              title: 'สร้างเรื่องราว / โพสต์ใหม่',
              desc: 'เขียนเรื่องเล่าผลิตภัณฑ์ชุมชน ปักหมุดพิกัด และแนบสินค้าที่เกี่ยวข้อง',
              color: const Color(0xFF10B981),
              route: AppRoutes.myShopContentForm,
            ),
          ],
        ),

        const SizedBox(height: 18),

        // 4. Shop Settings & Public View
        _buildServiceGroup(
          groupTitle: 'ข้อมูลร้านค้าและมุมมองลูกค้า (Shop Profile)',
          icon: Icons.storefront_rounded,
          items: [
            _ServiceItem(
              title: 'เปิดดูหน้าร้านค้าจริง (Customer View)',
              desc: 'ตรวจสอบความสวยงามของหน้าร้านในมุมมองที่ลูกค้าเห็นบนแอปพลิเคชัน',
              color: MerchantColors.primary,
              route: shop?.shopId != null && shop!.shopId.isNotEmpty
                  ? '/shops/${shop!.shopId}'
                  : AppRoutes.myShop,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceGroup({
    required String groupTitle,
    required IconData icon,
    required List<_ServiceItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: MerchantColors.primary),
              const SizedBox(width: 6),
              Text(
                groupTitle,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: MerchantColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050D2B22),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 24, endIndent: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  onTap: () => Get.toNamed(item.route),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: MerchantColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    item.desc,
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      color: MerchantColors.textSecondary,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MerchantColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'เข้าใช้งาน',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: MerchantColors.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: MerchantColors.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceItem {
  final String title;
  final String desc;
  final Color color;
  final String route;

  _ServiceItem({
    required this.title,
    required this.desc,
    required this.color,
    required this.route,
  });
}
