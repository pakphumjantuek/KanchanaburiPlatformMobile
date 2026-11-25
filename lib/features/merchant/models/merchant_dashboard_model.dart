class MerchantDashboardModel {
  final double totalRevenue;
  final double todayRevenue;
  final double monthRevenue;
  final int totalOrders;
  final int pendingSlipOrdersCount;
  final int pendingShipmentOrdersCount;
  final int completedOrdersCount;
  final int totalProducts;
  final int lowStockProductsCount;
  final int totalContents;
  final List<RecentOrderSummary> recentOrders;
  final PromotionAnalytics promotionAnalytics;

  MerchantDashboardModel({
    required this.totalRevenue,
    required this.todayRevenue,
    required this.monthRevenue,
    required this.totalOrders,
    required this.pendingSlipOrdersCount,
    required this.pendingShipmentOrdersCount,
    required this.completedOrdersCount,
    required this.totalProducts,
    required this.lowStockProductsCount,
    required this.totalContents,
    required this.recentOrders,
    required this.promotionAnalytics,
  });

  factory MerchantDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    final recentList = json['recentOrders'] as List? ?? [];
    final promotion = json['promotionAnalytics'] as Map<String, dynamic>? ?? {};

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    return MerchantDashboardModel(
      totalRevenue: parseDouble(summary['totalRevenue']),
      todayRevenue: parseDouble(summary['todayRevenue']),
      monthRevenue: parseDouble(summary['monthRevenue']),
      totalOrders: parseInt(summary['totalOrders']),
      pendingSlipOrdersCount: parseInt(summary['pendingSlipOrdersCount']),
      pendingShipmentOrdersCount: parseInt(
        summary['pendingShipmentOrdersCount'],
      ),
      completedOrdersCount: parseInt(summary['completedOrdersCount']),
      totalProducts: parseInt(summary['totalProducts']),
      lowStockProductsCount: parseInt(summary['lowStockProductsCount']),
      totalContents: parseInt(summary['totalContents']),
      recentOrders: recentList
          .map((e) => RecentOrderSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      promotionAnalytics: PromotionAnalytics.fromJson(promotion),
    );
  }
}

class PromotionAnalytics {
  final double promotionRevenue;
  final double totalDiscountAmount;
  final int usedQuantity;
  final int activeDealsCount;
  final List<PromotionDealAnalytics> deals;

  const PromotionAnalytics({
    this.promotionRevenue = 0,
    this.totalDiscountAmount = 0,
    this.usedQuantity = 0,
    this.activeDealsCount = 0,
    this.deals = const [],
  });

  factory PromotionAnalytics.fromJson(Map<String, dynamic> json) {
    double d(dynamic value) => double.tryParse(value?.toString() ?? '') ?? 0;
    int i(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
    final list = json['deals'] is List ? json['deals'] as List : const [];
    return PromotionAnalytics(
      promotionRevenue: d(json['promotionRevenue']),
      totalDiscountAmount: d(json['totalDiscountAmount']),
      usedQuantity: i(json['usedQuantity']),
      activeDealsCount: i(json['activeDealsCount']),
      deals: list
          .map(
            (e) => PromotionDealAnalytics.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PromotionDealAnalytics {
  final String productDealId;
  final String productName;
  final String dealType;
  final int usedQuantity;
  final int totalQuantity;
  final double revenue;
  final double discountAmount;
  final String status;

  const PromotionDealAnalytics({
    required this.productDealId,
    required this.productName,
    required this.dealType,
    required this.usedQuantity,
    required this.totalQuantity,
    required this.revenue,
    required this.discountAmount,
    required this.status,
  });

  factory PromotionDealAnalytics.fromJson(Map<String, dynamic> json) {
    double d(dynamic value) => double.tryParse(value?.toString() ?? '') ?? 0;
    int i(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
    return PromotionDealAnalytics(
      productDealId: json['productDealId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? 'สินค้า',
      dealType: json['dealType']?.toString() ?? 'FlashDeal',
      usedQuantity: i(json['usedQuantity']),
      totalQuantity: i(json['totalQuantity']),
      revenue: d(json['revenue']),
      discountAmount: d(json['discountAmount']),
      status: json['status']?.toString() ?? 'Active',
    );
  }

  String get dealTypeLabel =>
      dealType.toLowerCase() == 'localdeal' ? 'โปรเด็ดชุมชน' : 'โปรโมชันพิเศษ';
}

class RecentOrderSummary {
  final String orderId;
  final String orderNumber;
  final String? receiverName;
  final double totalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String createdAt;

  RecentOrderSummary({
    required this.orderId,
    required this.orderNumber,
    this.receiverName,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory RecentOrderSummary.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return RecentOrderSummary(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      receiverName: json['receiverName']?.toString(),
      totalAmount: parseDouble(json['totalAmount']),
      orderStatus: json['orderStatus']?.toString() ?? 'Pending',
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
