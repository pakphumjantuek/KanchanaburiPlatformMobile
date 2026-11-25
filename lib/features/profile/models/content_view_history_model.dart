import '../../../app/config/api_config.dart';

class ContentViewHistoryModel {
  final String contentId;
  final String title;
  final String? summary;
  final String? coverImageUrl;
  final String? youtubeUrl;
  final String? viewedAt;

  ContentViewHistoryModel({
    required this.contentId,
    required this.title,
    this.summary,
    this.coverImageUrl,
    this.youtubeUrl,
    this.viewedAt,
  });

  factory ContentViewHistoryModel.fromJson(Map<String, dynamic> json) {
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

    final rawViewedAt = json['viewedAt']?.toString() ??
        json['viewDate']?.toString() ??
        json['createdAt']?.toString() ??
        json['updatedAt']?.toString() ??
        json['timestamp']?.toString() ??
        json['created_at']?.toString() ??
        json['viewed_at']?.toString();

    return ContentViewHistoryModel(
      contentId: json['contentId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ไม่มีชื่อเรื่อง',
      summary: json['summary']?.toString() ?? json['description']?.toString(),
      coverImageUrl: resolveUrl(
        json['coverImageUrl'] ?? json['imageUrl'] ?? json['thumbnailUrl'],
      ),
      youtubeUrl: json['youtubeUrl']?.toString(),
      viewedAt: rawViewedAt,
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

  String get displayImage {
    if (coverImageUrl != null && coverImageUrl!.isNotEmpty) {
      return coverImageUrl!;
    }
    if (youtubeThumbnail.isNotEmpty) {
      return youtubeThumbnail;
    }
    return '';
  }

  DateTime? get parsedDateTime {
    return _parseUtcDateTime(viewedAt);
  }

  static DateTime? _parseUtcDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    String str = raw.trim();
    // If ISO string without Z or offset, append Z for UTC
    if (str.contains('T')) {
      if (!str.endsWith('Z') && !RegExp(r'[\+\-]\d{2}:?\d{2}$').hasMatch(str)) {
        str = '${str}Z';
      }
    } else if (RegExp(r'^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}').hasMatch(str)) {
      str = '${str.replaceAll(' ', 'T')}Z';
    }

    try {
      final dt = DateTime.tryParse(str);
      if (dt != null) {
        return dt.toLocal();
      }
    } catch (_) {}

    try {
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        return dt.toLocal();
      }
    } catch (_) {}

    return null;
  }

  String get formattedViewedAt {
    if (viewedAt == null || viewedAt!.isEmpty) return '';
    final dt = parsedDateTime;
    if (dt == null) return viewedAt!;

    final now = DateTime.now();
    final diff = now.difference(dt);

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day;

    if (isToday) {
      if (diff.inSeconds >= 0 && diff.inMinutes < 1) {
        return 'เมื่อสักครู่ ($hour:$minute น.)';
      } else if (diff.inSeconds >= 0 && diff.inMinutes < 60) {
        return '${diff.inMinutes} นาทีที่แล้ว ($hour:$minute น.)';
      } else {
        return 'วันนี้ $hour:$minute น.';
      }
    } else if (isYesterday) {
      return 'เมื่อวานนี้ $hour:$minute น.';
    } else {
      final day = dt.day.toString().padLeft(2, '0');
      final month = _thaiMonthAbbr(dt.month);
      final year = (dt.year + 543) % 100;
      return '$day $month $year, $hour:$minute น.';
    }
  }

  static String _thaiMonthAbbr(int month) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
