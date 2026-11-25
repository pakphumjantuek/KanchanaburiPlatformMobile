import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/payment_controller.dart';

class PaymentOrderSummaryCard extends GetView<PaymentController> {
  const PaymentOrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentOrder = controller.order.value;
      final total = currentOrder?.totalAmount ?? 0.0;
      final orderNo =
          currentOrder?.orderNumber ??
          'ORD-${DateTime.now().millisecondsSinceEpoch}';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8D9C9), width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 18,
                        color: Color(0xFFD96C2C),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'หมายเลขคำสั่งซื้อ',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    '#$orderNo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE8D9C9)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยอดสุทธิต้องชำระ',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.security_rounded,
                          size: 14,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ปลอดภัย 100% (SSL Encrypted)',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            color: const Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '฿${total.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
