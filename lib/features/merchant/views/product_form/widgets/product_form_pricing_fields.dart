import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_input_decoration.dart';

class ProductFormPricingFields extends StatelessWidget {
  const ProductFormPricingFields({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Input Field
            Expanded(
              child: TextFormField(
                controller: controller.priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MerchantColors.textPrimary,
                ),
                decoration: ProductFormInputDecoration.build(
                  'ราคาขาย (บาท) *',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8, top: 12),
                    child: Text(
                      '฿',
                      style: GoogleFonts.krub(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.primary,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกราคา';
                  }
                  final p = double.tryParse(value.trim());
                  if (p == null || p < 0) {
                    return 'ราคาไม่ถูกต้อง';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),

            // Stock Quantity Field
            Expanded(
              child: TextFormField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MerchantColors.textPrimary,
                ),
                decoration: ProductFormInputDecoration.build(
                  'จำนวนสต็อก *',
                  prefixIcon: const Icon(
                    Icons.inventory_2_outlined,
                    color: MerchantColors.primary,
                    size: 20,
                  ),
                  suffix: Text(
                    'ชิ้น',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: MerchantColors.textSecondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกสต็อก';
                  }
                  final q = int.tryParse(value.trim());
                  if (q == null || q < 0) {
                    return 'ระบุจำนวนเต็ม';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
