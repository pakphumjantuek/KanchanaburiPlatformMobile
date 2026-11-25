import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductFormHeroHeader extends StatelessWidget {
  const ProductFormHeroHeader({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingProduct != null;
    final product = controller.editingProduct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      decoration: const BoxDecoration(
        gradient: MerchantColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              isEditing ? Icons.edit_note_rounded : Icons.add_business_rounded,
              color: const Color(0xFFFDE68A),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? (product?.name ?? 'แก้ไขข้อมูลสินค้า')
                      : 'เพิ่มสินค้าใหม่เข้าสู่ร้าน',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  isEditing
                      ? 'อัปเดตราคา จำนวนสต็อกคงเหลือ และรูปภาพสินค้า'
                      : 'กรอกข้อมูลรายละเอียดสินค้า รูปภาพ และกำหนดราคาขาย',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFFA7F3D0).withValues(alpha: 0.95),
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
