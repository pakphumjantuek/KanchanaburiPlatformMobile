import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminSlipImageViewer {
  const AdminSlipImageViewer._();

  static void show({
    required BuildContext context,
    required String imageUrl,
    String? title,
    String? amountText,
    String? buyerName,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (ctx) => _SlipViewerDialog(
        imageUrl: imageUrl,
        title: title,
        amountText: amountText,
        buyerName: buyerName,
      ),
    );
  }
}

class _SlipViewerDialog extends StatefulWidget {
  final String imageUrl;
  final String? title;
  final String? amountText;
  final String? buyerName;

  const _SlipViewerDialog({
    required this.imageUrl,
    this.title,
    this.amountText,
    this.buyerName,
  });

  @override
  State<_SlipViewerDialog> createState() => _SlipViewerDialogState();
}

class _SlipViewerDialogState extends State<_SlipViewerDialog> {
  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final newScale = (_currentScale + 0.5).clamp(1.0, 5.0);
    _setScale(newScale);
  }

  void _zoomOut() {
    final newScale = (_currentScale - 0.5).clamp(1.0, 5.0);
    _setScale(newScale);
  }

  void _resetZoom() {
    _setScale(1.0);
  }

  void _setScale(double scale) {
    setState(() {
      _currentScale = scale;
      _transformationController.value = Matrix4.diagonal3Values(scale, scale, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.receipt_long_rounded,
                            color: AdminColors.secondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.title ?? 'รูปภาพสลิปชำระเงิน',
                            style: GoogleFonts.krub(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      if (widget.buyerName != null || widget.amountText != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          '${widget.buyerName ?? "ลูกค้า"} ${widget.amountText != null ? "• ยอด ${widget.amountText}" : ""}',
                          style: GoogleFonts.krub(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Controls
                IconButton(
                  tooltip: 'ซูมเข้า',
                  icon: const Icon(Icons.zoom_in_rounded, color: Colors.white70),
                  onPressed: _zoomIn,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  tooltip: 'ซูมออก',
                  icon: const Icon(Icons.zoom_out_rounded, color: Colors.white70),
                  onPressed: _zoomOut,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  tooltip: 'รีเซ็ตขนาด',
                  icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70),
                  onPressed: _resetZoom,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'ปิด',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                  ),
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Slip Image Body (Interactive Pinch & Pan)
          Flexible(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 560),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  onInteractionEnd: (_) {
                    setState(() {
                      _currentScale = _transformationController.value.getMaxScaleOnAxis();
                    });
                  },
                  child: Center(
                    child: widget.imageUrl.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'ไม่พบไฟล์รูปสลิปในระบบ',
                                  style: GoogleFonts.krub(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Image.network(
                            widget.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: AdminColors.secondary,
                                        strokeWidth: 2.5,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'กำลังโหลดรูปสลิปความละเอียดสูง...',
                                        style: GoogleFonts.krub(
                                          color: Colors.white70,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.redAccent,
                                    size: 54,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'ไม่สามารถเปิดแสดงผลรูปสลิปได้',
                                    style: GoogleFonts.krub(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.imageUrl,
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            'ใช้นิ้วหนีบเพื่อขยาย หรือแตะปุ่มเพื่อตรวจเลขบัญชีและยอดเงินให้ชัดเจน',
            style: GoogleFonts.krub(
              color: Colors.white60,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
