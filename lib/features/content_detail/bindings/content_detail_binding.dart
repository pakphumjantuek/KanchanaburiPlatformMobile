import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../repositories/content_detail_repository.dart';

class ContentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContentDetailRepository>(() => ContentDetailRepository());
    Get.lazyPut<ContentDetailController>(
      () => ContentDetailController(
        repository: Get.find<ContentDetailRepository>(),
      ),
    );
  }
}
