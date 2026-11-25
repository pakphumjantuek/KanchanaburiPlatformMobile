import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../shops/models/shop_model.dart';
import '../models/merchant_dashboard_model.dart';
import '../repositories/merchant_repository.dart';

class MerchantDashboardController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);
  final Rx<MerchantDashboardModel?> report = Rx<MerchantDashboardModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  int get totalAlertsCount {
    final rep = report.value;
    if (rep == null) return 0;
    // Slips are handled by Admin, so Merchant alerts focus on shipments to pack and low stock
    return rep.pendingShipmentOrdersCount + rep.lowStockProductsCount;
  }

  int get pendingShipments => report.value?.pendingShipmentOrdersCount ?? 0;
  int get pendingVerifications => report.value?.pendingSlipOrdersCount ?? 0;
  int get pendingSlips => pendingVerifications;
  int get lowStockCount => report.value?.lowStockProductsCount ?? 0;
  int get activeDealsCount => report.value?.promotionAnalytics.activeDealsCount ?? 0;


  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.fetchMyShop(),
        _repository.fetchDashboardReport(),
      ]);

      myShop.value = results[0] as ShopModel?;
      report.value = results[1] as MerchantDashboardModel?;
    } catch (e) {
      debugPrint('Error loading merchant dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    isRefreshing.value = true;
    try {
      final results = await Future.wait([
        _repository.fetchMyShop(),
        _repository.fetchDashboardReport(),
      ]);

      myShop.value = results[0] as ShopModel?;
      report.value = results[1] as MerchantDashboardModel?;
    } catch (e) {
      debugPrint('Error refreshing merchant dashboard: $e');
    } finally {
      isRefreshing.value = false;
    }
  }
}
