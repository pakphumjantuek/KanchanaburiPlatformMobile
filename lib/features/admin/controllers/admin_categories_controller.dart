import 'package:get/get.dart';
import '../models/admin_category_model.dart';
import '../repositories/admin_repository.dart';

class AdminCategoriesController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final activeTab = 0.obs; // 0: Shop Categories, 1: Product Categories

  // Shop Categories
  final isShopLoading = false.obs;
  final shopCategories = <ShopCategoryAdmin>[].obs;
  final shopPage = 1.obs;
  final shopTotalPages = 1.obs;

  // Product Categories
  final isProductLoading = false.obs;
  final productCategories = <ProductCategoryAdmin>[].obs;
  final productPage = 1.obs;
  final productTotalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadShopCategories();
    loadProductCategories();
  }

  void switchTab(int index) {
    activeTab.value = index;
    if (index == 0) {
      loadShopCategories();
    } else {
      loadProductCategories();
    }
  }

  // --- Shop Category Actions ---
  Future<void> loadShopCategories({int page = 1}) async {
    isShopLoading.value = true;
    shopPage.value = page;
    try {
      final paged = await _repository.fetchShopCategories(page: page, pageSize: 10);
      if (paged != null) {
        shopCategories.assignAll(paged.items);
        shopTotalPages.value = paged.totalPages;
      }
    } finally {
      isShopLoading.value = false;
    }
  }

  Future<bool> createShopCategory(String name, String desc) async {
    final cat = await _repository.createShopCategory(name, desc);
    if (cat != null) {
      Get.snackbar('สำเร็จ', 'สร้างหมวดหมู่ร้านค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadShopCategories(page: shopPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถสร้างหมวดหมู่ร้านค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> updateShopCategory(String id, String name, String desc, String status) async {
    final ok = await _repository.updateShopCategory(id, name, desc, status);
    if (ok) {
      Get.snackbar('สำเร็จ', 'อัปเดตหมวดหมู่ร้านค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadShopCategories(page: shopPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถแก้ไขหมวดหมู่ร้านค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> deleteShopCategory(String id) async {
    final ok = await _repository.deleteShopCategory(id);
    if (ok) {
      Get.snackbar('สำเร็จ', 'ลบหมวดหมู่ร้านค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadShopCategories(page: shopPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบหมวดหมู่ร้านค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  // --- Product Category Actions ---
  Future<void> loadProductCategories({int page = 1}) async {
    isProductLoading.value = true;
    productPage.value = page;
    try {
      final paged = await _repository.fetchProductCategories(page: page, pageSize: 10);
      if (paged != null) {
        productCategories.assignAll(paged.items);
        productTotalPages.value = paged.totalPages;
      }
    } finally {
      isProductLoading.value = false;
    }
  }

  Future<bool> createProductCategory(String name, String desc) async {
    final ok = await _repository.createProductCategory(name, desc);
    if (ok) {
      Get.snackbar('สำเร็จ', 'สร้างหมวดหมู่สินค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadProductCategories(page: productPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถสร้างหมวดหมู่สินค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> updateProductCategory(String id, String name, String desc, String status) async {
    final ok = await _repository.updateProductCategory(id, name, desc, status);
    if (ok) {
      Get.snackbar('สำเร็จ', 'อัปเดตหมวดหมู่สินค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadProductCategories(page: productPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถแก้ไขหมวดหมู่สินค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> deleteProductCategory(String id) async {
    final ok = await _repository.deleteProductCategory(id);
    if (ok) {
      Get.snackbar('สำเร็จ', 'ลบหมวดหมู่สินค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadProductCategories(page: productPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบหมวดหมู่สินค้าได้', snackPosition: SnackPosition.TOP);
    return false;
  }
}
