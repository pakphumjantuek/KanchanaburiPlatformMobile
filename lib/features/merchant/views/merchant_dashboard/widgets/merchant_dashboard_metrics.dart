import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/dashboard_format.dart';

class MerchantDashboardMetrics extends StatelessWidget {
  const MerchantDashboardMetrics({super.key, this.report});

  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final totalRev = report?.totalRevenue ?? 0.0;
    final monthRev = report?.monthRevenue ?? 0.0;
    final totalProd = report?.totalProducts ?? 0;
    final lowStock = report?.lowStockProductsCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'สรุปภาพรวมรายได้ & สต็อก',
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
          childAspectRatio: 1.35,
          children: [
            _buildStatCard(
              title: 'ยอดขายรวมทั้งหมด',
              value: formatCurrency(totalRev),
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFF059669),
              bg: const Color(0xFFECFDF5),
              borderColor: const Color(0xFFA7F3D0),
            ),
            _buildStatCard(
              title: 'ยอดขายเดือนนี้',
              value: formatCurrency(monthRev),
              icon: Icons.trending_up_rounded,
              color: const Color(0xFF0284C7),
              bg: const Color(0xFFF0F9FF),
              borderColor: const Color(0xFFBAE6FD),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.toNamed(AppRoutes.myShopProducts),
              child: _buildStatCard(
                title: 'สินค้าในร้านทั้งหมด',
                value: '$totalProd รายการ',
                icon: Icons.inventory_2_rounded,
                color: const Color(0xFF7C3AED),
                bg: const Color(0xFFF5F3FF),
                borderColor: const Color(0xFFDDD6FE),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.toNamed(
                AppRoutes.myShopProducts,
                parameters: {'filter': 'lowStock'},
                arguments: {'filter': 'lowStock'},
              ),
              child: _buildStatCard(
                title: 'สินค้าสต็อกต่ำ',
                value: '$lowStock รายการ',
                icon: Icons.warning_amber_rounded,
                color: lowStock > 0
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF64748B),
                bg: lowStock > 0
                    ? const Color(0xFFFFF1F2)
                    : const Color(0xFFF8FAFC),
                borderColor: lowStock > 0
                    ? const Color(0xFFFECDD3)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.krub(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
