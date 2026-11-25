import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductDealProductSummary extends StatelessWidget {
  const ProductDealProductSummary({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MerchantColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ? Image.network(
                      product.imageUrl!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: Color(0xFF94A3B8),
                          size: 28,
                        ),
                      ),
                    )
                  : Container(
                      color: MerchantColors.successBg,
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: MerchantColors.primary,
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.krub(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: MerchantColors.textPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'ราคาปกติ ฿${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'สต็อก ${product.quantity} ชิ้น',
                        style: GoogleFonts.krub(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: MerchantColors.textSecondary,
                        ),
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
  }
}
