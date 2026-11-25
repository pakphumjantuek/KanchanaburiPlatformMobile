import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminShopStatusBadge extends StatelessWidget {
  const AdminShopStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  final String status;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final (bg, border, text, dot, icon, label) = _resolveStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isCompact ? 6 : 7,
            height: isCompact ? 6 : 7,
            decoration: BoxDecoration(
              color: dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Icon(icon, size: isCompact ? 11 : 13, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color, Color, IconData, String) _resolveStatus(String raw) {
    switch (raw.toLowerCase()) {
      case 'active':
      case 'approved':
        return (
          const Color(0xFFECFDF5),
          const Color(0xFFA7F3D0),
          const Color(0xFF065F46),
          const Color(0xFF10B981),
          Icons.check_circle_rounded,
          'เปิดใช้งาน',
        );
      case 'pending':
      case 'pendingapproval':
        return (
          const Color(0xFFFFFBEB),
          const Color(0xFFFDE68A),
          const Color(0xFF92400E),
          const Color(0xFFF59E0B),
          Icons.hourglass_top_rounded,
          'รอการอนุมัติ',
        );
      case 'suspended':
        return (
          const Color(0xFFFEF2F2),
          const Color(0xFFFECACA),
          const Color(0xFF991B1B),
          const Color(0xFFEF4444),
          Icons.block_rounded,
          'ระงับการใช้งาน',
        );
      case 'closed':
        return (
          const Color(0xFFF1F5F9),
          const Color(0xFFCBD5E1),
          const Color(0xFF475569),
          const Color(0xFF64748B),
          Icons.lock_clock_rounded,
          'ปิดบริการ',
        );
      default:
        return (
          const Color(0xFFF8FAFC),
          const Color(0xFFE2E8F0),
          const Color(0xFF334155),
          const Color(0xFF94A3B8),
          Icons.info_outline_rounded,
          raw,
        );
    }
  }
}

