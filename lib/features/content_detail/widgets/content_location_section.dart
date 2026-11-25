import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// Small static map preview with the address and a directions button.
class ContentLocationSection extends StatelessWidget {
  final ContentDetailModel item;
  final VoidCallback onOpenMap;

  const ContentLocationSection({
    super.key,
    required this.item,
    required this.onOpenMap,
  });

  static bool hasCoordinates(ContentDetailModel item) =>
      item.latitude != null &&
      item.longitude != null &&
      item.latitude != 0 &&
      item.longitude != 0;

  @override
  Widget build(BuildContext context) {
    if (!hasCoordinates(item)) return const SizedBox.shrink();
    final point = LatLng(item.latitude!, item.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'ตำแหน่งที่ตั้ง'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DetailColors.line),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 170,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: point,
                        initialZoom: 14,
                        // Preview only: the page scroll keeps priority.
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  Shadow(
                                    color: Color(0x55000000),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(onTap: onOpenMap),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fullLocationText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: DetailColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'จ.กาญจนบุรี',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: DetailColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onOpenMap,
                      style: TextButton.styleFrom(
                        foregroundColor: DetailColors.brand,
                      ),
                      icon: const Icon(Icons.directions_rounded, size: 20),
                      label: const Text(
                        'เส้นทาง',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
