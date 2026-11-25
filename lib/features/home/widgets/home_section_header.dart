import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../navigation/controllers/navigation_controller.dart';
import 'home_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onSeeAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 22,
                      decoration: BoxDecoration(
                        color: HomeColors.brandPrimary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: HomeColors.textBlack,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: HomeColors.brandPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_forward_ios_rounded, size: 13),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Switches to a main tab when the home page lives inside [MainPage],
/// otherwise falls back to pushing [route].
void openMainTab(int index, String route, {dynamic arguments}) {
  if (Get.isRegistered<NavigationController>()) {
    Get.find<NavigationController>().changeTab(index);
  } else {
    Get.toNamed(route, arguments: arguments);
  }
}

Widget buildPlaceholderBox() {
  return Container(
    color: const Color(0xFFE2E8F0),
    child: const Center(
      child: Icon(Icons.image_outlined, color: Color(0xFF334155), size: 28),
    ),
  );
}

Widget buildGradientBannerBg() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFC85A17), Color(0xFFE65100)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Center(
      child: Icon(Icons.landscape_rounded, color: Colors.white, size: 48),
    ),
  );
}
