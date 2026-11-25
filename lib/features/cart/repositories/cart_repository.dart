import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class CartRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Fetch user's cart from backend database
  /// API: GET /api/cart
  Future<Map<String, dynamic>?> fetchCart() async {
    try {
      final response = await _apiClient.get('/cart');
      if (response.isOk && response.body != null) {
        if (response.body is Map<String, dynamic>) {
          return response.body as Map<String, dynamic>;
        }
      } else {
        debugPrint(
          'Fetch cart failed: ${response.statusCode} - ${response.statusText}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }
    return null;
  }

  /// Add item to cart on backend
  /// API: POST /api/cart/items
  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final body = {'productId': productId, 'quantity': quantity};
      final response = await _apiClient.post('/cart/items', body);
      return response.isOk;
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
      return false;
    }
  }

  /// Update item quantity in cart on backend
  /// API: PUT /api/cart/items/{id}
  Future<bool> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      final body = {'quantity': quantity};
      final response = await _apiClient.put('/cart/items/$cartItemId', body);
      return response.isOk;
    } catch (e) {
      debugPrint('Error updating cart item quantity: $e');
      return false;
    }
  }

  /// Delete item from cart on backend
  /// API: DELETE /api/cart/items/{id}
  Future<bool> deleteCartItem(String cartItemId) async {
    try {
      final response = await _apiClient.delete('/cart/items/$cartItemId');
      return response.isOk;
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
      return false;
    }
  }
}
