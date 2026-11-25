import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../contents/models/content_model.dart';
import '../../../controllers/my_contents_controller.dart';
import 'my_content_thumbnail.dart';

class MyContentCard extends StatelessWidget {
  const MyContentCard({
    super.key,
    required this.content,
    required this.controller,
  });

  final ContentModel content;
  final MyContentsController controller;

  @override
  Widget build(BuildContext context) {
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
          MyContentThumbnail(content: content),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF332820),
                    height: 1.3,
                  ),
                ),
                if (content.description != null &&
                    content.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    content.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF786B62),
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _ContentMetadata(content: content),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE8D9C9)),
                const SizedBox(height: 10),
                _ContentCardActions(content: content, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentMetadata extends StatelessWidget {
  const _ContentMetadata({required this.content});

  final ContentModel content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (content.districtName != null &&
            content.districtName!.isNotEmpty) ...[
          const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: Color(0xFFD96C2C),
          ),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              content.districtName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: const Color(0xFF786B62),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        const Icon(
          Icons.visibility_outlined,
          size: 14,
          color: Color(0xFF786B62),
        ),
        const SizedBox(width: 3),
        Text(
          '${content.viewCount} เข้าชม',
          style: GoogleFonts.krub(fontSize: 12, color: const Color(0xFF786B62)),
        ),
        const Spacer(),
        if (content.publishedAt != null)
          Text(
            _formatDate(content.publishedAt!),
            style: GoogleFonts.krub(fontSize: 11, color: Color(0xFF786B62)),
          ),
      ],
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

class _ContentCardActions extends StatelessWidget {
  const _ContentCardActions({required this.content, required this.controller});

  final ContentModel content;
  final MyContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () => Get.toNamed(
            AppRoutes.contentDetail.replaceAll(':id', content.id),
          ),
          icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
          label: Text(
            'ดูคอนเทนต์',
            style: GoogleFonts.krub(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF332820),
            side: const BorderSide(color: Color(0xFFE8D9C9)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: Color(0xFFD96C2C),
              ),
              tooltip: 'แก้ไข',
              onPressed: () =>
                  Get.toNamed(AppRoutes.createContent, arguments: content),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: Colors.redAccent,
              ),
              tooltip: 'จัดเก็บถาวร',
              onPressed: () => controller.archiveContent(content),
            ),
          ],
        ),
      ],
    );
  }
}
