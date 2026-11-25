import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/dashboard_format.dart';

class MerchantDashboardPromotionAnalytics extends StatelessWidget {
  const MerchantDashboardPromotionAnalytics({super.key, this.report});

  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final analytics = report?.promotionAnalytics ?? const PromotionAnalytics();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFBCFE8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFE11D48),
              ),
              const SizedBox(width: 8),
              Text(
                'วิเคราะห์โปรโมชัน',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _promotionMetric(
                  'ยอดขายจากโปร',
                  analytics.promotionRevenue,
                  Icons.payments_rounded,
                  const Color(0xFFBE123C),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _promotionMetric(
                  'ส่วนลดรวม',
                  analytics.totalDiscountAmount,
                  Icons.discount_rounded,
                  const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _promotionMetric(
                  'ใช้สิทธิ์แล้ว',
                  analytics.usedQuantity.toDouble(),
                  Icons.shopping_bag_rounded,
                  const Color(0xFF7C3AED),
                  suffix: ' ชิ้น',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _promotionMetric(
                  'ดีลที่ใช้งาน',
                  analytics.activeDealsCount.toDouble(),
                  Icons.bolt_rounded,
                  const Color(0xFF0284C7),
                  suffix: ' ดีล',
                ),
              ),
            ],
          ),
          if (analytics.deals.isNotEmpty) ...[
            const Divider(height: 24),
            ...analytics.deals.map(
              (deal) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.productName,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${deal.dealTypeLabel} • ใช้แล้ว ${deal.usedQuantity}/${deal.totalQuantity} ชิ้น • ${deal.status}',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatCurrency(deal.revenue),
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFBE123C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _promotionMetric(
    String label,
    double value,
    IconData icon,
    Color color, {
    String suffix = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              '$label\n${formatCurrency(value)}$suffix',
              style: GoogleFonts.krub(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
