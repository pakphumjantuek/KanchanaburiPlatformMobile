import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

/// Story, contact details and a map preview for the shop.
class ShopDetailAboutSection extends StatelessWidget {
  final ShopModel shop;
  final ValueChanged<String> onCallPhone;
  final VoidCallback onDirections;

  const ShopDetailAboutSection({
    super.key,
    required this.shop,
    required this.onCallPhone,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    String? clean(String? v) =>
        (v == null || v.trim().isEmpty) ? null : v.trim();

    final description = clean(shop.description);
    final rows = <Widget>[
      if (shop.openingTime != null && shop.closingTime != null)
        _InfoRow(
          icon: Icons.access_time_rounded,
          label: 'เวลาทำการ',
          value: '${shop.openingTime} - ${shop.closingTime} น.',
          trailing: shop.isOpenNow ? 'เปิดอยู่' : 'ปิดแล้ว',
          trailingColor: shop.isOpenNow
              ? const Color(0xFF16A34A)
              : DetailColors.muted,
        ),
      if (clean(shop.phone) case final phone?)
        _InfoRow(
          icon: Icons.call_outlined,
          label: 'โทรศัพท์',
          value: phone,
          action: Icons.call_rounded,
          onTap: () => onCallPhone(phone),
        ),
      if (clean(shop.email) case final email?)
        _InfoRow(
          icon: Icons.mail_outline_rounded,
          label: 'อีเมล',
          value: email,
        ),
      _InfoRow(
        icon: Icons.location_on_outlined,
        label: 'ที่อยู่',
        value:
            clean(shop.address) ??
            [
              if (shop.subDistrictName?.isNotEmpty ?? false)
                'ต.${shop.subDistrictName}',
              if (shop.districtName?.isNotEmpty ?? false)
                'อ.${shop.districtName}',
              'จ.กาญจนบุรี',
            ].join(' '),
      ),
    ];

    final hasMap =
        shop.latitude != null &&
        shop.longitude != null &&
        shop.latitude != 0 &&
        shop.longitude != 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'ข้อมูลร้าน'),
        if (description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: DetailColors.body,
                height: 1.7,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: DetailColors.line),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              if (hasMap) _mapPreview(LatLng(shop.latitude!, shop.longitude!)),
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0 || hasMap)
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

  Widget _mapPreview(LatLng point) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: point,
              initialZoom: 15,
              // Preview only: the page scroll keeps priority.
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kanchanaburi.projecte',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 44,
                      color: DetailColors.brand,
                      shadows: [
                        Shadow(color: Color(0x55000000), blurRadius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Material(
              color: Colors.white,
              shape: const StadiumBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: onDirections,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 7, 12, 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_rounded,
                        size: 18,
                        color: DetailColors.brand,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'เส้นทาง',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: DetailColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final IconData? action;
  final String? trailing;
  final Color? trailingColor;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.action,
    this.trailing,
    this.trailingColor,
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
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: trailingColor,
                ),
              ),
            if (action != null)
              Icon(action, size: 18, color: DetailColors.muted),
          ],
        ),
      ),
    );
  }
}
