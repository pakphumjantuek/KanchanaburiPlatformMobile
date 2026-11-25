import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../home/widgets/home_colors.dart';
import '../controllers/content_controller.dart';
import '../widgets/content_card.dart';
import '../widgets/content_category_district_filter.dart';
import '../widgets/content_interactive_map_view.dart';
import '../widgets/content_search_header.dart';

class ContentsPage extends GetView<ContentController> {
  const ContentsPage({super.key});

  static const double _toolbarHeight = 64;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: HomeColors.darkHeader,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: _toolbarHeight,
        title: const ContentAppBarTitle(),
        actions: [
          Obx(
            () => controller.hasActiveFilters
                ? TextButton.icon(
                    onPressed: controller.clearFilters,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                    label: const Text(
                      'ล้างตัวกรอง',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 6),
        ],
        bottom: const ContentSearchBar(),
      ),
      body: Obx(() {
        // Full-screen loader only on first open; refetches keep the
        // search box and filters on screen.
        if (controller.isLoading.value && !controller.hasLoaded.value) {
          return const LoadingWidget(
            message: 'กำลังสำรวจเรื่องราวเมืองกาญจน์...',
            subMessage: 'ค้นหาบทความ & สถานที่แนะนำ',
            icon: Icons.explore_rounded,
          );
        }

        final progress = SizedBox(
          height: 3,
          child: controller.isLoading.value
              ? const LinearProgressIndicator(
                  color: HomeColors.brandPrimary,
                  backgroundColor: Colors.transparent,
                )
              : null,
        );

        final mode = controller.viewMode.value;

        // The app bar is shared by every mode, so switching views only
        // swaps the content below it.
        return Column(
          children: [
            Expanded(
              child: mode == 'map'
                  // Map stays outside the scroll view so dragging it never
                  // scrolls the page or triggers pull-to-refresh.
                  ? Column(
                      children: [
                        const ContentCategoryDistrictFilter(),
                        progress,
                        Expanded(
                          child: ContentInteractiveMapView(
                            contents: controller.contents,
                          ),
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: controller.fetchContents,
                      color: HomeColors.brandPrimary,
                      backgroundColor: Colors.white,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          const SliverToBoxAdapter(
                            child: ContentCategoryDistrictFilter(),
                          ),
                          SliverToBoxAdapter(child: progress),
                          if (controller.contents.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Expanded(
                                    child: EmptyWidget(
                                      message:
                                          'ไม่พบข้อมูลคอนเทนต์ตรงกับเงื่อนไขการค้นหา',
                                    ),
                                  ),
                                  if (controller.hasActiveFilters)
                                    OutlinedButton.icon(
                                      onPressed: controller.clearFilters,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            HomeColors.brandPrimary,
                                        side: const BorderSide(
                                          color: HomeColors.brandPrimary,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.filter_alt_off_rounded,
                                      ),
                                      label: const Text('ล้างตัวกรองทั้งหมด'),
                                    ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: mode == 'grid' ? 16 : 12,
                                    ),
                                    child: ContentCard(
                                      // Keyed by mode so cards rebuild cleanly
                                      // when switching card/list layouts.
                                      key: ValueKey(
                                        '$mode-${controller.contents[index].id}',
                                      ),
                                      item: controller.contents[index],
                                      displayMode: mode,
                                      index: index,
                                    ),
                                  ),
                                  childCount: controller.contents.length,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
