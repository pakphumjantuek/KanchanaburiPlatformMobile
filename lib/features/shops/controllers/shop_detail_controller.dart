import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projecte/features/contents/models/content_model.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/models/shop_review_model.dart';
import 'package:projecte/features/shops/repositories/shop_repository.dart';

class ShopDetailController extends GetxController {
  ShopDetailController({ShopRepository? repository})
    : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final shop = Rxn<ShopModel>();
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final shopContents = <ContentModel>[].obs;
  final reviews = <ShopReviewModel>[].obs;

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  final activeTab =
      0.obs; // 0: หน้าแรก, 1: สินค้า, 2: คอนเทนต์, 3: เกี่ยวกับ, 4: รีวิว

  // Product Filters & Sort
  final productSearchQuery = ''.obs;
  final selectedProductCategory = RxnString();
  final productSortOption =
      'popular'.obs; // popular, price_asc, price_desc, newest

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ShopModel) {
      shop.value = args;
      loadShopDetailAndProducts(args.id);
    } else if (args is String && args.isNotEmpty) {
      loadShopDetailAndProducts(args);
    } else if (Get.parameters['id'] != null) {
      loadShopDetailAndProducts(Get.parameters['id']!);
    }
  }

  Future<void> loadShopDetailAndProducts(String shopId) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final detail = await _repository.fetchShopById(shopId);
      if (detail != null) {
        shop.value = detail;
      }

      final shopProducts = await _repository.fetchProducts(shopId: shopId);
      products.assignAll(shopProducts);

      final contentsList = await _repository.fetchShopContents(shopId);
      shopContents.assignAll(contentsList);

      final shopReviews = await _repository.fetchShopReviews(shopId);
      reviews.assignAll(shopReviews);

      filterAndSortProducts();
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'ไม่สามารถโหลดข้อมูลร้านค้าได้ กรุณาลองใหม่อีกครั้ง';
    } finally {
      isLoading.value = false;
    }
  }

  void filterAndSortProducts() {
    List<ProductModel> list = List.from(products);

    // Filter search
    if (productSearchQuery.value.trim().isNotEmpty) {
      final q = productSearchQuery.value.trim().toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }

    // Sort
    switch (productSortOption.value) {
      case 'price_asc':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        // list remains in initial fetch order or reversed
        break;
      case 'popular':
      default:
        break;
    }

    filteredProducts.assignAll(list);
  }

  void setSearchQuery(String query) {
    productSearchQuery.value = query;
    filterAndSortProducts();
  }

  void setSortOption(String option) {
    productSortOption.value = option;
    filterAndSortProducts();
  }

  void setActiveTab(int index) {
    activeTab.value = index;
  }

  Future<void> shareShop() async {
    final currentShop = shop.value;
    if (currentShop == null) return;
    Get.snackbar(
      'แชร์ร้านค้า',
      'คัดลอกลิงก์ร้านค้า "${currentShop.name}" เรียบร้อยแล้ว',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF0F172A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  Future<void> openDirections() async {
    final currentShop = shop.value;
    if (currentShop?.latitude == null || currentShop?.longitude == null) {
      Get.snackbar(
        'ไม่พบลำดับพิกัด',
        'ร้านค้านี้ยังไม่ได้ระบุพิกัดแผนที่',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFC85A17),
        colorText: Colors.white,
      );
      return;
    }
    final lat = currentShop!.latitude;
    final lng = currentShop.longitude;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<double>(0.0, (acc, r) => acc + r.rating);
    return double.parse((total / reviews.length).toStringAsFixed(1));
  }

  int get reviewCount => reviews.length;
}
