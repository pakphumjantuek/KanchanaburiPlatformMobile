import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../app/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../contents/models/district_model.dart';
import '../../orders/models/order_model.dart';
import '../../shops/models/category_model.dart';
import '../../shops/models/product_model.dart';
import '../../shops/models/shop_model.dart';
import '../models/merchant_dashboard_model.dart';
import '../../shops/models/product_deal_model.dart';

class MerchantRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<MerchantDashboardModel?> fetchDashboardReport() async {
    try {
      final response = await _apiClient.get('/shops/mine/dashboard');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return MerchantDashboardModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching dashboard report: $e');
    }
    return null;
  }

  Future<ShopModel?> fetchMyShop() async {
    try {
      final response = await _apiClient.get('/shops/mine');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ShopModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching my shop: $e');
    }
    return null;
  }

  Future<ShopModel?> createShop(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/shops', data);
      if (response.isOk && response.body != null) {
        final resData = response.body;
        if (resData is Map<String, dynamic>) {
          return ShopModel.fromJson(resData);
        }
      }
    } catch (e) {
      debugPrint('Error creating shop: $e');
    }
    return null;
  }

  Future<bool> updateShop(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/shops/$id', data);
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating shop: $e');
      return false;
    }
  }

  Future<List<ShopCategory>> fetchShopCategories() async {
    try {
      final response = await _apiClient.get(
        '/shop-categories',
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
            .map((e) => ShopCategory.fromJson(e as Map<String, dynamic>))
            .where((c) => c.status == 'Active')
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching shop categories: $e');
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
      debugPrint('Error fetching districts: $e');
    }
    return [];
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

  Future<List<ProductModel>> fetchMerchantProducts(String shopId) async {
    if (shopId.isEmpty) return [];
    try {
      final response = await _apiClient.get(
        '/products',
        query: {'shopId': shopId, 'page': '1', 'pageSize': '100'},
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
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .where(
              (p) =>
                  shopId.isEmpty ||
                  p.shopId.toLowerCase() == shopId.toLowerCase(),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching merchant products: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchProductCategories() async {
    try {
      final response = await _apiClient.get(
        '/product-categories',
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
            .map((e) => e as Map<String, dynamic>)
            .where((c) => c['status'] == 'Active' || c['status'] == null)
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching product categories: $e');
    }
    return [];
  }

  Future<ProductModel?> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/products', data);
      if (response.isOk && response.body != null) {
        final resData = response.body;
        if (resData is Map<String, dynamic>) {
          return ProductModel.fromJson(resData);
        }
      }
    } catch (e) {
      debugPrint('Error creating product: $e');
    }
    return null;
  }

  Future<bool> uploadProductCoverImage(
    String productId,
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('Cover image file does not exist at path: $filePath');
        return false;
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/products/$productId/cover-image',
      );
      debugPrint('Uploading product cover image to $uri');

      final request = http.MultipartRequest('POST', uri);

      if (_apiClient.authToken != null && _apiClient.authToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${_apiClient.authToken}';
      }

      String ext = filePath.split('.').last.toLowerCase();
      if (ext != 'png' && ext != 'webp' && ext != 'jpeg' && ext != 'jpg') {
        ext = 'jpg';
      }
      final mimeSubtype = (ext == 'png')
          ? 'png'
          : ((ext == 'webp') ? 'webp' : 'jpeg');
      final filename = 'cover_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: filename,
        contentType: MediaType('image', mimeSubtype),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(
        'Cover image upload response status: ${response.statusCode}, body: ${response.body}',
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('Error uploading product cover image: $e');
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/products/$id', data);
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  Future<List<OrderModel>> fetchMerchantOrders({
    String? orderStatus,
    String? paymentStatus,
  }) async {
    try {
      final query = <String, String>{};
      if (orderStatus != null &&
          orderStatus.isNotEmpty &&
          orderStatus != 'All') {
        query['orderStatus'] = orderStatus;
      }
      if (paymentStatus != null && paymentStatus.isNotEmpty) {
        query['paymentStatus'] = paymentStatus;
      }

      final response = await _apiClient.get('/orders/shop/mine', query: query);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching merchant orders: $e');
    }
    return [];
  }

  Future<bool> updateShipment(
    String orderId,
    String carrierName,
    String trackingNumber,
  ) async {
    try {
      final response = await _apiClient.put('/orders/$orderId/shipment', {
        'shippingProvider': carrierName,
        'trackingNumber': trackingNumber,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating shipment: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await _apiClient.delete('/products/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _apiClient.patch('/orders/$orderId/status', {
        'status': status,
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating order status: $e');
      return false;
    }
  }

  Future<List<ProductDealModel>> fetchProductDeals(String productId) async {
    try {
      final response = await _apiClient.get(
        '/product-deals/products/$productId',
      );
      if (response.isOk && response.body is List) {
        return (response.body as List)
            .map((e) => ProductDealModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching product deals: $e');
    }
    return [];
  }

  Future<bool> createProductDeal(
    String productId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.post(
        '/product-deals/products/$productId',
        data,
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error creating product deal: $e');
      return false;
    }
  }

  Future<bool> stopProductDeal(String dealId) async {
    try {
      final response = await _apiClient.patch(
        '/product-deals/$dealId/stop',
        {},
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error stopping product deal: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchContentCategories() async {
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
        return items.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (e) {
      debugPrint('Error fetching content categories: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchMerchantContents() async {
    try {
      final response = await _apiClient.get(
        '/contents/mine',
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
        return items.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (e) {
      debugPrint('Error fetching merchant contents: $e');
    }
    return [];
  }

  Future<bool> createContent(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/contents', data);
      return response.isOk;
    } catch (e) {
      debugPrint('Error creating content: $e');
      return false;
    }
  }

  Future<bool> updateContent(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/contents/$id', data);
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating content: $e');
      return false;
    }
  }

  Future<bool> deleteContent(String id) async {
    try {
      final response = await _apiClient.delete('/contents/$id');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting content: $e');
      return false;
    }
  }

  String buildExportUrl({
    required String exportType,
    required String fromDate,
    required String toDate,
    required String format,
    String? orderStatus,
    String? paymentStatus,
  }) {
    String endpoint = '/shops/mine/exports/orders';
    if (exportType == 'products') {
      endpoint = '/shops/mine/exports/products';
    } else if (exportType == 'payouts') {
      endpoint = '/shops/mine/exports/payouts';
    }

    final queryParams = <String, String>{
      'from': fromDate,
      'to': toDate,
      'format': format,
    };

    if (exportType == 'orders') {
      if (orderStatus != null &&
          orderStatus.isNotEmpty &&
          orderStatus != 'All') {
        queryParams['orderStatus'] = orderStatus;
      }
      if (paymentStatus != null &&
          paymentStatus.isNotEmpty &&
          paymentStatus != 'All') {
        queryParams['paymentStatus'] = paymentStatus;
      }
    }

    final token = _apiClient.authToken;
    if (token != null && token.isNotEmpty) {
      queryParams['token'] = token;
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$endpoint',
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }
}
