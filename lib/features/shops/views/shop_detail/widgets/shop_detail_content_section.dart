import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/contents/models/content_model.dart';

/// Travel stories that feature this shop. Hidden when there are none.
class ShopDetailContentSection extends StatelessWidget {
  final List<ContentModel> contents;
  const ShopDetailContentSection({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    if (contents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'เรื่องราวที่พูดถึงร้านนี้'),
        if (contents.length == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _StoryTile(item: contents.first, wide: true),
          )
        else
          SizedBox(
            height: 206,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: contents.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _StoryTile(item: contents[i]),
            ),
          ),
      ],
    );
  }
}

class _StoryTile extends StatelessWidget {
  final ContentModel item;
  final bool wide;
  const _StoryTile({required this.item, this.wide = false});

  @override
  Widget build(BuildContext context) {
    final image = (item.coverImageUrl?.isNotEmpty ?? false)
        ? item.coverImageUrl
        : item.youtubeThumbnail;

    final tile = InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: item),
      child: wide
          ? Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 132,
                    height: 88,
                    child: DetailImage(url: image),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: _texts()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 200,
                    height: 120,
                    child: DetailImage(url: image),
                  ),
                ),
                const SizedBox(height: 8),
                _texts(),
              ],
            ),
    );
    return wide ? tile : SizedBox(width: 200, child: tile);
  }

  Widget _texts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: DetailColors.ink,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.visibility_outlined,
              size: 13,
              color: DetailColors.muted,
            ),
            const SizedBox(width: 3),
            Text(
              '${item.viewCount} เข้าชม',
              style: const TextStyle(fontSize: 12, color: DetailColors.muted),
            ),
          ],
        ),
      ],
    );
  }
}
