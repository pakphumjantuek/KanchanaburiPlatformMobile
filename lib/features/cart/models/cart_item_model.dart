import '../../shops/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String? shopName;
  int quantity;
  bool isSelected;
  final double subtotalFromApi;
  final int dealQuantity;
  final int normalQuantity;
  final double? dealUnitPrice;
  final double? normalUnitPrice;
  final String? dealType;
  final DateTime? dealEndsAt;

  CartItemModel({
    required this.id,
    required this.product,
    this.shopName,
    this.quantity = 1,
    this.isSelected = true,
    this.subtotalFromApi = 0,
    this.dealQuantity = 0,
    this.normalQuantity = 0,
    this.dealUnitPrice,
    this.normalUnitPrice,
    this.dealType,
    this.dealEndsAt,
  });

  double get subtotal =>
      subtotalFromApi > 0 ? subtotalFromApi : product.price * quantity;

  String get effectiveShopId =>
      product.shopId.isNotEmpty ? product.shopId : 'unknown_shop';

  String get effectiveShopName => (shopName != null && shopName!.isNotEmpty)
      ? shopName!
      : (product.shopName != null && product.shopName!.isNotEmpty)
      ? product.shopName!
      : 'ร้านค้าชุมชน';

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseUtc(dynamic value) {
      if (value == null) return null;
      final raw = value.toString();
      final hasTimezone = RegExp(
        r'(Z|[+-]\d{2}:?\d{2})$',
        caseSensitive: false,
      ).hasMatch(raw);
      return DateTime.tryParse(hasTimezone ? raw : '${raw}Z')?.toUtc();
    }

    final productId = json['productId']?.toString() ?? '';
    final productName = json['productName']?.toString() ?? 'สินค้า';
    final shopId = json['shopId']?.toString() ?? '';
    final shopName = json['shopName']?.toString();
    final imageUrl = json['imageUrl']?.toString() ?? '';
    final unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final quantity = (json['quantity'] as num?)?.toInt() ?? 1;

    final product = ProductModel(
      id: productId,
      name: productName,
      description: '',
      price:
          double.tryParse(json['originalPrice']?.toString() ?? '') ?? unitPrice,
      quantity: (json['availableQuantity'] as num?)?.toInt() ?? 100,
      imageUrl: imageUrl,
      shopId: shopId,
      shopName: shopName,
    );

    return CartItemModel(
      id:
          json['cartItemId']?.toString() ??
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      shopName: shopName,
      quantity: quantity,
      isSelected: true,
      subtotalFromApi:
          double.tryParse(json['subtotal']?.toString() ?? '') ??
          unitPrice * quantity,
      dealQuantity: int.tryParse(json['dealQuantity']?.toString() ?? '') ?? 0,
      normalQuantity:
          int.tryParse(json['normalQuantity']?.toString() ?? '') ?? 0,
      dealUnitPrice: double.tryParse(json['dealUnitPrice']?.toString() ?? ''),
      normalUnitPrice: double.tryParse(
        json['normalUnitPrice']?.toString() ?? '',
      ),
      dealType: json['dealType']?.toString(),
      dealEndsAt: parseUtc(json['dealEndsAt']),
    );
  }

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? shopName,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      shopName: shopName ?? this.shopName,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      subtotalFromApi: subtotalFromApi,
      dealQuantity: dealQuantity,
      normalQuantity: normalQuantity,
      dealUnitPrice: dealUnitPrice,
      normalUnitPrice: normalUnitPrice,
      dealType: dealType,
      dealEndsAt: dealEndsAt,
    );
  }
}
