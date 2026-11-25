import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/my_contents_controller.dart';

class MyContentsFilterChips extends StatelessWidget {
  const MyContentsFilterChips({super.key, required this.controller});

  final MyContentsController controller;

  static const _filters = [
    (key: 'all', label: 'ทั้งหมด'),
    (key: 'published', label: 'เผยแพร่แล้ว'),
    (key: 'pending', label: 'รอตรวจสอบ'),
    (key: 'archived', label: 'เก็บถาวร'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final selected = controller.selectedFilter.value == filter.key;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  filter.label,
                  style: GoogleFonts.krub(
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                    color: selected ? Colors.white : const Color(0xFF786B62),
                  ),
                ),
                selected: selected,
                selectedColor: const Color(0xFFD96C2C),
                backgroundColor: const Color(0xFFFFF9F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFFD96C2C)
                        : const Color(0xFFE8D9C9),
                  ),
                ),
                onSelected: (_) => controller.setFilter(filter.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
