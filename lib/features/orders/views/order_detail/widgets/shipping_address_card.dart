import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key, required this.order});

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
                  Icons.location_on_rounded,
                  color: Color(0xFFD96C2C),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ที่อยู่สำหรับจัดส่งสินค้า',
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
          const SizedBox(height: 12),
          Text(
            '${order.receiverName ?? "ผู้รับสินค้า"} (${order.receiverPhone ?? "N/A"})',
            style: GoogleFonts.krub(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress ?? 'ไม่ได้ระบุที่อยู่',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
