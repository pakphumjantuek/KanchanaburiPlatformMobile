import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shops/models/product_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class ManageProductsController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedFilter = 'all'.obs; // 'all', 'active', 'lowStock', 'outOfStock'

  int get totalCount => products.length;
  int get activeCount =>
      products.where((p) => p.status.toLowerCase() == 'active').length;
  int get lowStockCount =>
      products.where((p) => p.quantity > 0 && p.quantity <= 5).length;
  int get outOfStockCount => products.where((p) => p.quantity <= 0).length;

  List<ProductModel> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();
    return products.where((p) {
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          (p.description?.toLowerCase().contains(query) ?? false);
      if (!matchesSearch) return false;

      switch (selectedFilter.value) {
        case 'active':
          return p.status.toLowerCase() == 'active';
        case 'lowStock':
          return p.quantity > 0 && p.quantity <= 5;
        case 'outOfStock':
          return p.quantity <= 0;
        case 'all':
        default:
          return true;
      }
    }).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  @override
  void onInit() {
    super.onInit();
    checkAndUpdateFilter();
    loadProducts();
  }

  void checkAndUpdateFilter() {
    final param = Get.parameters['filter'] ??
        (Get.arguments is Map ? Get.arguments['filter'] : null);
    if (param != null && param.toString().isNotEmpty) {
      final val = param.toString();
      if (selectedFilter.value != val) {
        selectedFilter.value = val;
      }
    }
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final shop = await _repository.fetchMyShop();
      myShop.value = shop;
      if (shop != null && shop.id.isNotEmpty) {
        final list = await _repository.fetchMerchantProducts(shop.id);
        products.value = list;
      } else {
        products.clear();
      }
    } catch (e) {
      debugPrint('Error loading merchant products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmDeleteProduct(ProductModel product) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('ยืนยันการลบสินค้า'),
        content: Text('คุณต้องการลบสินค้า "${product.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await _repository.deleteProduct(product.id);
              if (success) {
                products.removeWhere((p) => p.id == product.id);
                Get.snackbar(
                  'ลบสินค้าสำเร็จ',
                  'ลบสินค้า "${product.name}" เรียบร้อยแล้ว',
                  backgroundColor: const Color(0xFF047857),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'เกิดข้อผิดพลาด',
                  'ไม่สามารถลบสินค้าได้ กรุณาลองใหม่อีกครั้ง',
                  backgroundColor: Colors.red.shade700,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ลบสินค้า'),
          ),
        ],
      ),
    );
  }
}
