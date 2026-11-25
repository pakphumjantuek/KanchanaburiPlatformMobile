class AdminContentItem {
  final String contentId;
  final String createdByUserId;
  final String? shopId;
  final String? shopName;
  final String contentCategoryId;
  final String? contentCategoryName;
  final String? districtId;
  final String? districtName;
  final String? subDistrictId;
  final String? subDistrictName;
  final String title;
  final String? summary;
  final double? latitude;
  final double? longitude;
  final String? youtubeUrl;
  final String status; // 'Draft' | 'Pending' | 'Published' | 'Archived'
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;

  AdminContentItem({
    required this.contentId,
    required this.createdByUserId,
    this.shopId,
    this.shopName,
    required this.contentCategoryId,
    this.contentCategoryName,
    this.districtId,
    this.districtName,
    this.subDistrictId,
    this.subDistrictName,
    required this.title,
    this.summary,
    this.latitude,
    this.longitude,
    this.youtubeUrl,
    required this.status,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminContentItem.fromJson(Map<String, dynamic> json) {
    return AdminContentItem(
      contentId: json['contentId'] as String? ?? '',
      createdByUserId: json['createdByUserId'] as String? ?? '',
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      contentCategoryId: json['contentCategoryId'] as String? ?? '',
      contentCategoryName: json['contentCategoryName'] as String?,
      districtId: json['districtId'] as String?,
      districtName: json['districtName'] as String?,
      subDistrictId: json['subDistrictId'] as String?,
      subDistrictName: json['subDistrictName'] as String?,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      youtubeUrl: json['youtubeUrl'] as String?,
      status: json['status'] as String? ?? 'Draft',
      publishedAt: json['publishedAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

class ContentFormData {
  final String title;
  final String summary;
  final String? contentCategoryId;
  final String? shopId;
  final String? districtId;
  final String? subDistrictId;
  final double? latitude;
  final double? longitude;
  final String youtubeUrl;
  final String status;

  ContentFormData({
    required this.title,
    required this.summary,
    this.contentCategoryId,
    this.shopId,
    this.districtId,
    this.subDistrictId,
    this.latitude,
    this.longitude,
    required this.youtubeUrl,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'contentCategoryId': contentCategoryId,
      'shopId': shopId,
      'districtId': districtId,
      'subDistrictId': subDistrictId,
      'latitude': latitude,
      'longitude': longitude,
      'youtubeUrl': youtubeUrl,
      'status': status,
    };
  }
}

class ContentOption {
  final String contentId;
  final String title;
  final String status;

  ContentOption({
    required this.contentId,
    required this.title,
    required this.status,
  });

  factory ContentOption.fromJson(Map<String, dynamic> json) {
    return ContentOption(
      contentId: json['contentId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class TagOption {
  final String tagId;
  final String tagName;
  final String status;

  TagOption({
    required this.tagId,
    required this.tagName,
    required this.status,
  });

  factory TagOption.fromJson(Map<String, dynamic> json) {
    return TagOption(
      tagId: json['tagId'] as String? ?? '',
      tagName: json['tagName'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }
}

class ContentTag {
  final String contentId;
  final String tagId;
  final String tagName;

  ContentTag({
    required this.contentId,
    required this.tagId,
    required this.tagName,
  });

  factory ContentTag.fromJson(Map<String, dynamic> json) {
    return ContentTag(
      contentId: json['contentId'] as String? ?? '',
      tagId: json['tagId'] as String? ?? '',
      tagName: json['tagName'] as String? ?? '',
    );
  }
}
