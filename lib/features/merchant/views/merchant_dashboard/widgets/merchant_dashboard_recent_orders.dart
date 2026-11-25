import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/dashboard_format.dart';

class MerchantDashboardRecentOrders extends StatelessWidget {
  const MerchantDashboardRecentOrders({super.key, this.report});

  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final recentOrders = (report?.recentOrders ?? []).where((o) {
      final orderStat = o.orderStatus.trim().toLowerCase();
      final payStat = o.paymentStatus.trim().toLowerCase();
      return orderStat != 'expired' && payStat != 'expired';
    }).toList();

    return Column(
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
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'คำสั่งซื้อล่าสุด',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.myShopOrders),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                'ดูทั้งหมด >',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (recentOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 36,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ยังไม่มีรายการสั่งซื้อเข้ามาในระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'เมื่อมีลูกค้าสั่งซื้อสินค้า รายการจะปรากฏตรงนี้',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length > 5 ? 5 : recentOrders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = recentOrders[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ออเดอร์ #${item.orderNumber}',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ผู้ซื้อ: ${item.receiverName ?? 'ลูกค้าทั่วไป'}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(item.totalAmount),
                          style: GoogleFonts.krub(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildOrderStatusBadge(
                          item.orderStatus,
                          item.paymentStatus,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildOrderStatusBadge(String orderStatus, String paymentStatus) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);
    String label = orderStatus;

    final payStat = paymentStatus.trim().toLowerCase();
    final orderStat = orderStatus.trim().toLowerCase();

    if (payStat == 'pendingverification') {
      bg = const Color(0xFFFFFBEB);
      fg = const Color(0xFFD97706);
      label = 'รอระบบยืนยันยอด';
    } else if (orderStat == 'completed') {
      bg = const Color(0xFFECFDF5);
      fg = const Color(0xFF059669);
      label = 'สำเร็จ';
    } else if (orderStat == 'shipped') {
      bg = const Color(0xFFEEF2FF);
      fg = const Color(0xFF4F46E5);
      label = 'จัดส่งแล้ว';
    } else if (payStat == 'paid') {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF2563EB);
      label = 'ชำระแล้ว';
    } else if (orderStat == 'cancelled') {
      bg = const Color(0xFFFFF1F2);
      fg = const Color(0xFFE11D48);
      label = 'ยกเลิก';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.krub(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
