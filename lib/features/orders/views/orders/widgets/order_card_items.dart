import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';

class OrderCardItems extends StatelessWidget {
  const OrderCardItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: order.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 54,
                    height: 54,
                    color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF786B62),
                              size: 24,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF786B62),
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.krub(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'จำนวน: ${item.quantity} ชิ้น',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '฿${item.unitPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
