import '../../../app/config/api_config.dart';
import '../../orders/models/order_model.dart';

class AdminPendingSlipGroup {
  final String slipImageUrl;
  final String? slipUploadedAt;
  final double totalGroupAmount;
  final String? buyerName;
  final String? buyerPhone;
  final List<OrderModel> orders;

  AdminPendingSlipGroup({
    required this.slipImageUrl,
    this.slipUploadedAt,
    required this.totalGroupAmount,
    this.buyerName,
    this.buyerPhone,
    required this.orders,
  });

  /// Helper to convert relative image paths (/uploads/...) to absolute URLs
  static String resolveSlipUrl(dynamic rawUrl) {
    if (rawUrl == null) return '';
    final url = rawUrl.toString().trim();
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    final baseDomain = ApiConfig.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (url.startsWith('/')) {
      return '$baseDomain$url';
    }
    return '$baseDomain/$url';
  }

  factory AdminPendingSlipGroup.fromJson(Map<String, dynamic> json) {
    final ordersList = (json['orders'] as List<dynamic>?)
            ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    String resolvedSlipUrl = resolveSlipUrl(json['slipImageUrl']);
    if (resolvedSlipUrl.isEmpty) {
      for (final o in ordersList) {
        if (o.slipImageUrl != null && o.slipImageUrl!.isNotEmpty) {
          resolvedSlipUrl = resolveSlipUrl(o.slipImageUrl);
          break;
        }
      }
    }

    return AdminPendingSlipGroup(
      slipImageUrl: resolvedSlipUrl,
      slipUploadedAt: json['slipUploadedAt'] as String?,
      totalGroupAmount: (json['totalGroupAmount'] as num?)?.toDouble() ?? 0.0,
      buyerName: json['buyerName'] as String?,
      buyerPhone: json['buyerPhone'] as String?,
      orders: ordersList,
    );
  }

  List<String> get allOrderIds => orders.map((o) => o.orderId).where((id) => id.isNotEmpty).toList();

  DateTime? get uploadDateTime {
    if (slipUploadedAt == null || slipUploadedAt!.isEmpty) return null;
    return DateTime.tryParse(slipUploadedAt!);
  }
}

class VerifySlipPayload {
  final List<String> orderIds;
  final String action; // 'Approve' | 'Reject'

  VerifySlipPayload({
    required this.orderIds,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderIds': orderIds,
      'action': action,
    };
  }
}
