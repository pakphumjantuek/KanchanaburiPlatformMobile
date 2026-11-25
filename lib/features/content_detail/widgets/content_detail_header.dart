import 'package:flutter/material.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// Category, title, location and quick stats right under the cover.
class ContentDetailHeader extends StatelessWidget {
  final ContentDetailModel item;
  final int reviewCount;
  final double reviewAverage;
  final VoidCallback? onRatingTap;

  const ContentDetailHeader({
    super.key,
    required this.item,
    this.reviewCount = 0,
    this.reviewAverage = 0,
    this.onRatingTap,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = _readingMinutes(item.body ?? item.description);
    // Prefer the live review average; the API rating is often missing.
    final rating = reviewAverage > 0 ? reviewAverage : item.rating;
    final hasCategory = item.categoryName?.isNotEmpty ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCategory)
            Text(
              item.categoryName!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: DetailColors.brand,
                letterSpacing: 0.4,
              ),
            ),
          if (hasCategory) const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: DetailColors.ink,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: DetailColors.muted,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.fullLocationText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: DetailColors.body,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Stats strip: rating · views · reading time · date
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: DetailColors.canvas,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _Stat(
                    icon: Icons.star_rounded,
                    iconColor: DetailColors.star,
                    value: rating > 0 ? rating.toStringAsFixed(1) : 'ใหม่',
                    label: reviewCount > 0
                        ? '$reviewCount รีวิว'
                        : 'ยังไม่มีรีวิว',
                    onTap: onRatingTap,
                  ),
                  const _StatDivider(),
                  _Stat(
                    icon: Icons.visibility_outlined,
                    value: _compact(item.viewCount),
                    label: 'เข้าชม',
                  ),
                  const _StatDivider(),
                  _Stat(
                    icon: Icons.schedule_rounded,
                    value: '$minutes นาที',
                    label: 'เวลาอ่าน',
                  ),
                  if (item.publishedAt?.isNotEmpty ?? false) ...[
                    const _StatDivider(),
                    _Stat(
                      icon: Icons.event_outlined,
                      value: formatThaiDate(item.publishedAt!),
                      label: 'เผยแพร่',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static int _readingMinutes(String? text) {
    if (text == null || text.trim().isEmpty) return 1;
    // Thai text has few spaces, so estimate from characters (~500/min).
    final minutes = (text.trim().length / 500).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  static String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor = DetailColors.muted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: iconColor),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: DetailColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, color: DetailColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: 1,
      thickness: 1,
      indent: 4,
      endIndent: 4,
      color: DetailColors.line,
    );
  }
}
