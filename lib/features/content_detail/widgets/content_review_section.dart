import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_review_model.dart';
import 'detail_ui.dart';

/// Rating summary, latest reviews and the "write a review" sheet.
class ContentReviewSection extends GetView<ContentDetailController> {
  const ContentReviewSection({super.key});

  static const _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reviews = controller.reviews;
      final avg = reviews.isEmpty
          ? 0.0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailDivider(),
          DetailSectionTitle(
            title: 'รีวิวจากผู้มาเยือน',
            trailingText: 'เขียนรีวิว',
            onTrailingTap: () => openReviewSheet(context),
          ),
          if (reviews.isEmpty)
            _EmptyReviews(onWrite: () => openReviewSheet(context))
          else ...[
            _RatingSummary(average: avg, reviews: reviews),
            const SizedBox(height: 8),
            for (final r in reviews.take(_previewCount)) _ReviewTile(item: r),
            if (reviews.length > _previewCount)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: OutlinedButton(
                  onPressed: () => _openAllReviews(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DetailColors.ink,
                    side: const BorderSide(color: DetailColors.line),
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'ดูรีวิวทั้งหมด ${reviews.length} รายการ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ],
      );
    });
  }

  void _openAllReviews(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, scroll) => Obx(
          () => ListView(
            controller: scroll,
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              DetailSectionTitle(
                title: 'รีวิวทั้งหมด (${controller.reviews.length})',
              ),
              for (final r in controller.reviews) _ReviewTile(item: r),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens the review composer, or asks the user to sign in first.
  void openReviewSheet(BuildContext context) {
    final loggedIn =
        !Get.isRegistered<AuthService>() ||
        Get.find<AuthService>().isLoggedIn.value;
    if (!loggedIn) {
      Get.snackbar(
        'เข้าสู่ระบบก่อนรีวิว',
        'แชร์ประสบการณ์ของคุณได้หลังเข้าสู่ระบบ',
        backgroundColor: DetailColors.ink,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.login),
          child: const Text(
            'เข้าสู่ระบบ',
            style: TextStyle(color: Color(0xFFFFCC80)),
          ),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ที่นี่เป็นอย่างไรบ้าง?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: DetailColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'แตะดาวเพื่อให้คะแนน',
              style: TextStyle(fontSize: 13, color: DetailColors.muted),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < controller.myRating.value;
                  return IconButton(
                    onPressed: () =>
                        controller.myRating.value = (i + 1).toDouble(),
                    iconSize: 38,
                    icon: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: filled ? DetailColors.star : DetailColors.line,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.reviewTextController,
              maxLines: 4,
              minLines: 3,
              autofocus: true,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'เล่าประสบการณ์ บรรยากาศ หรือคำแนะนำสำหรับคนอื่น',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: DetailColors.muted,
                ),
                filled: true,
                fillColor: DetailColors.canvas,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final posting = controller.isPostingReview.value;
              return FilledButton(
                onPressed: posting
                    ? null
                    : () async {
                        // postReview warns and keeps the sheet open when empty.
                        final hasText = controller.reviewTextController.text
                            .trim()
                            .isNotEmpty;
                        await controller.postReview();
                        if (hasText && sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: DetailColors.brand,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: posting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'โพสต์รีวิว',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  final double average;
  final List<ContentReviewModel> reviews;
  const _RatingSummary({required this.average, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final counts = List<int>.filled(5, 0);
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      counts[star - 1]++;
    }
    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Column(
              children: [
                Text(
                  average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: DetailColors.ink,
                    height: 1.1,
                  ),
                ),
                _Stars(rating: average, size: 15),
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
    );
  }
}

class _ReviewTile extends GetView<ContentDetailController> {
  final ContentReviewModel item;
  const _ReviewTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = item.userAvatar?.isNotEmpty ?? false;
    final initial = item.userName.isNotEmpty
        ? item.userName.characters.first.toUpperCase()
        : 'U';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 4),
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
                    if (item.isMine) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: DetailColors.brandSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'ของฉัน',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: DetailColors.brand,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _Stars(rating: item.rating, size: 13),
                    if (item.createdAt?.isNotEmpty ?? false) ...[
                      const SizedBox(width: 8),
                      Text(
                        DateTime.tryParse(item.createdAt!) != null
                            ? formatThaiDate(item.createdAt!)
                            : item.createdAt!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: DetailColors.muted,
                        ),
                      ),
                    ],
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
              ],
            ),
          ),
          if (item.isMine)
            IconButton(
              tooltip: 'ลบรีวิว',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: DetailColors.muted,
              ),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ลบรีวิวนี้?'),
        content: const Text('รีวิวที่ลบแล้วจะกู้คืนไม่ได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteReview(item.reviewId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('ลบ'),
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

class _EmptyReviews extends StatelessWidget {
  final VoidCallback onWrite;
  const _EmptyReviews({required this.onWrite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: DetailColors.canvas,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rate_review_outlined,
            size: 34,
            color: DetailColors.muted,
          ),
          const SizedBox(height: 8),
          const Text(
            'ยังไม่มีรีวิว',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: DetailColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'เคยไปมาแล้ว? เป็นคนแรกที่แชร์ประสบการณ์',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: DetailColors.muted),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onWrite,
            style: OutlinedButton.styleFrom(
              foregroundColor: DetailColors.brand,
              side: const BorderSide(color: DetailColors.brand),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'เขียนรีวิว',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
