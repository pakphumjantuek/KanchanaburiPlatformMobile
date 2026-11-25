import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';

/// One scrollable row of filters (district, open now, categories)
/// followed by "พบ N ร้าน" and removable tags for active filters.
class ShopListFilters extends StatelessWidget {
  final ShopController controller;
  final VoidCallback onClearSearch;

  const ShopListFilters({
    super.key,
    required this.controller,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                _PillButton(
                  icon: Icons.location_on_rounded,
                  label: controller.selectedDistrictName ?? 'ทุกอำเภอ',
                  active: controller.selectedDistrictId.value != null,
                  trailing: Icons.keyboard_arrow_down_rounded,
                  onTap: () => _openDistrictSheet(context),
                ),
                const SizedBox(width: 8),
                _PillButton(
                  icon: Icons.schedule_rounded,
                  label: 'เปิดอยู่ตอนนี้',
                  active: controller.onlyOpenNow.value,
                  onTap: controller.toggleOnlyOpenNow,
                ),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: ShopListPalette.line,
                ),
                _CategoryChip(
                  label: 'ทั้งหมด',
                  selected: controller.selectedCategoryId.value == null,
                  onTap: () => controller.selectCategory(null),
                ),
                for (final cat in controller.categories) ...[
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: cat.name,
                    selected: controller.selectedCategoryId.value == cat.id,
                    onTap: () => controller.selectCategory(cat.id),
                  ),
                ],
              ],
            ),
          ),
          _summary(),
        ],
      ),
    );
  }

  Widget _summary() {
    final count = controller.displayedShops.length;
    final search = controller.searchQuery.value;
    final district = controller.selectedDistrictName;
    final category = controller.selectedCategoryName;
    final loading = controller.isLoading.value && controller.hasLoaded.value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              loading ? 'กำลังค้นหา...' : 'พบ $count ร้าน',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ShopListPalette.muted,
              ),
            ),
          ),
          if (search.isNotEmpty)
            _FilterTag(label: '"$search"', onRemove: onClearSearch),
          if (district != null)
            _FilterTag(
              label: district,
              onRemove: () => controller.selectDistrict(null),
            ),
          if (category != null)
            _FilterTag(
              label: category,
              onRemove: () => controller.selectCategory(null),
            ),
          if (controller.onlyOpenNow.value)
            _FilterTag(
              label: 'เปิดอยู่',
              onRemove: controller.toggleOnlyOpenNow,
            ),
        ],
      ),
    );
  }

  void _openDistrictSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        void pick(String? id) {
          Navigator.of(sheetContext).pop();
          if (id != controller.selectedDistrictId.value) {
            controller.selectDistrict(id);
          }
        }

        Widget chip(String label, String? id) => ChoiceChip(
          label: Text(label),
          selected: controller.selectedDistrictId.value == id,
          onSelected: (_) => pick(id),
          showCheckmark: false,
          selectedColor: ShopListPalette.primary,
          backgroundColor: ShopListPalette.canvas,
          side: BorderSide.none,
          shape: const StadiumBorder(),
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: controller.selectedDistrictId.value == id
                ? Colors.white
                : ShopListPalette.ink,
          ),
        );

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เลือกอำเภอ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ShopListPalette.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ดูร้านค้าชุมชนเฉพาะพื้นที่ที่สนใจ',
                  style: TextStyle(fontSize: 13, color: ShopListPalette.muted),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: [
                        chip('ทุกอำเภอ', null),
                        for (final d in controller.districts)
                          chip(d.name, d.id),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final IconData? trailing;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : ShopListPalette.ink;
    return Material(
      color: active ? ShopListPalette.ink : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: active ? ShopListPalette.ink : ShopListPalette.line,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 8, trailing != null ? 8 : 14, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 2),
                Icon(trailing, size: 18, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? ShopListPalette.primary : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? ShopListPalette.primary : ShopListPalette.line,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : ShopListPalette.inkSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterTag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _FilterTag({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ShopListPalette.primarySoft,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onRemove,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: ShopListPalette.primary,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.close_rounded,
                size: 14,
                color: ShopListPalette.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
