import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardOrderStatusBreakdown extends StatelessWidget {
  const AdminDashboardOrderStatusBreakdown({super.key, required this.counts});

  final AdminOrderStatusCounts counts;

  @override
  Widget build(BuildContext context) {
    final total = counts.pendingPayment +
        counts.pendingVerification +
        counts.processing +
        counts.shipped +
        counts.completed +
        counts.cancelled;

    final stages = [
      _StageItem(
        label: 'รอชำระเงิน',
        count: counts.pendingPayment,
        color: const Color(0xFFD97724),
        bgTint: const Color(0xFFFDF6EE),
        icon: Icons.hourglass_top_rounded,
      ),
      _StageItem(
        label: 'รอยืนยันสลิป',
        count: counts.pendingVerification,
        color: const Color(0xFFE76F51),
        bgTint: const Color(0xFFFDF2EE),
        icon: Icons.fact_check_rounded,
      ),
      _StageItem(
        label: 'เตรียมจัดส่ง',
        count: counts.processing,
        color: const Color(0xFF2A9D8F),
        bgTint: const Color(0xFFF1F8F6),
        icon: Icons.inventory_2_rounded,
      ),
      _StageItem(
        label: 'กำลังจัดส่ง',
        count: counts.shipped,
        color: const Color(0xFF2B7DE9),
        bgTint: const Color(0xFFF0F6FD),
        icon: Icons.local_shipping_rounded,
      ),
      _StageItem(
        label: 'จัดส่งสำเร็จ',
        count: counts.completed,
        color: AdminColors.success,
        bgTint: AdminColors.successBg,
        icon: Icons.check_circle_rounded,
      ),
      _StageItem(
        label: 'ยกเลิก',
        count: counts.cancelled,
        color: const Color(0xFF8A9993),
        bgTint: const Color(0xFFF5F7F6),
        icon: Icons.cancel_rounded,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE0EAE6),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080D2B22),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
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
                      Icons.schema_rounded,
                      size: 16,
                      color: AdminColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'สถานะคำสั่งซื้อในระบบ (Pipeline)',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AdminColors.infoBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Text(
                  'รวม $total ออเดอร์',
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Visual Progress Bar
          if (total > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: stages.map((stage) {
                    final weight = stage.count / total;
                    if (weight == 0) return const SizedBox.shrink();
                    return Expanded(
                      flex: (weight * 1000).toInt(),
                      child: Container(color: stage.color),
                    );
                  }).toList(),
                ),
              ),
            ),

          const SizedBox(height: 14),

          // 2-row / 3-column Grid of statuses with safe fixed extent
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 68,
            ),
            itemCount: stages.length,
            itemBuilder: (context, index) {
              final stage = stages[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: stage.bgTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: stage.color.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(stage.icon, size: 14, color: stage.color),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${stage.count}',
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: stage.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        stage.label,
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AdminColors.textPrimary,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StageItem {
  final String label;
  final int count;
  final Color color;
  final Color bgTint;
  final IconData icon;

  _StageItem({
    required this.label,
    required this.count,
    required this.color,
    required this.bgTint,
    required this.icon,
  });
}
