import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onSubmitted;
  final Color fillColor;
  final Color iconColor;

  const AppSearchField({
    super.key,
    this.hintText = 'ค้นหา...',
    this.onChanged,
    this.controller,
    this.onSubmitted,
    this.fillColor = Colors.white,
    this.iconColor = const Color(0xFFD96C2C),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      style: const TextStyle(color: Color(0xFF332820), fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
        prefixIcon: Icon(Icons.search, color: iconColor, size: 22),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
