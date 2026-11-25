import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageOrdersFilterTabs extends StatelessWidget {
  const ManageOrdersFilterTabs({super.key, required this.controller});

  final ManageOrdersController controller;

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
      height: 52,
      child: Obx(() {
        final currentStatus = controller.selectedStatus.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          itemCount: controller.statusTabs.length,
          itemBuilder: (context, index) {
            final tab = controller.statusTabs[index];
            final value = tab['value']!;
            final label = tab['label']!;
            final isSelected = currentStatus.toLowerCase() == value.toLowerCase();
            final count = controller.getCountForStatus(value);

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.changeStatusTab(value),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MerchantColors.primary
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? MerchantColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.krub(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : MerchantColors.textPrimary,
                            fontSize: 12.5,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: GoogleFonts.krub(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? MerchantColors.primary
                                    : MerchantColors.textSecondary,
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
          },
        );
      }),
    );
  }
}
