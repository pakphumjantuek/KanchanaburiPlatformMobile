import 'package:flutter/material.dart';
import 'package:projecte/features/merchant/controllers/register_shop_controller.dart';
import 'package:projecte/shared/widgets/app_text_field.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_section_card.dart';

class RegisterShopBankSection extends StatelessWidget {
  const RegisterShopBankSection({super.key, required this.controller});

  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return RegisterShopSectionCard(
      title: 'ข้อมูลบัญชีธนาคารสำหรับรับเงิน',
      icon: Icons.account_balance_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'ชื่อธนาคาร',
                hintText: 'เช่น กสิกรไทย, ไทยพาณิชย์',
                controller: controller.bankNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'ชื่อบัญชีธนาคาร',
                hintText: 'นาย สมชาย ใจดี',
                controller: controller.bankAccountNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เลขที่บัญชี',
                hintText: '123-4-56789-0',
                controller: controller.bankAccountNumberController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'เบอร์พร้อมเพย์ (ถ้ามี)',
                hintText: '0812345678',
                controller: controller.promptPayController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
