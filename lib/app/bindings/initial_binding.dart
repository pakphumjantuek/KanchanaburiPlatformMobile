import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../../features/navigation/controllers/navigation_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
  }
}
