class AdminDashboardSummary {
  final double totalSales;
  final int totalOrders;
  final int paidOrders;
  final double pendingPayoutAmount;
  final int totalUsers;
  final int activeShops;
  final int lowStockProducts;

  AdminDashboardSummary({
    required this.totalSales,
    required this.totalOrders,
    required this.paidOrders,
    required this.pendingPayoutAmount,
    required this.totalUsers,
    required this.activeShops,
    required this.lowStockProducts,
  });

  factory AdminDashboardSummary.fromJson(Map<String, dynamic> json) {
    return AdminDashboardSummary(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] as int? ?? 0,
      paidOrders: json['paidOrders'] as int? ?? 0,
      pendingPayoutAmount: (json['pendingPayoutAmount'] as num?)?.toDouble() ?? 0.0,
      totalUsers: json['totalUsers'] as int? ?? 0,
      activeShops: json['activeShops'] as int? ?? 0,
      lowStockProducts: json['lowStockProducts'] as int? ?? 0,
    );
  }
}

class AdminOrderStatusCounts {
  final int pendingPayment;
  final int pendingVerification;
  final int processing;
  final int shipped;
  final int completed;
  final int cancelled;

  AdminOrderStatusCounts({
    required this.pendingPayment,
    required this.pendingVerification,
    required this.processing,
    required this.shipped,
    required this.completed,
    required this.cancelled,
  });

  factory AdminOrderStatusCounts.fromJson(Map<String, dynamic> json) {
    return AdminOrderStatusCounts(
      pendingPayment: json['pendingPayment'] as int? ?? 0,
      pendingVerification: json['pendingVerification'] as int? ?? 0,
      processing: json['processing'] as int? ?? 0,
      shipped: json['shipped'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }
}

class AdminSalesTrend {
  final String date;
  final double sales;
  final int orders;

  AdminSalesTrend({
    required this.date,
    required this.sales,
    required this.orders,
  });

  factory AdminSalesTrend.fromJson(Map<String, dynamic> json) {
    return AdminSalesTrend(
      date: json['date'] as String? ?? '',
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      orders: json['orders'] as int? ?? 0,
    );
  }
}

class AdminRecentOrder {
  final String orderId;
  final String orderNumber;
  final String shopName;
  final double totalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String createdAt;

  AdminRecentOrder({
    required this.orderId,
    required this.orderNumber,
    required this.shopName,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory AdminRecentOrder.fromJson(Map<String, dynamic> json) {
    return AdminRecentOrder(
      orderId: json['orderId'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      shopName: json['shopName'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderStatus: json['orderStatus'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class AdminTopShop {
  final String shopId;
  final String shopName;
  final double sales;
  final int paidOrders;

  AdminTopShop({
    required this.shopId,
    required this.shopName,
    required this.sales,
    required this.paidOrders,
  });

  factory AdminTopShop.fromJson(Map<String, dynamic> json) {
    return AdminTopShop(
      shopId: json['shopId'] as String? ?? '',
      shopName: json['shopName'] as String? ?? '',
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      paidOrders: json['paidOrders'] as int? ?? 0,
    );
  }
}

class AdminDashboardAlerts {
  final int pendingSlips;
  final int pendingPayoutOrders;
  final int pendingShipmentOrders;

  AdminDashboardAlerts({
    required this.pendingSlips,
    required this.pendingPayoutOrders,
    required this.pendingShipmentOrders,
  });

  factory AdminDashboardAlerts.fromJson(Map<String, dynamic> json) {
    return AdminDashboardAlerts(
      pendingSlips: json['pendingSlips'] as int? ?? 0,
      pendingPayoutOrders: json['pendingPayoutOrders'] as int? ?? 0,
      pendingShipmentOrders: json['pendingShipmentOrders'] as int? ?? 0,
    );
  }
}

class AdminDashboardReport {
  final String from;
  final String to;
  final AdminDashboardSummary summary;
  final AdminOrderStatusCounts orderStatusCounts;
  final List<AdminSalesTrend> salesTrend;
  final List<AdminRecentOrder> recentOrders;
  final List<AdminTopShop> topShops;
  final AdminDashboardAlerts alerts;

  AdminDashboardReport({
    required this.from,
    required this.to,
    required this.summary,
    required this.orderStatusCounts,
    required this.salesTrend,
    required this.recentOrders,
    required this.topShops,
    required this.alerts,
  });

  factory AdminDashboardReport.fromJson(Map<String, dynamic> json) {
    return AdminDashboardReport(
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      summary: AdminDashboardSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      orderStatusCounts: AdminOrderStatusCounts.fromJson(json['orderStatusCounts'] as Map<String, dynamic>? ?? {}),
      salesTrend: (json['salesTrend'] as List<dynamic>?)
              ?.map((e) => AdminSalesTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentOrders: (json['recentOrders'] as List<dynamic>?)
              ?.map((e) => AdminRecentOrder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topShops: (json['topShops'] as List<dynamic>?)
              ?.map((e) => AdminTopShop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      alerts: AdminDashboardAlerts.fromJson(json['alerts'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AdminExportParams {
  final String? from;
  final String? to;
  final String? shopId;
  final String? orderStatus;
  final String? paymentStatus;
  final String? payoutStatus;
  final String format; // 'csv' | 'pdf'

  AdminExportParams({
    this.from,
    this.to,
    this.shopId,
    this.orderStatus,
    this.paymentStatus,
    this.payoutStatus,
    this.format = 'csv',
  });

  Map<String, String> toQueryParameters() {
    final map = <String, String>{};
    if (from != null && from!.isNotEmpty) map['from'] = from!;
    if (to != null && to!.isNotEmpty) map['to'] = to!;
    if (shopId != null && shopId!.isNotEmpty) map['shopId'] = shopId!;
    if (orderStatus != null && orderStatus!.isNotEmpty) map['orderStatus'] = orderStatus!;
    if (paymentStatus != null && paymentStatus!.isNotEmpty) map['paymentStatus'] = paymentStatus!;
    if (payoutStatus != null && payoutStatus!.isNotEmpty) map['payoutStatus'] = payoutStatus!;
    map['format'] = format;
    return map;
  }
}
