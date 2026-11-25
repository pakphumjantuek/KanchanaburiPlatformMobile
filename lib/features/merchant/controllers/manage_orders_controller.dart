import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../orders/models/order_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class ManageOrdersController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;
  final selectedStatus = 'All'.obs;
  final searchQuery = ''.obs;
  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);

  bool _isExpired(OrderModel o) {
    final orderStat = o.orderStatus.trim().toLowerCase();
    final payStat = o.paymentStatus.trim().toLowerCase();

    // 1. Explicit expired
    if (orderStat == 'expired' || payStat == 'expired' || o.isPaymentExpired) {
      return true;
    }

    // 2. Explicit cancelled
    if (orderStat == 'cancelled') return true;

    // 3. Pending/Unpaid without slip (abandoned order)
    if (orderStat == 'pending' &&
        (payStat == 'pending' || payStat == 'unpaid') &&
        (o.slipImageUrl == null || o.slipImageUrl!.trim().isEmpty)) {
      return true;
    }

    return false;
  }

  List<OrderModel> get filteredOrders {
    var list = orders.toList();
    final status = selectedStatus.value.trim().toLowerCase();

    if (status.isNotEmpty && status != 'all') {
      list = list.where((o) {
        final orderStat = o.orderStatus.trim().toLowerCase();
        final payStat = o.paymentStatus.trim().toLowerCase();

        if (status == 'pendingverification') {
          return payStat == 'pendingverification' && !_isExpired(o);
        } else if (status == 'paid' || status == 'toship') {
          return (payStat == 'paid' || orderStat == 'confirmed' || orderStat == 'processing') &&
              orderStat != 'shipped' &&
              orderStat != 'completed' &&
              orderStat != 'cancelled' &&
              !_isExpired(o);
        } else if (status == 'shipped') {
          return orderStat == 'shipped';
        } else if (status == 'completed') {
          return orderStat == 'completed';
        } else if (status == 'cancelled') {
          return orderStat == 'cancelled' || _isExpired(o);
        }
        return orderStat == status && !_isExpired(o);
      }).toList();
    } else {
      // คำสั่งซื้อทั้งหมด: ไม่รวมออเดอร์ที่หมดอายุ
      list = list.where((o) => !_isExpired(o)).toList();
    }

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((o) {
        final num = (o.orderNumber ?? o.id).toLowerCase();
        final name = (o.receiverName ?? '').toLowerCase();
        final phone = (o.receiverPhone ?? '').toLowerCase();
        final tracking = (o.trackingNumber ?? '').toLowerCase();
        return num.contains(q) ||
            name.contains(q) ||
            phone.contains(q) ||
            tracking.contains(q);
      }).toList();
    }

    return list;
  }

  // Live KPI Counters (คำสั่งซื้อทั้งหมด ไม่รวมหมดอายุ)
  int get totalCount => orders.where((o) => !_isExpired(o)).length;

  int get pendingShipmentCount => orders.where((o) {
        final orderStat = o.orderStatus.trim().toLowerCase();
        final payStat = o.paymentStatus.trim().toLowerCase();
        return (payStat == 'paid' || orderStat == 'confirmed' || orderStat == 'processing') &&
            orderStat != 'shipped' &&
            orderStat != 'completed' &&
            orderStat != 'cancelled' &&
            !_isExpired(o);
      }).length;

  int get pendingVerificationCount => orders
      .where((o) => o.paymentStatus.trim().toLowerCase() == 'pendingverification' && !_isExpired(o))
      .length;

  int get pendingSlipCount => pendingVerificationCount;

  int get shippedCount => orders
      .where((o) => o.orderStatus.trim().toLowerCase() == 'shipped')
      .length;

  int get completedCount => orders
      .where((o) => o.orderStatus.trim().toLowerCase() == 'completed')
      .length;

  int get cancelledCount => orders
      .where((o) => o.orderStatus.trim().toLowerCase() == 'cancelled' || _isExpired(o))
      .length;

  int getCountForStatus(String status) {
    final s = status.trim().toLowerCase();
    if (s == 'all' || s.isEmpty) return totalCount;
    if (s == 'toship' || s == 'paid') return pendingShipmentCount;
    if (s == 'pendingverification') return pendingVerificationCount;
    if (s == 'shipped') return shippedCount;
    if (s == 'completed') return completedCount;
    if (s == 'cancelled') return cancelledCount;
    return orders
        .where((o) => o.orderStatus.trim().toLowerCase() == s && !_isExpired(o))
        .length;
  }

  final statusTabs = [
    {'value': 'All', 'label': 'ทั้งหมด'},
    {'value': 'ToShip', 'label': 'รอจัดส่ง'},
    {'value': 'PendingVerification', 'label': 'รอระบบยืนยันยอด'},
    {'value': 'Shipped', 'label': 'จัดส่งแล้ว'},
    {'value': 'Completed', 'label': 'สำเร็จแล้ว'},
    {'value': 'Cancelled', 'label': 'ยกเลิก'},
  ];

  @override
  void onInit() {
    super.onInit();
    checkAndUpdateStatusTab();
    loadOrders();
  }

  void checkAndUpdateStatusTab() {
    final status = Get.parameters['status'] ??
        (Get.arguments is Map
            ? Get.arguments['status']
            : (Get.arguments is String ? Get.arguments : null));
    if (status != null && status.toString().isNotEmpty) {
      final s = status.toString();
      if (selectedStatus.value.toLowerCase() != s.toLowerCase()) {
        selectedStatus.value = s;
      }
    }
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final shop = await _repository.fetchMyShop();
      myShop.value = shop;
      if (shop != null) {
        final list = await _repository.fetchMerchantOrders();
        orders.value = list;
      } else {
        orders.clear();
      }
    } catch (e) {
      debugPrint('Error loading merchant orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatusTab(String status) {
    selectedStatus.value = status;
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  Future<void> submitShipmentFulfillment({
    required OrderModel order,
    required String carrierName,
    required String trackingNumber,
  }) async {
    if (carrierName.trim().isEmpty || trackingNumber.trim().isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบ',
        'กรุณากรอกชื่อบริษัทขนส่ง และเลขติดตามพัสดุ (Tracking Number)',
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final success = await _repository.updateShipment(
        order.id,
        carrierName.trim(),
        trackingNumber.trim(),
      );

      if (success) {
        Get.back();
        Get.snackbar(
          'สำเร็จ',
          'บันทึกข้อมูลการจัดส่งเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        loadOrders();
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถอัปเดตการจัดส่งได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error updating shipment: $e');
    }
  }

  Future<void> changeFulfillmentStatus(OrderModel order, String newStatus) async {
    try {
      final success = await _repository.updateOrderStatus(order.id, newStatus);
      if (success) {
        Get.snackbar(
          'สำเร็จ',
          'อัปเดตสถานะออเดอร์เรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        loadOrders();
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถอัปเดตสถานะออเดอร์ได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error changing fulfillment status: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final success = await _repository.updateOrderStatus(orderId, 'Cancelled');
      if (success) {
        Get.snackbar(
          'ยกเลิกออเดอร์แล้ว',
          'อัปเดตสถานะเป็นยกเลิกคำสั่งซื้อเรียบร้อย',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        loadOrders();
      }
    } catch (e) {
      debugPrint('Error cancelling order: $e');
    }
  }
}
