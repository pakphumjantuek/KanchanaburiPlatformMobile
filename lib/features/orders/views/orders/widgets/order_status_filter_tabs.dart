import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/order_controller.dart';

class OrderStatusFilterTabs extends StatelessWidget {
  const OrderStatusFilterTabs({super.key, required this.controller});

  final OrderController controller;

  static const _tabs = [
    (id: 0, label: 'ทั้งหมด', icon: Icons.all_inbox_rounded),
    (id: 1, label: 'ที่ต้องชำระ', icon: Icons.account_balance_wallet_outlined),
    (id: 2, label: 'ที่ต้องจัดส่ง', icon: Icons.inventory_2_outlined),
    (id: 3, label: 'ที่ต้องได้รับ', icon: Icons.local_shipping_outlined),
    (id: 4, label: 'สำเร็จแล้ว', icon: Icons.check_circle_outline_rounded),
    (id: 5, label: 'ยกเลิกแล้ว', icon: Icons.cancel_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF9F2),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8D9C9), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final selectedTab = controller.activeTab.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: _tabs.map((tab) {
              final selected = selectedTab == tab.id;
              final count = controller.getCountByTab(tab.id);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => controller.setActiveTab(tab.id),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFD96C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFFE8D9C9),
                        width: 1.2,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFD96C2C,
                                ).withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 16,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF786B62),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tab.label,
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF332820),
                          ),
                        ),
                        if (count > 0 && tab.id != 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : const Color(
                                      0xFFD96C2C,
                                    ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFFD96C2C),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
