class ShopCategory {
  final String id;
  final String name;
  final String? description;
  final String status;
  final bool hasImage;

  ShopCategory({
    required this.id,
    required this.name,
    this.description,
    this.status = 'Active',
    this.hasImage = false,
  });

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
      id: json['shopCategoryId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['categoryName']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? 'Active',
      hasImage: json['hasImage'] == true,
    );
  }
}
