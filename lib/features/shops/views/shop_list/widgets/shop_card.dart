import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.item, this.displayMode = 'list'});

  final ShopModel item;
  final String displayMode; // 'featured' | 'list'

  static const _openGreen = Color(0xFF16A34A);

  Future<void> _makeCall() async {
    final phone = item.phone;
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  bool get _hasPhone => item.phone?.trim().isNotEmpty ?? false;

  /// "เปิดอยู่ · ปิด 21:00" / "ปิดแล้ว · เปิด 08:00".
  String get _statusText {
    final open = item.isOpenNow;
    final label = open ? 'เปิดอยู่' : 'ปิดแล้ว';
    final time = open ? item.closingTime : item.openingTime;
    if (time == null || time.isEmpty) return label;
    return '$label · ${open ? 'ปิด' : 'เปิด'} ${time.length >= 5 ? time.substring(0, 5) : time}';
  }

  String get _location => item.districtName?.isNotEmpty ?? false
      ? 'อ.${item.districtName}'
      : 'กาญจนบุรี';

  @override
  Widget build(BuildContext context) {
    final featured = displayMode == 'featured';
    final radius = BorderRadius.circular(featured ? 22 : 18);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ShopListPalette.ink.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: item),
          child: featured ? _featured() : _compact(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card mode: storefront photo, overlapping logo, name and quick actions.
  // ---------------------------------------------------------------------------
  Widget _featured() {
    final hasBackground = item.backgroundImageUrl?.isNotEmpty ?? false;
    final banner = hasBackground ? item.backgroundImageUrl : item.coverImageUrl;
    final showLogo = hasBackground && (item.coverImageUrl?.isNotEmpty ?? false);
    final description = item.description?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DetailImage(
                url: banner,
                placeholderIcon: Icons.storefront_rounded,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x40000000), Colors.transparent],
                    stops: [0, 0.45],
                  ),
                ),
              ),
              Positioned(top: 12, left: 12, child: _statusPill()),
              if (item.categoryName?.isNotEmpty ?? false)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _glassPill(item.categoryName!),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showLogo) ...[
                    Container(
                      width: 46,
                      height: 46,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: ShopListPalette.line),
                      ),
                      child: ClipOval(
                        child: DetailImage(
                          url: item.coverImageUrl,
                          placeholderIcon: Icons.storefront_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w700,
                            color: ShopListPalette.ink,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _locationRow(),
                      ],
                    ),
                  ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: ShopListPalette.muted,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  if (_hasPhone) ...[
                    _iconAction(Icons.call_outlined, _makeCall),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: ShopListPalette.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'เข้าชมร้าน',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: ShopListPalette.primary,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: ShopListPalette.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // List mode: compact row with thumbnail, name, location and live status.
  // ---------------------------------------------------------------------------
  Widget _compact() {
    final open = item.isOpenNow;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 92,
              height: 92,
              child: DetailImage(
                url: item.coverImageUrl ?? item.backgroundImageUrl,
                placeholderIcon: Icons.storefront_rounded,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.categoryName?.isNotEmpty ?? false)
                  Text(
                    item.categoryName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ShopListPalette.primary,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: ShopListPalette.ink,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                _locationRow(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: open ? _openGreen : ShopListPalette.mutedLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _statusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: open ? _openGreen : ShopListPalette.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: ShopListPalette.mutedLight,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pieces
  // ---------------------------------------------------------------------------
  Widget _locationRow() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 14,
          color: ShopListPalette.muted,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            _location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: ShopListPalette.muted),
          ),
        ),
      ],
    );
  }

  Widget _statusPill() {
    final open = item.isOpenNow;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: open ? _openGreen : ShopListPalette.mutedLight,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: open ? _openGreen : ShopListPalette.inkSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassPill(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 170),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _iconAction(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ShopListPalette.line, width: 1.5),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: ShopListPalette.ink),
        ),
      ),
    );
  }
}
