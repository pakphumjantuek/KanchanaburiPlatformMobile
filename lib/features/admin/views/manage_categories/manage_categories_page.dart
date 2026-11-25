import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_categories_controller.dart';
import 'widgets/admin_categories_body.dart';
import 'widgets/admin_categories_tab_bar.dart';
import 'widgets/admin_category_form_dialog.dart';

class ManageCategoriesPage extends GetView<AdminCategoriesController> {
  const ManageCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminCategoriesController>()) {
      Get.put(AdminCategoriesController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'จัดการหมวดหมู่ (Categories)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AdminCategoriesTabBar(controller: controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          if (controller.activeTab.value == 0) {
            AdminCategoryFormDialog.showShop(context, controller);
          } else {
            AdminCategoryFormDialog.showProduct(context, controller);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: AdminCategoriesBody(controller: controller),
    );
  }
}
