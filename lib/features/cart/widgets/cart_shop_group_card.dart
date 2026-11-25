import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartShopGroupCard extends GetView<CartController> {
  final String shopId;
  final List<CartItemModel> items;

  const CartShopGroupCard({
    super.key,
    required this.shopId,
    required this.items,
  });

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF2B1F17),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white54,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopName = items.first.effectiveShopName;
    final isShopSelected = controller.isShopAllSelected(shopId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFFF7F0E6).withValues(alpha: 0.6),
            child: Row(
              children: [
                Checkbox(
                  value: isShopSelected,
                  activeColor: const Color(0xFFD96C2C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    controller.toggleSelectShop(shopId, val ?? false);
                  },
                ),
                const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF1F5F58),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B1F17),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEADCCF)),

          // Items under shop
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, i) => const Divider(
              height: 1,
              indent: 48,
              endIndent: 16,
              color: Color(0xFFF0E6DC),
            ),
            itemBuilder: (context, itemIndex) {
              final item = items[itemIndex];
              final maxStock = item.product.quantity;
              final isAtMaxStock = item.quantity >= maxStock;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Item Selection Checkbox
                    Checkbox(
                      value: item.isSelected,
                      activeColor: const Color(0xFFD96C2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        controller.toggleSelect(item.id);
                      },
                    ),

                    // Product Thumbnail Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: const Color(0xFFF7F0E6),
                        child:
                            item.product.imageUrl != null &&
                                item.product.imageUrl!.isNotEmpty
                            ? Image.network(
                                item.product.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(),
                              )
                            : _buildImagePlaceholder(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Product Info & Stepper
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.krub(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2B1F17),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    controller.removeFromCart(item.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Stock Limit Label
                          Text(
                            isAtMaxStock
                                ? '⚠️ เพิ่มครบตามสต็อกแล้ว (มี $maxStock ชิ้น)'
                                : 'คงเหลือในสต็อก $maxStock ชิ้น',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: isAtMaxStock
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isAtMaxStock
                                  ? const Color(0xFFE65100)
                                  : const Color(0xFF786B62),
                            ),
                          ),
                          const SizedBox(height: 6),

                          if (item.dealQuantity > 0) ...[
                            Text(
                              '${item.dealType?.toLowerCase() == 'localdeal' ? 'โปรเด็ดชุมชน' : 'โปรโมชันพิเศษ'} ${item.dealQuantity} ชิ้น x ฿${(item.dealUnitPrice ?? 0).toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: const Color(0xFF047857),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          if (item.normalQuantity > 0)
                            Text(
                              'ราคาปกติ ${item.normalQuantity} ชิ้น x ฿${(item.normalUnitPrice ?? item.product.price).toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                          if (item.dealQuantity > 0 || item.normalQuantity > 0)
                            const SizedBox(height: 4),
                          if (item.dealQuantity > 0 && item.dealEndsAt != null)
                            Text(
                              'สิทธิ์ราคาพิเศษสิ้นสุด ${_formatThaiDateTime(item.dealEndsAt!)}',
                              style: GoogleFonts.krub(
                                fontSize: 10.5,
                                color: const Color(0xFFE65100),
                              ),
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price Display
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'รวม ฿${item.subtotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.krub(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD96C2C),
                                    ),
                                  ),
                                ],
                              ),

                              // Stepper Controls (- / qty / +)
                              Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F0E6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFEADCCF),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          controller.decrementQuantity(item.id),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            left: Radius.circular(10),
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Icon(
                                          item.quantity == 1
                                              ? Icons.delete_outline_rounded
                                              : Icons.remove,
                                          size: 14,
                                          color: item.quantity == 1
                                              ? const Color(0xFFC62828)
                                              : const Color(0xFF2B1F17),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: GoogleFonts.krub(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2B1F17),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: isAtMaxStock
                                          ? null
                                          : () => controller.incrementQuantity(
                                              item.id,
                                            ),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            right: Radius.circular(10),
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 14,
                                          color: isAtMaxStock
                                              ? Colors.grey[400]
                                              : const Color(0xFF2B1F17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatThaiDateTime(DateTime utcDateTime) {
    final thaiTime = utcDateTime.toUtc().add(const Duration(hours: 7));
    return '${thaiTime.day}/${thaiTime.month}/${thaiTime.year + 543} '
        '${thaiTime.hour.toString().padLeft(2, '0')}:${thaiTime.minute.toString().padLeft(2, '0')} น.';
  }
}
