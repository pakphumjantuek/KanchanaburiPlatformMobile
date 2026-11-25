import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/product_model.dart';
import '../repositories/merchant_repository.dart';

class ProductFormController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  final selectedCategoryId = RxnString();
  final status = 'Active'.obs;
  final categories = <Map<String, dynamic>>[].obs;

  final isLoading = true.obs;
  final isSaving = false.obs;

  ProductModel? editingProduct;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      editingProduct = args;
    }
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final cats = await _repository.fetchProductCategories();
      categories.value = cats;

      if (editingProduct != null) {
        final p = editingProduct!;
        nameController.text = p.name;
        priceController.text = p.price.toStringAsFixed(0);
        quantityController.text = p.quantity.toString();
        descriptionController.text = p.description ?? '';
        imageUrlController.text = p.imageUrl ?? '';
        selectedCategoryId.value = p.productCategoryId;
        status.value = p.status;
      }
    } catch (e) {
      debugPrint('Error loading product form data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final selectedCoverImagePath = RxnString();

  Future<void> pickCoverImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedCoverImagePath.value = pickedFile.path;
      }
    } catch (e) {
      debugPrint('Error picking cover image: $e');
    }
  }

  void removeSelectedCoverImage() {
    selectedCoverImagePath.value = null;
  }

  Future<void> submitProduct() async {
    if (!formKey.currentState!.validate()) return;

    final shop = await _repository.fetchMyShop();
    if (shop == null || shop.id.isEmpty) {
      Get.snackbar(
        'ไม่พบร้านค้าในระบบ',
        'กรุณาลงทะเบียนและเปิดใช้งานร้านค้าก่อนทำการเพิ่มหรือแก้ไขสินค้า',
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
      final payload = {
        'shopId': shop.id,
        'productName': nameController.text.trim(),
        'productCategoryId': selectedCategoryId.value,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
        'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
        'description': descriptionController.text.trim(),
        'imageUrl': editingProduct?.imageUrl ?? '',
        'status': status.value,
      };

      bool success = false;
      String? targetProductId = editingProduct?.id;

      if (editingProduct != null) {
        success = await _repository.updateProduct(editingProduct!.id, payload);
      } else {
        final newProd = await _repository.createProduct(payload);
        if (newProd != null) {
          success = true;
          targetProductId = newProd.id;
        }
      }

      bool imgUploaded = true;
      if (success &&
          selectedCoverImagePath.value != null &&
          selectedCoverImagePath.value!.isNotEmpty &&
          targetProductId != null &&
          targetProductId.isNotEmpty) {
        imgUploaded = await _repository.uploadProductCoverImage(
          targetProductId,
          selectedCoverImagePath.value!,
        );
      }

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'บันทึกสำเร็จ',
          imgUploaded
              ? (editingProduct != null ? 'อัปเดตข้อมูลสินค้าเรียบร้อยแล้ว' : 'เพิ่มสินค้าใหม่และอัปโหลดรูปเรียบร้อยแล้ว')
              : 'บันทึกข้อมูลสินค้าสำเร็จ (แต่รูปภาพอัปโหลดไม่ผ่าน กรุณาลองใหม่อีกครั้ง)',
          backgroundColor: imgUploaded ? const Color(0xFF047857) : Colors.amber.shade800,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถบันทึกสินค้าได้ กรุณาลองใหม่อีกครั้ง',
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
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}
