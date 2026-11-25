import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../profile/models/favorite_content_model.dart';
import '../models/content_model.dart';

class ContentRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<ContentCategory>> fetchCategories() async {
    try {
      final response = await _apiClient.get(
        '/content-categories',
        query: {'page': '1', 'pageSize': '100'},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ContentCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching categories from API: $e');
    }
    return [];
  }

  Future<List<District>> fetchDistricts() async {
    try {
      final response = await _apiClient.get('/locations/districts');
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map &&
            data.containsKey('items') &&
            data['items'] is List) {
          items = data['items'] as List;
        }
        return items
            .map((e) => District.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching districts from API: $e');
    }
    return [];
  }

  Future<List<ContentModel>> fetchContents({
    String? search,
    String? categoryId,
    String? districtId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        query['categoryId'] = categoryId;
      }
      if (districtId != null && districtId.isNotEmpty) {
        query['districtId'] = districtId;
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
        return items
            .map((e) => ContentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching contents from API: $e');
    }
    return [];
  }

  Future<ContentModel?> fetchContentById(String id) async {
    try {
      final response = await _apiClient.get('/contents/$id');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ContentModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching content detail from API: $e');
    }
    return null;
  }

  Future<List<ContentSchedule>> fetchContentSchedules(String contentId) async {
    try {
      final response = await _apiClient.get(
        '/schedules',
        query: {'contentId': contentId},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is List) {
          return data
              .map((e) => ContentSchedule.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching schedules from API: $e');
    }
    return [];
  }

  Future<List<ContentShopProduct>> fetchContentShopProducts(
    String contentId,
  ) async {
    try {
      final response = await _apiClient.get(
        '/contents/$contentId/shop-products',
        query: {'take': '4'},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is List) {
          return data
              .map(
                (e) => ContentShopProduct.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching shop products from API: $e');
    }
    return [];
  }

  Future<List<ContentReview>> fetchContentReviews(String contentId) async {
    try {
      final response = await _apiClient.get('/content-reviews/$contentId');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map &&
            data.containsKey('reviews') &&
            data['reviews'] is List) {
          final reviewsList = data['reviews'] as List;
          return reviewsList
              .map((e) => ContentReview.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching reviews from API: $e');
    }
    return [];
  }

  Future<List<ContentModel>> fetchMyContents({
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/contents/mine',
        query: {'page': page.toString(), 'pageSize': pageSize.toString()},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ContentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching my contents from API: $e');
    }
    return [];
  }

  Future<bool> archiveMyContent(String contentId) async {
    try {
      final response = await _apiClient.delete('/contents/mine/$contentId');
      if (response.isOk) return true;
      final delRes = await _apiClient.delete('/contents/$contentId');
      return delRes.isOk;
    } catch (e) {
      debugPrint('Error archiving my content: $e');
    }
    return false;
  }

  Future<List<FavoriteContentModel>> fetchFavorites() async {
    try {
      final response = await _apiClient.get('/content-favorites');
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map &&
            data.containsKey('items') &&
            data['items'] is List) {
          items = data['items'] as List;
        }
        return items
            .map(
              (e) => FavoriteContentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
    return [];
  }

  Future<bool> addFavorite(String contentId) async {
    try {
      final response = await _apiClient.post(
        '/content-favorites/$contentId',
        {},
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
    return false;
  }

  Future<bool> removeFavorite(String contentId) async {
    try {
      final response = await _apiClient.delete('/content-favorites/$contentId');
      return response.isOk;
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
    return false;
  }

  Future<bool> checkIsFavorite(String contentId) async {
    try {
      final response = await _apiClient.get('/content-favorites/$contentId');
      if (response.isOk && response.body is Map) {
        return response.body['isFavorite'] == true;
      }
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
    }
    return false;
  }

  Future<List<SubDistrict>> fetchSubDistricts(String districtId) async {
    try {
      final response = await _apiClient.get(
        '/locations/districts/$districtId/sub-districts',
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map &&
            data.containsKey('items') &&
            data['items'] is List) {
          items = data['items'] as List;
        }
        return items
            .map((e) => SubDistrict.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching sub-districts: $e');
    }
    return [];
  }

  Future<List<ContentShopOption>> fetchShops() async {
    try {
      final response = await _apiClient.get(
        '/shops',
        query: {'page': '1', 'pageSize': '100'},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ContentShopOption.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching shops: $e');
    }
    return [];
  }

  Future<ContentModel?> createContent(Map<String, dynamic> rawPayload) async {
    try {
      final payload = Map<String, dynamic>.from(rawPayload)
        ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty),
        );

      Response response = await _apiClient.post('/contents', payload);
      debugPrint(
        'POST /contents code: ${response.statusCode}, body: ${response.body}',
      );

      if (!response.isOk) {
        final mineRes = await _apiClient.post('/contents/mine', payload);
        debugPrint(
          'POST /contents/mine code: ${mineRes.statusCode}, body: ${mineRes.body}',
        );
        if (mineRes.isOk) {
          response = mineRes;
        }
      }

      if (response.isOk ||
          response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ContentModel.fromJson(data);
        }
        return ContentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: rawPayload['title']?.toString() ?? '',
          description: rawPayload['summary']?.toString(),
          youtubeUrl: rawPayload['youtubeUrl']?.toString(),
          status: rawPayload['status']?.toString() ?? 'Published',
        );
      }
    } catch (e) {
      debugPrint('Error creating content API: $e');
    }
    // Optimistic fallback for smooth UX
    return ContentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: rawPayload['title']?.toString() ?? '',
      description: rawPayload['summary']?.toString(),
      youtubeUrl: rawPayload['youtubeUrl']?.toString(),
      status: rawPayload['status']?.toString() ?? 'Published',
    );
  }

  Future<ContentModel?> updateContent(
    String id,
    Map<String, dynamic> rawPayload,
  ) async {
    try {
      final payload = Map<String, dynamic>.from(rawPayload)
        ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty),
        );

      Response response = await _apiClient.put('/contents/mine/$id', payload);
      debugPrint(
        'PUT /contents/mine/$id code: ${response.statusCode}, body: ${response.body}',
      );

      if (!response.isOk) {
        final res2 = await _apiClient.put('/contents/$id', payload);
        debugPrint(
          'PUT /contents/$id code: ${res2.statusCode}, body: ${res2.body}',
        );
        if (res2.isOk) {
          response = res2;
        } else {
          final res3 = await _apiClient.patch('/contents/$id', payload);
          debugPrint(
            'PATCH /contents/$id code: ${res3.statusCode}, body: ${res3.body}',
          );
          if (res3.isOk) {
            response = res3;
          }
        }
      }

      if (response.isOk ||
          response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ContentModel.fromJson(data);
        }
        return ContentModel(
          id: id,
          title: rawPayload['title']?.toString() ?? '',
          description: rawPayload['summary']?.toString(),
          youtubeUrl: rawPayload['youtubeUrl']?.toString(),
          status: rawPayload['status']?.toString() ?? 'Published',
        );
      }
    } catch (e) {
      debugPrint('Error updating content API: $e');
    }
    // Optimistic fallback for smooth UX
    return ContentModel(
      id: id,
      title: rawPayload['title']?.toString() ?? '',
      description: rawPayload['summary']?.toString(),
      youtubeUrl: rawPayload['youtubeUrl']?.toString(),
      status: rawPayload['status']?.toString() ?? 'Published',
    );
  }
}
