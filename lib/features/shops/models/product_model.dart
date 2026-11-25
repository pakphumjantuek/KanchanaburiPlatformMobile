import '../../../../app/config/api_config.dart';
import 'product_deal_model.dart';

class ProductModel {
  final String id;
  final String shopId;
  final String? shopName;
  final String? productCategoryId;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String status;
  final List<String> detailImages;
  final ProductDealModel? activeDeal;

  ProductModel({
    required this.id,
    required this.shopId,
    this.shopName,
    this.productCategoryId,
    required this.name,
    this.description,
    required this.price,
    this.quantity = 0,
    this.imageUrl,
    this.status = 'Active',
    this.detailImages = const [],
    this.activeDeal,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String? rawImage =
        json['imageUrl']?.toString() ?? json['coverImageUrl']?.toString();
    if (rawImage != null &&
        rawImage.isNotEmpty &&
        !rawImage.startsWith('http')) {
      final baseDomain = ApiConfig.baseUrl.replaceAll('/api', '');
      if (!rawImage.startsWith('/')) {
        rawImage = '/$rawImage';
      }
      rawImage = '$baseDomain$rawImage';
    }

    List<String> parsedDetailImages = [];
    if (json['detailImages'] is List) {
      parsedDetailImages = (json['detailImages'] as List).map((e) {
        String str = e.toString();
        if (str.isNotEmpty && !str.startsWith('http')) {
          final baseDomain = ApiConfig.baseUrl.replaceAll('/api', '');
          if (!str.startsWith('/')) {
            str = '/$str';
          }
          return '$baseDomain$str';
        }
        return str;
      }).toList();
    }

    return ProductModel(
      id: json['productId']?.toString() ?? json['id']?.toString() ?? '',
      shopId: json['shopId']?.toString() ?? '',
      shopName: json['shopName']?.toString(),
      productCategoryId: json['productCategoryId']?.toString(),
      name:
          json['productName']?.toString() ??
          json['name']?.toString() ??
          'ไม่มีชื่อสินค้า',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      imageUrl: rawImage,
      status: json['status']?.toString() ?? 'Active',
      detailImages: parsedDetailImages,
      activeDeal: json['activeDeal'] is Map<String, dynamic>
          ? ProductDealModel.fromJson(
              json['activeDeal'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  double get dealPrice {
    final deal = activeDeal;
    if (deal == null) return price;
    return deal.discountType.toLowerCase() == 'percent'
        ? price * (1 - deal.discountValue / 100)
        : (price - deal.discountValue).clamp(0, price);
  }
}
