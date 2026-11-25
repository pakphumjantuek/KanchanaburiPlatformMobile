import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'dashboard_format.dart';

class MerchantDashboardHeroCard extends StatelessWidget {
  const MerchantDashboardHeroCard({
    super.key,
    required this.shop,
    required this.report,
  });

  final ShopModel? shop;
  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final shopName = shop?.name ?? 'ร้านค้าชุมชนเมืองกาญจน์';
    final categoryName = shop?.categoryName ?? 'ผู้ประกอบการชุมชน';
    final districtName = shop?.districtName ?? 'กาญจนบุรี';
    final isActive = shop?.status == 'Active';
    final imageUrl = shop?.coverImageUrl ?? shop?.backgroundImageUrl;

    final todayRev = report?.todayRevenue ?? 0.0;
    final monthRev = report?.monthRevenue ?? 0.0;
    final activeOrdersCount = (report?.completedOrdersCount ?? 0) +
        (report?.pendingShipmentOrdersCount ?? 0) +
        (report?.pendingSlipOrdersCount ?? 0);
    final totalOrders = activeOrdersCount > 0
        ? activeOrdersCount
        : (report?.totalOrders ?? 0);

    return Container(
      decoration: BoxDecoration(
        gradient: MerchantColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: MerchantColors.primary.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient glass decorative circles
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 45,
            bottom: -35,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Shop Logo, Info, and Status Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Logo / Avatar
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Center(
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: MerchantColors.primary,
                                    size: 28,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.storefront_rounded,
                                  color: MerchantColors.primary,
                                  size: 28,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Shop Name & Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  shopName,
                                  style: GoogleFonts.krub(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF38BDF8),
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$categoryName • อ.$districtName',
                            style: GoogleFonts.krub(
                              fontSize: 11.5,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Online/Active Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF10B981).withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF34D399).withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? const Color(0xFF34D399)
                                  : Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isActive ? 'เปิดบริการ' : 'ปิดร้าน',
                            style: GoogleFonts.krub(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Middle: Revenue Metric Cards Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Today Revenue
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ยอดขายวันนี้',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatCurrency(todayRev),
                                style: GoogleFonts.krub(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      const SizedBox(width: 12),

                      // Month Revenue
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ยอดขายเดือนนี้',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatCurrency(monthRev),
                                style: GoogleFonts.krub(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFDE68A),
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      const SizedBox(width: 12),

                      // Total Orders
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'คำสั่งซื้อทั้งหมด',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$totalOrders รายการ',
                                style: GoogleFonts.krub(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFBAE6FD),
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Bottom Row: Quick Navigation Shortcuts
                Row(
                  children: [
                    Expanded(
                      child: _buildShortcutButton(
                        icon: Icons.storefront_outlined,
                        label: 'ดูหน้าร้านค้าของคุณ',
                        onTap: () {
                          if (shop?.id != null && shop!.id.isNotEmpty) {
                            Get.toNamed('/shops/${shop!.id}');
                          } else {
                            Get.toNamed(AppRoutes.myShop);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildShortcutButton(
                        icon: Icons.inventory_2_outlined,
                        label: 'จัดการสต็อกสินค้า',
                        onTap: () => Get.toNamed(AppRoutes.myShopProducts),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 15),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
