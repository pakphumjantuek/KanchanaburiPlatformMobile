import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../models/order_model.dart';

class ShopOrderItemsCard extends StatelessWidget {
  const ShopOrderItemsCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD96C2C,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 18,
                          color: Color(0xFFD96C2C),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          order.shopName ?? 'ร้านค้าชุมชนกาญจนบุรี',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.krub(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF332820),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.shopId != null && order.shopId!.isNotEmpty)
                  InkWell(
                    onTap: () => Get.toNamed(
                      AppRoutes.shopDetail,
                      arguments: order.shopId,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8D9C9)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ดูร้านค้า',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD96C2C),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Color(0xFFD96C2C),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 58,
                          height: 58,
                          color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
                          child:
                              item.imageUrl != null && item.imageUrl!.isNotEmpty
                              ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Color(0xFF786B62),
                                    size: 26,
                                  ),
                                )
                              : const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xFF786B62),
                                  size: 26,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF332820),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '฿${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '฿${item.totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
