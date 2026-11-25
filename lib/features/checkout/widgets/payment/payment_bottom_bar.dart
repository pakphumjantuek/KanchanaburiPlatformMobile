import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/payment_controller.dart';

class PaymentBottomBar extends GetView<PaymentController> {
  const PaymentBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentOrder = controller.order.value;
      final total = currentOrder?.totalAmount ?? 0.0;
      final isStripe = controller.selectedMethod.value == 'stripe';
      final isExpired = controller.isPaymentExpired;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          border: const Border(
            top: BorderSide(color: Color(0xFFE8D9C9), width: 1.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ยอดชำระสุทธิ',
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  Text(
                    '฿${total.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isExpired
                        ? null
                        : () {
                            if (isStripe) {
                              controller.processStripePayment();
                            } else {
                              controller.submitSlipPayment();
                            }
                          },
                    icon: Icon(
                      isStripe ? Icons.lock_rounded : Icons.send_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isStripe ? 'ยืนยันชำระเงินด้วยบัตร' : 'ยืนยันส่งสลิป',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpired
                          ? const Color(0xFF9E9E9E)
                          : isStripe
                          ? const Color(0xFF1F5F58)
                          : const Color(0xFFD96C2C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
