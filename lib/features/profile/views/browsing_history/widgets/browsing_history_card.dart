import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/content_view_history_model.dart';
import 'browsing_history_thumbnail.dart';

class BrowsingHistoryCard extends StatelessWidget {
  const BrowsingHistoryCard({super.key, required this.item});

  final ContentViewHistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.contentId.isNotEmpty) {
            Get.toNamed('/contents/${item.contentId}');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrowsingHistoryThumbnail(
                imageUri: item.displayImage,
                hasVideo:
                    item.youtubeUrl != null && item.youtubeUrl!.isNotEmpty,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.krub(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF332820),
                        height: 1.3,
                      ),
                    ),
                    if (item.summary != null && item.summary!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.summary!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFFD96C2C),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.formattedViewedAt.isNotEmpty
                                ? item.formattedViewedAt
                                : 'เข้าชมแล้ว',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.krub(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD96C2C),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Color(0xFF786B62),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
