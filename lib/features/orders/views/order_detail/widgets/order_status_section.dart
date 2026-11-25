import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';
import '../../order_date_format.dart';

class OrderStatusBanner extends StatelessWidget {
  const OrderStatusBanner({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    late final Color bannerColor;
    late final IconData bannerIcon;
    late final String description;

    if (order.paymentStatus.toLowerCase() == 'pendingverification' ||
        (order.slipImageUrl != null &&
            order.slipImageUrl!.isNotEmpty &&
            order.orderStatus.toLowerCase() == 'pending')) {
      bannerColor = const Color(0xFFD96C2C);
      bannerIcon = Icons.access_time_filled_rounded;
      description = 'ส่งสลิปชำระเงินเรียบร้อยแล้ว รอเจ้าหน้าที่ตรวจสอบ';
    } else {
      switch (order.orderStatus.toLowerCase()) {
        case 'pending':
          bannerColor = const Color(0xFFE76F51);
          if (order.paymentStatus.toLowerCase() == 'paid') {
            bannerIcon = Icons.verified_rounded;
            description =
                'ชำระเงินสำเร็จแล้ว ร้านค้ากำลังรอยืนยันออเดอร์ของคุณ';
          } else {
            bannerIcon = Icons.hourglass_empty_rounded;
            description = 'กรุณาชำระเงินเพื่อดำเนินการต่อในขั้นตอนถัดไป';
          }
          break;
        case 'paid':
        case 'processing':
          bannerColor = const Color(0xFF2A9D8F);
          bannerIcon = Icons.inventory_2_rounded;
          description = 'ผู้ขายกำลังจัดเตรียมสินค้าของคุณเพื่อการจัดส่ง';
          break;
        case 'shipped':
          bannerColor = const Color(0xFF2980B9);
          bannerIcon = Icons.local_shipping_rounded;
          description = 'พัสดุของคุณอยู่ระหว่างการจัดส่งไปยังที่อยู่ระบุ';
          break;
        case 'completed':
          bannerColor = const Color(0xFF059669);
          bannerIcon = Icons.check_circle_rounded;
          description =
              'คำสั่งซื้อสำเร็จ ขอบคุณที่ร่วมอุดหนุนสินค้าโอทอปกาญจนบุรี';
          break;
        case 'cancelled':
          bannerColor = const Color(0xFF786B62);
          bannerIcon = Icons.cancel_rounded;
          description = 'คำสั่งซื้อนี้ถูกยกเลิกเรียบร้อยแล้ว';
          break;
        case 'expired':
          bannerColor = const Color(0xFF786B62);
          bannerIcon = Icons.timer_off_rounded;
          description =
              'คำสั่งซื้อนี้ถูกยกเลิก เพราะไม่ได้ชำระเงินภายใน 30 นาที หากยังต้องการสินค้า กรุณาสั่งซื้อใหม่';
          break;
        default:
          bannerColor = const Color(0xFFD96C2C);
          bannerIcon = Icons.info_rounded;
          description = 'สถานะคำสั่งซื้อปัจจุบันของคุณ';
      }
    }

    final createdAt = order.createdAt == null
        ? '-'
        : formatOrderDate(order.createdAt!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bannerColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.statusLabel,
                  style: GoogleFonts.krub(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'สั่งซื้อเมื่อ: $createdAt',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            bannerIcon,
            size: 44,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }
}

class PaymentExpiryNotice extends StatelessWidget {
  const PaymentExpiryNotice({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final remaining = order.remainingPaymentTime ?? Duration.zero;
    final expired = order.isPaymentExpired || remaining == Duration.zero;
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    final color = expired ? const Color(0xFFC62828) : const Color(0xFFE65100);
    final expiresAt = order.paymentExpiresAt == null
        ? null
        : formatOrderDate(order.paymentExpiresAt!);

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
                if (expiresAt != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'ชำระได้ถึง $expiresAt',
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
}
