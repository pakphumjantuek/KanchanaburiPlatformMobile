import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// Practical visitor info: hours, fee, organizer, phone, website.
/// Renders nothing when the content has none of these.
class ContentInfoSection extends GetView<ContentDetailController> {
  final ContentDetailModel item;
  const ContentInfoSection({super.key, required this.item});

  static bool hasInfo(ContentDetailModel item) => [
    item.openingHours,
    item.admissionFee,
    item.organizer,
    item.phone,
    item.website,
  ].any((v) => v != null && v.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    String? clean(String? v) =>
        (v == null || v.trim().isEmpty) ? null : v.trim();

    final rows = <Widget>[
      if (clean(item.openingHours) case final v?)
        _InfoRow(icon: Icons.access_time_rounded, label: 'เวลาเปิด', value: v),
      if (clean(item.admissionFee) case final v?)
        _InfoRow(
          icon: Icons.confirmation_number_outlined,
          label: 'ค่าเข้าชม',
          value: v,
        ),
      if (clean(item.organizer) case final v?)
        _InfoRow(icon: Icons.person_outline_rounded, label: 'ผู้จัด', value: v),
      if (clean(item.phone) case final v?)
        _InfoRow(
          icon: Icons.call_outlined,
          label: 'โทร',
          value: v,
          actionIcon: Icons.call_rounded,
          onTap: () => controller.callPhone(v),
        ),
      if (clean(item.website) case final v?)
        _InfoRow(
          icon: Icons.language_rounded,
          label: 'เว็บไซต์',
          value: v,
          actionIcon: Icons.open_in_new_rounded,
          onTap: () => controller.openWebsite(v),
        ),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'ข้อมูลสำหรับผู้มาเยือน'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: DetailColors.line),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: DetailColors.line,
                  ),
                rows[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final IconData? actionIcon;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.actionIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: DetailColors.brand),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DetailColors.muted,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: onTap != null
                          ? DetailColors.brand
                          : DetailColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            if (actionIcon != null)
              Icon(actionIcon, size: 18, color: DetailColors.muted),
          ],
        ),
      ),
    );
  }
}
