import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../models/content_view_history_model.dart';

class ProfileRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Fetch user viewing history
  /// API: GET /content-views/history?take=24
  Future<List<ContentViewHistoryModel>> fetchViewingHistory({int take = 24}) async {
    try {
      final response = await _apiClient.get(
        '/content-views/history',
        query: {'take': take.toString()},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        }
        return items
            .map((e) => ContentViewHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('Fetch viewing history response not OK: ${response.statusCode} ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error fetching viewing history API: $e');
    }
    return [];
  }
}
