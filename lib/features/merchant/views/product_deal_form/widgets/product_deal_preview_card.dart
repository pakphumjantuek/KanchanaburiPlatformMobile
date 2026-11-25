import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductDealPreviewCard extends StatelessWidget {
  const ProductDealPreviewCard({
    super.key,
    required this.originalPrice,
    required this.discountValue,
    required this.discountType,
    required this.quantity,
  });

  final double originalPrice;
  final double discountValue;
  final String discountType;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final isPercent = discountType == 'Percent';
    double savings = 0;
    if (isPercent) {
      savings = originalPrice * (discountValue.clamp(0, 100) / 100);
    } else {
      savings = discountValue.clamp(0, originalPrice);
    }
    final finalPrice = (originalPrice - savings).clamp(0.0, originalPrice);
    final percentSaved = originalPrice > 0 ? (savings / originalPrice * 100).round() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFD97706),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'พรีวิวราคาโปรโมชันที่ลูกค้าจะเห็น',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
              const Spacer(),
              if (savings > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ลด $percentSaved%',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '฿${finalPrice.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: MerchantColors.primaryDark,
                ),
              ),
              const SizedBox(width: 10),
              if (savings > 0)
                Text(
                  '฿${originalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: MerchantColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const Spacer(),
              Text(
                'โควตา $quantity สิทธิ์',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          if (savings > 0) ...[
            const SizedBox(height: 4),
            Text(
              'ลูกค้าประหยัดได้ ฿${savings.toStringAsFixed(2)} ต่อชิ้น',
              style: GoogleFonts.krub(
                fontSize: 11.5,
                color: MerchantColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
