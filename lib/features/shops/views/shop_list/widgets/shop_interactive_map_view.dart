import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';

class ShopInteractiveMapView extends StatefulWidget {
  final List<ShopModel> shops;

  const ShopInteractiveMapView({super.key, required this.shops});

  @override
  State<ShopInteractiveMapView> createState() => _ShopInteractiveMapViewState();
}

class _ShopInteractiveMapViewState extends State<ShopInteractiveMapView> {
  final MapController _mapController = MapController();

  List<ShopModel> get _validItems => widget.shops
      .where(
        (item) =>
            item.latitude != null &&
            item.longitude != null &&
            item.latitude != 0 &&
            item.longitude != 0,
      )
      .toList();

  LatLng get _initialCenter {
    final valid = _validItems;
    if (valid.isNotEmpty) {
      final avgLat =
          valid.map((e) => e.latitude!).reduce((a, b) => a + b) / valid.length;
      final avgLng =
          valid.map((e) => e.longitude!).reduce((a, b) => a + b) / valid.length;
      return LatLng(avgLat, avgLng);
    }
    return const LatLng(14.0234, 99.5321); // Kanchanaburi default
  }

  @override
  Widget build(BuildContext context) {
    final validItems = _validItems;

    if (validItems.isEmpty) {
      return Container(
        color: ShopListPalette.canvas,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ShopListPalette.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    size: 52,
                    color: ShopListPalette.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ยังไม่มีพิกัดร้านค้าตามตัวกรองนี้',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: ShopListPalette.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ลองเลือกอำเภออื่น หรือเปลี่ยนหมวดหมู่ร้านค้า',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: ShopListPalette.muted),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: 10.5,
            minZoom: 6,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.kanchanaburi.projecte',
            ),
            MarkerLayer(
              markers: validItems.map((item) {
                return Marker(
                  point: LatLng(item.latitude!, item.longitude!),
                  width: 58,
                  height: 64,
                  alignment: Alignment.topCenter,
                  child: _buildShopImageMarkerPin(context, item),
                );
              }).toList(),
            ),
          ],
        ),

        // Count Badge (Frosted Pill)
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xDE0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 0.8,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storefront_rounded,
                  size: 16,
                  color: ShopListPalette.gold,
                ),
                const SizedBox(width: 7),
                Text(
                  'พบ ${validItems.length} ร้านค้าบนแผนที่',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recenter FAB Button
        Positioned(
          bottom: 24,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'shop_map_recenter',
            onPressed: () {
              _mapController.move(_initialCenter, 10.5);
            },
            backgroundColor: ShopListPalette.primaryDark,
            foregroundColor: Colors.white,
            elevation: 4,
            tooltip: 'จัดกึ่งกลางแผนที่',
            child: const Icon(Icons.my_location_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildShopImageMarkerPin(BuildContext context, ShopModel item) {
    final imgUrl = item.coverImageUrl;

    return GestureDetector(
      onTap: () => _showShopPreviewSheet(context, item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Photo Frame Pin Head
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [ShopListPalette.primaryDark, ShopListPalette.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: ShopListPalette.gold, width: 2.8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: imgUrl != null && imgUrl.isNotEmpty
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          _buildShopMarkerFallbackIcon(),
                    )
                  : _buildShopMarkerFallbackIcon(),
            ),
          ),

          // Downward Pointer Tail
          CustomPaint(
            size: const Size(12, 7),
            painter: _ShopPinTrianglePainter(
              color: ShopListPalette.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopMarkerFallbackIcon() {
    return Container(
      color: ShopListPalette.primaryDark,
      child: const Center(
        child: Icon(
          Icons.storefront_rounded,
          color: ShopListPalette.gold,
          size: 24,
        ),
      ),
    );
  }

  void _showShopPreviewSheet(BuildContext context, ShopModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isOpen = item.isOpenNow;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              if (item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty)
                AspectRatio(
                  aspectRatio: 21 / 9,
                  child: Image.network(item.coverImageUrl!, fit: BoxFit.cover),
                ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Category row
                    Row(
                      children: [
                        if (item.categoryName != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ShopListPalette.primarySoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.categoryName!,
                              style: const TextStyle(
                                color: ShopListPalette.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? ShopListPalette.greenSoft
                                : ShopListPalette.surfaceMuted,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isOpen
                                      ? ShopListPalette.green
                                      : ShopListPalette.mutedLight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isOpen ? 'เปิดบริการอยู่' : 'ปิดชั่วคราว',
                                style: TextStyle(
                                  color: isOpen
                                      ? ShopListPalette.green
                                      : ShopListPalette.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Shop Name
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ShopListPalette.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description / Address
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: ShopListPalette.muted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 18),

                    // Actions Row
                    Row(
                      children: [
                        // Navigate Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final url =
                                  'https://www.google.com/maps/search/?api=1&query=${item.latitude},${item.longitude}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ShopListPalette.primary,
                              side: const BorderSide(
                                color: ShopListPalette.primaryLight,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.near_me_outlined, size: 16),
                            label: const Text(
                              'นำทาง',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // View Shop Details Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.toNamed(
                                AppRoutes.shopDetail,
                                arguments: item,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ShopListPalette.primaryDark,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(
                              Icons.storefront_rounded,
                              size: 16,
                            ),
                            label: const Text(
                              'ดูหน้าร้าน',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShopPinTrianglePainter extends CustomPainter {
  final Color color;

  _ShopPinTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ShopPinTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
