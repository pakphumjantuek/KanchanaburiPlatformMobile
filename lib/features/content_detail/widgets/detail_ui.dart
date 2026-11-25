import 'package:flutter/material.dart';
import '../../home/widgets/home_colors.dart';

/// Shared colors and building blocks for the content detail page.
class DetailColors {
  static const brand = HomeColors.brandPrimary;
  static const brandSoft = HomeColors.brandSoft;
  static const ink = HomeColors.textBlack;
  static const body = HomeColors.textSecondary;
  static const muted = HomeColors.textMuted;
  static const line = Color(0xFFEDE6DE);
  static const canvas = Color(0xFFF7F3EE);
  static const star = Color(0xFFF2B33D);
}

/// Section title with optional trailing action, used by every block.
class DetailSectionTitle extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTrailingTap;

  const DetailSectionTitle({
    super.key,
    required this.title,
    this.trailingText,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DetailColors.ink,
                letterSpacing: -0.2,
              ),
            ),
          ),
          if (trailingText != null)
            TextButton(
              onPressed: onTrailingTap,
              style: TextButton.styleFrom(
                foregroundColor: DetailColors.brand,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Vertical space + hairline between sections.
class DetailDivider extends StatelessWidget {
  const DetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(height: 1, thickness: 8, color: DetailColors.canvas),
    );
  }
}

/// Network image with a soft placeholder for loading and error states.
class DetailImage extends StatelessWidget {
  final String? url;
  final IconData placeholderIcon;

  /// Tried when [url] fails, e.g. a lower-resolution YouTube thumbnail.
  final String? fallbackUrl;

  const DetailImage({
    super.key,
    required this.url,
    this.placeholderIcon = Icons.landscape_rounded,
    this.fallbackUrl,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: const Color(0xFFF1EAE2),
      child: Center(
        child: Icon(placeholderIcon, size: 32, color: DetailColors.muted),
      ),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) => fallbackUrl?.isNotEmpty ?? false
          ? DetailImage(url: fallbackUrl, placeholderIcon: placeholderIcon)
          : placeholder,
      frameBuilder: (_, child, frame, sync) {
        if (sync) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            placeholder,
            AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              child: child,
            ),
          ],
        );
      },
    );
  }
}

String formatThaiDate(String raw) {
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
  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw;
  final local = dt.toLocal();
  return '${local.day} ${months[local.month - 1]} ${local.year + 543}';
}
