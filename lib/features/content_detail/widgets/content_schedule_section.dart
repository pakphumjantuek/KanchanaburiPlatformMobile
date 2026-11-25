import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_schedule_model.dart';
import 'detail_ui.dart';

/// Event rounds shown as a simple vertical timeline.
class ContentScheduleSection extends GetView<ContentDetailController> {
  const ContentScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final schedules = controller.schedules;
      if (schedules.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailDivider(),
          DetailSectionTitle(
            title: 'กำหนดการกิจกรรม · ${schedules.length} รอบ',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < schedules.length; i++)
                  _TimelineItem(
                    item: schedules[i],
                    isLast: i == schedules.length - 1,
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _TimelineItem extends StatelessWidget {
  final ContentScheduleModel item;
  final bool isLast;
  const _TimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final when = [
      if (item.date?.isNotEmpty ?? false) _date(item.date!),
      if (item.time?.isNotEmpty ?? false) _time(item.time!),
    ].join(' · ');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: DetailColors.brand, width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: DetailColors.line),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (when.isNotEmpty)
                    Text(
                      when,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: DetailColors.brand,
                      ),
                    ),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: DetailColors.ink,
                      height: 1.4,
                    ),
                  ),
                  if (item.location?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.location!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: DetailColors.muted,
                        ),
                      ),
                    ),
                  if (item.description?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: DetailColors.body,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _date(String raw) =>
      DateTime.tryParse(raw) != null ? formatThaiDate(raw) : raw;

  static String _time(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final l = dt.toLocal();
    return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')} น.';
  }
}
