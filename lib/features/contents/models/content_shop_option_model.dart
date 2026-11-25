class ContentShopOption {
  final String id;
  final String name;

  ContentShopOption({required this.id, required this.name});

  factory ContentShopOption.fromJson(Map<String, dynamic> json) {
    return ContentShopOption(
      id: json['shopId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['shopName']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}
