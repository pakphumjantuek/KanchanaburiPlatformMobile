import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';

class MerchantDashboardOrderCounters extends StatelessWidget {
  const MerchantDashboardOrderCounters({super.key, this.report});

  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final pendingSlip = report?.pendingSlipOrdersCount ?? 0;
    final pendingShipment = report?.pendingShipmentOrdersCount ?? 0;
    final completed = report?.completedOrdersCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF047857),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'การประมวลผลคำสั่งซื้อ',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.myShopOrders),
                child: Text(
                  'ดูทั้งหมด >',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildCounterItem(
                  label: 'รอระบบยืนยันยอด',
                  count: pendingSlip,
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFD97706),
                  bg: const Color(0xFFFFFBEB),
                  borderColor: const Color(0xFFFDE68A),
                  status: 'PendingVerification',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounterItem(
                  label: 'รอจัดส่ง',
                  count: pendingShipment,
                  icon: Icons.local_shipping_rounded,
                  color: const Color(0xFF2563EB),
                  bg: const Color(0xFFEFF6FF),
                  borderColor: const Color(0xFFBFDBFE),
                  status: 'ToShip',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounterItem(
                  label: 'สำเร็จแล้ว',
                  count: completed,
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF059669),
                  bg: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                  status: 'Completed',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color borderColor,
    String? status,
  }) {
    return InkWell(
      onTap: () => Get.toNamed(
        AppRoutes.myShopOrders,
        parameters: status != null ? {'status': status} : null,
        arguments: status != null ? {'status': status} : null,
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: GoogleFonts.krub(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
