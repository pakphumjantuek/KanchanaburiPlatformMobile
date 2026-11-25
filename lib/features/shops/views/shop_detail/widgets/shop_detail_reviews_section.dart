import 'package:flutter/material.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/shop_review_model.dart';

/// Rating summary and customer reviews (with shop replies).
class ShopDetailReviewsSection extends StatefulWidget {
  final List<ShopReviewModel> reviews;
  final double averageRating;

  const ShopDetailReviewsSection({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  State<ShopDetailReviewsSection> createState() =>
      _ShopDetailReviewsSectionState();
}

class _ShopDetailReviewsSectionState extends State<ShopDetailReviewsSection> {
  static const _preview = 3;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.reviews;

    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailSectionTitle(title: 'รีวิวจากลูกค้า'),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            decoration: BoxDecoration(
              color: DetailColors.canvas,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  size: 32,
                  color: DetailColors.muted,
                ),
                SizedBox(height: 8),
                Text(
                  'ยังไม่มีรีวิว',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DetailColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'รีวิวจะแสดงหลังลูกค้าได้รับสินค้าจากร้านนี้',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: DetailColors.muted),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final visible = _showAll ? reviews : reviews.take(_preview).toList();
    final counts = List<int>.filled(5, 0);
    for (final r in reviews) {
      counts[r.rating.round().clamp(1, 5) - 1]++;
    }
    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'รีวิวจากลูกค้า'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: 96,
                child: Column(
                  children: [
                    Text(
                      widget.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: DetailColors.ink,
                        height: 1.1,
                      ),
                    ),
                    _Stars(rating: widget.averageRating, size: 15),
                    const SizedBox(height: 4),
                    Text(
                      '${reviews.length} รีวิว',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: DetailColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    for (var star = 5; star >= 1; star--)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              child: Text(
                                '$star',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: DetailColors.muted,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: maxCount == 0
                                      ? 0
                                      : counts[star - 1] / maxCount,
                                  minHeight: 6,
                                  backgroundColor: DetailColors.canvas,
                                  color: DetailColors.star,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (final r in visible) _ReviewTile(item: r),
        if (reviews.length > _preview)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: OutlinedButton(
              onPressed: () => setState(() => _showAll = !_showAll),
              style: OutlinedButton.styleFrom(
                foregroundColor: DetailColors.ink,
                side: const BorderSide(color: DetailColors.line),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _showAll
                    ? 'ย่อรีวิว'
                    : 'ดูรีวิวทั้งหมด ${reviews.length} รายการ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ShopReviewModel item;
  const _ReviewTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = item.userAvatar?.isNotEmpty ?? false;
    final initial = item.userName.isNotEmpty
        ? item.userName.characters.first.toUpperCase()
        : 'U';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: DetailColors.brandSoft,
            backgroundImage: hasAvatar ? NetworkImage(item.userAvatar!) : null,
            child: hasAvatar
                ? null
                : Text(
                    initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: DetailColors.brand,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: DetailColors.ink,
                        ),
                      ),
                    ),
                    if (item.isVerifiedBuyer) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'ซื้อแล้ว',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _Stars(rating: item.rating, size: 13),
                    const SizedBox(width: 8),
                    Text(
                      formatThaiDate(item.createdAt.toIso8601String()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: DetailColors.muted,
                      ),
                    ),
                  ],
                ),
                if (item.comment.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.comment,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: DetailColors.body,
                      height: 1.55,
                    ),
                  ),
                ],
                if (item.ownerReply?.isNotEmpty ?? false)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DetailColors.canvas,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ตอบกลับจากร้าน',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: DetailColors.brand,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.ownerReply!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: DetailColors.body,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  final double size;
  const _Stars({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = rating >= i + 1
            ? Icons.star_rounded
            : rating > i
            ? Icons.star_half_rounded
            : Icons.star_outline_rounded;
        return Icon(
          icon,
          size: size,
          color: rating > i ? DetailColors.star : DetailColors.line,
        );
      }),
    );
  }
}
