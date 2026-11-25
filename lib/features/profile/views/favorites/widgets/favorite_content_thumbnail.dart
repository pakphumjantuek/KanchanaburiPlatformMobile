import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteContentThumbnail extends StatelessWidget {
  const FavoriteContentThumbnail({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: Container(
            height: 160,
            width: double.infinity,
            color: const Color(0xFFE8D9C9).withValues(alpha: 0.5),
            child: imageUrl == null
                ? const _FavoriteImageFallback()
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _FavoriteImageFallback(),
                  ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE76F51),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x25000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 13),
                const SizedBox(width: 4),
                Text(
                  'รายการโปรด',
                  style: GoogleFonts.krub(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteImageFallback extends StatelessWidget {
  const _FavoriteImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8D9C9).withValues(alpha: 0.4),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF786B62), size: 40),
      ),
    );
  }
}
