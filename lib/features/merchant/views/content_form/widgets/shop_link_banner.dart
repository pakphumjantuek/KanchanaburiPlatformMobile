import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ShopLinkBanner extends StatelessWidget {
  const ShopLinkBanner({super.key, required this.shopName});

  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: MerchantColors.successBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFA7F3D0)),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: MerchantColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ผูกกับร้านค้าของคุณอัตโนมัติ',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: MerchantColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Verified',
                        style: GoogleFonts.krub(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: MerchantColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'เรื่องราวนี้จะถูกเชื่อมโยงกับร้าน "$shopName" และแสดงผลต่อลูกค้า',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: MerchantColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

