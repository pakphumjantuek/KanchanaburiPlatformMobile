import 'package:flutter/material.dart';
import 'home_network_image.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'home_section_header.dart';
import '../widgets/home_colors.dart';

class HomeStoriesSection extends GetView<HomeController> {
  const HomeStoriesSection({super.key});

  Widget _buildPlaceholderBox() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE7D6), Color(0xFFF6C4A0), Color(0xFFC85A17)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.landscape_rounded, size: 44, color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.recommendedContents;

      if (list.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // HEADER
          // =========================
          HomeSectionHeader(
            title: 'ค้นพบเสน่ห์กาญจนบุรี',
            subtitle: 'แนะนำแหล่งท่องเที่ยวและสถานที่น่าสนใจ',
            onSeeAll: () => openMainTab(2, '/contents'),
          ),

          const SizedBox(height: 14),

          // =========================
          // HORIZONTAL STORY CARDS
          // =========================
          SizedBox(
            height: 290,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = list[index];

                final rawUrl =
                    (item.coverImageUrl != null &&
                        item.coverImageUrl!.isNotEmpty)
                    ? item.coverImageUrl!
                    : item.youtubeThumbnail;

                // Ensure YouTube letterbox black bars (hqdefault) are replaced with clean 16:9 (mqdefault)
                final imageUrl = rawUrl.replaceAll(
                  'hqdefault.jpg',
                  'mqdefault.jpg',
                );

                return Container(
                  width: 230,
                  decoration: BoxDecoration(
                    color: HomeColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/contents/${item.id}');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =========================
                            // IMAGE CONTAINER (FULL FRAME, NO BLACK BARS)
                            // =========================
                            Stack(
                              children: [
                                SizedBox(
                                  height: 155,
                                  width: double.infinity,
                                  child: imageUrl.isNotEmpty
                                      ? HomeNetworkImage(
                                          url: imageUrl,
                                          placeholder: _buildPlaceholderBox(),
                                        )
                                      : _buildPlaceholderBox(),
                                ),

                                // Category Badge (Top-Left)
                                if (item.categoryName != null &&
                                    item.categoryName!.isNotEmpty)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: HomeColors.brandPrimary,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        item.categoryName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),

                                // View Count Badge (Bottom-Right on image)
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HomeColors.brandPrimary.withValues(
                                        alpha: 0.88,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.visibility_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${item.viewCount}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // =========================
                            // CARD DETAILS (WHITE CANVAS)
                            // =========================
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Title Text
                                    Text(
                                      item.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.3,
                                        fontWeight: FontWeight.w700,
                                        color: HomeColors.textBlack,
                                      ),
                                    ),

                                    // Location Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 4.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: HomeColors.brandSoft,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: HomeColors.brandPrimary
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 14,
                                            color: HomeColors.brandPrimary,
                                          ),
                                          const SizedBox(width: 3),
                                          Flexible(
                                            child: Text(
                                              item.districtName ?? 'กาญจนบุรี',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: HomeColors.brandPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Bottom Action Text
                                    const Row(
                                      children: [
                                        Text(
                                          'อ่านเรื่องราว',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: HomeColors.textMuted,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 15,
                                          color: HomeColors.brandPrimary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
