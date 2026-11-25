import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../contents/models/content_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class ContentFormController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final titleController = TextEditingController();
  final summaryController = TextEditingController();
  final bodyController = TextEditingController();
  final coverImageUrlController = TextEditingController();
  final youtubeUrlController = TextEditingController();

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final selectedSubDistrictId = RxnString();
  final selectedStatus = 'Published'.obs; // 'Published' or 'Draft'

  final shop = Rxn<ShopModel>();
  final categories = <Map<String, dynamic>>[].obs;
  final districts = <District>[].obs;
  final subDistricts = <SubDistrict>[].obs;

  final isLoadingForm = true.obs;
  final isLoadingSubDistricts = false.obs;
  final isSaving = false.obs;
  final isEditing = false.obs;
  ContentModel? contentToEdit;

  final statusOptions = [
    {'label': '🟢 เผยแพร่ทันที', 'value': 'Published'},
    {'label': '📝 บันทึกร่าง', 'value': 'Draft'},
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ContentModel) {
      contentToEdit = Get.arguments as ContentModel;
      isEditing.value = true;
    }
    loadFormData();
  }

  Future<void> loadFormData() async {
    isLoadingForm.value = true;
    try {
      final shopData = await _repository.fetchMyShop();
      shop.value = shopData;

      final catData = await _repository.fetchContentCategories();
      categories.value = catData;

      final distData = await _repository.fetchDistricts();
      districts.value = distData;

      if (isEditing.value && contentToEdit != null) {
        _prefillData(contentToEdit!);
      } else {
        // Auto fill shop defaults matching Vue logic
        if (shopData != null) {
          selectedDistrictId.value = shopData.districtId;
          selectedSubDistrictId.value = shopData.subDistrictId;
          if (shopData.districtId != null && shopData.districtId!.isNotEmpty) {
            await loadSubDistricts(shopData.districtId!);
          }
        }
        if (selectedCategoryId.value == null && catData.isNotEmpty) {
          selectedCategoryId.value = catData.first['contentCategoryId']?.toString() ??
              catData.first['id']?.toString();
        }
      }
    } catch (e) {
      debugPrint('Error loading form data: $e');
    } finally {
      isLoadingForm.value = false;
    }
  }

  void _prefillData(ContentModel model) async {
    titleController.text = model.title;
    summaryController.text = model.description ?? '';
    bodyController.text = model.body ?? '';
    coverImageUrlController.text = model.coverImageUrl ?? '';
    youtubeUrlController.text = model.youtubeUrl ?? '';
    selectedCategoryId.value = model.categoryId;
    selectedDistrictId.value = model.districtId;
    selectedSubDistrictId.value = model.subDistrictId;
    selectedStatus.value = (model.status == 'Draft') ? 'Draft' : 'Published';

    if (model.districtId != null && model.districtId!.isNotEmpty) {
      await loadSubDistricts(model.districtId!);
    }
  }

  Future<void> loadSubDistricts(String districtId) async {
    isLoadingSubDistricts.value = true;
    try {
      final list = await _repository.fetchSubDistricts(districtId);
      subDistricts.value = list;
    } catch (e) {
      debugPrint('Error loading sub-districts: $e');
    } finally {
      isLoadingSubDistricts.value = false;
    }
  }

  void onDistrictChanged(String? districtId) {
    selectedDistrictId.value = districtId;
    selectedSubDistrictId.value = null;
    subDistricts.clear();
    if (districtId != null && districtId.isNotEmpty) {
      loadSubDistricts(districtId);
    }
  }

  String get youtubeThumbnailUrl {
    final url = youtubeUrlController.text.trim();
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
        return 'https://i.ytimg.com/vi/$videoId/mqdefault.jpg';
      }
    } catch (_) {}
    return '';
  }

  Future<void> saveContent() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบ',
        'กรุณาระบุชื่อเรื่องราว / หัวข้อข่าวสาร',
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedCategoryId.value == null || selectedCategoryId.value!.isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบ',
        'กรุณาเลือกหมวดหมู่บทความ',
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (shop.value == null) {
      shop.value = await _repository.fetchMyShop();
    }

    if (shop.value == null) {
      Get.snackbar(
        'ไม่พบร้านค้าในระบบ',
        'กรุณาลงทะเบียนและเปิดใช้งานร้านค้าก่อนทำการเผยแพร่บทความ',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.registerShop),
          child: const Text('ลงทะเบียน', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        ),
      );
      return;
    }

    isSaving.value = true;
    try {
      String cover = youtubeThumbnailUrl;
      if (cover.isEmpty && contentToEdit != null) {
        cover = contentToEdit?.coverImageUrl ?? '';
      }

      final payload = <String, dynamic>{
        'title': title,
        'summary': summaryController.text.trim(),
        'description': summaryController.text.trim(),
        'content': bodyController.text.trim(),
        'coverImageUrl': cover,
        'youtubeUrl': youtubeUrlController.text.trim(),
        'contentCategoryId': selectedCategoryId.value,
        'shopId': shop.value?.shopId,
        'districtId': selectedDistrictId.value,
        'subDistrictId': selectedSubDistrictId.value,
        'latitude': shop.value?.latitude,
        'longitude': shop.value?.longitude,
        'status': selectedStatus.value,
      };

      bool success = false;
      if (isEditing.value && contentToEdit != null) {
        success = await _repository.updateContent(contentToEdit!.id, payload);
      } else {
        success = await _repository.createContent(payload);
      }

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'บันทึกสำเร็จ',
          selectedStatus.value == 'Published'
              ? 'คอนเทนต์แสดงผลต่อสาธารณะเรียบร้อยแล้ว'
              : 'บันทึกเป็นฉบับร่างเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถบันทึกบทความได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    summaryController.dispose();
    bodyController.dispose();
    coverImageUrlController.dispose();
    youtubeUrlController.dispose();
    super.onClose();
  }
}
