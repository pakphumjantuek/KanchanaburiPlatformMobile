import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';
import 'order_slip_image.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_rounded,
                  color: Color(0xFFD96C2C),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'สรุปยอดการชำระเงิน',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 14),
          _summaryRow('หมายเลขคำสั่งซื้อ', '#${order.orderNumber ?? order.id}'),
          const SizedBox(height: 8),
          _summaryRow('ยอดรวมสินค้า', '฿${order.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _summaryRow(
            'ค่าจัดส่ง (${order.shippingMethod ?? "Standard"})',
            '฿${order.shippingFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยอดชำระสุทธิ',
                style: GoogleFonts.krub(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              Text(
                '฿${order.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ],
          ),
          if (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE8D9C9)),
            const SizedBox(height: 14),
            Text(
              'หลักฐานการชำระเงิน (สลิป)',
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  OrderSlipImage.showPreview(context, order.slipImageUrl!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: OrderSlipImage(
                  slip: order.slipImageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF786B62),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.end,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
      ],
    );
  }
}
