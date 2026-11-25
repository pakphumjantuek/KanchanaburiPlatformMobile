import 'package:flutter/material.dart';
import 'home_network_image.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'home_section_header.dart';
import '../widgets/home_colors.dart';

class HomeHeroSlider extends GetView<HomeController> {
  const HomeHeroSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = controller.heroBanners;
      if (banners.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          SizedBox(
            height: 235,
            child: PageView.builder(
              controller: controller.bannerPageController,
              onPageChanged: (idx) => controller.carouselIndex.value = idx,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final item = banners[index];
                final imageUrl =
                    (item.coverImageUrl != null &&
                        item.coverImageUrl!.isNotEmpty)
                    ? item.coverImageUrl!
                    : item.youtubeThumbnail;

                final card = Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: HomeColors.cardWhite,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Image
                        Positioned.fill(
                          child: imageUrl.isNotEmpty
                              ? HomeNetworkImage(
                                  url: imageUrl,
                                  placeholder: buildGradientBannerBg(),
                                )
                              : buildGradientBannerBg(),
                        ),

                        // Solid Black Bottom Card Sheet for maximum text readability
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black87,
                                  Colors.black,
                                ],
                                stops: [0.0, 0.45, 1.0],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: HomeColors.brandPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.categoryName ?? 'ไฮไลท์แนะนำ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (item.districtName != null &&
                                        item.districtName!.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '📍 ${item.districtName}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.toNamed('/contents/${item.id}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                // Shrink side cards slightly so the active one stands out.
                return AnimatedBuilder(
                  animation: controller.bannerPageController,
                  child: card,
                  builder: (context, child) {
                    final pc = controller.bannerPageController;
                    final page = pc.hasClients && pc.position.haveDimensions
                        ? pc.page ?? pc.initialPage.toDouble()
                        : controller.carouselIndex.value.toDouble();
                    final distance = (page - index).abs().clamp(0.0, 1.0);
                    return Transform.scale(
                      scale: 1 - distance * 0.06,
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final isSelected = controller.carouselIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 26 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? HomeColors.brandPrimary
                      : const Color(0xFF94A3B8),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
