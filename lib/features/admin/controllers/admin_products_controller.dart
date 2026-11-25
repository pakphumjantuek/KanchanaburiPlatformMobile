import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shops/models/product_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/admin_repository.dart';

class AdminProductsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();
  int _loadToken = 0;

  final shopId = ''.obs;
  final shopName = ''.obs;
  final shopModel = Rxn<ShopModel>();

  final isLoading = false.obs;
  final isUpdatingStatus = false.obs;
  final products = <ProductModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;

  final searchQuery = ''.obs;
  final selectedStatus = ''.obs; // '' | 'Active' | 'Inactive' | 'LowStock'

  // Metric counts
  final totalProductsCount = 0.obs;
  final activeCount = 0.obs;
  final inactiveCount = 0.obs;
  final lowStockCount = 0.obs;

  void setShop(String id, String name, {ShopModel? model}) {
    _loadToken++;
    shopId.value = id;
    shopName.value = name;
    shopModel.value = model;
    selectedStatus.value = '';
    searchQuery.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
    totalCount.value = 0;
    products.clear();
    isLoading.value = false;
    loadData();
  }

  Future<void> loadData({int page = 1}) async {
    await Future.wait([
      loadProducts(page: page),
      loadCounts(),
    ]);
  }

  Future<void> loadProducts({int page = 1}) async {
    if (shopId.value.isEmpty) return;
    final requestedShopId = shopId.value;
    final requestedStatus = selectedStatus.value == 'LowStock' ? null : (selectedStatus.value.isEmpty ? null : selectedStatus.value);
    final loadToken = ++_loadToken;
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminProducts(
        shopId: requestedShopId,
        status: requestedStatus,
        page: page,
        pageSize: 10,
      );

      if (loadToken != _loadToken) return;

      if (paged != null) {
        products.assignAll(paged.items);
        totalPages.value = paged.totalPages > 0 ? paged.totalPages : 1;
        totalCount.value = paged.totalCount;
      } else {
        products.clear();
        totalPages.value = 1;
        totalCount.value = 0;
      }
    } catch (e) {
      debugPrint('Error loading admin products: $e');
      products.clear();
    } finally {
      if (loadToken == _loadToken) isLoading.value = false;
    }
  }

  Future<void> loadCounts() async {
    if (shopId.value.isEmpty) return;
    try {
      final results = await Future.wait([
        _repository.fetchAdminProducts(shopId: shopId.value, pageSize: 1),
        _repository.fetchAdminProducts(shopId: shopId.value, status: 'Active', pageSize: 1),
        _repository.fetchAdminProducts(shopId: shopId.value, status: 'Inactive', pageSize: 1),
      ]);

      if (results[0] != null) totalProductsCount.value = results[0]!.totalCount;
      if (results[1] != null) activeCount.value = results[1]!.totalCount;
      if (results[2] != null) inactiveCount.value = results[2]!.totalCount;

      // Low stock count from current batch or estimate
      lowStockCount.value = products.where((p) => p.quantity <= 5).length;
    } catch (e) {
      debugPrint('Error loading product counts: $e');
    }
  }

  List<ProductModel> get filteredProducts {
    var list = products.toList();
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.trim().toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    if (selectedStatus.value == 'LowStock') {
      list = list.where((p) => p.quantity <= 5).toList();
    }
    return list;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void selectStatus(String status) {
    selectedStatus.value = status;
    if (status != 'LowStock') {
      loadProducts(page: 1);
    }
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      loadProducts(page: page);
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      setPage(currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      setPage(currentPage.value - 1);
    }
  }

  Future<bool> toggleProductStatus(
    String productId,
    String currentStatus,
  ) async {
    isUpdatingStatus.value = true;
    final nextStatus = currentStatus.toLowerCase() == 'active'
        ? 'Inactive'
        : 'Active';
    try {
      final ok = await _repository.updateProductStatus(productId, nextStatus);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'เปลี่ยนสถานะเป็น "${nextStatus == 'Active' ? 'เปิดวางจำหน่าย' : 'ระงับการจำหน่าย'}" สำเร็จ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.95),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        await Future.wait([
          loadProducts(page: currentPage.value),
          loadCounts(),
        ]);
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ไม่สามารถเปลี่ยนสถานะสินค้าได้ กรุณาลองใหม่',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.95),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error toggling product status: $e');
      return false;
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}

