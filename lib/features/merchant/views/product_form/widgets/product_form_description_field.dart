import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_input_decoration.dart';

class ProductFormDescriptionField extends StatelessWidget {
  const ProductFormDescriptionField({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.descriptionController,
      minLines: 3,
      maxLines: 5,
      style: GoogleFonts.krub(
        fontSize: 13.5,
        color: MerchantColors.textPrimary,
        height: 1.4,
      ),
      decoration: ProductFormInputDecoration.build(
        'รายละเอียดสินค้า (ไม่บังคับ)',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Icon(
            Icons.notes_rounded,
            color: MerchantColors.primary,
            size: 20,
          ),
        ),
      ).copyWith(
        hintText: 'อธิบายจุดเด่นของสินค้า ขนาด วิธีการใช้งาน หรือข้อมูลสำหรับลูกค้า...',
        hintStyle: GoogleFonts.krub(
          fontSize: 12.5,
          color: MerchantColors.textMuted,
        ),
      ),
    );
  }
}
