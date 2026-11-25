import 'package:get/get.dart';
import '../models/admin_category_model.dart';
import '../models/admin_content_model.dart';
import '../repositories/admin_repository.dart';

class AdminContentsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final activeTab = 0.obs; // 0: Articles/Contents, 1: Content Categories

  // --- Contents ---
  final isLoading = false.obs;
  final contents = <AdminContentItem>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final pageSize = 20.obs;
  final selectedStatusFilter =
      ''.obs; // '' | 'Draft' | 'Pending' | 'Published' | 'Archived'

  // --- Content Categories ---
  final isCatLoading = false.obs;
  final contentCategories = <ContentCategoryAdmin>[].obs;

  // --- Tag Binding state ---
  final activeTags = <TagOption>[].obs;
  final selectedContentTagIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadContents();
    loadContentCategories();
    loadActiveTags();
  }

  void switchTab(int index) {
    activeTab.value = index;
    if (index == 0) {
      loadContents();
    } else {
      loadContentCategories();
    }
  }

  // --- Content Operations ---
  Future<void> loadContents({int? page, int? size}) async {
    isLoading.value = true;
    if (page != null) currentPage.value = page;
    if (size != null) pageSize.value = size;
    try {
      final paged = await _repository.fetchAdminContents(
        status: selectedStatusFilter.value.isEmpty
            ? null
            : selectedStatusFilter.value,
        page: currentPage.value,
        pageSize: pageSize.value,
      );
      if (paged != null) {
        contents.assignAll(paged.items);
        totalPages.value = paged.totalPages > 0 ? paged.totalPages : 1;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      loadContents(page: currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      loadContents(page: currentPage.value - 1);
    }
  }

  Future<bool> saveContent({String? id, required ContentFormData data}) async {
    if (id != null && id.isNotEmpty) {
      final ok = await _repository.updateContent(id, data);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'แก้ไขบทความเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        loadContents(page: currentPage.value);
        return true;
      }
    } else {
      final item = await _repository.createContent(data);
      if (item != null) {
        Get.snackbar(
          'สำเร็จ',
          'สร้างบทความใหม่เรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        loadContents(page: 1);
        return true;
      }
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'บันทึกบทความไม่สำเร็จ',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  Future<bool> archiveContent(String id) async {
    final ok = await _repository.archiveContent(id);
    if (ok) {
      Get.snackbar(
        'สำเร็จ',
        'ปิดการแสดงผลคอนเทนต์เรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
      );
      loadContents(page: currentPage.value);
      return true;
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถปิดการแสดงผลคอนเทนต์ได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  Future<bool> toggleContentVisibility(AdminContentItem item) async {
    final isArchived = item.status.toLowerCase() == 'archived';
    if (isArchived) {
      // Re-open / Publish
      final ok = await _repository.updateContent(
        item.contentId,
        ContentFormData(
          title: item.title,
          summary: item.summary ?? '',
          contentCategoryId: item.contentCategoryId,
          shopId: item.shopId,
          districtId: item.districtId,
          subDistrictId: item.subDistrictId,
          latitude: item.latitude,
          longitude: item.longitude,
          youtubeUrl: item.youtubeUrl ?? '',
          status: 'Published',
        ),
      );
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'เปิดการแสดงผลคอนเทนต์เรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        loadContents(page: currentPage.value);
        return true;
      }
    } else {
      // Close / Archive
      final ok = await _repository.archiveContent(item.contentId);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'ปิดการแสดงผลคอนเทนต์เรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        loadContents(page: currentPage.value);
        return true;
      }
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถเปลี่ยนสถานะคอนเทนต์ได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  // --- Content Category Operations ---
  Future<void> loadContentCategories() async {
    isCatLoading.value = true;
    try {
      final paged = await _repository.fetchContentCategories(
        page: 1,
        pageSize: 50,
      );
      if (paged != null) {
        contentCategories.assignAll(paged.items);
      }
    } finally {
      isCatLoading.value = false;
    }
  }

  Future<bool> createContentCategory(String name, String desc) async {
    final cat = await _repository.createContentCategory(name, desc);
    if (cat != null) {
      Get.snackbar(
        'สำเร็จ',
        'สร้างหมวดหมู่เนื้อหาเรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
      );
      loadContentCategories();
      return true;
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถสร้างหมวดหมู่เนื้อหาได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  Future<bool> updateContentCategory(
    String id,
    String name,
    String desc,
    String status,
  ) async {
    final ok = await _repository.updateContentCategory(id, name, desc, status);
    if (ok) {
      Get.snackbar(
        'สำเร็จ',
        'แก้ไขหมวดหมู่เนื้อหาเรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
      );
      loadContentCategories();
      return true;
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถแก้ไขหมวดหมู่เนื้อหาได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  Future<bool> deleteContentCategory(String id) async {
    final ok = await _repository.deleteContentCategory(id);
    if (ok) {
      Get.snackbar(
        'สำเร็จ',
        'ลบหมวดหมู่เนื้อหาเรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
      );
      loadContentCategories();
      return true;
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถลบหมวดหมู่เนื้อหาได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  // --- Tag Binding Operations ---
  Future<void> loadActiveTags() async {
    final tags = await _repository.fetchActiveTags();
    activeTags.assignAll(tags);
  }

  Future<void> loadContentTags(String contentId) async {
    final tags = await _repository.fetchContentTags(contentId);
    selectedContentTagIds.assignAll(tags.map((e) => e.tagId));
  }

  Future<bool> saveContentTags(String contentId) async {
    final ok = await _repository.updateContentTags(
      contentId,
      selectedContentTagIds,
    );
    if (ok) {
      Get.snackbar(
        'สำเร็จ',
        'ผูกแท็กเนื้อหาเรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
      );
      return true;
    }
    Get.snackbar(
      'ข้อผิดพลาด',
      'ไม่สามารถอัปเดตแท็กเนื้อหาได้',
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }
}
