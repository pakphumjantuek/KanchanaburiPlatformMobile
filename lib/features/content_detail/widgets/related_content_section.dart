import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// "You may also like" shelf of other stories in the same category.
class RelatedContentSection extends GetView<ContentDetailController> {
  const RelatedContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.relatedContents;
      if (items.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailDivider(),
          const DetailSectionTitle(title: 'ที่เที่ยวที่คุณอาจชอบ'),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _RelatedCard(item: items[i]),
            ),
          ),
        ],
      );
    });
  }
}

class _RelatedCard extends StatelessWidget {
  final ContentDetailModel item;
  const _RelatedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final image = (item.coverImageUrl?.isNotEmpty ?? false)
        ? item.coverImageUrl
        : item.youtubeThumbnail;

    return SizedBox(
      width: 200,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.offNamed('/contents/${item.id}', arguments: item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 200,
                height: 124,
                child: DetailImage(url: image),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DetailColors.ink,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: DetailColors.muted,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    item.districtName?.isNotEmpty ?? false
                        ? 'อ.${item.districtName}'
                        : 'กาญจนบุรี',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DetailColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
