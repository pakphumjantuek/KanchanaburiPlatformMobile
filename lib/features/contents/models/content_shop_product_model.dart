import '../../../app/config/api_config.dart';

class ContentShopProduct {
  final String productId;
  final String shopId;
  final String? shopName;
  final String productName;
  final String? description;
  final double price;
  final String? imageUrl;

  ContentShopProduct({
    required this.productId,
    required this.shopId,
    this.shopName,
    required this.productName,
    this.description,
    required this.price,
    this.imageUrl,
  });

  factory ContentShopProduct.fromJson(Map<String, dynamic> json) {
    String? resolveUrl(dynamic val) {
      if (val == null) return null;
      String str = val.toString().trim();
      if (str.isEmpty) return null;
      if (str.startsWith('http://') || str.startsWith('https://')) {
        return str;
      }
      if (str.startsWith('/')) {
        return ApiConfig.baseUrl.replaceAll('/api', '') + str;
      }
      return '${ApiConfig.baseUrl.replaceAll('/api', '')}/$str';
    }

    return ContentShopProduct(
      productId: json['productId']?.toString() ?? '',
      shopId: json['shopId']?.toString() ?? '',
      shopName: json['shopName']?.toString(),
      productName: json['productName']?.toString() ?? 'สินค้าชุมชน',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: resolveUrl(json['imageUrl'] ?? json['coverImageUrl']),
    );
  }
}
