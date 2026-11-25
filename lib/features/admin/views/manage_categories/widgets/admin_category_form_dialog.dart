import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_categories_controller.dart';
import 'package:projecte/features/admin/models/admin_category_model.dart';

class AdminCategoryFormDialog {
  const AdminCategoryFormDialog._();

  static void showShop(
    BuildContext context,
    AdminCategoriesController controller, {
    ShopCategoryAdmin? category,
  }) {
    final nameController = TextEditingController(
      text: category?.categoryName ?? '',
    );
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    final status = category?.status ?? 'Active';

    _show(
      context,
      title: category == null ? 'สร้างหมวดหมู่ร้านค้า' : 'แก้ไขหมวดหมู่ร้านค้า',
      nameLabel: 'ชื่อหมวดหมู่ร้านค้า',
      nameController: nameController,
      descriptionController: descriptionController,
      onSave: () async {
        if (category == null) {
          await controller.createShopCategory(
            nameController.text.trim(),
            descriptionController.text.trim(),
          );
        } else {
          await controller.updateShopCategory(
            category.shopCategoryId,
            nameController.text.trim(),
            descriptionController.text.trim(),
            status,
          );
        }
      },
    );
  }

  static void showProduct(
    BuildContext context,
    AdminCategoriesController controller, {
    ProductCategoryAdmin? category,
  }) {
    final nameController = TextEditingController(
      text: category?.categoryName ?? '',
    );
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    final status = category?.status ?? 'Active';

    _show(
      context,
      title: category == null ? 'สร้างหมวดหมู่สินค้า' : 'แก้ไขหมวดหมู่สินค้า',
      nameLabel: 'ชื่อหมวดหมู่สินค้า',
      nameController: nameController,
      descriptionController: descriptionController,
      onSave: () async {
        if (category == null) {
          await controller.createProductCategory(
            nameController.text.trim(),
            descriptionController.text.trim(),
          );
        } else {
          await controller.updateProductCategory(
            category.productCategoryId,
            nameController.text.trim(),
            descriptionController.text.trim(),
            status,
          );
        }
      },
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String nameLabel,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required Future<void> Function() onSave,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: nameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'คำอธิบาย',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.primary),
            onPressed: () async {
              await onSave();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
