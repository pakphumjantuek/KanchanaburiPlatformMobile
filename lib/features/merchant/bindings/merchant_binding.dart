import 'package:get/get.dart';
import '../controllers/content_form_controller.dart';
import '../controllers/manage_contents_controller.dart';
import '../controllers/manage_orders_controller.dart';
import '../controllers/manage_products_controller.dart';
import '../controllers/merchant_dashboard_controller.dart';
import '../controllers/merchant_export_controller.dart';
import '../controllers/product_form_controller.dart';
import '../controllers/register_shop_controller.dart';
import '../repositories/merchant_repository.dart';

class MerchantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MerchantRepository>(() => MerchantRepository());
    Get.lazyPut<RegisterShopController>(() => RegisterShopController());
    Get.lazyPut<MerchantDashboardController>(
      () => MerchantDashboardController(),
    );
    Get.lazyPut<ManageProductsController>(() => ManageProductsController());
    Get.lazyPut<ProductFormController>(() => ProductFormController());
    Get.lazyPut<ManageOrdersController>(() => ManageOrdersController());
    Get.lazyPut<ManageContentsController>(() => ManageContentsController());
    Get.lazyPut<ContentFormController>(() => ContentFormController());
    Get.lazyPut<MerchantExportController>(() => MerchantExportController());
  }
}
