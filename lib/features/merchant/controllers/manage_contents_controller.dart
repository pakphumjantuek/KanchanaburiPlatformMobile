import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contents/models/content_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class ManageContentsController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final contents = <ContentModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  final selectedFilter = 'all'.obs; // 'all', 'published', 'draft', 'video'

  int get totalCount => contents.length;
  int get publishedCount => contents
      .where((c) => (c.status ?? 'published').toLowerCase() == 'published')
      .length;
  int get draftCount =>
      contents.where((c) => (c.status ?? '').toLowerCase() == 'draft').length;
  int get videoCount =>
      contents.where((c) => c.youtubeUrl != null && c.youtubeUrl!.isNotEmpty).length;
  int get totalViews =>
      contents.fold<int>(0, (sum, item) => sum + item.viewCount);

  List<ContentModel> get filteredContents {
    final query = searchQuery.value.trim().toLowerCase();
    return contents.where((c) {
      final titleMatch = c.title.toLowerCase().contains(query);
      final descMatch = c.description?.toLowerCase().contains(query) ?? false;
      final catMatch = c.categoryName?.toLowerCase().contains(query) ?? false;
      final matchesSearch = query.isEmpty || titleMatch || descMatch || catMatch;
      if (!matchesSearch) return false;

      switch (selectedFilter.value) {
        case 'published':
          return (c.status ?? 'published').toLowerCase() == 'published';
        case 'draft':
          return (c.status ?? '').toLowerCase() == 'draft';
        case 'video':
          return c.youtubeUrl != null && c.youtubeUrl!.isNotEmpty;
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
    loadContents();
  }

  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);

  Future<void> loadContents() async {
    isLoading.value = true;
    try {
      final shop = await _repository.fetchMyShop();
      myShop.value = shop;
      if (shop != null) {
        final rawList = await _repository.fetchMerchantContents();
        contents.value = rawList.map((e) => ContentModel.fromJson(e)).toList();
      } else {
        contents.clear();
      }
    } catch (e) {
      debugPrint('Error loading merchant contents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteContent(ContentModel item) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('ยืนยันการลบบทความ'),
        content: Text('คุณต้องการลบบทความ "${item.title}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('ลบข้อมูล', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _repository.deleteContent(item.id);
      if (success) {
        contents.removeWhere((c) => c.id == item.id);
        Get.snackbar(
          'ลบสำเร็จ',
          'ลบบทความเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถลบบทความได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
