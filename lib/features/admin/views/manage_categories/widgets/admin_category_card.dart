import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminCategoryCard extends StatelessWidget {
  const AdminCategoryCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final String? description;
  final IconData icon;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (description != null && description!.isNotEmpty)
                  Text(
                    description!,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AdminColors.error),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
