import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_input_decoration.dart';

class ProductFormBasicFields extends StatelessWidget {
  const ProductFormBasicFields({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name Field
        TextFormField(
          controller: controller.nameController,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: MerchantColors.textPrimary,
          ),
          decoration: ProductFormInputDecoration.build(
            'ชื่อสินค้า *',
            prefixIcon: const Icon(
              Icons.shopping_bag_outlined,
              color: MerchantColors.primary,
              size: 20,
            ),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'กรุณากรอกชื่อสินค้า'
              : null,
        ),

        const SizedBox(height: 14),

        // Product Category Dropdown
        Obx(() {
          final categoryEntries = controller.categories
              .map((category) {
                final id =
                    category['productCategoryId']?.toString() ??
                    category['id']?.toString() ??
                    '';
                final name =
                    category['categoryName']?.toString() ??
                    category['name']?.toString() ??
                    '';
                return MapEntry(id, name);
              })
              .where((entry) => entry.key.isNotEmpty)
              .toList();

          final uniqueCategories = <String, String>{};
          for (final entry in categoryEntries) {
            uniqueCategories[entry.key] = entry.value;
          }

          final selectedCategoryId = controller.selectedCategoryId.value;
          final validValue =
              selectedCategoryId != null &&
                  uniqueCategories.containsKey(selectedCategoryId)
              ? selectedCategoryId
              : null;

          return DropdownButtonFormField<String>(
            initialValue: validValue,
            decoration: ProductFormInputDecoration.build(
              'หมวดหมู่สินค้า *',
              prefixIcon: const Icon(
                Icons.category_outlined,
                color: MerchantColors.primary,
                size: 20,
              ),
            ),
            isExpanded: true,
            style: GoogleFonts.krub(
              fontSize: 14,
              color: MerchantColors.textPrimary,
            ),
            items: uniqueCategories.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: GoogleFonts.krub(fontSize: 13.5),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => controller.selectedCategoryId.value = value,
            validator: (value) => (value == null || value.isEmpty)
                ? 'กรุณาเลือกหมวดหมู่สินค้า'
                : null,
          );
        }),
      ],
    );
  }
}
