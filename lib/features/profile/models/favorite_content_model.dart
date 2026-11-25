import '../../../app/config/api_config.dart';

class FavoriteContentModel {
  final String contentId;
  final String title;
  final String? summary;
  final String? coverImageUrl;
  final String? youtubeUrl;
  final String? createdAt;

  FavoriteContentModel({
    required this.contentId,
    required this.title,
    this.summary,
    this.coverImageUrl,
    this.youtubeUrl,
    this.createdAt,
  });

  factory FavoriteContentModel.fromJson(Map<String, dynamic> json) {
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

    return FavoriteContentModel(
      contentId: json['contentId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ไม่มีชื่อเรื่อง',
      summary: json['summary']?.toString() ?? json['description']?.toString(),
      coverImageUrl: resolveUrl(json['coverImageUrl'] ?? json['imageUrl']),
      youtubeUrl: json['youtubeUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

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
}
