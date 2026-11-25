import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../contents/models/content_model.dart';

class MyContentThumbnail extends StatelessWidget {
  const MyContentThumbnail({super.key, required this.content});

  final ContentModel content;

  @override
  Widget build(BuildContext context) {
    final imageUrl = content.coverImageUrl?.isNotEmpty == true
        ? content.coverImageUrl!
        : (content.youtubeThumbnail.isNotEmpty
              ? content.youtubeThumbnail
              : null);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: SizedBox(
            height: 160,
            width: double.infinity,
            child: ColoredBox(
              color: const Color(0xFFE8D9C9).withValues(alpha: 0.5),
              child: imageUrl == null
                  ? const _FallbackImage()
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _FallbackImage(),
                    ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: MyContentStatusBadge(status: content.status),
        ),
        if (content.categoryName != null && content.categoryName!.isNotEmpty)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content.categoryName!,
                style: GoogleFonts.krub(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MyContentStatusBadge extends StatelessWidget {
  const MyContentStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final value = status?.toLowerCase() ?? 'published';
    late final Color background;
    late final String label;
    late final IconData icon;

    if (value == 'pending') {
      background = const Color(0xFFF59E0B);
      label = 'รอตรวจสอบ';
      icon = Icons.hourglass_empty_rounded;
    } else if (value == 'archived' || value == 'draft') {
      background = const Color(0xFF8D7B68);
      label = 'เก็บถาวร';
      icon = Icons.archive_outlined;
    } else {
      background = const Color(0xFF059669);
      label = 'เผยแพร่แล้ว';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.photo_library_outlined,
        color: Color(0xFF786B62),
        size: 40,
      ),
    );
  }
}
