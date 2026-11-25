import 'package:get/get.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final activeTab = 0
      .obs; // 0: ทั้งหมด, 1: ที่ต้องชำระ, 2: ที่ต้องจัดส่ง, 3: ที่ต้องได้รับ, 4: สำเร็จแล้ว, 5: ยกเลิกแล้ว

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchMyOrders();
      orders.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  void setActiveTab(int index) {
    activeTab.value = index;
  }

  List<OrderModel> get filteredOrders {
    if (activeTab.value == 0) return orders;

    return orders.where((order) {
      final status = order.orderStatus.toLowerCase();
      switch (activeTab.value) {
        case 1: // ที่ต้องชำระ
          return order.canPay;
        case 2: // ที่ต้องจัดส่ง
          return status == 'paid' || status == 'processing';
        case 3: // ที่ต้องได้รับ
          return status == 'shipped';
        case 4: // สำเร็จแล้ว
          return status == 'completed';
        case 5: // ยกเลิกแล้ว
          return status == 'cancelled';
        default:
          return true;
      }
    }).toList();
  }

  int getCountByTab(int tabIndex) {
    if (tabIndex == 0) return orders.length;
    return orders.where((order) {
      final status = order.orderStatus.toLowerCase();
      switch (tabIndex) {
        case 1:
          return order.canPay;
        case 2:
          return status == 'paid' || status == 'processing';
        case 3:
          return status == 'shipped';
        case 4:
          return status == 'completed';
        case 5:
          return status == 'cancelled';
        default:
          return false;
      }
    }).length;
  }
}
