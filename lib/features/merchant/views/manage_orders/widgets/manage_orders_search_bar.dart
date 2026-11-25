import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageOrdersSearchBar extends StatefulWidget {
  const ManageOrdersSearchBar({super.key, required this.controller});

  final ManageOrdersController controller;

  @override
  State<ManageOrdersSearchBar> createState() => _ManageOrdersSearchBarState();
}

class _ManageOrdersSearchBarState extends State<ManageOrdersSearchBar> {
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.controller.searchQuery.value);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
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
                    color: MerchantColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: MerchantColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาเลขที่ออเดอร์, ชื่อผู้รับ, เบอร์โทร, เลขพัสดุ...',
                        hintStyle: GoogleFonts.krub(
                          fontSize: 12.5,
                          color: MerchantColors.textMuted,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      onChanged: (val) => widget.controller.setSearchQuery(val),
                    ),
                  ),
                  Obx(() {
                    if (widget.controller.searchQuery.value.isNotEmpty) {
                      return IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: MerchantColors.textSecondary,
                        ),
                        onPressed: () {
                          _textCtrl.clear();
                          widget.controller.clearSearch();
                        },
                      );
                    }
                    return const SizedBox(width: 6);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() {
            final count = widget.controller.filteredOrders.length;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: MerchantColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count รายการ',
                style: GoogleFonts.krub(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: MerchantColors.primary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
