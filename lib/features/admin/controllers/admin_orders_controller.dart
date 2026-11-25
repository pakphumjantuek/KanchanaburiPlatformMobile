import 'package:get/get.dart';
import '../models/admin_order_slip_model.dart';
import '../repositories/admin_repository.dart';

class AdminOrdersController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final pendingSlips = <AdminPendingSlipGroup>[].obs;
  final isProcessingAction = false.obs;
  final processingSlipIndex = Rxn<int>();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingSlips();
  }

  Future<void> loadPendingSlips() async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchPendingSlips();
      pendingSlips.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  List<AdminPendingSlipGroup> get filteredSlips {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return pendingSlips;

    return pendingSlips.where((group) {
      final matchBuyer = (group.buyerName?.toLowerCase().contains(query) ?? false);
      final matchPhone = (group.buyerPhone?.contains(query) ?? false);
      final matchOrder = group.orders.any((o) =>
          (o.orderNumber?.toLowerCase().contains(query) ?? false) ||
          (o.shopName?.toLowerCase().contains(query) ?? false) ||
          o.items.any((item) => item.productName.toLowerCase().contains(query)));
      return matchBuyer || matchPhone || matchOrder;
    }).toList();
  }

  double get totalPendingAmount {
    return pendingSlips.fold(0.0, (sum, g) => sum + g.totalGroupAmount);
  }

  int get totalPendingOrdersCount {
    return pendingSlips.fold(0, (sum, g) => sum + g.orders.length);
  }

  Future<bool> verifySlipGroup({
    required AdminPendingSlipGroup group,
    required int index,
    required String action, // 'Approve' | 'Reject'
  }) async {
    final orderIds = group.allOrderIds;
    if (orderIds.isEmpty) return false;

    processingSlipIndex.value = index;
    isProcessingAction.value = true;
    try {
      final payload = VerifySlipPayload(orderIds: orderIds, action: action);
      final success = await _repository.verifySlip(payload);
      if (success) {
        Get.snackbar(
          'สำเร็จ',
          action == 'Approve'
              ? 'อนุมัติการชำระเงินเรียบร้อยแล้ว (${orderIds.length} ออเดอร์)'
              : 'ปฏิเสธการชำระเงินเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        await loadPendingSlips();
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ทำรายการไม่สำเร็จ กรุณาลองใหม่อีกครั้ง',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      processingSlipIndex.value = null;
      isProcessingAction.value = false;
    }
  }

  Future<void> verifySlip(List<String> orderIds, String action) async {
    if (orderIds.isEmpty) return;
    isProcessingAction.value = true;
    try {
      final payload = VerifySlipPayload(orderIds: orderIds, action: action);
      final success = await _repository.verifySlip(payload);
      if (success) {
        Get.snackbar(
          'สำเร็จ',
          action == 'Approve'
              ? 'อนุมัติการชำระเงินเรียบร้อยแล้ว'
              : 'ปฏิเสธการชำระเงินเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        await loadPendingSlips();
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ทำรายการไม่สำเร็จ กรุณาลองใหม่',
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isProcessingAction.value = false;
    }
  }
}
