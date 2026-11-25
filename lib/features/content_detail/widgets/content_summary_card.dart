import 'package:flutter/material.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// Summary lead + full story, collapsed to a few lines with "อ่านต่อ".
class ContentSummaryCard extends StatefulWidget {
  final ContentDetailModel item;
  const ContentSummaryCard({super.key, required this.item});

  @override
  State<ContentSummaryCard> createState() => _ContentSummaryCardState();
}

class _ContentSummaryCardState extends State<ContentSummaryCard> {
  static const _collapsedLines = 6;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.item.description?.trim() ?? '';
    var body = widget.item.body?.trim() ?? '';
    if (body == summary) body = '';
    if (summary.isEmpty && body.isEmpty) return const SizedBox.shrink();

    const bodyStyle = TextStyle(
      fontSize: 15.5,
      color: DetailColors.body,
      height: 1.75,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'เกี่ยวกับที่นี่'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (summary.isNotEmpty)
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 16,
                    color: DetailColors.ink,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                  ),
                ),
              if (body.isNotEmpty) ...[
                if (summary.isNotEmpty) const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Only offer "อ่านต่อ" when the story actually overflows.
                    final painter = TextPainter(
                      text: TextSpan(text: body, style: bodyStyle),
                      maxLines: _collapsedLines,
                      textDirection: Directionality.of(context),
                      textScaler: MediaQuery.textScalerOf(context),
                    )..layout(maxWidth: constraints.maxWidth);
                    final overflows = painter.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topCenter,
                          child: Text(
                            body,
                            style: bodyStyle,
                            maxLines: _expanded ? null : _collapsedLines,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.fade,
                          ),
                        ),
                        if (overflows)
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _expanded = !_expanded),
                            style: TextButton.styleFrom(
                              foregroundColor: DetailColors.brand,
                              padding: EdgeInsets.zero,
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                            ),
                            label: Text(
                              _expanded ? 'ย่อเนื้อหา' : 'อ่านต่อ',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
              if (widget.item.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.item.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: DetailColors.canvas,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: DetailColors.body,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
