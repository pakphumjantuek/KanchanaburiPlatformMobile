import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// Full-bleed cover photo that collapses into a compact title bar.
class ContentDetailHero extends GetView<ContentDetailController> {
  final ContentDetailModel item;
  final VoidCallback onReport;
  final VoidCallback? onPlayVideo;

  const ContentDetailHero({
    super.key,
    required this.item,
    required this.onReport,
    this.onPlayVideo,
  });

  static const double expandedHeight = 320;

  @override
  Widget build(BuildContext context) {
    final hasCover = item.coverImageUrl?.isNotEmpty ?? false;
    final cover = hasCover ? item.coverImageUrl : item.youtubeThumbnailHd;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: expandedHeight,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      foregroundColor: DetailColors.ink,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: _CircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: Get.back,
        ),
      ),
      actions: [
        Obx(
          () => _CircleButton(
            icon: controller.isFavorite.value
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: controller.isFavorite.value
                ? const Color(0xFFE5484D)
                : null,
            onTap: controller.toggleFavorite,
          ),
        ),
        const SizedBox(width: 8),
        _CircleButton(
          icon: Icons.ios_share_rounded,
          onTap: controller.shareContent,
        ),
        const SizedBox(width: 8),
        _CircleButton(icon: Icons.more_horiz_rounded, onTap: onReport),
        const SizedBox(width: 12),
      ],
      // Title only appears once the cover has collapsed.
      title: Builder(
        builder: (context) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final collapsed =
              settings != null &&
              settings.currentExtent <= settings.minExtent + 8;
          return AnimatedOpacity(
            opacity: collapsed ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DetailColors.ink,
              ),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            DetailImage(
              url: cover,
              fallbackUrl: hasCover ? null : item.youtubeThumbnail,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x33000000),
                  ],
                  stops: [0, 0.3, 0.7, 1],
                ),
              ),
            ),
            if (onPlayVideo != null)
              Center(
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: onPlayVideo,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(14, 10, 18, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: DetailColors.brand,
                            size: 26,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ดูวิดีโอ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: DetailColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      // Rounded white lip that the content sheet continues from.
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(icon, size: 19, color: iconColor ?? DetailColors.ink),
          ),
        ),
      ),
    );
  }
}
