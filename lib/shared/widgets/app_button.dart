import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final Color textColor;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor = Colors.white,
    this.icon,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? const Color(0xFFD96C2C);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        disabledBackgroundColor: buttonColor.withValues(alpha: 0.6),
        foregroundColor: textColor,
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
    );
  }
}
