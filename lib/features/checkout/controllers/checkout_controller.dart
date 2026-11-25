import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/models/user_address_model.dart';
import '../../orders/repositories/order_repository.dart';

class CheckoutController extends GetxController {
  final OrderRepository _repository = OrderRepository();
  final CartController cartController = Get.find<CartController>();
  final AuthService _authService = Get.find<AuthService>();

  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final addressLineController = TextEditingController();
  final subDistrictController = TextEditingController();
  final districtController = TextEditingController();
  final provinceController = TextEditingController(text: 'กาญจนบุรี');
  final postalCodeController = TextEditingController();

  final selectedShippingMethod = 'Standard Delivery'.obs;
  final shippingFee = 40.0.obs;

  final savedAddresses = <UserAddressModel>[].obs;
  final isLoading = false.obs;
  final isFetchingAddresses = false.obs;

  double get subtotal => cartController.totalPrice;
  double get totalAmount => subtotal + shippingFee.value;

  @override
  void onInit() {
    super.onInit();
    _initUserData();
    loadAddresses();
  }

  void _initUserData() {
    final user = _authService.currentUser.value;
    if (user != null) {
      receiverNameController.text = user.displayName;
    }
  }

  Future<void> loadAddresses() async {
    if (!_authService.isLoggedIn.value) return;
    isFetchingAddresses.value = true;
    try {
      final list = await _repository.fetchUserAddresses();
      savedAddresses.assignAll(list);

      if (savedAddresses.isNotEmpty) {
        final defaultAddress = savedAddresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => savedAddresses.first,
        );
        applyAddress(defaultAddress);
      }
    } finally {
      isFetchingAddresses.value = false;
    }
  }

  void applyAddress(UserAddressModel address) {
    receiverNameController.text = address.recipientName;
    receiverPhoneController.text = address.recipientPhone;
    addressLineController.text = address.addressLine;
    subDistrictController.text = address.subDistrict ?? '';
    districtController.text = address.district ?? '';
    provinceController.text = address.province ?? 'กาญจนบุรี';
    postalCodeController.text = address.postalCode ?? '';
  }

  void setShippingOption(String method, double fee) {
    selectedShippingMethod.value = method;
    shippingFee.value = fee;
  }

  Future<void> submitCheckout() async {
    // Prices and deal allocations may have changed while this page was open.
    await cartController.fetchCart();
    final name = receiverNameController.text.trim();
    final phone = receiverPhoneController.text.trim();
    final addressLine = addressLineController.text.trim();
    final subDistrict = subDistrictController.text.trim();
    final district = districtController.text.trim();
    final province = provinceController.text.trim();
    final postalCode = postalCodeController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'ข้อมูลไม่ครบถ้วน',
        'กรุณากรอกชื่อผู้รับสินค้า',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
      );
      return;
    }

    if (phone.isEmpty || phone.length < 9) {
      Get.snackbar(
        'ข้อมูลไม่ครบถ้วน',
        'กรุณากรอกเบอร์โทรศัพท์ผู้รับให้ถูกต้อง',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
      );
      return;
    }

    if (addressLine.isEmpty) {
      Get.snackbar(
        'ข้อมูลไม่ครบถ้วน',
        'กรุณากรอกที่อยู่จัดส่งสินค้า',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
      );
      return;
    }

    final fullAddress = [
      addressLine,
      if (subDistrict.isNotEmpty) 'ต.$subDistrict',
      if (district.isNotEmpty) 'อ.$district',
      if (province.isNotEmpty) 'จ.$province',
      if (postalCode.isNotEmpty) postalCode,
    ].join(' ');

    isLoading.value = true;
    try {
      final apiShippingMethod =
          selectedShippingMethod.value.toLowerCase().contains('pickup')
          ? 'Pickup'
          : 'Delivery';

      final orders = await _repository.checkout(
        shippingMethod: apiShippingMethod,
        shippingFee: shippingFee.value,
        receiverName: name,
        receiverPhone: phone,
        shippingAddress: fullAddress,
      );

      if (orders.isEmpty) {
        await cartController.fetchCart();
        Get.snackbar(
          'ไม่สามารถสั่งซื้อได้',
          'ราคาโปรโมชันหรือสต็อกอาจเปลี่ยน กรุณาตรวจสอบตะกร้าอีกครั้ง',
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
        );
        return;
      }
      final targetOrder = orders.first;

      // Remove checkout items from cart
      cartController.removeSelectedItems();

      Get.snackbar(
        'สั่งซื้อสินค้าสำเร็จ',
        'สร้างรายการสั่งซื้อเรียบร้อยแล้ว',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.offNamed(AppRoutes.payment, arguments: targetOrder);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    addressLineController.dispose();
    subDistrictController.dispose();
    districtController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}
