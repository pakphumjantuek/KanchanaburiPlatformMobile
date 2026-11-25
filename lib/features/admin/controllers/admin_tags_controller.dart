import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin_tag_model.dart';
import '../repositories/admin_repository.dart';

class AdminTagsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final tags = <AdminTag>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalItems = 0.obs;

  // Filter & Search states
  final selectedStatusFilter = ''.obs; // '' for all, 'Active', 'Inactive'
  final searchQuery = ''.obs;
  final viewMode = 'cards'.obs; // 'cards' | 'cloud'

  @override
  void onInit() {
    super.onInit();
    loadTags();
  }

  /// Computed list based on real-time client-side search query
  List<AdminTag> get filteredTags {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return tags;
    return tags
        .where(
          (tag) =>
              tag.tagName.toLowerCase().contains(query) ||
              tag.tagId.toLowerCase().contains(query),
        )
        .toList();
  }

  int get totalCount => totalItems.value > 0 ? totalItems.value : tags.length;

  int get activeCount =>
      tags.where((t) => t.status.toLowerCase() == 'active').length;

  int get inactiveCount =>
      tags.where((t) => t.status.toLowerCase() == 'inactive').length;

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void setStatusFilter(String status) {
    if (selectedStatusFilter.value == status) {
      selectedStatusFilter.value = '';
    } else {
      selectedStatusFilter.value = status;
    }
    loadTags(page: 1);
  }

  void toggleViewMode() {
    viewMode.value = viewMode.value == 'cards' ? 'cloud' : 'cards';
  }

  Future<void> loadTags({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminTags(
        status:
            selectedStatusFilter.value.isEmpty
                ? null
                : selectedStatusFilter.value,
        page: page,
        pageSize: 30,
      );
      if (paged != null) {
        tags.assignAll(paged.items);
        totalPages.value = paged.totalPages;
        totalItems.value = paged.totalCount;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTag(String name, {String status = 'Active'}) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      Get.snackbar(
        'แจ้งเตือน',
        'กรุณาระบุชื่อแท็ก',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final res = await _repository.createTag(cleanName);
      if (res != null) {
        // If user chose Inactive on creation, update it
        if (status == 'Inactive') {
          await _repository.updateTag(res.tagId, res.tagName, 'Inactive');
        }

        Get.snackbar(
          'สำเร็จ',
          'เพิ่มแท็ก "$cleanName" เรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        await loadTags(page: 1);
        return true;
      }
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถเพิ่มแท็กได้ อาจมีแท็กชื่อนี้อยู่แล้ว',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateTag(String id, String name, String status) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      Get.snackbar(
        'แจ้งเตือน',
        'กรุณาระบุชื่อแท็ก',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final ok = await _repository.updateTag(id, cleanName, status);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'แก้ไขแท็กเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        await loadTags(page: currentPage.value);
        return true;
      }
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถแก้ไขแท็กได้ กรุณาลองใหม่อีกครั้ง',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> toggleTagStatus(AdminTag tag) async {
    final newStatus = tag.status == 'Active' ? 'Inactive' : 'Active';
    isSaving.value = true;
    try {
      final ok = await _repository.updateTag(
        tag.tagId,
        tag.tagName,
        newStatus,
      );
      if (ok) {
        Get.snackbar(
          'เปลี่ยนสถานะแล้ว',
          'เปลี่ยนสถานะแท็ก "${tag.tagName}" เป็น ${newStatus == "Active" ? "เปิดใช้งาน" : "ปิดใช้งาน"}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: newStatus == 'Active'
              ? const Color(0xFF10B981)
              : const Color(0xFF64748B),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: Icon(
            newStatus == 'Active'
                ? Icons.check_circle_rounded
                : Icons.pause_circle_rounded,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 2),
        );
        await loadTags(page: currentPage.value);
        return true;
      }
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteTag(String id) async {
    isSaving.value = true;
    try {
      final ok = await _repository.deleteTag(id);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'ลบแท็กเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        await loadTags(page: currentPage.value);
        return true;
      }
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถลบแท็กได้',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
