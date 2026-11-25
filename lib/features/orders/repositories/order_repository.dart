import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../models/order_model.dart';
import '../models/user_address_model.dart';

class OrderRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Fetch user addresses
  /// API: GET /api/user-addresses
  Future<List<UserAddressModel>> fetchUserAddresses() async {
    try {
      final response = await _apiClient.get('/user-addresses');
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
            .map((e) => UserAddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching user addresses: $e');
    }
    return [];
  }

  /// Save new user address
  /// API: POST /api/user-addresses
  Future<UserAddressModel?> saveUserAddress(UserAddressModel address) async {
    try {
      final response = await _apiClient.post(
        '/user-addresses',
        address.toJson(),
      );
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return UserAddressModel.fromJson(
            response.body as Map<String, dynamic>,
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving user address: $e');
    }
    return null;
  }

  /// Submit Checkout
  /// API: POST /api/orders/checkout
  Future<List<OrderModel>> checkout({
    required String shippingMethod,
    required double shippingFee,
    required String receiverName,
    required String receiverPhone,
    required String shippingAddress,
    String? shopId,
  }) async {
    try {
      final body = <String, dynamic>{
        'shippingMethod': shippingMethod,
        'shippingFee': shippingFee,
        'receiverName': receiverName.trim(),
        'receiverPhone': receiverPhone.trim(),
        'shippingAddress': shippingAddress.trim(),
      };
      if (shopId != null && shopId.isNotEmpty) {
        body['shopId'] = shopId;
      }

      final response = await _apiClient.post('/orders/checkout', body);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map &&
            data.containsKey('items') &&
            data['items'] is List) {
          items = data['items'] as List;
        } else if (data is Map<String, dynamic>) {
          items = [data];
        }
        return items
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint(
          'Checkout failed: ${response.statusCode} - ${response.statusText}',
        );
      }
    } catch (e) {
      debugPrint('Error during checkout: $e');
    }
    return [];
  }

  /// Fetch user's orders
  /// API: GET /api/orders/mine
  Future<List<OrderModel>> fetchMyOrders() async {
    try {
      final response = await _apiClient.get('/orders/mine');
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
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching my orders: $e');
    }
    return [];
  }

  /// Fetch single order detail
  /// API: GET /api/orders/{id}
  Future<OrderModel?> fetchOrderById(String orderId) async {
    try {
      final response = await _apiClient.get('/orders/$orderId');
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return OrderModel.fromJson(response.body as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('Error fetching order by id: $e');
    }
    return null;
  }

  /// Customer confirms a paid, shipped order has been received.
  Future<bool> confirmShipmentReceived(String orderId) async {
    try {
      final response = await _apiClient.patch(
        '/orders/$orderId/shipment/status',
        {'status': 'Completed'},
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error confirming shipment received: $e');
      return false;
    }
  }

  Future<Set<String>> fetchReviewedProductIds(String orderId) async {
    try {
      final response = await _apiClient.get(
        '/product-reviews/my-reviews',
        query: {'orderId': orderId},
      );
      if (response.isOk && response.body is List) {
        return (response.body as List).map((id) => id.toString()).toSet();
      }
    } catch (e) {
      debugPrint('Error fetching order reviews: $e');
    }
    return {};
  }

  Future<bool> submitProductReview({
    required String orderId,
    required String productId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiClient.post('/product-reviews', {
        'orderId': orderId,
        'productId': productId,
        'rating': rating,
        'comment': comment.trim(),
      });
      return response.isOk;
    } catch (e) {
      debugPrint('Error submitting product review: $e');
      return false;
    }
  }

  /// Create payment intent
  /// API: POST /api/payments/orders/{orderId}/intent
  Future<Map<String, dynamic>?> createPaymentIntent(String orderId) async {
    try {
      final response = await _apiClient.post(
        '/payments/orders/$orderId/intent',
        {},
      );
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return response.body as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
    }
    return null;
  }

  /// Sync payment status with Stripe backend
  /// API: POST /api/payments/orders/{orderId}/sync
  Future<bool> syncPaymentStatus(String orderId) async {
    try {
      final response = await _apiClient.post(
        '/payments/orders/$orderId/sync',
        {},
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error syncing payment status: $e');
      return false;
    }
  }

  /// Upload slip image for order via POST /api/orders/{id}/upload-slip (multipart)
  Future<bool> updateOrderSlip(String orderId, String slipFilePath) async {
    final transferTime = DateTime.now().toIso8601String();

    // 1. Primary endpoint: POST /orders/{id}/upload-slip with multipart FormData
    if (!slipFilePath.startsWith('data:') && !slipFilePath.startsWith('http')) {
      try {
        final file = File(slipFilePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final ext = slipFilePath.split('.').last.toLowerCase();
          final mimeType = (ext == 'png' || ext == 'webp')
              ? 'image/$ext'
              : 'image/jpeg';

          final form = FormData({
            'slipFile': MultipartFile(
              bytes,
              filename: 'slip_${DateTime.now().millisecondsSinceEpoch}.$ext',
              contentType: mimeType,
            ),
            'transferTime': transferTime,
          });

          final response = await _apiClient.post(
            '/orders/$orderId/upload-slip',
            form,
          );

          if (response.isOk) {
            debugPrint(
              'Successfully uploaded slip via POST /orders/$orderId/upload-slip',
            );
            return true;
          } else {
            debugPrint(
              'POST /orders/$orderId/upload-slip returned ${response.statusCode}',
            );
          }
        } else {
          debugPrint('File does not exist at path: $slipFilePath');
        }
      } catch (e) {
        debugPrint('Error upload-slip multipart: $e');
      }
    }

    // 2. Fallback endpoint: PATCH /orders/{id}/status with paymentStatus: 'PendingVerification'
    try {
      final body = {
        'orderStatus': 'Pending',
        'paymentStatus': 'PendingVerification',
        'slipImageUrl': slipFilePath,
        'slipUploadedAt': transferTime,
      };

      final response = await _apiClient.patch('/orders/$orderId/status', body);
      debugPrint(
        'PATCH /orders/$orderId/status response: ${response.statusCode} ${response.isOk}',
      );
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating order slip fallback: $e');
      return false;
    }
  }

  /// Fetch pending slips for Admin verification
  /// API: GET /api/orders/admin/pending-slips
  Future<List<dynamic>> fetchPendingSlips() async {
    try {
      final response = await _apiClient.get('/orders/admin/pending-slips');
      if (response.isOk && response.body != null) {
        if (response.body is List) {
          return response.body as List;
        }
      }
    } catch (e) {
      debugPrint('Error fetching pending slips: $e');
    }
    return [];
  }

  /// Admin Verify / Reject Slip
  /// API: POST /api/orders/admin/verify-slip
  Future<bool> verifySlip(
    List<String> orderIds,
    String action, {
    String note = '',
  }) async {
    try {
      final body = {
        'orderIds': orderIds,
        'action': action, // 'approve' | 'reject'
        'note': note,
      };
      final response = await _apiClient.post('/orders/admin/verify-slip', body);
      return response.isOk;
    } catch (e) {
      debugPrint('Error verifying slip: $e');
      return false;
    }
  }
}
