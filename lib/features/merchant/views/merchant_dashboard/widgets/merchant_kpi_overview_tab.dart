import 'package:flutter/material.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'merchant_dashboard_metrics.dart';
import 'merchant_dashboard_order_counters.dart';
import 'merchant_dashboard_promotion_analytics.dart';
import 'merchant_dashboard_recent_orders.dart';
import 'merchant_dashboard_shop_warning.dart';

class MerchantKpiOverviewTab extends StatelessWidget {
  const MerchantKpiOverviewTab({
    super.key,
    required this.shop,
    required this.report,
  });

  final ShopModel? shop;
  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Inactive Shop Warning if not Active
        if (shop == null || shop?.status != 'Active') ...[
          MerchantDashboardShopWarning(status: shop?.status),
          const SizedBox(height: 16),
        ],

        // 2. Order Processing Pipeline Status Counters
        MerchantDashboardOrderCounters(report: report),
        const SizedBox(height: 18),

        // 3. Revenue, Products & Contents Metrics Grid
        MerchantDashboardMetrics(report: report),
        const SizedBox(height: 18),

        // 4. Promotions & Flash Deals Analytics
        MerchantDashboardPromotionAnalytics(report: report),
        const SizedBox(height: 18),

        // 5. Recent Orders Activity Feed
        MerchantDashboardRecentOrders(report: report),
      ],
    );
  }
}
