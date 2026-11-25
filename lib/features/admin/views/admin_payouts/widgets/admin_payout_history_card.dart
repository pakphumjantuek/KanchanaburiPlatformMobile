import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';
import 'package:projecte/features/admin/models/admin_order_slip_model.dart';

class AdminPayoutHistoryCard extends StatelessWidget {
  const AdminPayoutHistoryCard({super.key, required this.record});

  final MerchantPayoutRecord record;

  void _showSlipDialog(BuildContext context, String slipUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'หลักฐานการโอนเงิน',
                      style: GoogleFonts.krub(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  child: Image.network(
                    slipUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(color: AdminColors.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('ไม่สามารถโหลดรูปภาพสลิปได้'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String raw) {
    if (raw.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(raw).toLocal();
      final day = parsed.day;
      final months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      final month = months[parsed.month - 1];
      final year = parsed.year + 543;
      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');
      return '$day $month $year, $hour:$minute น.';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = record.shopLogoUrl != null && record.shopLogoUrl!.isNotEmpty
        ? AdminPendingSlipGroup.resolveSlipUrl(record.shopLogoUrl!)
        : null;

    final resolvedSlipUrl = record.slipImageUrl != null && record.slipImageUrl!.isNotEmpty
        ? AdminPendingSlipGroup.resolveSlipUrl(record.slipImageUrl!)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Shop Info & Amount
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AdminColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: logoUrl != null
                      ? Image.network(
                          logoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              (record.shopName?.isNotEmpty ?? false) ? record.shopName![0] : 'S',
                              style: GoogleFonts.krub(
                                fontWeight: FontWeight.bold,
                                color: AdminColors.primary,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            (record.shopName?.isNotEmpty ?? false) ? record.shopName![0] : 'S',
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              color: AdminColors.primary,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.shopName ?? 'ร้านค้า',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AdminColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDateTime(record.createdAt),
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '฿${record.totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                      color: AdminColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'โอนสำเร็จ',
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Row 2: Transaction Reference & View Slip button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.tag_rounded, size: 14, color: AdminColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'อ้างอิง: ',
                      style: GoogleFonts.krub(fontSize: 11.5, color: AdminColors.textSecondary),
                    ),
                    Flexible(
                      child: Text(
                        record.transactionRef ?? '-',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AdminColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (record.transactionRef != null && record.transactionRef!.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: record.transactionRef!));
                          Get.snackbar(
                            'คัดลอกสำเร็จ',
                            'คัดลอกรหัสอ้างอิงเรียบร้อย',
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: const Icon(Icons.copy_rounded, size: 12, color: AdminColors.primary),
                      ),
                    ],
                  ],
                ),
              ),

              if (resolvedSlipUrl != null)
                InkWell(
                  onTap: () => _showSlipDialog(context, resolvedSlipUrl),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AdminColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_rounded, size: 14, color: AdminColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'ดูสลิปโอน',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          if (record.note != null && record.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'บันทึก: ${record.note}',
                style: GoogleFonts.krub(
                  fontSize: 11.5,
                  color: AdminColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
