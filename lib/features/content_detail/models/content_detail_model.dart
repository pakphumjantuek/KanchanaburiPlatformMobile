class ContentDetailModel {
  final String id;
  final String title;
  final String? description;
  final String? body;
  final String? categoryId;
  final String? categoryName;
  final String? districtId;
  final String? districtName;
  final String? subDistrictId;
  final String? subDistrictName;
  final String? shopId;
  final String? shopName;
  final double? latitude;
  final double? longitude;
  final String? youtubeUrl;
  final String? coverImageUrl;
  final int viewCount;
  final double rating;
  final String? publishedAt;
  final bool isFavorite;
  final List<String> tags;
  final String? openingHours;
  final String? admissionFee;
  final String? organizer;
  final String? phone;
  final String? website;

  ContentDetailModel({
    required this.id,
    required this.title,
    this.description,
    this.body,
    this.categoryId,
    this.categoryName,
    this.districtId,
    this.districtName,
    this.subDistrictId,
    this.subDistrictName,
    this.shopId,
    this.shopName,
    this.latitude,
    this.longitude,
    this.youtubeUrl,
    this.coverImageUrl,
    this.viewCount = 0,
    this.rating = 5.0,
    this.publishedAt,
    this.isFavorite = false,
    this.tags = const [],
    this.openingHours,
    this.admissionFee,
    this.organizer,
    this.phone,
    this.website,
  });

  factory ContentDetailModel.fromJson(Map<String, dynamic> json) {
    var rawTags = json['tags'];
    List<String> parsedTags = [];
    if (rawTags is List) {
      parsedTags = rawTags
          .map((e) {
            if (e is Map) {
              return e['tagName']?.toString() ?? e['name']?.toString() ?? '';
            }
            return e.toString();
          })
          .where((t) => t.isNotEmpty)
          .toList();
    }

    double? parseCoord(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    return ContentDetailModel(
      id: json['contentId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ไม่มีชื่อเรื่อง',
      description:
          json['summary']?.toString() ?? json['description']?.toString(),
      body:
          json['content']?.toString() ??
          json['body']?.toString() ??
          json['details']?.toString(),
      categoryId:
          json['contentCategoryId']?.toString() ??
          json['categoryId']?.toString(),
      categoryName:
          json['contentCategoryName']?.toString() ??
          json['categoryName']?.toString(),
      districtId: json['districtId']?.toString(),
      districtName: json['districtName']?.toString(),
      subDistrictId: json['subDistrictId']?.toString(),
      subDistrictName: json['subDistrictName']?.toString(),
      shopId: json['shopId']?.toString(),
      shopName: json['shopName']?.toString(),
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      youtubeUrl: json['youtubeUrl']?.toString(),
      coverImageUrl:
          json['coverImageUrl']?.toString() ?? json['imageUrl']?.toString(),
      viewCount: int.tryParse(json['viewCount']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      publishedAt:
          json['publishedAt']?.toString() ?? json['createdAt']?.toString(),
      isFavorite: json['isFavorite'] == true,
      tags: parsedTags,
      openingHours:
          json['openingHours']?.toString() ?? json['businessHours']?.toString(),
      admissionFee:
          json['admissionFee']?.toString() ?? json['ticketPrice']?.toString(),
      organizer:
          json['organizer']?.toString() ?? json['authorName']?.toString(),
      phone: json['phone']?.toString() ?? json['contactPhone']?.toString(),
      website: json['website']?.toString() ?? json['url']?.toString(),
    );
  }

  ContentDetailModel copyWith({
    bool? isFavorite,
    int? viewCount,
    double? rating,
  }) {
    return ContentDetailModel(
      id: id,
      title: title,
      description: description,
      body: body,
      categoryId: categoryId,
      categoryName: categoryName,
      districtId: districtId,
      districtName: districtName,
      subDistrictId: subDistrictId,
      subDistrictName: subDistrictName,
      shopId: shopId,
      shopName: shopName,
      latitude: latitude,
      longitude: longitude,
      youtubeUrl: youtubeUrl,
      coverImageUrl: coverImageUrl,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      publishedAt: publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags,
      openingHours: openingHours,
      admissionFee: admissionFee,
      organizer: organizer,
      phone: phone,
      website: website,
    );
  }

  /// Full-HD thumbnail (1280x720). Not every video has one, so callers
  /// should fall back to [youtubeThumbnail] when it fails to load.
  String get youtubeThumbnailHd =>
      youtubeThumbnail.replaceFirst('mqdefault.jpg', 'maxresdefault.jpg');

  String get youtubeThumbnail {
    if (youtubeUrl == null || youtubeUrl!.isEmpty) return '';
    try {
      final uri = Uri.parse(youtubeUrl!);
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else {
        videoId = uri.queryParameters['v'];
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://i.ytimg.com/vi/$videoId/mqdefault.jpg';
      }
    } catch (_) {}
    return '';
  }

  String get fullLocationText {
    final parts = <String>[];
    if (shopName != null && shopName!.isNotEmpty) {
      parts.add(shopName!);
    }
    if (subDistrictName != null && subDistrictName!.isNotEmpty) {
      parts.add('ต.$subDistrictName');
    }
    if (districtName != null && districtName!.isNotEmpty) {
      parts.add('อ.$districtName');
    }
    if (parts.isEmpty) return 'กาญจนบุรี';
    return parts.join(' · ');
  }
}
