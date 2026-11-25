import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutItemsSection extends GetView<CheckoutController> {
  const CheckoutItemsSection({super.key});

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEADCCF)),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: 'รายการสินค้าที่จะสั่งซื้อ',
      icon: Icons.shopping_bag_rounded,
      iconColor: const Color(0xFF1F5F58),
      child: Obx(() {
        final selectedItems = controller.cartController.cartItems
            .where((item) => item.isSelected)
            .toList();

        if (selectedItems.isEmpty) {
          return Text(
            'ไม่มีสินค้าที่เลือกในตะกร้า',
            style: GoogleFonts.krub(color: Colors.red),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedItems.length,
          separatorBuilder: (context, i) =>
              const Divider(height: 16, color: Color(0xFFF0E6DC)),
          itemBuilder: (context, i) {
            final item = selectedItems[i];
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: const Color(0xFFF7F0E6),
                    child:
                        item.product.imageUrl != null &&
                            item.product.imageUrl!.isNotEmpty
                        ? Image.network(
                            item.product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.grey,
                                ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2B1F17),
                        ),
                      ),
                      Text(
                        '${item.effectiveShopName} • x${item.quantity}',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (item.dealQuantity > 0)
                        Text(
                          '${item.dealType?.toLowerCase() == 'localdeal' ? 'โปรเด็ดชุมชน' : 'โปรโมชันพิเศษ'} ${item.dealQuantity} ชิ้น x ฿${(item.dealUnitPrice ?? 0).toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: const Color(0xFF047857),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (item.normalQuantity > 0)
                        Text(
                          'ราคาปกติ ${item.normalQuantity} ชิ้น x ฿${(item.normalUnitPrice ?? item.product.price).toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '฿${item.subtotal.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
