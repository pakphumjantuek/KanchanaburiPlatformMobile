import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardRecentOrders extends StatelessWidget {
  const AdminDashboardRecentOrders({super.key, required this.recentOrders});

  final List<AdminRecentOrder> recentOrders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AdminColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 16,
                    color: AdminColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'คำสั่งซื้อล่าสุด',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.adminOrders),
              icon: const Icon(Icons.arrow_forward_rounded, size: 14),
              label: Text(
                'ดูทั้งหมด',
                style: GoogleFonts.krub(
                  color: AdminColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AdminColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (recentOrders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0EAE6)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 40,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Text(
                  'ยังไม่มีคำสั่งซื้อล่าสุดในระบบ',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x060D2B22),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentOrders.length > 5 ? 5 : recentOrders.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFEFF5F2),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                final isPaid = order.paymentStatus.toLowerCase().contains('paid') ||
                    order.paymentStatus.contains('ชำระ');

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.adminOrders),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Leading Icon Container
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? AdminColors.success.withValues(alpha: 0.12)
                                  : const Color(0xFFE76F51).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isPaid ? Icons.check_circle_outline_rounded : Icons.pending_actions_rounded,
                              size: 20,
                              color: isPaid ? AdminColors.success : const Color(0xFFE76F51),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Order Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '#${order.orderNumber}',
                                      style: GoogleFonts.krub(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                        color: AdminColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '• ${order.shopName}',
                                        style: GoogleFonts.krub(
                                          fontSize: 12,
                                          color: AdminColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      '฿${order.totalAmount.toStringAsFixed(2)}',
                                      style: GoogleFonts.krub(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AdminColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'สถานะ: ${order.orderStatus}',
                                        style: GoogleFonts.krub(
                                          fontSize: 11,
                                          color: const Color(0xFF7A978E),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Payment Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? const Color(0xFFE5F7EE)
                                  : const Color(0xFFFDEEE9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isPaid
                                    ? const Color(0xFFB3E6D0)
                                    : const Color(0xFFF5C4B5),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                order.paymentStatus,
                                style: GoogleFonts.krub(
                                  fontSize: 10.5,
                                  color: isPaid ? const Color(0xFF1B9966) : const Color(0xFFBF4F35),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
