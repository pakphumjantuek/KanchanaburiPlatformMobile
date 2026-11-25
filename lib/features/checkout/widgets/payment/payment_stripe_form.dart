import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../controllers/payment_controller.dart';

class PaymentStripeForm extends GetView<PaymentController> {
  const PaymentStripeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_rounded,
                color: Color(0xFF1F5F58),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'กรอกข้อมูลบัตรเครดิต / เดบิต',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5F58).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SSL 256-bit',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F5F58),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 16),

          Text(
            'หมายเลขบัตร, วันหมดอายุ และ CVC',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 8),

          // Official Stripe CardFormField Widget for Direct Typing
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: CardFormField(
              controller: CardFormEditController(),
              onCardChanged: (card) {
                controller.cardFormDetails.value = card;
              },
            ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: controller.cardHolderController,
            labelText: 'ชื่อบนหน้าบัตร (Cardholder Name)',
            hintText: 'เช่น SOMCHAI JAIDEE',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF1F5F58),
            ),
          ),

          const SizedBox(height: 22),

          Obx(
            () => AppButton(
              text:
                  'ยืนยันชำระเงินด้วยบัตร • ฿${(controller.order.value?.totalAmount ?? 0.0).toStringAsFixed(2)}',
              color: const Color(0xFF1F5F58),
              icon: Icons.lock_rounded,
              isLoading: controller.isLoading.value,
              onPressed: controller.processStripePayment,
            ),
          ),
        ],
      ),
    );
  }
}
