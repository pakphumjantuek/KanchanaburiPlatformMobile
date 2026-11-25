import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowsingHistoryThumbnail extends StatelessWidget {
  const BrowsingHistoryThumbnail({
    super.key,
    required this.imageUri,
    required this.hasVideo,
  });

  final String imageUri;
  final bool hasVideo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 90,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: const Color(0xFFE8D9C9),
              child: imageUri.isNotEmpty
                  ? Image.network(
                      imageUri,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _PlaceholderImage(),
                    )
                  : const _PlaceholderImage(),
            ),
            if (hasVideo)
              ColoredBox(
                color: Colors.black.withValues(alpha: 0.25),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.article_outlined,
            color: Color(0xFF786B62),
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            'ไม่มีรูป',
            style: GoogleFonts.krub(fontSize: 10, color: Color(0xFF786B62)),
          ),
        ],
      ),
    );
  }
}
