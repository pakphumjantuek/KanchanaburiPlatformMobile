import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardKpiGrid extends StatelessWidget {
  const AdminDashboardKpiGrid({super.key, this.summary});

  final AdminDashboardSummary? summary;

  @override
  Widget build(BuildContext context) {
    final totalSales = summary?.totalSales ?? 0.0;
    final totalOrders = summary?.totalOrders ?? 0;
    final paidOrders = summary?.paidOrders ?? 0;
    final pendingPayout = summary?.pendingPayoutAmount ?? 0.0;
    final activeShops = summary?.activeShops ?? 0;
    final lowStock = summary?.lowStockProducts ?? 0;
    final totalUsers = summary?.totalUsers ?? 0;

    final payRatio = totalOrders > 0 ? (paidOrders / totalOrders).clamp(0.0, 1.0) : 0.0;

    return Column(
      children: [
        // 1. Hero Revenue Card (Executive Masterpiece)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AdminColors.primaryDark,
                Color(0xFF132238),
                AdminColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AdminColors.primaryDark.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Ambient soft glow in background
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AdminColors.secondary.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: 60,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AdminColors.gold.withValues(alpha: 0.1),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top badge & shortcut
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.insights_rounded,
                              size: 14,
                              color: Color(0xFFE9C46A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ยอดขายรวมสะสม (GMV)',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.adminExports),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'รายงาน',
                                style: GoogleFonts.krub(
                                  fontSize: 11,
                                  color: const Color(0xFFD4E7E0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: Color(0xFFD4E7E0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sales Number
                  Text(
                    '฿${totalSales.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: GoogleFonts.krub(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Progress & order ratio stacked
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'ชำระแล้ว $paidOrders จาก $totalOrders รายการ',
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                color: const Color(0xFFD0E5DC),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            '${(payRatio * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFFE9C46A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: payRatio,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2A9D8F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Sub-metric Cards (2x2 Grid with high information density)
        Row(
          children: [
            // Pending Payout
            Expanded(
              child: _buildSubCard(
                title: 'ยอดรอโอนร้านค้า',
                value: '฿${pendingPayout.toStringAsFixed(0)}',
                tagText: 'คลิกเพื่อตรวจสอบ',
                icon: Icons.account_balance_wallet_rounded,
                accentColor: const Color(0xFFE76F51),
                bgTint: const Color(0xFFFDF4F1),
                onTap: () => Get.toNamed(AppRoutes.adminPayouts),
              ),
            ),
            const SizedBox(width: 12),
            // Active Shops
            Expanded(
              child: _buildSubCard(
                title: 'ร้านค้าเปิดใช้งาน',
                value: '$activeShops ร้าน',
                tagText: lowStock > 0 ? '⚠️ สต็อกต่ำ $lowStock' : 'สถานะปกติ',
                tagIsWarning: lowStock > 0,
                icon: Icons.storefront_rounded,
                accentColor: const Color(0xFF2A9D8F),
                bgTint: const Color(0xFFF1F8F6),
                onTap: () => Get.toNamed(AppRoutes.adminShops),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            // Total Platform Users
            Expanded(
              child: _buildSubCard(
                title: 'สมาชิกในระบบ',
                value: '$totalUsers บัญชี',
                tagText: 'รวมผู้ซื้อและร้านค้า',
                icon: Icons.people_alt_rounded,
                accentColor: const Color(0xFF3D6B82),
                bgTint: const Color(0xFFF1F5F8),
              ),
            ),
            const SizedBox(width: 12),
            // Orders Total
            Expanded(
              child: _buildSubCard(
                title: 'ออเดอร์ทั้งหมด',
                value: '$totalOrders รายการ',
                tagText: 'สำเร็จ $paidOrders รายการ',
                icon: Icons.shopping_bag_rounded,
                accentColor: AdminColors.primaryLight,
                bgTint: AdminColors.infoBg,
                onTap: () => Get.toNamed(AppRoutes.adminOrders),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubCard({
    required String title,
    required String value,
    required String tagText,
    required IconData icon,
    required Color accentColor,
    required Color bgTint,
    bool tagIsWarning = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE0EAE6),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080D2B22),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgTint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(icon, size: 18, color: accentColor),
                  ),
                  if (onTap != null)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: Color(0xFF98B3AA),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagIsWarning
                        ? const Color(0xFFFFF3CD)
                        : accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tagText,
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: tagIsWarning ? const Color(0xFF856404) : accentColor,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
