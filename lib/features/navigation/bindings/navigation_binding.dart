import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../shops/controllers/shop_controller.dart';
import '../../contents/controllers/content_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NavigationController>()) {
      Get.put(NavigationController(), permanent: true);
    }
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ShopController>(() => ShopController(), fenix: true);
    Get.lazyPut<ContentController>(() => ContentController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
