import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contents/models/district_model.dart';
import '../../shops/models/category_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class RegisterShopController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  final categories = <ShopCategory>[].obs;
  final districts = <District>[].obs;
  final subDistricts = <SubDistrict>[].obs;

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final selectedSubDistrictId = RxnString();

  final latitude = RxnDouble();
  final longitude = RxnDouble();

  final shopNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();
  final bankNameController = TextEditingController();
  final bankAccountNameController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final promptPayController = TextEditingController();
  final coverImageUrlController = TextEditingController();
  final backgroundImageUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.fetchShopCategories(),
        _repository.fetchDistricts(),
        _repository.fetchMyShop(),
      ]);

      categories.value = results[0] as List<ShopCategory>;
      districts.value = results[1] as List<District>;

      final shop = results[2] as ShopModel?;
      if (shop != null) {
        myShop.value = shop;
        populateForm(shop);
      }
    } catch (e) {
      debugPrint('Error loading register shop data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void populateForm(ShopModel shop) {
    shopNameController.text = shop.name;
    descriptionController.text = shop.description ?? '';
    phoneController.text = shop.phone ?? '';
    emailController.text = shop.email ?? '';
    addressController.text = shop.address ?? '';
    openingTimeController.text = shop.openingTime ?? '';
    closingTimeController.text = shop.closingTime ?? '';
    bankNameController.text = shop.bankName ?? '';
    bankAccountNameController.text = shop.bankAccountName ?? '';
    bankAccountNumberController.text = shop.bankAccountNumber ?? '';
    promptPayController.text = shop.promptPay ?? '';
    coverImageUrlController.text = shop.coverImageUrl ?? '';
    backgroundImageUrlController.text = shop.backgroundImageUrl ?? '';

    selectedCategoryId.value = shop.shopCategoryId;
    latitude.value = shop.latitude;
    longitude.value = shop.longitude;

    if (shop.districtId != null) {
      selectedDistrictId.value = shop.districtId;
      onDistrictChanged(
        shop.districtId,
        keepSubDistrict: true,
        initialSubDistrictId: shop.subDistrictId,
      );
    }
  }

  Future<void> onDistrictChanged(
    String? districtId, {
    bool keepSubDistrict = false,
    String? initialSubDistrictId,
  }) async {
    selectedDistrictId.value = districtId;
    if (districtId == null || districtId.isEmpty) {
      subDistricts.clear();
      selectedSubDistrictId.value = null;
      return;
    }

    final list = await _repository.fetchSubDistricts(districtId);
    subDistricts.value = list;

    if (keepSubDistrict && initialSubDistrictId != null) {
      selectedSubDistrictId.value = initialSubDistrictId;
    } else {
      selectedSubDistrictId.value = null;
    }
  }

  Future<void> submitApplication() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoryId.value == null ||
        selectedDistrictId.value == null ||
        selectedSubDistrictId.value == null) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบถ้วน',
        'กรุณาเลือกหมวดหมู่ อำเภอ และตำบล',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;
    try {
      final payload = {
        'shopName': shopNameController.text.trim(),
        'shopCategoryId': selectedCategoryId.value,
        'districtId': selectedDistrictId.value,
        'subDistrictId': selectedSubDistrictId.value,
        'description': descriptionController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'openingTime': openingTimeController.text.trim(),
        'closingTime': closingTimeController.text.trim(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        'bankName': bankNameController.text.trim(),
        'bankAccountName': bankAccountNameController.text.trim(),
        'bankAccountNumber': bankAccountNumberController.text.trim(),
        'promptPay': promptPayController.text.trim(),
        'coverImageUrl': coverImageUrlController.text.trim(),
        'backgroundImageUrl': backgroundImageUrlController.text.trim(),
      };

      ShopModel? result;
      if (myShop.value != null) {
        final success = await _repository.updateShop(myShop.value!.id, payload);
        if (success) {
          result = await _repository.fetchMyShop();
        }
      } else {
        result = await _repository.createShop(payload);
      }

      if (result != null) {
        myShop.value = result;
        Get.snackbar(
          'ส่งใบสมัครแล้ว',
          'เจ้าหน้าที่/แอดมินจะทำการตรวจสอบข้อมูลก่อนเปิดใช้งานร้านค้า',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถส่งใบสมัครได้ กรุณาลองใหม่อีกครั้ง',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    shopNameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    bankNameController.dispose();
    bankAccountNameController.dispose();
    bankAccountNumberController.dispose();
    promptPayController.dispose();
    super.onClose();
  }
}
