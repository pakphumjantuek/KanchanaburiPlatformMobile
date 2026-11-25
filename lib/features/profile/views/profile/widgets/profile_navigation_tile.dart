import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileNavigationTile extends StatelessWidget {
  const ProfileNavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(
          icon,
          color: iconColor ?? const Color(0xFFD96C2C),
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF332820),
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: GoogleFonts.krub(
                  fontSize: 11.5,
                  color: const Color(0xFF786B62),
                ),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFFD96C2C)).withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText!,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? const Color(0xFFD96C2C),
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
