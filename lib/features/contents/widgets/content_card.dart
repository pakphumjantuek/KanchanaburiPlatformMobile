import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/widgets/home_colors.dart';
import '../models/content_model.dart';

const _brand = HomeColors.brandPrimary;
const _ink = HomeColors.textBlack;
const _muted = HomeColors.textMuted;

class ContentCard extends StatelessWidget {
  final ContentModel item;
  final String displayMode; // 'grid' | 'list'
  final int index;

  const ContentCard({
    super.key,
    required this.item,
    this.displayMode = 'grid',
    this.index = 0,
  });

  bool get _hasVideo =>
      item.youtubeUrl != null && item.youtubeUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Staggered entry animation based on position in the list.
    final animDelay = (index % 6) * 50;
    final isGrid = displayMode == 'grid';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 380 + animDelay),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1.0 - animValue) * 24),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isGrid ? 20 : 16),
          boxShadow: [
            BoxShadow(
              color: _ink.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(isGrid ? 20 : 16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: item),
            child: isGrid ? _buildGrid() : _buildList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final description = item.description?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(),
              if (item.categoryName != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: _CategoryPill(label: item.categoryName!),
                ),
              if (_hasVideo) const Center(child: _PlayBadge(size: 24)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              _MetaRow(item: item),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: _muted,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return SizedBox(
      height: 112,
      child: Row(
        children: [
          SizedBox(
            width: 112,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(),
                if (_hasVideo) const Center(child: _PlayBadge(size: 18)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.categoryName != null)
                    Text(
                      item.categoryName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _brand,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _ink,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  _MetaRow(item: item),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imgUrl =
        item.coverImageUrl ??
        (item.youtubeThumbnail.isNotEmpty ? item.youtubeThumbnail : null);
    if (imgUrl != null && imgUrl.isNotEmpty) {
      return Image.network(
        imgUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF3EAE0),
      child: const Center(
        child: Icon(Icons.travel_explore_rounded, size: 36, color: _muted),
      ),
    );
  }
}

/// "📍 ทองผาภูมิ · ★ 4.5 · 👁 120" on one line.
class _MetaRow extends StatelessWidget {
  final ContentModel item;
  const _MetaRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final district = item.districtName?.trim() ?? '';
    const style = TextStyle(fontSize: 12.5, color: _muted);

    final parts = <Widget>[
      if (district.isNotEmpty)
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: _brand),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  district,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      if (item.rating > 0)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF2B33D)),
            const SizedBox(width: 2),
            Text(item.rating.toStringAsFixed(1), style: style),
          ],
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility_outlined, size: 14, color: _muted),
          const SizedBox(width: 3),
          Text('${item.viewCount}', style: style),
        ],
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < parts.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('·', style: TextStyle(color: _muted)),
            ),
          parts[i],
        ],
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
    );
  }
}

class _PlayBadge extends StatelessWidget {
  final double size;
  const _PlayBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * 0.35),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: size),
    );
  }
}
