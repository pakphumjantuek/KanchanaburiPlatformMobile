import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:projecte/shared/widgets/app_search_field.dart';
import 'package:projecte/shared/widgets/app_view_toggle.dart';

/// Search box and view switcher shown as the `bottom` of the app bar.
class ShopListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ShopController controller;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const ShopListHeader({
    super.key,
    required this.controller,
    required this.searchController,
    required this.onSearchChanged,
  });

  static const double height = 122;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          AppSearchField(
            hintText: 'ค้นหาร้านค้า อำเภอ หรือสินค้า...',
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: () => controller.setSearch(searchController.text),
            iconColor: ShopListPalette.primary,
          ),
          const SizedBox(height: 10),
          Obx(
            () => AppViewToggle<String>(
              selectedValue: controller.viewMode.value,
              onChanged: controller.setViewMode,
              activeColor: ShopListPalette.primary,
              options: const [
                ToggleOption(
                  value: 'grid',
                  label: 'การ์ด',
                  icon: Icons.view_agenda_rounded,
                ),
                ToggleOption(
                  value: 'list',
                  label: 'รายการ',
                  icon: Icons.format_list_bulleted_rounded,
                ),
                ToggleOption(
                  value: 'map',
                  label: 'แผนที่',
                  icon: Icons.map_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
