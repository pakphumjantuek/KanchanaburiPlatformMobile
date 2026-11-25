import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class MerchantExportSectionCard extends StatelessWidget {
  const MerchantExportSectionCard({
    super.key,
    required this.stepNumber,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.children,
    this.trailing,
  });

  final String stepNumber;
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MerchantColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: MerchantColors.cardAccentGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: MerchantColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: MerchantColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
