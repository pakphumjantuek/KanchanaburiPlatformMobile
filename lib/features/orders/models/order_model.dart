import '../../../../app/config/api_config.dart';

class OrderItemModel {
  final String orderItemId;
  final String productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItemModel({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    String? img = json['imageUrl']?.toString();
    if (img != null && img.startsWith('/uploads')) {
      img = ApiConfig.baseUrl.replaceAll('/api', '') + img;
    }

    return OrderItemModel(
      orderItemId: json['orderItemId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? 'สินค้า',
      imageUrl: img,
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class OrderModel {
  final String orderId;
  final String? shopId;
  final String? shopName;
  final String? shopLogoUrl;
  final String? orderNumber;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final String? shippingMethod;
  final String orderStatus;
  final String paymentStatus;
  final String? receiverName;
  final String? receiverPhone;
  final String? shippingAddress;
  final String? slipImageUrl;
  final String? carrierName;
  final String? trackingNumber;
  final DateTime? createdAt;

  /// UTC instant supplied by the API. Never derive this from [createdAt].
  final DateTime? paymentExpiresAt;
  final List<OrderItemModel> items;

  String get id => orderId;

  OrderModel({
    required this.orderId,
    this.shopId,
    this.shopName,
    this.shopLogoUrl,
    this.orderNumber,
    this.subtotal = 0.0,
    this.shippingFee = 0.0,
    required this.totalAmount,
    this.shippingMethod,
    this.orderStatus = 'Pending',
    this.paymentStatus = 'Pending',
    this.receiverName,
    this.receiverPhone,
    this.shippingAddress,
    this.slipImageUrl,
    this.carrierName,
    this.trackingNumber,
    this.createdAt,
    this.paymentExpiresAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseUtcDate(dynamic value) {
      if (value == null) return null;
      final raw = value.toString().trim();
      if (raw.isEmpty) return null;
      // The API defines timestamps without a suffix as UTC; DateTime.parse
      // would otherwise interpret them using the device timezone.
      final hasTimezone = RegExp(
        r'(Z|[+-]\d{2}:?\d{2})$',
        caseSensitive: false,
      ).hasMatch(raw);
      return DateTime.tryParse(hasTimezone ? raw : '${raw}Z')?.toUtc();
    }

    String? resolveUrl(dynamic val) {
      if (val == null) return null;
      String str = val.toString();
      if (str.startsWith('/uploads')) {
        return ApiConfig.baseUrl.replaceAll('/api', '') + str;
      }
      return str;
    }

    List<OrderItemModel> parsedItems = [];
    if (json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return OrderModel(
      orderId: json['orderId']?.toString() ?? json['id']?.toString() ?? '',
      shopId: json['shopId']?.toString(),
      shopName: json['shopName']?.toString() ?? 'ร้านค้าชุมชน',
      shopLogoUrl: resolveUrl(json['shopLogoUrl']),
      orderNumber:
          json['orderNumber']?.toString() ??
          'ORD-${DateTime.now().millisecondsSinceEpoch}',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      shippingFee:
          double.tryParse(json['shippingFee']?.toString() ?? '0') ?? 0.0,
      totalAmount:
          double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0.0,
      shippingMethod: json['shippingMethod']?.toString() ?? 'Standard Delivery',
      orderStatus: json['orderStatus']?.toString() ?? 'Pending',
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      receiverName: json['receiverName']?.toString(),
      receiverPhone: json['receiverPhone']?.toString(),
      shippingAddress: json['shippingAddress']?.toString(),
      slipImageUrl: resolveUrl(json['slipImageUrl']),
      carrierName:
          json['carrierName']?.toString() ??
          json['shipment']?['carrierName']?.toString() ??
          json['shipment']?['shippingProvider']?.toString(),
      trackingNumber:
          json['trackingNumber']?.toString() ??
          json['shipment']?['trackingNumber']?.toString(),
      createdAt: parseUtcDate(json['createdAt']),
      paymentExpiresAt: parseUtcDate(json['paymentExpiresAt']),
      items: parsedItems,
    );
  }

  bool get isAwaitingPayment =>
      orderStatus.toLowerCase() == 'pending' &&
      paymentStatus.toLowerCase() == 'pending';

  bool get isPaymentExpired {
    if (orderStatus.toLowerCase() == 'expired' ||
        paymentStatus.toLowerCase() == 'expired') {
      return true;
    }
    return isAwaitingPayment &&
        (paymentExpiresAt == null ||
            !paymentExpiresAt!.isAfter(DateTime.now().toUtc()));
  }

  /// Single source of truth for every payment CTA in the app.
  bool get canPay => isAwaitingPayment && !isPaymentExpired;

  Duration? get remainingPaymentTime {
    if (!isAwaitingPayment || paymentExpiresAt == null) return null;
    final remaining = paymentExpiresAt!.difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get statusLabel {
    if (paymentStatus.toLowerCase() == 'pendingverification' ||
        (slipImageUrl != null &&
            slipImageUrl!.isNotEmpty &&
            orderStatus.toLowerCase() == 'pending')) {
      return 'รอแอดมินตรวจสอบสลิป';
    }
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return paymentStatus.toLowerCase() == 'paid'
            ? 'รอยืนยันออเดอร์'
            : 'รอชำระเงิน';
      case 'confirmed':
        return 'ยืนยันออเดอร์แล้ว';
      case 'paid':
        return 'ชำระเงินสำเร็จ';
      case 'processing':
        return 'กำลังเตรียมจัดส่ง';
      case 'shipped':
        return 'จัดส่งแล้ว';
      case 'completed':
        return 'สำเร็จสมบูรณ์';
      case 'cancelled':
        return 'ยกเลิกแล้ว';
      case 'expired':
        return 'หมดเวลาชำระ';
      default:
        return orderStatus;
    }
  }
}
