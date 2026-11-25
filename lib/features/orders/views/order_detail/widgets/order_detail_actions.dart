import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../models/order_model.dart';

class OrderDetailActions extends StatelessWidget {
  const OrderDetailActions({
    super.key,
    required this.order,
    required this.onConfirmReceived,
  });

  final OrderModel order;
  final VoidCallback onConfirmReceived;

  @override
  Widget build(BuildContext context) {
    final waitingForSlipReview =
        order.paymentStatus.toLowerCase() == 'pendingverification' ||
        (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty);

    return Column(
      children: [
        if (order.canPay)
          if (waitingForSlipReview)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_read_rounded,
                    color: Color(0xFFE65100),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'แนบสลิปเรียบร้อยแล้ว — รอแอดมินตรวจสอบ',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE65100),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Get.toNamed(AppRoutes.payment, arguments: order),
                icon: const Icon(Icons.payment_rounded, size: 20),
                label: Text(
                  'ดำเนินการชำระเงิน',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C2C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
            ),
        if (order.orderStatus.toLowerCase() == 'shipped' &&
            order.paymentStatus.toLowerCase() == 'paid') ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onConfirmReceived,
              icon: const Icon(Icons.inventory_rounded),
              label: Text(
                'ยืนยันว่าได้รับสินค้าแล้ว',
                style: GoogleFonts.krub(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F5F58),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
