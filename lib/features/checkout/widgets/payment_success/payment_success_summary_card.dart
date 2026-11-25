import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../orders/models/order_model.dart';

class PaymentSuccessSummaryCard extends StatelessWidget {
  final OrderModel order;

  const PaymentSuccessSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('หมายเลขคำสั่งซื้อ', order.orderNumber ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow('ร้านค้า', order.shopName ?? 'ร้านค้าชุมชน'),
          const SizedBox(height: 8),
          _buildInfoRow(
            'ราคารวมทั้งสิ้น',
            '฿${order.totalAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'สถานะการชำระเงิน',
            order.paymentStatus == 'PendingVerify'
                ? 'แนบสลิปแล้ว (รอตรวจสอบ)'
                : order.statusLabel,
          ),
          if (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEADCCF)),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: _buildSlipImageWidget(order.slipImageUrl!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'แนบหลักฐานการชำระเงินเรียบร้อย',
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'เจ้าหน้าที่จะทำการตรวจสอบยอดชำระโดยเร็วที่สุด',
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.krub(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2B1F17),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlipImageWidget(
    String slip, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (slip.startsWith('data:image')) {
      try {
        final base64Data = slip.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, width: width, height: height, fit: fit);
      } catch (_) {}
    }
    if (slip.startsWith('http://') || slip.startsWith('https://')) {
      return Image.network(
        slip,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF2E7D32),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 24),
        ),
      );
    }
    final file = File(slip);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF2E7D32),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 24),
        ),
      );
    }
    return Container(
      color: const Color(0xFF2E7D32),
      child: const Icon(Icons.image_rounded, color: Colors.white, size: 24),
    );
  }
}
