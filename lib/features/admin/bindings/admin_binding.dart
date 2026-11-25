import 'package:get/get.dart';
import '../controllers/admin_categories_controller.dart';
import '../controllers/admin_contents_controller.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../controllers/admin_orders_controller.dart';
import '../controllers/admin_payouts_controller.dart';
import '../controllers/admin_products_controller.dart';
import '../controllers/admin_reports_controller.dart';
import '../controllers/admin_schedules_controller.dart';
import '../controllers/admin_shops_controller.dart';
import '../controllers/admin_tags_controller.dart';
import '../controllers/admin_export_controller.dart';
import '../repositories/admin_repository.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRepository>(() => AdminRepository(), fenix: true);
    Get.lazyPut<AdminExportController>(
      () => AdminExportController(),
      fenix: true,
    );
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
      fenix: true,
    );
    Get.lazyPut<AdminOrdersController>(
      () => AdminOrdersController(),
      fenix: true,
    );
    Get.lazyPut<AdminPayoutsController>(
      () => AdminPayoutsController(),
      fenix: true,
    );
    Get.lazyPut<AdminShopsController>(
      () => AdminShopsController(),
      fenix: true,
    );
    Get.lazyPut<AdminProductsController>(
      () => AdminProductsController(),
      fenix: true,
    );
    Get.lazyPut<AdminCategoriesController>(
      () => AdminCategoriesController(),
      fenix: true,
    );
    Get.lazyPut<AdminContentsController>(
      () => AdminContentsController(),
      fenix: true,
    );
    Get.lazyPut<AdminTagsController>(() => AdminTagsController(), fenix: true);
    Get.lazyPut<AdminSchedulesController>(
      () => AdminSchedulesController(),
      fenix: true,
    );
    Get.lazyPut<AdminReportsController>(
      () => AdminReportsController(),
      fenix: true,
    );
  }
}
