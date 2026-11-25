import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/content_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class YoutubeThumbnailPreview extends StatelessWidget {
  const YoutubeThumbnailPreview({super.key, required this.controller});

  final ContentFormController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.youtubeUrlController,
      builder: (context, value, _) {
        final thumbnailUrl = controller.youtubeThumbnailUrl;
        if (thumbnailUrl.isEmpty) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: MerchantColors.border),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(17),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      thumbnailUrl,
                      height: 165,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            height: 120,
                            color: const Color(0xFFF1F5F9),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: MerchantColors.textMuted,
                              size: 32,
                            ),
                          ),
                    ),
                    // Dark subtle gradient overlay
                    Container(
                      height: 165,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Centered Play Button
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // YouTube Badge Top Left
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.video_library_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'YouTube Cover',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: MerchantColors.successBg,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(17),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: MerchantColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'พบวิดีโอ YouTube สำเร็จ (นำภาพวิดีโอมาใช้เป็นรูปปกบทความอัตโนมัติ)',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: MerchantColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

