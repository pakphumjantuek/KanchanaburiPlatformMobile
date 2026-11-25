import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/app_category_chip.dart';
import '../../home/widgets/home_colors.dart';
import '../controllers/content_controller.dart';

const _brand = HomeColors.brandPrimary;
const _ink = HomeColors.textBlack;
const _muted = HomeColors.textMuted;
const _line = HomeColors.borderLight;

class ContentCategoryDistrictFilter extends GetView<ContentController> {
  const ContentCategoryDistrictFilter({super.key});

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
                _DistrictButton(
                  label: controller.selectedDistrictName ?? 'ทุกอำเภอ',
                  isActive: controller.selectedDistrictId.value != null,
                  onTap: () => _openDistrictSheet(context),
                ),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: _line,
                ),
                AppCategoryChip(
                  label: 'ทั้งหมด',
                  isSelected: controller.selectedCategoryId.value == null,
                  onTap: () => controller.selectCategory(null),
                ),
                ...controller.categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AppCategoryChip(
                      label: cat.name,
                      isSelected: controller.selectedCategoryId.value == cat.id,
                      onTap: () => controller.selectCategory(cat.id),
                    ),
                  );
                }),
              ],
            ),
          ),
          _ResultSummary(controller: controller),
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
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ดูเรื่องราวและสถานที่เฉพาะพื้นที่ที่สนใจ',
                  style: TextStyle(fontSize: 13, color: _muted),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: [
                        _SheetChip(
                          label: 'ทุกอำเภอ',
                          selected: controller.selectedDistrictId.value == null,
                          onTap: () => pick(null),
                        ),
                        ...controller.districts.map(
                          (d) => _SheetChip(
                            label: d.name,
                            selected:
                                controller.selectedDistrictId.value == d.id,
                            onTap: () => pick(d.id),
                          ),
                        ),
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

class _DistrictButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DistrictButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? Colors.white : _ink;
    return Material(
      color: isActive ? _ink : Colors.white,
      shape: StadiumBorder(side: BorderSide(color: isActive ? _ink : _line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: fg),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SheetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: _brand,
      backgroundColor: HomeColors.bgCanvas,
      side: BorderSide(color: selected ? _brand : _line),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : _ink,
      ),
    );
  }
}

/// "พบ 12 เรื่อง" plus removable chips for each active filter.
class _ResultSummary extends StatelessWidget {
  final ContentController controller;
  const _ResultSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    final search = controller.searchQuery.value;
    final district = controller.selectedDistrictName;
    final category = controller.selectedCategoryName;
    final count = controller.contents.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Text(
                      controller.isLoading.value && controller.hasLoaded.value
                          ? 'กำลังค้นหา...'
                          : 'พบ $count เรื่อง',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _muted,
                      ),
                    ),
                  ),
                  if (search.isNotEmpty)
                    _FilterTag(
                      label: '"$search"',
                      onRemove: controller.clearSearch,
                    ),
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
                ],
              ),
            ),
          ),
        ],
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
      color: _brand.withValues(alpha: 0.1),
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
                    color: _brand,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.close_rounded, size: 14, color: _brand),
            ],
          ),
        ),
      ),
    );
  }
}
