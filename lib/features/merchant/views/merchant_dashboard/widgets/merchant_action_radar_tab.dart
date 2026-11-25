import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/models/merchant_dashboard_model.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class MerchantActionRadarTab extends StatelessWidget {
  const MerchantActionRadarTab({super.key, required this.report});

  final MerchantDashboardModel? report;

  @override
  Widget build(BuildContext context) {
    final pendingShipments = report?.pendingShipmentOrdersCount ?? 0;
    final lowStock = report?.lowStockProductsCount ?? 0;
    final activeDeals = report?.promotionAnalytics.activeDealsCount ?? 0;
    final totalUrgent = pendingShipments + lowStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Executive Radar Header Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: totalUrgent > 0 ? MerchantColors.warningBg : MerchantColors.successBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: totalUrgent > 0
                  ? MerchantColors.warning.withValues(alpha: 0.3)
                  : MerchantColors.success.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: totalUrgent > 0
                      ? MerchantColors.warning.withValues(alpha: 0.15)
                      : MerchantColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  totalUrgent > 0
                      ? Icons.radar_rounded
                      : Icons.task_alt_rounded,
                  color: totalUrgent > 0
                      ? MerchantColors.warning
                      : MerchantColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalUrgent > 0
                          ? 'มี $totalUrgent รายการที่ต้องการการดำเนินการของคุณ'
                          : 'ยอดเยี่ยม! คุณจัดการงานทั้งหมดเรียบร้อยแล้ว',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: totalUrgent > 0
                            ? const Color(0xFF92400E)
                            : const Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      totalUrgent > 0
                          ? 'ตรวจสอบสินค้าค้างจัดส่ง และสต็อกสินค้าในร้านค้า'
                          : 'ไม่มีสินค้าค้างส่ง หรือสต็อกสินค้าหมดในขณะนี้',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: totalUrgent > 0
                            ? const Color(0xFFB45309)
                            : const Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Action Radar Cards (Focusing strictly on Merchant's tasks)
        _buildActionItemCard(
          title: 'คำสั่งซื้อที่ต้องจัดส่ง (To Ship)',
          count: pendingShipments,
          unit: 'ออเดอร์',
          description: pendingShipments > 0
              ? 'ลูกค้าชำระเงินแล้ว รอแพ็คและส่งสินค้าไปยังผู้รับ'
              : 'ไม่มีออเดอร์ค้างส่ง จัดการพัสดุเรียบร้อย',
          icon: Icons.local_shipping_rounded,
          iconBgColor: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          isUrgent: pendingShipments > 0,
          buttonText: 'ไปหน้าแพ็คของและจัดส่ง',
          onAction: () => Get.toNamed(
            AppRoutes.myShopOrders,
            parameters: {'status': 'ToShip'},
            arguments: {'status': 'ToShip'},
          ),
        ),

        const SizedBox(height: 12),


        _buildActionItemCard(
          title: 'สินค้าใกล้หมดสต็อก (Low Stock)',
          count: lowStock,
          unit: 'รายการ',
          description: lowStock > 0
              ? 'สินค้าบางรายการมีจำนวนคงเหลือน้อยกว่าเกณฑ์ เสี่ยงสินค้าหมด'
              : 'สต็อกสินค้าทุกรายการอยู่ในระดับปลอดภัย',
          icon: Icons.inventory_2_rounded,
          iconBgColor: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFDC2626),
          isUrgent: lowStock > 0,
          buttonText: 'อัปเดตสต็อกสินค้า',
          onAction: () => Get.toNamed(
            AppRoutes.myShopProducts,
            parameters: {'filter': 'lowStock'},
            arguments: {'filter': 'lowStock'},
          ),
        ),

        const SizedBox(height: 12),

        _buildActionItemCard(
          title: 'โปรโมชั่น & Flash Deals ที่กำลังทำงาน',
          count: activeDeals,
          unit: 'แคมเปญ',
          description: activeDeals > 0
              ? 'มีโปรโมชั่นส่วนลดและดีลพิเศษกำลังดึงดูดลูกค้า'
              : 'ยังไม่มีโปรโมชั่นที่เปิดใช้งาน เลือกสินค้าเพื่อตั้งค่าดีลโปรโมชั่น',
          icon: Icons.flash_on_rounded,
          iconBgColor: const Color(0xFFF3E8FF),
          iconColor: const Color(0xFF9333EA),
          isUrgent: false,
          buttonText: 'ไปที่รายการสินค้าเพื่อตั้งโปรโมชั่น',
          onAction: () => Get.toNamed(AppRoutes.myShopProducts),
        ),
      ],
    );
  }

  Widget _buildActionItemCard({
    required String title,
    required int count,
    required String unit,
    required String description,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isUrgent,
    required String buttonText,
    required VoidCallback onAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUrgent
              ? iconColor.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
          width: isUrgent ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.krub(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: MerchantColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          description,
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            color: MerchantColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? iconColor.withValues(alpha: 0.12)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count $unit',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isUrgent ? iconColor : MerchantColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUrgent
                          ? MerchantColors.primary
                          : const Color(0xFFF1F5F9),
                      foregroundColor: isUrgent
                          ? Colors.white
                          : MerchantColors.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: isUrgent ? Colors.white : MerchantColors.primary,
                    ),
                    label: Text(
                      buttonText,
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
