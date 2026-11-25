import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../controllers/favorites_controller.dart';
import '../../../models/favorite_content_model.dart';
import 'favorite_content_thumbnail.dart';

class FavoriteContentCard extends StatelessWidget {
  const FavoriteContentCard({
    super.key,
    required this.item,
    required this.controller,
  });

  final FavoriteContentModel item;
  final FavoritesController controller;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.coverImageUrl?.isNotEmpty == true
        ? item.coverImageUrl!
        : (item.youtubeThumbnail.isNotEmpty ? item.youtubeThumbnail : null);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteContentThumbnail(imageUrl: imageUrl),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF332820),
                    height: 1.3,
                  ),
                ),
                if (item.summary != null && item.summary!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.summary!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF786B62),
                      height: 1.35,
                    ),
                  ),
                ],
                if (item.createdAt != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Color(0xFF786B62),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'บันทึกเมื่อ: ${_formatDate(item.createdAt!)}',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE8D9C9)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppRoutes.contentDetail.replaceAll(
                          ':id',
                          item.contentId,
                        ),
                      ),
                      icon: const Icon(Icons.menu_book_rounded, size: 16),
                      label: Text(
                        'อ่านบทความ',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C2C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        size: 22,
                        color: Color(0xFFE76F51),
                      ),
                      tooltip: 'นำออกจากรายการโปรด',
                      onPressed: () => controller.removeFavorite(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
    } catch (_) {
      return isoDate;
    }
  }
}
