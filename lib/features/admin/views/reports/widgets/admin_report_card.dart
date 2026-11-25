import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_reports_controller.dart';
import '../../../models/admin_report_model.dart';
import 'admin_report_status_badge.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({
    super.key,
    required this.report,
    required this.controller,
  });

  final AdminReport report;
  final AdminReportsController controller;

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = [
        '',
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];
      final month =
          dt.month >= 1 && dt.month <= 12 ? months[dt.month] : '${dt.month}';
      final year = (dt.year + 543) % 100;
      final minute = dt.minute.toString().padLeft(2, '0');
      final hour = dt.hour.toString().padLeft(2, '0');
      return '${dt.day} $month $year, $hour:$minute น.';
    } catch (_) {
      return dateStr.length >= 16 ? dateStr.substring(0, 16) : dateStr;
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'คัดลอกแล้ว',
      'คัดลอก$label: $text เรียบร้อยแล้ว',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: AdminColors.primaryDark,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showChangeStatusSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AdminColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.published_with_changes_rounded,
                      color: AdminColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เปลี่ยนสถานะการร้องเรียน',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        Text(
                          report.targetLabel,
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 8),

              _statusOptionTile(
                ctx,
                statusKey: 'Pending',
                title: 'รอดำเนินการ (Pending)',
                subtitle: 'รายงานยังไม่ได้รับการตรวจสอบ รอเจ้าหน้าที่พิจารณา',
                icon: Icons.hourglass_top_rounded,
                color: AdminColors.error,
              ),
              _statusOptionTile(
                ctx,
                statusKey: 'InProgress',
                title: 'กำลังตรวจสอบ (InProgress)',
                subtitle: 'อยู่ระหว่างดำเนินการตรวจสอบข้อเท็จจริงหรือติดต่อผู้ใช้',
                icon: Icons.sync_rounded,
                color: AdminColors.info,
              ),
              _statusOptionTile(
                ctx,
                statusKey: 'Resolved',
                title: 'แก้ไขแล้ว (Resolved)',
                subtitle: 'ดำเนินการแก้ไข จัดการเนื้อหา หรือลงโทษเรียบร้อยแล้ว',
                icon: Icons.check_circle_rounded,
                color: AdminColors.success,
              ),
              _statusOptionTile(
                ctx,
                statusKey: 'Dismissed',
                title: 'ยกเลิกคำร้อง (Dismissed)',
                subtitle: 'ข้อร้องเรียนไม่พบความผิด หรือไม่ตรงเงื่อนไข',
                icon: Icons.cancel_outlined,
                color: const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusOptionTile(
    BuildContext ctx, {
    required String statusKey,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isCurrent = report.status.toLowerCase() == statusKey.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? color.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Material(
        color: isCurrent ? color.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 13.5,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
            color: isCurrent ? color : AdminColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: AdminColors.textSecondary,
          ),
        ),
        trailing: isCurrent
            ? Icon(Icons.check_circle_rounded, color: color, size: 20)
            : null,
        onTap: () {
          Navigator.pop(ctx);
          if (!isCurrent) {
            controller.updateReportStatus(report.reportId, statusKey);
          }
        },
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final isPending = report.status.toLowerCase() == 'pending';
    final hasDescription = report.description != null && report.description!.isNotEmpty;
    final isContent = report.contentId != null && report.contentId!.isNotEmpty;
    final isReview = report.reviewId != null && report.reviewId!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPending ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPending
                ? AdminColors.error.withValues(alpha: 0.05)
                : AdminColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isContent
                            ? const Color(0xFFEFF6FF)
                            : (isReview ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isContent
                              ? const Color(0xFFBFDBFE)
                              : (isReview ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isContent
                                ? Icons.article_outlined
                                : (isReview ? Icons.rate_review_outlined : Icons.flag_outlined),
                            size: 13,
                            color: isContent
                                ? AdminColors.primary
                                : (isReview ? const Color(0xFFD97706) : AdminColors.textSecondary),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              isContent ? 'บทความ/เนื้อหา' : (isReview ? 'รีวิวสินค้า' : 'รายงานทั่วไป'),
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isContent
                                    ? AdminColors.primary
                                    : (isReview ? const Color(0xFFB45309) : AdminColors.textSecondary),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AdminReportStatusBadge(status: report.status),
                ],
              ),
              const SizedBox(height: 10),

              // Target Label
              Text(
                report.targetLabel,
                style: GoogleFonts.krub(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Reason Alert Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AdminColors.errorBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECACA), width: 0.8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: AdminColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'สาเหตุ: ${report.reason}',
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Description Box
              if (hasDescription) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.format_quote_rounded,
                            size: 14,
                            color: AdminColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'รายละเอียดจากผู้ร้องเรียน:',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.description!,
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          color: AdminColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),

              // Meta & Actions Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Date & Report ID in a responsive Wrap
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Date
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_outlined,
                              size: 13,
                              color: AdminColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(report.createdAt),
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                color: AdminColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Report ID copy pill
                        InkWell(
                          onTap: () => _copyToClipboard(context, report.reportId, 'รหัสรายงาน'),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '#${report.reportId.length > 8 ? report.reportId.substring(0, 8) : report.reportId}',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 10,
                                    color: AdminColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.copy_rounded, size: 10, color: AdminColors.textMuted),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Change Status Action Button
                  InkWell(
                    onTap: () => _showChangeStatusSheet(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
                      decoration: BoxDecoration(
                        gradient: AdminColors.cardAccentGradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AdminColors.primary.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.published_with_changes_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'เปลี่ยนสถานะ',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
      ),
    );
  }
}
