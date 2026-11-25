import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/loading_widget.dart';
import '../../../controllers/favorites_controller.dart';
import 'favorite_content_card.dart';
import 'favorites_empty_state.dart';
import 'favorites_header_card.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key, required this.controller});

  final FavoritesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingWidget(
          message: 'กำลังโหลดรายการโปรด...',
          icon: Icons.favorite_rounded,
        );
      }

      return RefreshIndicator(
        color: const Color(0xFFE76F51),
        onRefresh: controller.fetchFavorites,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FavoritesHeaderCard(),
              const SizedBox(height: 18),
              if (controller.favoritesList.isEmpty)
                const FavoritesEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.favoritesList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) => FavoriteContentCard(
                    item: controller.favoritesList[index],
                    controller: controller,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
