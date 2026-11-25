class ContentCategory {
  final String id;
  final String name;
  final String? description;

  ContentCategory({required this.id, required this.name, this.description});

  factory ContentCategory.fromJson(Map<String, dynamic> json) {
    return ContentCategory(
      id: json['contentCategoryId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['categoryName']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}
