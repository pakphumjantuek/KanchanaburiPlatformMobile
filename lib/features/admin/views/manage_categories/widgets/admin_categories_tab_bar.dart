import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_categories_controller.dart';

class AdminCategoriesTabBar extends StatelessWidget {
  const AdminCategoriesTabBar({super.key, required this.controller});

  final AdminCategoriesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AdminColors.primary,
      child: Obx(
        () => Row(
          children: [
            _buildTab('หมวดหมู่ร้านค้า', 0),
            _buildTab('หมวดหมู่สินค้า', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = controller.activeTab.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.switchTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AdminColors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
