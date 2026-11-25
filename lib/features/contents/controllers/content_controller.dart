import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';

class ContentController extends GetxController {
  ContentController({ContentRepository? repository})
    : _repository = repository ?? ContentRepository();

  final ContentRepository _repository;

  final contents = <ContentModel>[].obs;
  final categories = <ContentCategory>[].obs;
  final districts = <District>[].obs;

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  Timer? _searchDebounce;

  final isLoading = false.obs;
  // True once the first fetch finished; later fetches keep the page visible.
  final hasLoaded = false.obs;
  final viewMode = 'grid'.obs; // 'grid' | 'list' | 'map'

  bool get hasActiveFilters =>
      selectedCategoryId.value != null ||
      selectedDistrictId.value != null ||
      searchQuery.value.isNotEmpty;

  void setViewMode(String mode) {
    viewMode.value = mode;
  }

  String? get selectedDistrictName =>
      districts.firstWhereOrNull((d) => d.id == selectedDistrictId.value)?.name;

  String? get selectedCategoryName => categories
      .firstWhereOrNull((c) => c.id == selectedCategoryId.value)
      ?.name;

  @override
  void onInit() {
    super.onInit();
    parseArguments(Get.arguments);
    initMasterDataAndFetch();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void parseArguments(dynamic args) {
    if (args is Map) {
      if (args['districtId'] != null) {
        selectedDistrictId.value = args['districtId']?.toString();
      }
      if (args['categoryId'] != null) {
        selectedCategoryId.value = args['categoryId']?.toString();
      }
      if (args['search'] != null) {
        _setSearchText(args['search']?.toString() ?? '');
      }
    }
  }

  /// Applies filters coming from another page (e.g. home search or district
  /// map). Unspecified filters are cleared so results match what was asked.
  void applyFilters({String? search, String? districtId, String? categoryId}) {
    _searchDebounce?.cancel();
    _setSearchText(search ?? '');
    selectedDistrictId.value = districtId;
    selectedCategoryId.value = categoryId;
    fetchContents();
  }

  Future<void> initMasterDataAndFetch() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _repository.fetchCategories();
      final fetchedDistricts = await _repository.fetchDistricts();
      categories.assignAll(fetchedCategories);
      districts.assignAll(fetchedDistricts);
      await fetchContents();
    } finally {
      isLoading.value = false;
    }
  }

  // Ignores responses from older requests when filters change quickly.
  int _fetchId = 0;

  Future<void> fetchContents() async {
    final fetchId = ++_fetchId;
    try {
      isLoading.value = true;
      final result = await _repository.fetchContents(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
        districtId: selectedDistrictId.value,
      );
      if (fetchId == _fetchId) contents.assignAll(result);
    } finally {
      if (fetchId == _fetchId) {
        isLoading.value = false;
        hasLoaded.value = true;
      }
    }
  }

  void selectCategory(String? categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = null;
    } else {
      selectedCategoryId.value = categoryId;
    }
    fetchContents();
  }

  void selectDistrict(String? districtId) {
    if (selectedDistrictId.value == districtId) {
      selectedDistrictId.value = null;
    } else {
      selectedDistrictId.value = districtId;
    }
    fetchContents();
  }

  /// Called on every keystroke; searches once typing pauses.
  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      setSearch(query);
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    searchController.clear();
    setSearch('');
  }

  void setSearch(String query) {
    _searchDebounce?.cancel();
    final trimmed = query.trim();
    if (trimmed == searchQuery.value) return;
    searchQuery.value = trimmed;
    fetchContents();
  }

  void clearFilters() {
    _searchDebounce?.cancel();
    selectedCategoryId.value = null;
    selectedDistrictId.value = null;
    _setSearchText('');
    fetchContents();
  }

  void _setSearchText(String text) {
    searchQuery.value = text.trim();
    searchController.text = text;
  }
}
