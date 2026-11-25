import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSlipImage extends StatelessWidget {
  const OrderSlipImage({
    super.key,
    required this.slip,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String slip;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (slip.startsWith('data:image')) {
      try {
        final bytes = base64Decode(slip.split(',').last);
        return Image.memory(bytes, width: width, height: height, fit: fit);
      } catch (_) {
        return _loadError();
      }
    }
    if (slip.startsWith('http://') || slip.startsWith('https://')) {
      return Image.network(
        slip,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _loadError(),
      );
    }

    final file = File(slip);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _loadError(),
      );
    }
    return _loadError();
  }

  Widget _loadError() {
    return Container(
      width: width,
      height: height ?? 80,
      color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
      child: Center(
        child: Text(
          'ไม่สามารถโหลดรูปสลิปได้',
          style: GoogleFonts.krub(fontSize: 13, color: const Color(0xFF786B62)),
        ),
      ),
    );
  }

  static Future<void> showPreview(BuildContext context, String imageUrl) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: OrderSlipImage(slip: imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
