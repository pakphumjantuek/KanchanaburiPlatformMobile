import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/product_model.dart';
import '../controllers/home_controller.dart';
import 'home_colors.dart';
import 'home_network_image.dart';
import 'home_section_header.dart';

class HomeDealsSection extends GetView<HomeController> {
  const HomeDealsSection({super.key});

  static const Color dealRed = Color(0xFFE5484D);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final deals = controller.activeDeals.where((product) {
        final deal = product.activeDeal;
        return product.quantity > 0 &&
            deal != null &&
            deal.availableQuantity > 0 &&
            !deal.isExpired;
      }).toList();
      if (deals.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DealsHeader(),
          const SizedBox(height: 14),
          SizedBox(
            height: 236,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              itemCount: deals.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, index) => HomeDealCard(product: deals[index]),
            ),
          ),
        ],
      );
    });
  }
}

class _DealsHeader extends StatelessWidget {
  const _DealsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 22,
            decoration: BoxDecoration(
              color: HomeColors.brandPrimary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'โปรโมชันพิเศษ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: HomeColors.textBlack,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => openMainTab(1, '/shops'),
            style: TextButton.styleFrom(
              foregroundColor: HomeColors.brandPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ดูทั้งหมด',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_forward_ios_rounded, size: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One shared 1-second tick for every deal countdown on the page.
final Stream<void> _ticker = Stream<void>.periodic(
  const Duration(seconds: 1),
).asBroadcastStream();

/// Small pill showing the time left for a single deal.
class _Countdown extends StatelessWidget {
  final DateTime endsAt;
  const _Countdown({required this.endsAt});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: _ticker,
      builder: (_, _) {
        final left = endsAt.difference(DateTime.now().toUtc());
        final d = left.isNegative ? Duration.zero : left;
        String two(int v) => v.toString().padLeft(2, '0');
        final text = d.inDays > 0
            ? 'เหลือ ${d.inDays} วัน'
            : '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule_rounded, size: 12, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Deal product card with discount, per-deal countdown and claim bar.
class HomeDealCard extends StatelessWidget {
  final ProductModel product;
  const HomeDealCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal!;
    final percent = product.price > 0
        ? ((1 - product.dealPrice / product.price) * 100).round()
        : 0;
    final total = deal.totalQuantity;
    final claimed = total > 0
        ? ((total - deal.availableQuantity) / total).clamp(0.0, 1.0)
        : 0.0;
    final hasImage = product.imageUrl?.isNotEmpty == true;

    return Container(
      width: 156,
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 124,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    hasImage
                        ? HomeNetworkImage(
                            url: product.imageUrl!,
                            placeholder: _placeholder(),
                          )
                        : _placeholder(),
                    if (percent > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: HomeDealsSection.dealRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-$percent%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    if (deal.endsAt != null)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: _Countdown(endsAt: deal.endsAt!),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HomeColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '฿${product.dealPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: HomeDealsSection.dealRed,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '฿${product.price.toStringAsFixed(0)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: HomeColors.textMuted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: claimed,
                          minHeight: 4,
                          backgroundColor: const Color(0xFFF1ECE7),
                          color: HomeDealsSection.dealRed,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'เหลือ ${deal.availableQuantity} สิทธิ์',
                        style: const TextStyle(
                          fontSize: 11,
                          color: HomeColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFF6EFE9),
    child: const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        color: HomeColors.textMuted,
        size: 32,
      ),
    ),
  );
}
