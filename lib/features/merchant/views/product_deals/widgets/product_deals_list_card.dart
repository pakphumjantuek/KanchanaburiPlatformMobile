import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductDealsListCard extends StatelessWidget {
  const ProductDealsListCard({
    super.key,
    required this.deals,
    required this.onStopDeal,
  });

  final List<dynamic> deals;
  final ValueChanged<String> onStopDeal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MerchantColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายการโปรโมชันของสินค้านี้',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ดีลลดราคาพิเศษและโปรโมชันดึงดูดลูกค้า',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: MerchantColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${deals.length} ดีล',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: MerchantColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          if (deals.isEmpty)
            _buildEmptyDeals()
          else
            Column(
              children: deals.map((deal) => _buildDealItem(context, deal)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyDeals() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              size: 28,
              color: Color(0xFFD97706),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ยังไม่มีโปรโมชันสำหรับสินค้านี้',
            style: GoogleFonts.krub(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: MerchantColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'สร้างดีลลดราคาพิเศษเพื่อกระตุ้นยอดขายในร้านค้าของคุณ',
            style: GoogleFonts.krub(
              fontSize: 12,
              color: MerchantColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDealItem(BuildContext context, dynamic deal) {
    final active = deal.status.toString().toLowerCase() == 'active' && !deal.isExpired;
    final isPercent = deal.discountType.toString().toLowerCase() == 'percent';
    final discountStr = isPercent
        ? 'ลด ${deal.discountValue}%'
        : 'ลด ฿${deal.discountValue}';
    final used = deal.usedQuantity ?? 0;
    final total = deal.totalQuantity ?? 1;
    final progress = (used / (total > 0 ? total : 1)).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? const Color(0xFFFDE68A) : MerchantColors.border,
          width: active ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Deal Type & Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFD97706) : const Color(0xFF64748B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  deal.label ?? 'โปรโมชันพิเศษ',
                  style: GoogleFonts.krub(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                discountStr,
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: active ? const Color(0xFFB45309) : MerchantColors.textPrimary,
                ),
              ),
              const Spacer(),
              _buildStatusPill(deal.status.toString(), active),
            ],
          ),
          const SizedBox(height: 10),

          // Quota Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      active ? const Color(0xFFD97706) : MerchantColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ใช้แล้ว $used/$total สิทธิ์',
                style: GoogleFonts.krub(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MerchantColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date Span & Action Button Row
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: MerchantColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'สิ้นสุด ${_thaiDate(deal.endsAt)}',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    color: MerchantColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (active) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _confirmStopDeal(context, deal.id ?? ''),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: MerchantColors.errorBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stop_circle_outlined,
                          size: 13,
                          color: MerchantColors.error,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'หยุดดีล',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: MerchantColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmStopDeal(BuildContext context, String dealId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'ยืนยันการหยุดดีล',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'คุณต้องการยุติโปรโมชันนี้ก่อนกำหนดใช่หรือไม่? (ลูกค้าจะไม่สามารถใช้ส่วนลดนี้ได้อีก)',
          style: GoogleFonts.krub(fontSize: 13, color: MerchantColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: MerchantColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onStopDeal(dealId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MerchantColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'หยุดดีลทันที',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status, bool active) {
    Color bg = const Color(0xFFE2E8F0);
    Color fg = MerchantColors.textSecondary;
    String label = _statusLabel(status);

    if (active) {
      bg = const Color(0xFFECFDF5);
      fg = MerchantColors.success;
      label = 'กำลังใช้งาน';
    } else if (status.toLowerCase() == 'stopped') {
      bg = const Color(0xFFF1F5F9);
      fg = const Color(0xFF64748B);
      label = 'หยุดแล้ว';
    } else if (status.toLowerCase() == 'expired') {
      bg = MerchantColors.errorBg;
      fg = MerchantColors.error;
      label = 'หมดเวลา';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
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

  String _thaiDate(DateTime? value) {
    if (value == null) return '-';
    final thai = value.toUtc().add(const Duration(hours: 7));
    return '${thai.day}/${thai.month}/${thai.year + 543} ${thai.hour.toString().padLeft(2, '0')}:${thai.minute.toString().padLeft(2, '0')} น.';
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'กำลังใช้งาน';
      case 'stopped':
        return 'หยุดแล้ว';
      case 'expired':
        return 'หมดเวลาแล้ว';
      default:
        return status;
    }
  }
}
