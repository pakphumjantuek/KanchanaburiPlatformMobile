import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../models/order_model.dart';

class OrderCardActions extends StatelessWidget {
  const OrderCardActions({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final hasSlip =
        order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty;
    final waitingForVerification =
        order.paymentStatus.toLowerCase() == 'pendingverification' || hasSlip;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (order.canPay)
            if (waitingForVerification)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 15,
                      color: Color(0xFFE65100),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'รอแอดมินตรวจสอบสลิป',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () =>
                    Get.toNamed(AppRoutes.payment, arguments: order),
                icon: const Icon(Icons.payment_rounded, size: 16),
                label: Text(
                  'ชำระเงิน',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C2C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                ),
              ),
          OutlinedButton.icon(
            onPressed: () =>
                Get.toNamed(AppRoutes.orderDetail, arguments: order),
            icon: const Icon(Icons.receipt_long_outlined, size: 16),
            label: Text(
              'ดูรายละเอียด',
              style: GoogleFonts.krub(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF332820),
              side: const BorderSide(color: Color(0xFFE8D9C9), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
