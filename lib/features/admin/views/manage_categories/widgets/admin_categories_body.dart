import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_categories_controller.dart';
import 'package:projecte/features/admin/views/manage_categories/widgets/admin_category_card.dart';
import 'package:projecte/features/admin/views/manage_categories/widgets/admin_category_form_dialog.dart';

class AdminCategoriesBody extends StatelessWidget {
  const AdminCategoriesBody({super.key, required this.controller});

  final AdminCategoriesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.activeTab.value == 0) {
        if (controller.isShopLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AdminColors.primary),
          );
        }
        final items = controller.shopCategories;
        if (items.isEmpty) {
          return Center(
            child: Text('ไม่มีหมวดหมู่ร้านค้า', style: GoogleFonts.krub()),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final category = items[index];
            return AdminCategoryCard(
              name: category.categoryName,
              description: category.description,
              icon: Icons.category_outlined,
              color: AdminColors.primary,
              onEdit: () => AdminCategoryFormDialog.showShop(
                context,
                controller,
                category: category,
              ),
              onDelete: () =>
                  controller.deleteShopCategory(category.shopCategoryId),
            );
          },
        );
      }

      if (controller.isProductLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AdminColors.primary),
        );
      }
      final items = controller.productCategories;
      if (items.isEmpty) {
        return Center(
          child: Text('ไม่มีหมวดหมู่สินค้า', style: GoogleFonts.krub()),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final category = items[index];
          return AdminCategoryCard(
            name: category.categoryName,
            description: category.description,
            icon: Icons.shopping_bag_outlined,
            color: AdminColors.accent,
            onEdit: () => AdminCategoryFormDialog.showProduct(
              context,
              controller,
              category: category,
            ),
            onDelete: () =>
                controller.deleteProductCategory(category.productCategoryId),
          );
        },
      );
    });
  }
}
