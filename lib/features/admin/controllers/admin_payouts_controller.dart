import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin_merchant_payout_model.dart';
import '../repositories/admin_repository.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'admin_dashboard_controller.dart';

class AdminPayoutsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final activeTab = 0.obs; // 0: Pending, 1: History
  final pendingPayouts = <AdminMerchantPayoutGroup>[].obs;
  final payoutHistory = <MerchantPayoutRecord>[].obs;
  final searchQuery = ''.obs;

  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      if (activeTab.value == 0) {
        final list = await _repository.fetchPayouts();
        pendingPayouts.assignAll(list);
      } else {
        final list = await _repository.fetchPayoutHistory();
        payoutHistory.assignAll(list);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void switchTab(int index) {
    activeTab.value = index;
    searchQuery.value = '';
    loadData();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<AdminMerchantPayoutGroup> get filteredPendingPayouts {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return pendingPayouts;
    return pendingPayouts.where((p) {
      final name = p.shopName.toLowerCase();
      final bank = (p.bankName ?? '').toLowerCase();
      final acc = p.bankAccountNumber ?? '';
      final prompt = p.promptPay ?? '';
      final accName = (p.bankAccountName ?? '').toLowerCase();
      return name.contains(query) ||
          bank.contains(query) ||
          acc.contains(query) ||
          prompt.contains(query) ||
          accName.contains(query);
    }).toList();
  }

  List<MerchantPayoutRecord> get filteredHistory {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return payoutHistory;
    return payoutHistory.where((r) {
      final name = (r.shopName ?? '').toLowerCase();
      final ref = (r.transactionRef ?? '').toLowerCase();
      final note = (r.note ?? '').toLowerCase();
      return name.contains(query) || ref.contains(query) || note.contains(query);
    }).toList();
  }

  double get totalPendingAmount {
    return pendingPayouts.fold(0.0, (sum, p) => sum + p.totalSalesAmount);
  }

  int get totalPendingOrders {
    return pendingPayouts.fold(0, (sum, p) => sum + p.paidOrdersCount);
  }

  Future<bool> confirmPayout({
    required String shopId,
    required List<String> orderIds,
    String? transactionRef,
    String? note,
    File? slipFile,
  }) async {
    isSubmitting.value = true;
    try {
      final ok = await _repository.confirmPayout(
        shopId: shopId,
        orderIds: orderIds,
        transactionRef: transactionRef,
        note: note,
        slipFile: slipFile,
      );
      if (ok) {
        Get.snackbar(
          'สำเร็จ',
          'ยืนยันการโอนเงินให้ร้านค้าเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AdminColors.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await loadData();
        if (Get.isRegistered<AdminDashboardController>()) {
          Get.find<AdminDashboardController>().loadDashboard();
        }
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ไม่สามารถบันทึกการโอนเงินได้ กรุณาลองใหม่อีกครั้ง',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFDC2626),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      return ok;
    } finally {
      isSubmitting.value = false;
    }
  }
}
