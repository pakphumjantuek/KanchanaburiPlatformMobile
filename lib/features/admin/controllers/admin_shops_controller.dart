import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/admin_repository.dart';

class AdminShopsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final isUpdatingStatus = false.obs;
  final shops = <ShopModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;

  final searchQuery = ''.obs;
  final selectedStatus = ''.obs; // '' | 'Pending' | 'Active' | 'Suspended' | 'Closed'

  // Metric counts
  final totalShopsCount = 0.obs;
  final pendingCount = 0.obs;
  final activeCount = 0.obs;
  final suspendedCount = 0.obs;
  final closedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData({int page = 1}) async {
    await Future.wait([
      loadShops(page: page),
      loadCounts(),
    ]);
  }

  Future<void> loadShops({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminShops(
        search: searchQuery.value.isEmpty ? null : searchQuery.value.trim(),
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        page: page,
        pageSize: 10,
      );

      if (paged != null) {
        shops.assignAll(paged.items);
        totalPages.value = paged.totalPages > 0 ? paged.totalPages : 1;
        totalCount.value = paged.totalCount;
      } else {
        shops.clear();
        totalPages.value = 1;
        totalCount.value = 0;
      }
    } catch (e) {
      debugPrint('Error loading admin shops: $e');
      shops.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCounts() async {
    try {
      final results = await Future.wait([
        _repository.fetchAdminShops(pageSize: 1),
        _repository.fetchAdminShops(status: 'Pending', pageSize: 1),
        _repository.fetchAdminShops(status: 'Active', pageSize: 1),
        _repository.fetchAdminShops(status: 'Suspended', pageSize: 1),
        _repository.fetchAdminShops(status: 'Closed', pageSize: 1),
      ]);

      if (results[0] != null) totalShopsCount.value = results[0]!.totalCount;
      if (results[1] != null) pendingCount.value = results[1]!.totalCount;
      if (results[2] != null) activeCount.value = results[2]!.totalCount;
      if (results[3] != null) suspendedCount.value = results[3]!.totalCount;
      if (results[4] != null) closedCount.value = results[4]!.totalCount;
    } catch (e) {
      debugPrint('Error loading shop metric counts: $e');
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    loadShops(page: 1);
  }

  void clearSearch() {
    searchQuery.value = '';
    loadShops(page: 1);
  }

  void selectStatus(String status) {
    selectedStatus.value = status;
    loadShops(page: 1);
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      loadShops(page: page);
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

  Future<bool> changeShopStatus(String shopId, String newStatus) async {
    isUpdatingStatus.value = true;
    try {
      final ok = await _repository.updateShopStatus(shopId, newStatus);
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'เปลี่ยนสถานะร้านค้าเป็น "${getStatusThai(newStatus)}" สำเร็จ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.95),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        await Future.wait([
          loadShops(page: currentPage.value),
          loadCounts(),
        ]);
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ไม่สามารถเปลี่ยนสถานะได้ กรุณาลองใหม่อีกครั้ง',
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
      debugPrint('Error changing shop status: $e');
      return false;
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  static String getStatusThai(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'เปิดใช้งาน';
      case 'pending':
      case 'pendingapproval':
        return 'รอการอนุมัติ';
      case 'suspended':
        return 'ระงับการใช้งาน';
      case 'closed':
        return 'ปิดบริการ';
      default:
        return status;
    }
  }
}

