import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shops/widgets/shared/product_card.dart';
import '../controllers/home_controller.dart';
import 'home_section_header.dart';

class HomeProductsSection extends GetView<HomeController> {
  const HomeProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.products;
      if (list.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: 'สินค้าชุมชนโดดเด่น',
            subtitle: 'ของดีของฝากเมืองกาญจน์ คัดสรรตรงจากชุมชน',
            onSeeAll: () => openMainTab(1, '/shops'),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 286,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, index) =>
                  SizedBox(width: 190, child: ProductCard(item: list[index])),
            ),
          ),
        ],
      );
    });
  }
}
