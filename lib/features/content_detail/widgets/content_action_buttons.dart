import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import 'detail_ui.dart';

/// Sticky bottom bar: save + review shortcuts and the main directions CTA.
class ContentActionButtons extends GetView<ContentDetailController> {
  final VoidCallback onReview;
  const ContentActionButtons({super.key, required this.onReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: DetailColors.line)),
      ),
      child: Row(
        children: [
          Obx(() {
            final fav = controller.isFavorite.value;
            return _SideAction(
              icon: fav
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              label: fav ? 'บันทึกแล้ว' : 'บันทึก',
              color: fav ? const Color(0xFFE5484D) : DetailColors.ink,
              onTap: controller.toggleFavorite,
            );
          }),
          _SideAction(
            icon: Icons.rate_review_outlined,
            label: 'รีวิว',
            color: DetailColors.ink,
            onTap: onReview,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: controller.openGoogleMaps,
              style: FilledButton.styleFrom(
                backgroundColor: DetailColors.brand,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.directions_rounded, size: 21),
              label: const Text(
                'นำทางไปที่นี่',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SideAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 60,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(icon, key: ValueKey(icon), size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
