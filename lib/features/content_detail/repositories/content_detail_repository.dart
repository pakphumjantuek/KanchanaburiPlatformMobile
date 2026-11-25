import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../models/content_detail_model.dart';
import '../models/content_schedule_model.dart';
import '../models/content_review_model.dart';
import '../../shops/models/shop_model.dart';
import '../../shops/models/product_model.dart';

class ContentDetailRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Fetch full content detail by ID
  Future<ContentDetailModel?> fetchContentDetail(String id) async {
    try {
      final response = await _apiClient.get('/contents/$id');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ContentDetailModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching content detail API: $e');
    }
    return null;
  }

  /// Fetch schedules for content
  Future<List<ContentScheduleModel>> fetchSchedules(String contentId) async {
    try {
      final response = await _apiClient.get(
        '/schedules',
        query: {'contentId': contentId},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is List) {
          return data
              .map(
                (e) => ContentScheduleModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching schedules API: $e');
    }
    return [];
  }

  /// Fetch user reviews for content
  Future<List<ContentReviewModel>> fetchReviews(String contentId) async {
    try {
      final response = await _apiClient.get('/content-reviews/$contentId');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map &&
            data.containsKey('reviews') &&
            data['reviews'] is List) {
          final list = data['reviews'] as List;
          return list
              .map(
                (e) => ContentReviewModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } else if (data is List) {
          return data
              .map(
                (e) => ContentReviewModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching reviews API: $e');
    }
    return [];
  }

  /// Fetch related shops
  Future<List<ShopModel>> fetchRelatedShops({String? shopId}) async {
    try {
      final query = {'page': '1', 'pageSize': '10'};
      if (shopId != null && shopId.isNotEmpty) {
        final res = await _apiClient.get('/shops/$shopId');
        if (res.isOk && res.body is Map<String, dynamic>) {
          return [ShopModel.fromJson(res.body as Map<String, dynamic>)];
        }
      }
      final response = await _apiClient.get('/shops', query: query);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching related shops API: $e');
    }
    return [];
  }

  /// Fetch related community products
  Future<List<ProductModel>> fetchRelatedProducts(String contentId) async {
    try {
      final response = await _apiClient.get(
        '/contents/$contentId/shop-products',
        query: {'take': '10'},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is List) {
          return data
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching related products API: $e');
    }
    return [];
  }

  /// Fetch related contents
  Future<List<ContentDetailModel>> fetchRelatedContents({
    String? categoryId,
    String? currentContentId,
  }) async {
    try {
      final query = <String, String>{'page': '1', 'pageSize': '10'};
      if (categoryId != null && categoryId.isNotEmpty) {
        query['categoryId'] = categoryId;
      }
      final response = await _apiClient.get('/contents', query: query);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        final list = items
            .map((e) => ContentDetailModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (currentContentId != null) {
          return list.where((item) => item.id != currentContentId).toList();
        }
        return list;
      }
    } catch (e) {
      debugPrint('Error fetching related contents API: $e');
    }
    return [];
  }

  /// Post a new review
  Future<bool> postReview(
    String contentId,
    String comment,
    double rating,
  ) async {
    try {
      final response = await _apiClient.post('/content-reviews/$contentId', {
        'comment': comment,
        'rating': rating,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error posting review API: $e');
      return false;
    }
  }

  /// Delete a review
  Future<bool> deleteReview(String reviewId) async {
    try {
      final response = await _apiClient.delete('/content-reviews/$reviewId');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting review API: $e');
      return false;
    }
  }

  /// Report content
  Future<bool> reportContent(String contentId, String reason) async {
    try {
      final response = await _apiClient.post('/reports', {
        'contentId': contentId,
        'reason': reason,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error reporting content API: $e');
      return false;
    }
  }

  /// Add content to favorites API
  Future<bool> addFavorite(String contentId) async {
    try {
      final response = await _apiClient.post(
        '/content-favorites/$contentId',
        {},
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error adding favorite API: $e');
      return false;
    }
  }

  /// Remove content from favorites API
  Future<bool> removeFavorite(String contentId) async {
    try {
      final response = await _apiClient.delete('/content-favorites/$contentId');
      return response.isOk;
    } catch (e) {
      debugPrint('Error removing favorite API: $e');
      return false;
    }
  }

  /// Check if content is favorited
  Future<bool> checkIsFavorite(String contentId) async {
    try {
      final response = await _apiClient.get('/content-favorites/$contentId');
      if (response.isOk && response.body is Map) {
        return response.body['isFavorite'] == true;
      }
    } catch (e) {
      debugPrint('Error checking favorite API: $e');
    }
    return false;
  }

  /// Record content view history
  Future<bool> recordContentView(String contentId) async {
    try {
      var response = await _apiClient.post('/content-views/$contentId', {});
      if (!response.isOk) {
        response = await _apiClient.post('/content-views', {
          'contentId': contentId,
        });
      }
      return response.isOk;
    } catch (e) {
      debugPrint('Error recording content view: $e');
      return false;
    }
  }
}
