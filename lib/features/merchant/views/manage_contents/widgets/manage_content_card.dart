import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/contents/models/content_model.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageContentCard extends GetView<ManageContentsController> {
  const ManageContentCard({super.key, required this.item});

  final ContentModel item;

  @override
  Widget build(BuildContext context) {
    final displayCoverImage =
        (item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty)
            ? item.coverImageUrl!
            : item.youtubeThumbnail;

    final hasVideo = item.youtubeUrl != null && item.youtubeUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MerchantColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Banner with Rich Overlays
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color(0xFFE2E8F0),
                  child: displayCoverImage.isNotEmpty
                      ? Image.network(
                          displayCoverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image_outlined,
                                  color: Color(0xFF64748B),
                                  size: 38,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ไม่สามารถโหลดรูปภาพได้',
                                  style: GoogleFonts.krub(
                                    color: const Color(0xFF64748B),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD1FAE5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_stories_rounded,
                                  color: MerchantColors.primary,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'เรื่องราวและข่าวสารร้านค้า',
                                style: GoogleFonts.krub(
                                  color: const Color(0xFF475569),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                // Bottom Gradient Shade Overlay for Text Readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Category Tag Pill & Status Badge (Top Bar)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.categoryName != null &&
                          item.categoryName!.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bookmark_rounded,
                                  color: Color(0xFF34D399),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.categoryName!,
                                    style: GoogleFonts.krub(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(width: 8),
                      _buildStatusBadge(item.statusLabel),
                    ],
                  ),
                ),

                // Video Badge Pill (Bottom Left on Image)
                if (hasVideo)
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'วิดีโอ YouTube',
                            style: GoogleFonts.krub(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content Info Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.krub(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: MerchantColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      item.description!,
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        color: MerchantColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 14),

                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),

                  // Metadata & Actions Footer Row
                  Row(
                    children: [
                      // View Counter & Location Badges
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.visibility_rounded,
                                    size: 13,
                                    color: Color(0xFF0284C7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.viewCount}',
                                    style: GoogleFonts.krub(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.districtName != null &&
                                item.districtName!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: MerchantColors.warningBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 13,
                                      color: Color(0xFFD97706),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.districtName!,
                                      style: GoogleFonts.krub(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFB45309),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Action Buttons Row (Edit & Delete)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              final res = await Get.toNamed(
                                AppRoutes.myShopContentForm,
                                arguments: item,
                              );
                              if (res == true) {
                                controller.loadContents();
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: MerchantColors.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: MerchantColors.primary.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.edit_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'แก้ไข',
                                    style: GoogleFonts.krub(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => controller.deleteContent(item),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: MerchantColors.errorBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFFECDD3),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 15,
                                color: MerchantColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String statusLabel) {
    Color bg = MerchantColors.success;
    Color text = Colors.white;

    if (statusLabel.contains('รอ')) {
      bg = MerchantColors.warning;
      text = Colors.white;
    } else if (statusLabel.contains('เก็บ') || statusLabel.contains('ร่าง')) {
      bg = const Color(0xFF64748B);
      text = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        statusLabel,
        style: GoogleFonts.krub(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
