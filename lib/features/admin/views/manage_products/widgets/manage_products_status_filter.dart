import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/controllers/admin_products_controller.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class ManageProductsStatusFilter extends StatefulWidget {
  const ManageProductsStatusFilter({super.key, required this.controller});

  final AdminProductsController controller;

  @override
  State<ManageProductsStatusFilter> createState() =>
      _ManageProductsStatusFilterState();
}

class _ManageProductsStatusFilterState
    extends State<ManageProductsStatusFilter> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.controller.searchQuery.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search_rounded,
                  color: AdminColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      widget.controller.onSearchChanged(value);
                      setState(() {});
                    },
                    style: GoogleFonts.krub(
                      fontSize: 13.5,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาชื่อสินค้าในร้านนี้...',
                      hintStyle: GoogleFonts.krub(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Color(0xFF94A3B8),
                      size: 18,
                    ),
                    splashRadius: 18,
                    onPressed: () {
                      _searchController.clear();
                      widget.controller.clearSearch();
                      setState(() {});
                    },
                  ),
                const SizedBox(width: 4),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Horizontal Status Filter Chips with Counts
          Obx(() {
            final currentStatus = widget.controller.selectedStatus.value;
            final total = widget.controller.totalProductsCount.value;
            final active = widget.controller.activeCount.value;
            final inactive = widget.controller.inactiveCount.value;
            final lowStock = widget.controller.lowStockCount.value;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildTabChip(
                    statusKey: '',
                    label: 'ทั้งหมด',
                    count: total > 0 ? total : null,
                    isSelected: currentStatus == '',
                    accentColor: AdminColors.primary,
                  ),
                  _buildTabChip(
                    statusKey: 'Active',
                    label: 'วางขายอยู่',
                    count: active > 0 ? active : null,
                    isSelected: currentStatus == 'Active',
                    accentColor: const Color(0xFF059669),
                  ),
                  _buildTabChip(
                    statusKey: 'Inactive',
                    label: 'ระงับการขาย',
                    count: inactive > 0 ? inactive : null,
                    isSelected: currentStatus == 'Inactive',
                    accentColor: const Color(0xFFDC2626),
                  ),
                  _buildTabChip(
                    statusKey: 'LowStock',
                    label: 'สต็อกใกล้หมด',
                    count: lowStock > 0 ? lowStock : null,
                    isSelected: currentStatus == 'LowStock',
                    accentColor: const Color(0xFFD97706),
                    highlightCount: lowStock > 0,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabChip({
    required String statusKey,
    required String label,
    int? count,
    required bool isSelected,
    required Color accentColor,
    bool highlightCount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            widget.controller.selectStatus(statusKey);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? accentColor : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? accentColor : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : highlightCount
                              ? const Color(0xFFFEF3C7)
                              : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : highlightCount
                                ? const Color(0xFFB45309)
                                : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

