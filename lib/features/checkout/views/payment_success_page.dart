import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../orders/models/order_model.dart';
import '../widgets/payment_success/payment_success_action_buttons.dart';
import '../widgets/payment_success/payment_success_summary_card.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final OrderModel? order = args is OrderModel ? args : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon Badge
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'ทำรายการสั่งซื้อสำเร็จ!',
                style: GoogleFonts.krub(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'ขอบคุณที่ร่วมอุดหนุนสินค้าโอทอปและของฝากชุมชนจังหวัดกาญจนบุรี',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Order Summary Info Box
              if (order != null) ...[
                PaymentSuccessSummaryCard(order: order),
                const SizedBox(height: 36),
              ],

              // CTA Action Buttons
              const PaymentSuccessActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
