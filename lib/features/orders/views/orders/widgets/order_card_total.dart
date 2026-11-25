import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';

class OrderCardTotal extends StatelessWidget {
  const OrderCardTotal({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'รวม ${order.items.length} รายการ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.krub(
                fontSize: 12.5,
                color: const Color(0xFF786B62),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ยอดรวมสุทธิ: ',
                style: GoogleFonts.krub(
                  fontSize: 13.5,
                  color: const Color(0xFF332820),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '฿${order.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
