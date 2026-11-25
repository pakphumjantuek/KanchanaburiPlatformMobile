import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ContentFormSectionCard extends StatelessWidget {
  const ContentFormSectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    required this.children,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MerchantColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MerchantColors.successBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Icon(icon, color: MerchantColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: MerchantColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          ...children,
        ],
      ),
    );
  }
}

