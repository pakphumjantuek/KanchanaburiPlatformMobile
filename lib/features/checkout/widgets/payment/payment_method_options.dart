import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/payment_controller.dart';

class PaymentMethodOptions extends GetView<PaymentController> {
  const PaymentMethodOptions({super.key});

  Widget _buildMethodCard({
    required String id,
    required bool isSelected,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<String> badges,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFE8D9C9),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? accentColor : const Color(0xFF786B62),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: accentColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.krub(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF332820),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: badges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentColor.withValues(alpha: 0.1)
                              : const Color(0xFFE8D9C9).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.krub(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? accentColor
                                : const Color(0xFF786B62),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedMethod.value;

      return Column(
        children: [
          // Option 1: Stripe (Card / PromptPay / Apple Pay)
          _buildMethodCard(
            id: 'stripe',
            isSelected: selected == 'stripe',
            title: 'บัตรเครดิต / เดบิต (Stripe Gateway)',
            subtitle: 'รองรับ Visa, MasterCard, JCB, UnionPay ชำระเงินทันที',
            icon: Icons.credit_card_rounded,
            accentColor: const Color(0xFF1F5F58),
            badges: ['Visa', 'MasterCard', 'JCB', 'Stripe'],
            onTap: () => controller.setPaymentMethod('stripe'),
          ),

          const SizedBox(height: 12),

          // Option 2: PromptPay & Bank Transfer Slip
          _buildMethodCard(
            id: 'slip',
            isSelected: selected == 'slip',
            title: 'สแกน QR Code / โอนผ่านธนาคาร',
            subtitle: 'โอนผ่านแอปธนาคาร PromptPay ฟรีค่าธรรมเนียม พร้อมแนบสลิป',
            icon: Icons.qr_code_scanner_rounded,
            accentColor: const Color(0xFFD96C2C),
            badges: ['PromptPay', 'โอนเงิน', 'ฟรีค่าธรรมเนียม'],
            onTap: () => controller.setPaymentMethod('slip'),
          ),
        ],
      );
    });
  }
}
