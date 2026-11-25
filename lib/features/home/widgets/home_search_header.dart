import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'home_colors.dart';

/// Greeting text shown in the expanded area of the home SliverAppBar.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ค้นหาเสน่ห์เมืองกาญจน์ 🌿',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'เรื่องราวท่องเที่ยว สินค้าหัตถกรรม และอาหารพื้นบ้าน',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Search box pinned at the bottom of the home SliverAppBar.
class HomeSearchBar extends GetView<HomeController>
    implements PreferredSizeWidget {
  const HomeSearchBar({super.key});

  static const double height = 68;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 14, right: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: HomeColors.brandPrimary,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller.searchInputController,
                onSubmitted: controller.onSearchSubmit,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: HomeColors.textBlack,
                ),
                decoration: const InputDecoration(
                  hintText: 'พิมพ์สถานที่, สินค้า, หรืออำเภอ...',
                  hintStyle: TextStyle(
                    fontSize: 14.5,
                    color: HomeColors.textMuted,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.onSearchSubmit(
                controller.searchInputController.text,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'ค้นหา',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Popular tag chips shown right below the app bar.
class HomePopularTags extends GetView<HomeController> {
  const HomePopularTags({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 18),
      decoration: const BoxDecoration(
        color: HomeColors.darkHeader,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: controller.popularTags.map((tag) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => controller.onTagTap(tag),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
