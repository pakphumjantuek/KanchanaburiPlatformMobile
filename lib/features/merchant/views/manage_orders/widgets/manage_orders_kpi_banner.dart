import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageOrdersKpiBanner extends StatelessWidget {
  const ManageOrdersKpiBanner({super.key, required this.controller});

  final ManageOrdersController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(
        gradient: MerchantColors.headerGradient,
      ),
      child: Obx(() {
        final toShip = controller.pendingShipmentCount;
        final pendingSlip = controller.pendingSlipCount;
        final shipped = controller.shippedCount;
        final total = controller.totalCount;
        final selected = controller.selectedStatus.value.toLowerCase();

        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'รอจัดส่ง',
                value: '$toShip',
                subText: toShip > 0 ? 'รอแพ็คสินค้า' : 'เรียบร้อย',
                icon: Icons.local_shipping_rounded,
                iconColor: const Color(0xFFFBBF24),
                isSelected: selected == 'toship',
                onTap: () => controller.changeStatusTab('ToShip'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'รอระบบยืนยัน',
                value: '$pendingSlip',
                subText: pendingSlip > 0 ? 'Admin ตรวจสอบ' : 'ไม่มีค้าง',
                icon: Icons.hourglass_top_rounded,
                iconColor: const Color(0xFF38BDF8),
                isSelected: selected == 'pendingverification',
                onTap: () => controller.changeStatusTab('PendingVerification'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'จัดส่งแล้ว',
                value: '$shipped',
                subText: 'พัสดุออกแล้ว',
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF34D399),
                isSelected: selected == 'shipped',
                onTap: () => controller.changeStatusTab('Shipped'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'ทั้งหมด',
                value: '$total',
                subText: 'ไม่รวมหมดอายุ',
                icon: Icons.inventory_2_rounded,
                iconColor: Colors.white,
                isSelected: selected == 'all' || selected.isEmpty,
                onTap: () => controller.changeStatusTab('All'),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF34D399).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.14),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF34D399).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(icon, size: 13, color: iconColor),
                ],
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subText,
                style: GoogleFonts.krub(
                  fontSize: 9,
                  color: isSelected
                      ? const Color(0xFFD1FAE5)
                      : Colors.white.withValues(alpha: 0.65),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
