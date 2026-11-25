import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageContentsSearchField extends StatefulWidget {
  const ManageContentsSearchField({super.key, required this.controller});

  final ManageContentsController controller;

  @override
  State<ManageContentsSearchField> createState() =>
      _ManageContentsSearchFieldState();
}

class _ManageContentsSearchFieldState extends State<ManageContentsSearchField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MerchantColors.border),
              boxShadow: [
                BoxShadow(
                  color: MerchantColors.primaryDark.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _textController,
              onChanged: (value) => widget.controller.searchQuery.value = value,
              style: GoogleFonts.krub(
                fontSize: 14,
                color: MerchantColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อเรื่องราว ข่าวสาร หรือหมวดหมู่...',
                hintStyle: GoogleFonts.krub(
                  color: MerchantColors.textMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: MerchantColors.primary,
                  size: 22,
                ),
                suffixIcon: Obx(
                  () => widget.controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          tooltip: 'ล้างคำค้นหา',
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: MerchantColors.textSecondary,
                          ),
                          onPressed: () {
                            _textController.clear();
                            widget.controller.searchQuery.value = '';
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: MerchantColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Quick Filter Chips + Results Count Row
          Obx(() {
            final activeFilter = widget.controller.selectedFilter.value;
            final filteredCount = widget.controller.filteredContents.length;

            return Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'ทั้งหมด',
                          count: widget.controller.totalCount,
                          filterKey: 'all',
                          isSelected: activeFilter == 'all',
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'เผยแพร่แล้ว',
                          count: widget.controller.publishedCount,
                          filterKey: 'published',
                          isSelected: activeFilter == 'published',
                          badgeColor: MerchantColors.success,
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'ฉบับร่าง',
                          count: widget.controller.draftCount,
                          filterKey: 'draft',
                          isSelected: activeFilter == 'draft',
                          badgeColor: const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'มีวิดีโอ',
                          count: widget.controller.videoCount,
                          filterKey: 'video',
                          isSelected: activeFilter == 'video',
                          badgeColor: const Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MerchantColors.successBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    'พบ $filteredCount รายการ',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: MerchantColors.primaryDark,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required String filterKey,
    required bool isSelected,
    Color? badgeColor,
  }) {
    return InkWell(
      onTap: () => widget.controller.setFilter(filterKey),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? MerchantColors.primary
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MerchantColors.primary : MerchantColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : MerchantColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : (badgeColor?.withValues(alpha: 0.15) ?? const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.krub(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (badgeColor ?? MerchantColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
