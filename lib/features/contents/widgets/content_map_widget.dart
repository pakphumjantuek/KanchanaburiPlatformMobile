import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class _Palette {
  static const ink = Color(0xFF241A12);
  static const stone = Color(0xFFF7F0E6); // must match the page it sits on
  static const river = Color(0xFF1F5F58);
  static const brass = Color(0xFFC8952F);
}

/// A location card styled like a railway boarding pass — coordinates as a
/// "ticket code", a torn perforation before the action, one bold CTA.
class ContentMapWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? title;
  final String? shopName;
  final String? districtName;

  const ContentMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.title,
    this.shopName,
    this.districtName,
  });

  bool get hasValidCoordinates =>
      latitude != null && longitude != null && latitude != 0 && longitude != 0;

  Future<void> _openGoogleMaps() async {
    if (!hasValidCoordinates) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasValidCoordinates) return const SizedBox.shrink();

    final locationText = [
      if (shopName != null && shopName!.isNotEmpty) shopName,
      if (districtName != null && districtName!.isNotEmpty) 'อ.$districtName',
      'จ.กาญจนบุรี',
    ].join(' · ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _Palette.ink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _Palette.ink.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: _Palette.brass,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    color: _Palette.ink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'พิกัดนำทาง',
                        style: GoogleFonts.kanit(
                          color: Colors.white60,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.taviraj(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Ticket-tear perforation
          SizedBox(
            height: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                  left: 18,
                  right: 18,
                  top: 8,
                  child: _DashedLine(),
                ),
                const Positioned(left: -8, top: 1, child: _Notch()),
                const Positioned(right: -8, top: 1, child: _Notch()),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.explore_outlined,
                        size: 15,
                        color: _Palette.brass,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openGoogleMaps,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _Palette.river,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.near_me_rounded, size: 18),
                    label: Text(
                      'เปิดนำทางด้วย Google Maps',
                      style: GoogleFonts.kanit(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: _Palette.stone,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: Colors.white24),
      size: const Size(double.infinity, 1),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
