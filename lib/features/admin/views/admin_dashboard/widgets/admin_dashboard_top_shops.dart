import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardTopShops extends StatelessWidget {
  const AdminDashboardTopShops({super.key, required this.topShops});

  final List<AdminTopShop> topShops;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9C46A).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 16,
                    color: Color(0xFFC79218),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ร้านค้ายอดขายสูงสุด (Top Performers)',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.adminShops),
              icon: const Icon(Icons.arrow_forward_rounded, size: 14),
              label: Text(
                'จัดการร้าน',
                style: GoogleFonts.krub(
                  color: AdminColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AdminColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (topShops.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0EAE6)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 40,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Text(
                  'ยังไม่มีข้อมูลร้านค้ายอดขายสูงสุดในรอบนี้',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x060D2B22),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topShops.length > 5 ? 5 : topShops.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFEFF5F2),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final shop = topShops[index];

                Color medalColor;
                Color medalBg;
                String rankSymbol;

                if (index == 0) {
                  medalColor = const Color(0xFFB58105);
                  medalBg = const Color(0xFFFFF4D4);
                  rankSymbol = '1';
                } else if (index == 1) {
                  medalColor = const Color(0xFF5E6D7E);
                  medalBg = const Color(0xFFE9EEF4);
                  rankSymbol = '2';
                } else if (index == 2) {
                  medalColor = const Color(0xFFB8592C);
                  medalBg = const Color(0xFFFBECE4);
                  rankSymbol = '3';
                } else {
                  medalColor = AdminColors.textSecondary;
                  medalBg = const Color(0xFFF0F5F2);
                  rankSymbol = '${index + 1}';
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.adminShops),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Medal / Rank Badge
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: medalBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: medalColor.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                rankSymbol,
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: medalColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Shop Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.shopName,
                                  style: GoogleFonts.krub(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: AdminColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 13,
                                      color: Color(0xFF7A978E),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${shop.paidOrders} ออเดอร์ที่ชำระแล้ว',
                                        style: GoogleFonts.krub(
                                          fontSize: 11.5,
                                          color: AdminColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Sales Total
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '฿${shop.sales.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: GoogleFonts.krub(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AdminColors.primary,
                                  ),
                                ),
                              ),
                              Text(
                                'ยอดขายรวม',
                                style: GoogleFonts.krub(
                                  fontSize: 10,
                                  color: const Color(0xFF7A978E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
