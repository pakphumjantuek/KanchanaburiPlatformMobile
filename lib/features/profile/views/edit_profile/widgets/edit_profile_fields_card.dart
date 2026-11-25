import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/profile_controller.dart';

class EditProfileFieldsCard extends StatelessWidget {
  const EditProfileFieldsCard({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: Color(0xFFD96C2C),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'ข้อมูลส่วนตัว',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE8D9C9)),
          _ProfileInputField(
            label: 'ชื่อจริง *',
            hint: 'กรอกชื่อจริง',
            controller: controller.firstNameController,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          _ProfileInputField(
            label: 'นามสกุล',
            hint: 'กรอกนามสกุล',
            controller: controller.lastNameController,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          _ProfileInputField(
            label: 'อีเมล (ไม่สามารถแก้ไขได้)',
            controller: controller.emailController,
            icon: Icons.email_outlined,
            suffixIcon: Icons.lock_outline_rounded,
            readOnly: true,
            isEmail: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileInputField extends StatelessWidget {
  const _ProfileInputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.suffixIcon,
    this.readOnly = false,
    this.isEmail = false,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData icon;
  final IconData? suffixIcon;
  final bool readOnly;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    final textColor = isEmail ? Colors.grey[600] : const Color(0xFF332820);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isEmail ? Colors.grey[700] : const Color(0xFF332820),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          style: GoogleFonts.krub(fontSize: 14.5, color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: isEmail ? Colors.grey : const Color(0xFFD96C2C),
            ),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, color: Colors.grey, size: 18),
            filled: true,
            fillColor: isEmail ? const Color(0xFFF4F6F5) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: readOnly
                ? border
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFD96C2C),
                      width: 1.8,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
