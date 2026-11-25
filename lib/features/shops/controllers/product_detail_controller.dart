import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/cart/controllers/cart_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/models/shop_review_model.dart';
import 'package:projecte/features/shops/repositories/shop_repository.dart';

class ProductDetailController extends GetxController {
  ProductDetailController({ShopRepository? repository})
    : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final product = Rxn<ProductModel>();
  final sellerShop = Rxn<ShopModel>();
  final quantity = 1.obs;
  final isLoading = false.obs;

  final selectedImageIndex = 0.obs;
  final isFavorite = false.obs;
  final activeTab = 'details'.obs; // 'details' | 'reviews'

  final shopReviews = <ShopReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
      loadProductAndShop(args.id, args.shopId);
    } else if (args is String && args.isNotEmpty) {
      loadProductAndShop(args, null);
    } else if (Get.parameters['id'] != null) {
      loadProductAndShop(Get.parameters['id']!, null);
    }
  }

  Future<void> loadProductAndShop(String productId, String? shopId) async {
    isLoading.value = true;
    selectedImageIndex.value = 0;
    try {
      final item = await _repository.fetchProductById(productId);
      if (item != null) {
        product.value = item;
      }
      final targetShopId = shopId ?? product.value?.shopId;
      if (targetShopId != null && targetShopId.isNotEmpty) {
        final s = await _repository.fetchShopById(targetShopId);
        sellerShop.value = s;

        // Fetch reviews
        final reviews = await _repository.fetchShopReviews(targetShopId);
        shopReviews.assignAll(reviews);
      }
    } catch (e) {
      debugPrint('Error loading product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQuantity() {
    final maxQty = product.value?.quantity ?? 99;
    if (quantity.value < maxQty) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  void addToCart() {
    final current = product.value;
    if (current == null) return;
    Get.find<CartController>().addToCart(
      current,
      quantity: quantity.value,
      shopName: sellerShop.value?.name,
    );
  }

  void buyNow() {
    final current = product.value;
    if (current == null) return;
    Get.find<CartController>().addToCart(
      current,
      quantity: quantity.value,
      shopName: sellerShop.value?.name,
    );
    Get.toNamed(AppRoutes.cart);
  }
}
