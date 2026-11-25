import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';

class ManageTagsFilterBar extends StatefulWidget {
  const ManageTagsFilterBar({super.key, required this.controller});

  final AdminTagsController controller;

  @override
  State<ManageTagsFilterBar> createState() => _ManageTagsFilterBarState();
}

class _ManageTagsFilterBarState extends State<ManageTagsFilterBar> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.controller.searchQuery.value);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Search Input Field & View Mode Toggle
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.search_rounded,
                        color: AdminColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: GoogleFonts.krub(
                            fontSize: 13.5,
                            color: AdminColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'ค้นหาชื่อแท็ก หรือรหัสแท็ก...',
                            hintStyle: GoogleFonts.krub(
                              fontSize: 13,
                              color: AdminColors.textMuted,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (val) => widget.controller.setSearchQuery(val),
                        ),
                      ),
                      Obx(() {
                        if (widget.controller.searchQuery.value.isNotEmpty) {
                          return IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: AdminColors.textSecondary,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              widget.controller.clearSearch();
                            },
                          );
                        }
                        return const SizedBox(width: 8);
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View mode switch button
              Obx(() {
                final isCards = widget.controller.viewMode.value == 'cards';
                return Tooltip(
                  message: isCards ? 'สลับเป็นมุมมองกลุ่มคำ' : 'สลับเป็นมุมมองการ์ด',
                  child: Material(
                    color: isCards
                        ? AdminColors.primary.withValues(alpha: 0.08)
                        : AdminColors.primaryLight.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => widget.controller.toggleViewMode(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AdminColors.primaryLight.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCards
                                  ? Icons.view_agenda_rounded
                                  : Icons.bubble_chart_rounded,
                              size: 18,
                              color: AdminColors.primaryLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCards ? 'การ์ด' : 'กลุ่มคำ',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.primaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 8),

          // 2. Status Filter Chips and Item Count
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() {
                    final current = widget.controller.selectedStatusFilter.value;
                    return Row(
                      children: [
                        _buildFilterChip(
                          label: 'ทั้งหมด',
                          isSelected: current.isEmpty,
                          onTap: () => widget.controller.setStatusFilter(''),
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'เปิดใช้งาน',
                          dotColor: const Color(0xFF10B981),
                          isSelected: current == 'Active',
                          onTap: () => widget.controller.setStatusFilter('Active'),
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'ปิดใช้งาน',
                          dotColor: const Color(0xFF94A3B8),
                          isSelected: current == 'Inactive',
                          onTap: () => widget.controller.setStatusFilter('Inactive'),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              // Results Count
              Obx(() {
                final count = widget.controller.filteredTags.length;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count รายการ',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    Color? dotColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
          decoration: BoxDecoration(
            color: isSelected
                ? AdminColors.primaryDark
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AdminColors.primaryDark
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: GoogleFonts.krub(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AdminColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
