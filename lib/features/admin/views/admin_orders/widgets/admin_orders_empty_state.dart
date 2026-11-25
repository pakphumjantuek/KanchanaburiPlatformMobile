import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminOrdersEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const AdminOrdersEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AdminColors.primaryDark.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Badge
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                ),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFF059669),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'ไม่มีสลิปที่รอการอนุมัติในขณะนี้',
                style: GoogleFonts.krub(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'รายการสลิปโอนเงินทั้งหมดได้รับการตรวจสอบและอนุมัติเรียบร้อยแล้ว',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              if (onRefresh != null) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminColors.primary,
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    'รีเฟรชตรวจสอบอีกครั้ง',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: onRefresh,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
