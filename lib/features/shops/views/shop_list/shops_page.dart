import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_card.dart';
import 'package:projecte/features/home/widgets/home_deals_section.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_interactive_map_view.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_list_filters.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_list_header.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late final ShopController controller;
  late final TextEditingController searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ShopController>();
    searchController = TextEditingController(
      text: controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.isEmpty) {
      controller.setSearch('');
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => controller.setSearch(query),
    );
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    searchController.clear();
    controller.setSearch('');
  }

  void _clearFilters() {
    _searchDebounce?.cancel();
    searchController.clear();
    controller.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopListPalette.canvas,
      appBar: AppBar(
        backgroundColor: ShopListPalette.primaryDark,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ShopListPalette.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ร้านค้าชุมชน',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ของฝากและสินค้าภูมิปัญญาเมืองกาญจน์',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFCC80),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => controller.hasActiveFilters
                ? TextButton.icon(
                    onPressed: _clearFilters,
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
        bottom: ShopListHeader(
          controller: controller,
          searchController: searchController,
          onSearchChanged: _onSearchChanged,
        ),
      ),
      body: Obx(() {
        // Full-screen loader only on first open; refetches keep the
        // filters on screen and show a thin progress bar instead.
        if (controller.isLoading.value && !controller.hasLoaded.value) {
          return const LoadingWidget();
        }

        final filters = ShopListFilters(
          controller: controller,
          onClearSearch: _clearSearch,
        );
        final progress = SizedBox(
          height: 3,
          child: controller.isLoading.value
              ? const LinearProgressIndicator(
                  color: ShopListPalette.primary,
                  backgroundColor: Colors.transparent,
                )
              : null,
        );
        final mode = controller.viewMode.value;
        final shops = controller.displayedShops;

        // Map stays outside the scroll view so dragging it never scrolls
        // the page or triggers pull-to-refresh.
        if (mode == 'map') {
          return Column(
            children: [
              filters,
              progress,
              Expanded(child: ShopInteractiveMapView(shops: shops)),
            ],
          );
        }

        final showDeals =
            !controller.hasActiveFilters &&
            controller.specialProducts.isNotEmpty;

        return RefreshIndicator(
          onRefresh: controller.refreshPage,
          color: ShopListPalette.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: filters),
              SliverToBoxAdapter(child: progress),
              if (showDeals) SliverToBoxAdapter(child: _dealsShelf()),
              if (shops.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _emptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: mode == 'grid' ? 16 : 12,
                        ),
                        child: ShopCard(
                          key: ValueKey('$mode-${shops[index].id}'),
                          item: shops[index],
                          displayMode: mode == 'grid' ? 'featured' : 'list',
                        ),
                      ),
                      childCount: shops.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _dealsShelf() {
    final deals = controller.specialProducts;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: ShopListPalette.orange,
                ),
                const SizedBox(width: 6),
                const Text(
                  'ดีลพิเศษวันนี้',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ShopListPalette.ink,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${deals.length} ดีล',
                  style: const TextStyle(
                    fontSize: 13,
                    color: ShopListPalette.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 236,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              itemCount: deals.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => HomeDealCard(product: deals[i]),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'ร้านค้าทั้งหมด',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ShopListPalette.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ShopListPalette.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_outlined,
                size: 40,
                color: ShopListPalette.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ยังไม่พบร้านค้าที่ตรงกับการค้นหา',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ShopListPalette.ink,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'ลองค้นหาด้วยคำอื่น หรือล้างตัวกรองเพื่อดูร้านค้าทั้งหมด',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ShopListPalette.muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: ShopListPalette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'ล้างตัวกรองทั้งหมด',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
