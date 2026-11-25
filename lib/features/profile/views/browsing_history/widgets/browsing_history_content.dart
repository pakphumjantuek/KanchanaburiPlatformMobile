import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../shared/widgets/loading_widget.dart';
import '../../../controllers/browsing_history_controller.dart';
import 'browsing_history_card.dart';
import 'browsing_history_empty_state.dart';

class BrowsingHistoryContent extends StatelessWidget {
  const BrowsingHistoryContent({super.key, required this.controller});

  final BrowsingHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.historyList.isEmpty) {
        return const LoadingWidget(
          message: 'กำลังโหลดประวัติการเข้าชม...',
          icon: Icons.history_rounded,
        );
      }
      if (controller.historyList.isEmpty) {
        return const BrowsingHistoryEmptyState();
      }
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refreshHistory,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          itemCount: controller.historyList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              BrowsingHistoryCard(item: controller.historyList[index]),
        ),
      );
    });
  }
}
