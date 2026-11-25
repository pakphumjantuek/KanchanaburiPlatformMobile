import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_detail_model.dart';
import '../widgets/content_action_buttons.dart';
import '../widgets/content_detail_header.dart';
import '../widgets/content_detail_hero.dart';
import '../widgets/content_info_section.dart';
import '../widgets/content_location_section.dart';
import '../widgets/content_product_section.dart';
import '../widgets/content_review_section.dart';
import '../widgets/content_schedule_section.dart';
import '../widgets/content_shop_section.dart';
import '../widgets/content_summary_card.dart';
import '../widgets/content_video_section.dart';
import '../widgets/detail_ui.dart';
import '../widgets/related_content_section.dart';

class ContentDetailPage extends StatefulWidget {
  const ContentDetailPage({super.key});

  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage> {
  final controller = Get.find<ContentDetailController>();
  final _videoKey = GlobalKey<ContentVideoSectionState>();
  final _reviewsKey = GlobalKey();
  static const _reviews = ContentReviewSection();

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  Future<void> _playVideo() async {
    await _scrollTo(_videoKey);
    _videoKey.currentState?.play();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.content.value;

      if (controller.isLoading.value && item == null) {
        return const _StatusScaffold(
          child: CircularProgressIndicator(color: DetailColors.brand),
        );
      }
      if (controller.isError.value || item == null) {
        return _StatusScaffold(child: _buildError());
      }

      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: ContentActionButtons(
          onReview: () => _reviews.openReviewSheet(context),
        ),
        body: CustomScrollView(
          slivers: [
            ContentDetailHero(
              item: item,
              onReport: () => _showReportSheet(context),
              onPlayVideo: ContentVideoSection.hasVideo(item)
                  ? _playVideo
                  : null,
            ),
            SliverToBoxAdapter(child: _buildBody(item)),
          ],
        ),
      );
    });
  }

  Widget _buildBody(ContentDetailModel item) {
    final blocks = <Widget>[
      if (ContentInfoSection.hasInfo(item)) ContentInfoSection(item: item),
      ContentSummaryCard(item: item),
      if (ContentVideoSection.hasVideo(item))
        ContentVideoSection(key: _videoKey, item: item),
      if (ContentLocationSection.hasCoordinates(item))
        ContentLocationSection(
          item: item,
          onOpenMap: controller.openGoogleMaps,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => ContentDetailHeader(
            item: item,
            reviewCount: controller.reviews.length,
            reviewAverage: controller.reviews.isEmpty
                ? 0
                : controller.reviews
                          .map((r) => r.rating)
                          .reduce((a, b) => a + b) /
                      controller.reviews.length,
            onRatingTap: () => _scrollTo(_reviewsKey),
          ),
        ),
        for (final block in blocks) ...[const SizedBox(height: 28), block],
        // These sections add their own divider when they have data.
        const ContentScheduleSection(),
        const ContentShopSection(),
        const ContentProductSection(),
        KeyedSubtree(key: _reviewsKey, child: _reviews),
        const RelatedContentSection(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 56,
            color: DetailColors.muted,
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value.isNotEmpty
                ? controller.errorMessage.value
                : 'โหลดข้อมูลไม่สำเร็จ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DetailColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต แล้วลองอีกครั้ง',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: DetailColors.muted),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: controller.retry,
            style: FilledButton.styleFrom(
              backgroundColor: DetailColors.brand,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(
              'ลองใหม่',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    const reasons = [
      'ข้อมูลไม่ถูกต้อง',
      'สถานที่ปิดถาวร',
      'เนื้อหาไม่เหมาะสม',
      'สแปมหรือโฆษณา',
    ];
    final other = TextEditingController();
    var selected = '';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheet) {
          final reason = selected.isNotEmpty ? selected : other.text.trim();
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'รายงานเนื้อหานี้',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: DetailColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ช่วยให้ข้อมูลในแอปถูกต้องสำหรับทุกคน',
                  style: TextStyle(fontSize: 13, color: DetailColors.muted),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reasons
                      .map(
                        (r) => ChoiceChip(
                          label: Text(r),
                          selected: selected == r,
                          showCheckmark: false,
                          selectedColor: DetailColors.ink,
                          backgroundColor: DetailColors.canvas,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selected == r
                                ? Colors.white
                                : DetailColors.ink,
                          ),
                          onSelected: (_) =>
                              setSheet(() => selected = selected == r ? '' : r),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: other,
                  onChanged: (_) => setSheet(() {}),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'หรือระบุเหตุผลอื่น...',
                    filled: true,
                    fillColor: DetailColors.canvas,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: reason.isEmpty
                      ? null
                      : () {
                          final detail = other.text.trim();
                          controller.reportContent(
                            [
                              if (selected.isNotEmpty) selected,
                              if (detail.isNotEmpty) detail,
                            ].join(': '),
                          );
                          Navigator.of(sheetContext).pop();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE5484D),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'ส่งรายงาน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).whenComplete(other.dispose);
  }
}

/// Plain scaffold with a back button for loading and error states.
class _StatusScaffold extends StatelessWidget {
  final Widget child;
  const _StatusScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: DetailColors.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: Get.back,
        ),
      ),
      body: Center(child: child),
    );
  }
}
