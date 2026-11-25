class ShopCategoryAdmin {
  final String shopCategoryId;
  final String categoryName;
  final String? description;
  final String status; // 'Active' | 'Inactive'
  final bool hasImage;

  ShopCategoryAdmin({
    required this.shopCategoryId,
    required this.categoryName,
    this.description,
    required this.status,
    required this.hasImage,
  });

  factory ShopCategoryAdmin.fromJson(Map<String, dynamic> json) {
    return ShopCategoryAdmin(
      shopCategoryId: json['shopCategoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'Active',
      hasImage: json['hasImage'] as bool? ?? false,
    );
  }
}

class ProductCategoryAdmin {
  final String productCategoryId;
  final String categoryName;
  final String? description;
  final String status; // 'Active' | 'Inactive'

  ProductCategoryAdmin({
    required this.productCategoryId,
    required this.categoryName,
    this.description,
    required this.status,
  });

  factory ProductCategoryAdmin.fromJson(Map<String, dynamic> json) {
    return ProductCategoryAdmin(
      productCategoryId: json['productCategoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'Active',
    );
  }
}

class ContentCategoryAdmin {
  final String contentCategoryId;
  final String categoryName;
  final String? description;
  final String status; // 'Active' | 'Inactive'

  ContentCategoryAdmin({
    required this.contentCategoryId,
    required this.categoryName,
    this.description,
    required this.status,
  });

  factory ContentCategoryAdmin.fromJson(Map<String, dynamic> json) {
    return ContentCategoryAdmin(
      contentCategoryId: json['contentCategoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'Active',
    );
  }
}
