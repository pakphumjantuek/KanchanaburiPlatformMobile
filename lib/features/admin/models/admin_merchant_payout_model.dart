import '../../orders/models/order_model.dart';

class AdminMerchantPayoutGroup {
  final String shopId;
  final String shopName;
  final String? shopLogoUrl;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? promptPay;
  final double totalSalesAmount;
  final int paidOrdersCount;
  final List<OrderModel> orders;

  AdminMerchantPayoutGroup({
    required this.shopId,
    required this.shopName,
    this.shopLogoUrl,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.promptPay,
    required this.totalSalesAmount,
    required this.paidOrdersCount,
    required this.orders,
  });

  factory AdminMerchantPayoutGroup.fromJson(Map<String, dynamic> json) {
    return AdminMerchantPayoutGroup(
      shopId: json['shopId'] as String? ?? '',
      shopName: json['shopName'] as String? ?? '',
      shopLogoUrl: json['shopLogoUrl'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountName: json['bankAccountName'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      promptPay: json['promptPay'] as String?,
      totalSalesAmount: (json['totalSalesAmount'] as num?)?.toDouble() ?? 0.0,
      paidOrdersCount: json['paidOrdersCount'] as int? ?? 0,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MerchantPayoutRecord {
  final String payoutId;
  final String shopId;
  final String? shopName;
  final String? shopLogoUrl;
  final double totalAmount;
  final String? slipImageUrl;
  final String? transactionRef;
  final String? note;
  final String status;
  final String createdAt;
  final int ordersCount;
  final List<OrderModel> orders;

  MerchantPayoutRecord({
    required this.payoutId,
    required this.shopId,
    this.shopName,
    this.shopLogoUrl,
    required this.totalAmount,
    this.slipImageUrl,
    this.transactionRef,
    this.note,
    required this.status,
    required this.createdAt,
    required this.ordersCount,
    required this.orders,
  });

  factory MerchantPayoutRecord.fromJson(Map<String, dynamic> json) {
    return MerchantPayoutRecord(
      payoutId: json['payoutId'] as String? ?? '',
      shopId: json['shopId'] as String? ?? '',
      shopName: json['shopName'] as String?,
      shopLogoUrl: json['shopLogoUrl'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      slipImageUrl: json['slipImageUrl'] as String?,
      transactionRef: json['transactionRef'] as String?,
      note: json['note'] as String?,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      ordersCount: json['ordersCount'] as int? ?? 0,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
