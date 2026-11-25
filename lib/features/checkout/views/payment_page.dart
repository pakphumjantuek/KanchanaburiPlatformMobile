import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/payment_controller.dart';
import '../widgets/payment/payment_bottom_bar.dart';
import '../widgets/payment/payment_method_options.dart';
import '../widgets/payment/payment_order_summary_card.dart';
import '../widgets/payment/payment_slip_form.dart';
import '../widgets/payment/payment_stripe_form.dart';
import '../../orders/models/order_model.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PaymentController>()) {
      Get.put(PaymentController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'เลือกวิธีชำระเงิน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Order Summary Card
            const PaymentOrderSummaryCard(),

            const SizedBox(height: 14),
            Obx(() => _buildPaymentExpiryNotice(controller.order.value)),

            const SizedBox(height: 18),

            // 2. Section Header: Select Payment Method
            _buildSectionHeader(
              'เลือกช่องทางการชำระเงิน',
              Icons.account_balance_wallet_rounded,
            ),

            const SizedBox(height: 12),

            // 3. Payment Method Choice Cards (Stripe vs PromptPay/Slip)
            const PaymentMethodOptions(),

            const SizedBox(height: 18),

            // 4. Active Method Dynamic Form View
            Obx(() {
              if (controller.selectedMethod.value == 'stripe') {
                return const PaymentStripeForm();
              } else {
                return const PaymentSlipForm();
              }
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const PaymentBottomBar(),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD96C2C), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentExpiryNotice(OrderModel? order) {
    if (order == null ||
        (!order.isAwaitingPayment && !order.isPaymentExpired)) {
      return const SizedBox.shrink();
    }
    final remaining = order.remainingPaymentTime ?? Duration.zero;
    final expired = controller.isPaymentExpired || remaining == Duration.zero;
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    final color = expired ? const Color(0xFFC62828) : const Color(0xFFE65100);
    final expiresAtText = order.paymentExpiresAt == null
        ? null
        : _formatThaiDateTime(order.paymentExpiresAt!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(
            expired ? Icons.timer_off_rounded : Icons.timer_outlined,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expired
                      ? 'หมดเวลาชำระเงินแล้ว กรุณาสั่งซื้อสินค้าใหม่อีกครั้ง'
                      : 'กรุณาชำระภายใน $hours:$minutes:$seconds นาที',
                  style: GoogleFonts.krub(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (expiresAtText != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'ชำระได้ถึง $expiresAtText',
                    style: GoogleFonts.krub(color: color, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatThaiDateTime(DateTime utcDateTime) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    final thaiTime = utcDateTime.toUtc().add(const Duration(hours: 7));
    final minute = thaiTime.minute.toString().padLeft(2, '0');
    return '${thaiTime.day} ${months[thaiTime.month - 1]} '
        '${thaiTime.year + 543} เวลา ${thaiTime.hour}:$minute น.';
  }
}
