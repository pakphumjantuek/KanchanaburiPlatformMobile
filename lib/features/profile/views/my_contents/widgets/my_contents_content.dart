import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/loading_widget.dart';
import '../../../controllers/my_contents_controller.dart';
import 'my_content_card.dart';
import 'my_contents_empty_state.dart';
import 'my_contents_filter_chips.dart';
import 'my_contents_hero_header.dart';

class MyContentsContent extends StatelessWidget {
  const MyContentsContent({super.key, required this.controller});

  final MyContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingWidget(
          message: 'กำลังโหลดคอนเทนต์ของคุณ...',
          icon: Icons.article_rounded,
        );
      }

      final contents = controller.filteredContents;
      return RefreshIndicator(
        color: const Color(0xFFD96C2C),
        onRefresh: controller.fetchMyContents,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyContentsHeroHeader(),
              const SizedBox(height: 18),
              MyContentsFilterChips(controller: controller),
              const SizedBox(height: 18),
              if (contents.isEmpty)
                const MyContentsEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contents.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) => MyContentCard(
                    content: contents[index],
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
