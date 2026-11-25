import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

/// Full-bleed shop photo that collapses into a compact title bar.
class ShopDetailHero extends StatelessWidget {
  final ShopModel shop;
  final VoidCallback onShare;

  const ShopDetailHero({super.key, required this.shop, required this.onShare});

  @override
  Widget build(BuildContext context) {
    // Prefer the wide background photo for the banner; fall back to cover.
    final banner = (shop.backgroundImageUrl?.isNotEmpty ?? false)
        ? shop.backgroundImageUrl
        : shop.coverImageUrl;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 260,
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
        _CircleButton(icon: Icons.ios_share_rounded, onTap: onShare),
        const SizedBox(width: 12),
      ],
      // Title only appears once the photo has collapsed.
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
              shop.name,
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
            DetailImage(url: banner, placeholderIcon: Icons.storefront_rounded),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66000000), Colors.transparent],
                  stops: [0, 0.35],
                ),
              ),
            ),
          ],
        ),
      ),
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
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(icon, size: 19, color: DetailColors.ink),
          ),
        ),
      ),
    );
  }
}
