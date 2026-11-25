import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';
import '../../order_date_format.dart';

class OrderPaymentExpiryNotice extends StatelessWidget {
  const OrderPaymentExpiryNotice({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final remaining = order.remainingPaymentTime ?? Duration.zero;
    final expired = order.isPaymentExpired || remaining == Duration.zero;
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    final color = expired ? const Color(0xFFC62828) : const Color(0xFFE65100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            expired ? Icons.timer_off_rounded : Icons.timer_outlined,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expired
                      ? 'หมดเวลาชำระเงินแล้ว กรุณาสั่งซื้อสินค้าใหม่อีกครั้ง'
                      : 'เหลือเวลา $hours ชั่วโมง $minutes นาที $seconds วินาที',
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (order.paymentExpiresAt != null)
                  Text(
                    'ชำระได้ถึง ${formatOrderDate(order.paymentExpiresAt!)}',
                    style: GoogleFonts.krub(fontSize: 11.5, color: color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
