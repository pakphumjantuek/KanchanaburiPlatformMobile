import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminReportStatusBadge extends StatelessWidget {
  const AdminReportStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'resolved':
        bg = AdminColors.successBg;
        fg = AdminColors.success;
        label = 'แก้ไขแล้ว';
        icon = Icons.check_circle_rounded;
        break;
      case 'inprogress':
        bg = AdminColors.infoBg;
        fg = AdminColors.info;
        label = 'กำลังตรวจสอบ';
        icon = Icons.sync_rounded;
        break;
      case 'dismissed':
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
        label = 'ยกเลิกคำร้อง';
        icon = Icons.cancel_outlined;
        break;
      case 'pending':
      default:
        bg = AdminColors.errorBg;
        fg = AdminColors.error;
        label = 'รอดำเนินการ';
        icon = Icons.hourglass_top_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
