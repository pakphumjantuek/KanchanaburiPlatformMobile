import 'package:get/get.dart';
import 'package:projecte/features/contents/models/content_model.dart';
import 'package:projecte/features/shops/models/category_model.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/repositories/shop_repository.dart';

class ShopController extends GetxController {
  ShopController({ShopRepository? repository})
    : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final shops = <ShopModel>[].obs;
  final categories = <ShopCategory>[].obs;
  final districts = <District>[].obs;
  final specialProducts = <ProductModel>[].obs;

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final searchQuery = ''.obs;

  final isLoading = false.obs;
  // True once the first fetch finished; later fetches keep the page visible.
  final hasLoaded = false.obs;
  final viewMode = 'grid'.obs; // 'grid' | 'list' | 'map'
  final onlyOpenNow = false.obs;

  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty ||
      selectedCategoryId.value != null ||
      selectedDistrictId.value != null ||
      onlyOpenNow.value;

  String? get selectedDistrictName =>
      districts.firstWhereOrNull((d) => d.id == selectedDistrictId.value)?.name;

  String? get selectedCategoryName => categories
      .firstWhereOrNull((c) => c.id == selectedCategoryId.value)
      ?.name;

  List<ShopModel> get displayedShops {
    if (onlyOpenNow.value) {
      return shops.where((s) => s.isOpenNow).toList();
    }
    return shops;
  }

  void toggleOnlyOpenNow() {
    onlyOpenNow.value = !onlyOpenNow.value;
  }

  @override
  void onInit() {
    super.onInit();
    initMasterDataAndFetch();
  }

  Future<void> initMasterDataAndFetch() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _repository.fetchShopCategories();
      final fetchedDistricts = await _repository.fetchDistricts();
      categories.assignAll(fetchedCategories);
      districts.assignAll(fetchedDistricts);
      await fetchShops();
      await fetchSpecialProducts();
    } finally {
      isLoading.value = false;
    }
  }

  // Ignores responses from older requests when filters change quickly.
  int _fetchId = 0;

  Future<void> fetchShops() async {
    final fetchId = ++_fetchId;
    try {
      isLoading.value = true;
      final result = await _repository.fetchShops(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
        districtId: selectedDistrictId.value,
      );
      if (fetchId == _fetchId) shops.assignAll(result);
    } finally {
      if (fetchId == _fetchId) {
        isLoading.value = false;
        hasLoaded.value = true;
      }
    }
  }

  Future<void> fetchSpecialProducts() async {
    final deals = await _repository.fetchActiveDeals(limit: 12);
    specialProducts.assignAll(
      deals.where((product) {
        final deal = product.activeDeal;
        return product.quantity > 0 &&
            deal != null &&
            deal.availableQuantity > 0 &&
            !deal.isExpired;
      }),
    );
  }

  Future<void> refreshPage() async {
    await Future.wait([fetchShops(), fetchSpecialProducts()]);
  }

  void selectCategory(String? categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = null;
    } else {
      selectedCategoryId.value = categoryId;
    }
    fetchShops();
  }

  void selectDistrict(String? districtId) {
    if (selectedDistrictId.value == districtId) {
      selectedDistrictId.value = null;
    } else {
      selectedDistrictId.value = districtId;
    }
    fetchShops();
  }

  void setSearch(String query) {
    final trimmed = query.trim();
    if (trimmed == searchQuery.value) return;
    searchQuery.value = trimmed;
    fetchShops();
  }

  void setViewMode(String mode) {
    viewMode.value = mode;
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    selectedDistrictId.value = null;
    searchQuery.value = '';
    onlyOpenNow.value = false;
    fetchShops();
  }
}
