import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_deal_model.dart';
import 'package:projecte/features/shops/models/product_model.dart';

class ProductDetailGallery extends GetView<ProductDetailController> {
  final ProductModel product;
  final List<String> images;

  const ProductDetailGallery({
    super.key,
    required this.product,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal;
    final hasDeal =
        deal != null && !deal.isExpired && deal.availableQuantity > 0;

    return Column(
      children: [
        // Main Image Hero Frame with curved bottom corners
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Display
                  Obx(() {
                    final selectedIdx = controller.selectedImageIndex.value;
                    final hasImages = images.isNotEmpty;
                    final currentImage =
                        hasImages && selectedIdx < images.length
                            ? images[selectedIdx]
                            : null;

                    return currentImage != null
                        ? Image.network(
                            currentImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder();
                  }),

                  // Top ambient dark gradient for button contrast
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0x55000000), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Floating Back Button (Glassmorphism)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: _glassCircleButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: Get.back,
                      tooltip: 'ย้อนกลับ',
                    ),
                  ),

                  // Floating Favorite Button (Glassmorphism)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Obx(
                      () => _glassCircleButton(
                        icon: controller.isFavorite.value
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: controller.isFavorite.value
                            ? AppColors.error
                            : AppColors.textPrimary,
                        onTap: controller.toggleFavorite,
                        tooltip: 'รายการโปรด',
                      ),
                    ),
                  ),

                  // Gallery Prev / Next Arrows
                  if (images.length > 1) ...[
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _glassCircleButton(
                          icon: Icons.chevron_left_rounded,
                          size: 34,
                          iconSize: 22,
                          onTap: () {
                            int prev =
                                (controller.selectedImageIndex.value -
                                        1 +
                                        images.length) %
                                    images.length;
                            controller.selectImage(prev);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _glassCircleButton(
                          icon: Icons.chevron_right_rounded,
                          size: 34,
                          iconSize: 22,
                          onTap: () {
                            int next =
                                (controller.selectedImageIndex.value + 1) %
                                    images.length;
                            controller.selectImage(next);
                          },
                        ),
                      ),
                    ),
                  ],

                  // Image Counter Pill (Bottom Right)
                  if (images.length > 1)
                    Positioned(
                      bottom: 14,
                      right: 14,
                      child: Obx(() {
                        final current = controller.selectedImageIndex.value + 1;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xCC0D2B22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '$current / ${images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Flash Sale / Active Deal Banner
        if (hasDeal) _buildFlashDealBanner(deal),

        // Image Dots Indicator
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final selected = controller.selectedImageIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectImage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: selected ? 22 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFD0DDD8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  Widget _glassCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    double size = 40,
    double iconSize = 20,
    String? tooltip,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: const Color(0x33000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildFlashDealBanner(ProductDealModel deal) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, snapshot) {
        final now = DateTime.now().toUtc();
        final remaining = deal.endsAt?.difference(now);
        final countdown = remaining == null || remaining.isNegative
            ? null
            : '${remaining.inHours.toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE76F51), // Warm Coral
                Color(0xFFF4A261), // Amber Sun
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ดีลพิเศษประจำวัน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'ราคาพิเศษเฉพาะช่วงนี้เท่านั้น',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (countdown != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xDD0D2B22),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: AppColors.gold,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        countdown,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFEDF3F0),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 44,
          color: Color(0xFF8BA69D),
        ),
      ),
    );
  }
}
