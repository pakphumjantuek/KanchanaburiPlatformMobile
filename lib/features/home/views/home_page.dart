import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_colors.dart';
import '../widgets/home_cta_banner.dart';
import '../widgets/home_district_transit_map.dart';
import '../widgets/home_hero_slider.dart';
import '../widgets/home_products_section.dart';
import '../widgets/home_deals_section.dart';
import '../widgets/home_search_header.dart';
import '../widgets/home_shops_section.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/home_stories_section.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const double _toolbarHeight = 64;
  static const double _greetingHeight = 76;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.bgCanvas,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const HomeSkeleton();
        }
        return RefreshIndicator(
          onRefresh: controller.fetchHomeData,
          color: HomeColors.brandPrimary,
          edgeOffset: _toolbarHeight + HomeSearchBar.height,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: HomeColors.darkHeader,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: _toolbarHeight,
                expandedHeight:
                    _toolbarHeight + _greetingHeight + HomeSearchBar.height,
                title: _buildBrand(),
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        _toolbarHeight + 4,
                        16,
                        HomeSearchBar.height,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HomeGreeting(),
                      ),
                    ),
                  ),
                ),
                bottom: const HomeSearchBar(),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomePopularTags(),
                    SizedBox(height: 20),
                    HomeHeroSlider(),
                    SizedBox(height: 26),
                    HomeDealsSection(),
                    SizedBox(height: 26),
                    HomeStoriesSection(),
                    SizedBox(height: 26),
                    HomeDistrictTransitMap(),
                    SizedBox(height: 26),
                    HomeShopsSection(),
                    SizedBox(height: 26),
                    HomeProductsSection(),
                    SizedBox(height: 26),
                    HomeCtaBanner(),
                    SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: HomeColors.brandPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KANCHANABURI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'แพลตฟอร์มท่องเที่ยว & สินค้าชุมชน',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFCC80),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
