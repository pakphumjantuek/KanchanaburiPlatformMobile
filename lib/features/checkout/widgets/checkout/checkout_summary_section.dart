import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutSummarySection extends GetView<CheckoutController> {
  const CheckoutSummarySection({super.key});

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEADCCF)),
          child,
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          amount,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2B1F17),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: 'สรุปยอดชำระเงิน',
      icon: Icons.receipt_long_rounded,
      iconColor: const Color(0xFF2B1F17),
      child: Obx(
        () => Column(
          children: [
            _buildPriceRow(
              'ยอดรวมสินค้า',
              '฿${controller.subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildPriceRow(
              'ค่าจัดส่ง',
              '฿${controller.shippingFee.value.toStringAsFixed(2)}',
            ),
            const Divider(height: 20, color: Color(0xFFEADCCF)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ยอดสุทธิต้องชำระ',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B1F17),
                  ),
                ),
                Text(
                  '฿${controller.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
