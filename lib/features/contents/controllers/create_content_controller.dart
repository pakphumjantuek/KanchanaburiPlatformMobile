import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profile/controllers/my_contents_controller.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';

class CreateContentController extends GetxController {
  final ContentRepository _repository = Get.isRegistered<ContentRepository>()
      ? Get.find<ContentRepository>()
      : ContentRepository();

  String? editingContentId;
  bool get isEditing =>
      editingContentId != null && editingContentId!.isNotEmpty;

  // Form Controllers
  final titleController = TextEditingController();
  final summaryController = TextEditingController();
  final youtubeUrlController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final youtubeUrlText = ''.obs;

  // Form Selections
  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final selectedSubDistrictId = RxnString();
  final selectedShopId = RxnString();
  final selectedStatus = 'Published'.obs; // 'Published' or 'Draft'

  // Master Data Lists
  final categories = <ContentCategory>[].obs;
  final districts = <District>[].obs;
  final subDistricts = <SubDistrict>[].obs;
  final shops = <ContentShopOption>[].obs;

  // Status flags
  final isLoadingFormOptions = true.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    youtubeUrlController.addListener(() {
      youtubeUrlText.value = youtubeUrlController.text;
    });
    loadFormMasterData();
  }

  @override
  void onClose() {
    titleController.dispose();
    summaryController.dispose();
    youtubeUrlController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  Future<void> loadFormMasterData() async {
    isLoadingFormOptions.value = true;
    try {
      final fetchedCategories = await _repository.fetchCategories();
      final fetchedDistricts = await _repository.fetchDistricts();
      final fetchedShops = await _repository.fetchShops();

      categories.assignAll(fetchedCategories);
      districts.assignAll(fetchedDistricts);
      shops.assignAll(fetchedShops);

      final args = Get.arguments;
      if (args is ContentModel) {
        editingContentId = args.id;
        titleController.text = args.title;
        summaryController.text = args.description ?? '';
        youtubeUrlController.text = args.youtubeUrl ?? '';
        youtubeUrlText.value = args.youtubeUrl ?? '';
        selectedCategoryId.value =
            args.categoryId ??
            (categories.isNotEmpty ? categories.first.id : null);
        selectedStatus.value = args.status ?? 'Published';
        if (args.latitude != null) {
          latitudeController.text = args.latitude.toString();
        }
        if (args.longitude != null) {
          longitudeController.text = args.longitude.toString();
        }
        if (args.districtId != null && args.districtId!.isNotEmpty) {
          selectedDistrictId.value = args.districtId;
          final fetchedSubs = await _repository.fetchSubDistricts(
            args.districtId!,
          );
          subDistricts.assignAll(fetchedSubs);
          if (args.subDistrictId != null && args.subDistrictId!.isNotEmpty) {
            selectedSubDistrictId.value = args.subDistrictId;
          }
        }
        if (args.shopId != null && args.shopId!.isNotEmpty) {
          selectedShopId.value = args.shopId;
        }
      } else {
        if (categories.isNotEmpty) {
          selectedCategoryId.value = categories.first.id;
        }
      }
    } catch (e) {
      debugPrint('Error loading form options: $e');
    } finally {
      isLoadingFormOptions.value = false;
    }
  }

  Future<void> onDistrictChanged(String? districtId) async {
    selectedDistrictId.value = districtId;
    selectedSubDistrictId.value = null;
    subDistricts.clear();

    if (districtId != null && districtId.isNotEmpty) {
      final fetchedSubs = await _repository.fetchSubDistricts(districtId);
      subDistricts.assignAll(fetchedSubs);
    }
  }

  String get youtubeThumbnailUrl {
    final url = youtubeUrlText.value.trim();
    if (url.isEmpty) return '';
    try {
      final uri = Uri.parse(url);
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else {
        videoId = uri.queryParameters['v'];
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
      }
    } catch (_) {}
    return '';
  }

  Future<void> submitContent() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบถ้วน',
        'กรุณากรอกชื่อเรื่องหรือหัวข้อบทความ',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    if (selectedCategoryId.value == null || selectedCategoryId.value!.isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบถ้วน',
        'กรุณาเลือกหมวดหมู่บทความท่องเที่ยว',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final payload = <String, dynamic>{
        'title': title,
        'summary': summaryController.text.trim().isEmpty
            ? null
            : summaryController.text.trim(),
        'contentCategoryId': selectedCategoryId.value,
        'districtId': selectedDistrictId.value,
        'subDistrictId': selectedSubDistrictId.value,
        'shopId': selectedShopId.value,
        'youtubeUrl': youtubeUrlController.text.trim().isEmpty
            ? null
            : youtubeUrlController.text.trim(),
        'status': selectedStatus.value,
        'latitude': double.tryParse(latitudeController.text.trim()),
        'longitude': double.tryParse(longitudeController.text.trim()),
      };

      final ContentModel? result;
      if (isEditing) {
        result = await _repository.updateContent(editingContentId!, payload);
      } else {
        result = await _repository.createContent(payload);
      }

      if (result != null) {
        // Refresh MyContentsController if registered
        if (Get.isRegistered<MyContentsController>()) {
          Get.find<MyContentsController>().fetchMyContents();
        }

        Get.back();
        Get.snackbar(
          isEditing ? 'แก้ไขคอนเทนต์สำเร็จ!' : 'ลงคอนเทนต์สำเร็จ!',
          isEditing
              ? 'บันทึกการแก้ไขคอนเทนต์เรียบร้อยแล้ว'
              : (selectedStatus.value == 'Published'
                    ? 'บทความของคุณได้รับการลงและเผยแพร่เรียบร้อยแล้ว'
                    : 'บันทึกฉบับร่างคอนเทนต์เรียบร้อยแล้ว'),
          backgroundColor: const Color(0xFF2B1F17),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถดำเนินการได้ กรุณาตรวจสอบข้อมูลและลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'เกิดข้อผิดพลาดในการดำเนินการ: $e',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
