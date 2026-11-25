import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/shared/widgets/app_button.dart';
import 'package:projecte/features/merchant/controllers/register_shop_controller.dart';

class RegisterShopSubmitButton extends StatelessWidget {
  const RegisterShopSubmitButton({super.key, required this.controller});

  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEdit = controller.myShop.value?.status == 'Rejected';
      return AppButton(
        text: isEdit ? 'แก้ไขและส่งใบสมัครอีกครั้ง' : 'ส่งใบสมัครเปิดร้านค้า',
        isLoading: controller.isSaving.value,
        onPressed: () => controller.submitApplication(),
      );
    });
  }
}
