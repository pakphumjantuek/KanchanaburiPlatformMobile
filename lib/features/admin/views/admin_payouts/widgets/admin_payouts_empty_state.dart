import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminPayoutsEmptyState extends StatelessWidget {
  const AdminPayoutsEmptyState({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.account_balance_wallet_outlined,
    this.onRefresh,
  });

  final String message;
  final String? subMessage;
  final IconData icon;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AdminColors.primary.withValues(alpha: 0.1),
                    AdminColors.secondary.withValues(alpha: 0.15),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AdminColors.primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 40,
                  color: AdminColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                subMessage!,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRefresh,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminColors.primary,
                  side: BorderSide(color: AdminColors.primary.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'โหลดข้อมูลใหม่',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
