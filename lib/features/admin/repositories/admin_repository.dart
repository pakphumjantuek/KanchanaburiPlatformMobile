import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../app/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../shops/models/product_model.dart';
import '../../shops/models/shop_model.dart';
import '../models/admin_category_model.dart';
import '../models/admin_content_model.dart';
import '../models/admin_dashboard_model.dart';
import '../models/admin_merchant_payout_model.dart';
import '../models/admin_order_slip_model.dart';
import '../models/admin_report_model.dart';
import '../models/admin_schedule_model.dart';
import '../models/admin_shop_product_model.dart';
import '../models/admin_tag_model.dart';

class AdminRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // ==========================================
  // 1. Admin Dashboard & Exports
  // ==========================================
  Future<AdminDashboardReport?> fetchDashboardReport({String? from, String? to}) async {
    try {
      final queryParams = <String, String>{};
      if (from != null && from.isNotEmpty) queryParams['from'] = from;
      if (to != null && to.isNotEmpty) queryParams['to'] = to;

      final queryStr = Uri(queryParameters: queryParams).query;
      final endpoint = queryStr.isNotEmpty ? '/admin/dashboard?$queryStr' : '/admin/dashboard';

      final response = await _apiClient.get(endpoint);
      if (response.isOk && response.body != null) {
        return AdminDashboardReport.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error fetching dashboard report: $e');
    }
    return null;
  }

  Future<String?> exportReport(String type, AdminExportParams params) async {
    try {
      final queryStr = Uri(queryParameters: params.toQueryParameters()).query;
      final endpoint = '/admin/exports/$type?$queryStr';
      final response = await _apiClient.get(endpoint);
      if (response.isOk) {
        return 'ดาวน์โหลดไฟล์ $type.${params.format} สำเร็จ';
      }
    } catch (e) {
      debugPrint('Error exporting $type: $e');
    }
    return null;
  }

  String buildAdminExportUrl({
    required String exportType,
    String? fromDate,
    String? toDate,
    required String format,
    String? shopId,
    String? orderStatus,
    String? paymentStatus,
    String? payoutStatus,
  }) {
    final endpoint = '/admin/exports/$exportType';

    final queryParams = <String, String>{
      'format': format,
    };
    if (fromDate != null && fromDate.isNotEmpty) queryParams['from'] = fromDate;
    if (toDate != null && toDate.isNotEmpty) queryParams['to'] = toDate;
    if (shopId != null && shopId.isNotEmpty) queryParams['shopId'] = shopId;
    if (orderStatus != null && orderStatus.isNotEmpty) queryParams['orderStatus'] = orderStatus;
    if (paymentStatus != null && paymentStatus.isNotEmpty) queryParams['paymentStatus'] = paymentStatus;
    if (payoutStatus != null && payoutStatus.isNotEmpty) queryParams['payoutStatus'] = payoutStatus;

    final token = _apiClient.authToken;
    if (token != null && token.isNotEmpty) {
      queryParams['token'] = token;
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$endpoint',
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }

  // ==========================================
  // 2. Order Slip Verification
  // ==========================================
  Future<List<AdminPendingSlipGroup>> fetchPendingSlips() async {
    try {
      final response = await _apiClient.get('/orders/admin/pending-slips');
      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => AdminPendingSlipGroup.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching pending slips: $e');
    }
    return [];
  }

  Future<bool> verifySlip(VerifySlipPayload payload) async {
    try {
      final response = await _apiClient.post('/orders/admin/verify-slip', payload.toJson());
      return response.isOk;
    } catch (e) {
      debugPrint('Error verifying slip: $e');
      return false;
    }
  }

  // ==========================================
  // 3. Merchant Payout Management
  // ==========================================
  Future<List<AdminMerchantPayoutGroup>> fetchPayouts() async {
    try {
      final response = await _apiClient.get('/orders/admin/payouts');
      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => AdminMerchantPayoutGroup.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching payouts: $e');
    }
    return [];
  }

  Future<List<MerchantPayoutRecord>> fetchPayoutHistory() async {
    try {
      final response = await _apiClient.get('/orders/admin/payouts/history');
      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => MerchantPayoutRecord.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching payout history: $e');
    }
    return [];
  }

  Future<bool> confirmPayout({
    required String shopId,
    required List<String> orderIds,
    String? transactionRef,
    String? note,
    File? slipFile,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/orders/admin/payouts/confirm');
      final request = http.MultipartRequest('POST', uri);

      if (_apiClient.authToken != null && _apiClient.authToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${_apiClient.authToken}';
      }

      request.fields['shopId'] = shopId;
      request.fields['orderIds'] = orderIds.join(',');
      if (transactionRef != null) request.fields['transactionRef'] = transactionRef;
      if (note != null) request.fields['note'] = note;

      if (slipFile != null) {
        final stream = http.ByteStream(slipFile.openRead());
        final length = await slipFile.length();
        final ext = slipFile.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? MediaType('image', 'png') : MediaType('image', 'jpeg');

        final multipartFile = http.MultipartFile(
          'slipFile',
          stream,
          length,
          filename: slipFile.path.split('/').last,
          contentType: mimeType,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (e) {
      debugPrint('Error confirming payout: $e');
      return false;
    }
  }

  // ==========================================
  // 4. Shop Management
  // ==========================================
  Future<PagedResult<ShopModel>?> fetchAdminShops({
    String? search,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (status != null && status.isNotEmpty) params['status'] = status;

      final queryStr = Uri(queryParameters: params).query;
      final response = await _apiClient.get('/shops/admin?$queryStr');

      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => ShopModel.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching admin shops: $e');
    }
    return null;
  }

  Future<bool> updateShopStatus(String shopId, String status) async {
    try {
      final response = await _apiClient.patch('/shops/$shopId/status', {'status': status});
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating shop status: $e');
      return false;
    }
  }

  // ==========================================
  // 5. Product Management
  // ==========================================
  Future<PagedResult<ProductModel>?> fetchAdminProducts({
    required String shopId,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'shopId': shopId,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) params['status'] = status;

      final queryStr = Uri(queryParameters: params).query;
      final response = await _apiClient.get('/products/admin?$queryStr');

      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => ProductModel.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching admin products: $e');
    }
    return null;
  }

  Future<bool> updateProductStatus(String productId, String status) async {
    try {
      final response = await _apiClient.patch('/products/$productId/status', {'status': status});
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating product status: $e');
      return false;
    }
  }

  // ==========================================
  // 6. Shop Category Management
  // ==========================================
  Future<PagedResult<ShopCategoryAdmin>?> fetchShopCategories({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get('/shop-categories?page=$page&pageSize=$pageSize');
      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => ShopCategoryAdmin.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching shop categories: $e');
    }
    return null;
  }

  Future<ShopCategoryAdmin?> createShopCategory(String name, String description) async {
    try {
      final response = await _apiClient.post('/shop-categories', {
        'categoryName': name,
        'description': description,
      });
      if (response.isOk && response.body != null) {
        return ShopCategoryAdmin.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error creating shop category: $e');
    }
    return null;
  }

  Future<bool> updateShopCategory(String id, String name, String description, String status) async {
    try {
      final response = await _apiClient.put('/shop-categories/$id', {
        'categoryName': name,
        'description': description,
        'status': status,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating shop category: $e');
      return false;
    }
  }

  Future<bool> deleteShopCategory(String id) async {
    try {
      final response = await _apiClient.delete('/shop-categories/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting shop category: $e');
      return false;
    }
  }

  // ==========================================
  // 7. Product Category Management
  // ==========================================
  Future<PagedResult<ProductCategoryAdmin>?> fetchProductCategories({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get('/product-categories?page=$page&pageSize=$pageSize');
      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => ProductCategoryAdmin.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching product categories: $e');
    }
    return null;
  }

  Future<bool> createProductCategory(String name, String description) async {
    try {
      final response = await _apiClient.post('/product-categories', {
        'categoryName': name,
        'description': description,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error creating product category: $e');
      return false;
    }
  }

  Future<bool> updateProductCategory(String id, String name, String description, String status) async {
    try {
      final response = await _apiClient.put('/product-categories/$id', {
        'categoryName': name,
        'description': description,
        'status': status,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating product category: $e');
      return false;
    }
  }

  Future<bool> deleteProductCategory(String id) async {
    try {
      final response = await _apiClient.delete('/product-categories/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting product category: $e');
      return false;
    }
  }

  // ==========================================
  // 8. Content Management
  // ==========================================
  Future<PagedResult<AdminContentItem>?> fetchAdminContents({
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) params['status'] = status;

      final queryStr = Uri(queryParameters: params).query;
      final response = await _apiClient.get('/contents/admin?$queryStr');

      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => AdminContentItem.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching admin contents: $e');
    }
    return null;
  }

  Future<AdminContentItem?> createContent(ContentFormData data) async {
    try {
      final response = await _apiClient.post('/contents', data.toJson());
      if (response.isOk && response.body != null) {
        return AdminContentItem.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error creating content: $e');
    }
    return null;
  }

  Future<bool> updateContent(String id, ContentFormData data) async {
    try {
      final response = await _apiClient.put('/contents/$id', data.toJson());
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating content: $e');
      return false;
    }
  }

  Future<bool> archiveContent(String id) async {
    try {
      final response = await _apiClient.delete('/contents/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error archiving content: $e');
      return false;
    }
  }

  // ==========================================
  // 9. Content Category Management
  // ==========================================
  Future<PagedResult<ContentCategoryAdmin>?> fetchContentCategories({
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) params['status'] = status;

      final queryStr = Uri(queryParameters: params).query;
      final response = await _apiClient.get('/content-categories/admin?$queryStr');

      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => ContentCategoryAdmin.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching content categories: $e');
    }
    return null;
  }

  Future<ContentCategoryAdmin?> createContentCategory(String name, String description) async {
    try {
      final response = await _apiClient.post('/content-categories', {
        'categoryName': name,
        'description': description,
      });
      if (response.isOk && response.body != null) {
        return ContentCategoryAdmin.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error creating content category: $e');
    }
    return null;
  }

  Future<bool> updateContentCategory(String id, String name, String description, String status) async {
    try {
      final response = await _apiClient.put('/content-categories/$id', {
        'categoryName': name,
        'description': description,
        'status': status,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating content category: $e');
      return false;
    }
  }

  Future<bool> deleteContentCategory(String id) async {
    try {
      final response = await _apiClient.delete('/content-categories/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting content category: $e');
      return false;
    }
  }

  // ==========================================
  // 10. Tag Management
  // ==========================================
  Future<PagedResult<AdminTag>?> fetchAdminTags({
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) params['status'] = status;

      final queryStr = Uri(queryParameters: params).query;
      final response = await _apiClient.get('/tags/admin?$queryStr');

      if (response.isOk && response.body != null) {
        return PagedResult.fromJson(
          Map<String, dynamic>.from(response.body),
          (json) => AdminTag.fromJson(json),
        );
      }
    } catch (e) {
      debugPrint('Error fetching admin tags: $e');
    }
    return null;
  }

  Future<AdminTag?> createTag(String name) async {
    try {
      final response = await _apiClient.post('/tags', {'tagName': name});
      if (response.isOk && response.body != null) {
        return AdminTag.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error creating tag: $e');
    }
    return null;
  }

  Future<bool> updateTag(String id, String name, String status) async {
    try {
      final response = await _apiClient.put('/tags/$id', {
        'tagName': name,
        'status': status,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating tag: $e');
      return false;
    }
  }

  Future<bool> deleteTag(String id) async {
    try {
      final response = await _apiClient.delete('/tags/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting tag: $e');
      return false;
    }
  }

  // ==========================================
  // 11. Content Tag Binding
  // ==========================================
  Future<List<TagOption>> fetchActiveTags() async {
    try {
      final response = await _apiClient.get('/tags');
      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => TagOption.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching active tags: $e');
    }
    return [];
  }

  Future<List<ContentTag>> fetchContentTags(String contentId) async {
    try {
      final response = await _apiClient.get('/content-tags?contentId=$contentId');
      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => ContentTag.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching content tags: $e');
    }
    return [];
  }

  Future<bool> updateContentTags(String contentId, List<String> tagIds) async {
    try {
      final response = await _apiClient.put('/content-tags/$contentId', {
        'tagIds': tagIds,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating content tags: $e');
      return false;
    }
  }

  // ==========================================
  // 12. Schedule Management
  // ==========================================
  Future<List<AdminSchedule>> fetchAdminSchedules({String? contentId}) async {
    try {
      final endpoint = (contentId != null && contentId.isNotEmpty)
          ? '/schedules/admin?contentId=$contentId'
          : '/schedules/admin';
      final response = await _apiClient.get(endpoint);

      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => AdminSchedule.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching admin schedules: $e');
    }
    return [];
  }

  Future<AdminSchedule?> createSchedule(ScheduleFormData data) async {
    try {
      final response = await _apiClient.post('/schedules', data.toJson());
      if (response.isOk && response.body != null) {
        return AdminSchedule.fromJson(Map<String, dynamic>.from(response.body));
      }
    } catch (e) {
      debugPrint('Error creating schedule: $e');
    }
    return null;
  }

  Future<bool> updateSchedule(String id, ScheduleFormData data) async {
    try {
      final response = await _apiClient.put('/schedules/$id', data.toJson());
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating schedule: $e');
      return false;
    }
  }

  Future<bool> deleteSchedule(String id) async {
    try {
      final response = await _apiClient.delete('/schedules/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
      return false;
    }
  }

  // ==========================================
  // 13. Report & Violation Management
  // ==========================================
  Future<List<AdminReport>> fetchAdminReports({String? status}) async {
    try {
      final endpoint = (status != null && status.isNotEmpty)
          ? '/reports/admin?status=$status'
          : '/reports/admin';
      final response = await _apiClient.get(endpoint);

      if (response.isOk && response.body != null) {
        final list = response.body as List<dynamic>;
        return list
            .map((e) => AdminReport.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching admin reports: $e');
    }
    return [];
  }

  Future<bool> updateReportStatus(String reportId, String status) async {
    try {
      final response = await _apiClient.patch('/reports/$reportId/status', {'status': status});
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating report status: $e');
      return false;
    }
  }
}
