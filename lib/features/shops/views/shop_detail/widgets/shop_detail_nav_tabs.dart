import 'package:flutter/material.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';

class ShopNavItem {
  final String label;
  final int? count;
  const ShopNavItem(this.label, [this.count]);
}

/// Pinned row of section shortcuts; tapping one scrolls to that section.
class ShopDetailNavTabs extends SliverPersistentHeaderDelegate {
  final List<ShopNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  ShopDetailNavTabs({
    required this.items,
    required this.activeIndex,
    required this.onSelected,
  });

  static const double height = 56;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: overlaps ? DetailColors.line : Colors.transparent,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = items[i];
          final selected = i == activeIndex;
          return Material(
            color: selected ? DetailColors.ink : DetailColors.canvas,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: Text(
                    item.count != null && item.count! > 0
                        ? '${item.label} ${item.count}'
                        : item.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : DetailColors.body,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(ShopDetailNavTabs old) =>
      old.activeIndex != activeIndex || old.items != items;
}
