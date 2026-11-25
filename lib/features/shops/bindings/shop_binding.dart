import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/controllers/shop_detail_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<ShopDetailController>(() => ShopDetailController());
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
