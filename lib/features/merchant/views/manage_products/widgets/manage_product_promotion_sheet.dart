import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageProductPromotionSheet {
  const ManageProductPromotionSheet._();

  static Future<void> show(BuildContext context, ProductModel product) async {
    final repository = MerchantRepository();
    var deals = await repository.fetchProductDeals(product.id);
    if (!context.mounted) return;
    final discountController = TextEditingController();
    final quantityController = TextEditingController(
      text: product.quantity.toString(),
    );
    var dealType = 'FlashDeal';
    var discountType = 'Percent';
    var startsAt = DateTime.now().toUtc();
    var endsAt = startsAt.add(const Duration(days: 1));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) {
          final activeDeals = deals
              .where(
                (deal) =>
                    deal.status.toLowerCase() == 'active' && !deal.isExpired,
              )
              .toList();
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MerchantColors.warningBg,
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
                        child: Text(
                          'โปรโมชัน: ${product.name}',
                          style: GoogleFonts.krub(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: MerchantColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (deals.isNotEmpty) ...[
                    Text(
                      'ดีลปัจจุบันของสินค้านี้',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...deals.map(
                      (deal) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: MerchantColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${deal.label} • ลด ${deal.discountValue}${deal.discountType == 'Percent' ? '%' : ' ฿'}',
                                    style: GoogleFonts.krub(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: MerchantColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${deal.status} • ใช้แล้ว ${deal.usedQuantity}/${deal.totalQuantity} • สิ้นสุด ${_thaiDate(deal.endsAt)}',
                                    style: GoogleFonts.krub(
                                      fontSize: 11,
                                      color: MerchantColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (deal.status.toLowerCase() == 'active')
                              TextButton(
                                onPressed: () async {
                                  final ok = await repository.stopProductDeal(
                                    deal.id ?? '',
                                  );
                                  if (ok) {
                                    deals = await repository.fetchProductDeals(
                                      product.id,
                                    );
                                    setState(() {});
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: MerchantColors.error,
                                ),
                                child: const Text('หยุดดีล'),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    'สร้างโปรโมชันใหม่',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: MerchantColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: dealType,
                    items: const [
                      DropdownMenuItem(
                        value: 'FlashDeal',
                        child: Text('โปรโมชันพิเศษ (Flash Deal)'),
                      ),
                      DropdownMenuItem(
                        value: 'LocalDeal',
                        child: Text('โปรเด็ดชุมชน (Local Deal)'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => dealType = value ?? dealType),
                    decoration: InputDecoration(
                      labelText: 'ประเภทโปรโมชัน',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: discountType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Percent',
                        child: Text('ลดเป็นเปอร์เซ็นต์ (%)'),
                      ),
                      DropdownMenuItem(
                        value: 'FixedAmount',
                        child: Text('ลดเป็นจำนวนเงิน (฿)'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => discountType = value ?? discountType),
                    decoration: InputDecoration(
                      labelText: 'รูปแบบส่วนลด',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: discountType == 'Percent'
                          ? 'ส่วนลด (%)'
                          : 'ส่วนลด (บาท)',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'จำนวนสิทธิ์ทั้งหมด',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'เริ่ม ${_thaiDate(startsAt)} - สิ้นสุด ${_thaiDate(endsAt)}',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: MerchantColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: activeDeals.isNotEmpty
                          ? null
                          : () async {
                              final discount =
                                  double.tryParse(discountController.text) ?? 0;
                              final totalQuantity =
                                  int.tryParse(quantityController.text) ?? 0;
                              if (discount <= 0 ||
                                  totalQuantity <= 0 ||
                                  endsAt.isBefore(startsAt) ||
                                  (discountType == 'Percent' &&
                                      discount >= 100) ||
                                  (discountType == 'FixedAmount' &&
                                      discount >= product.price)) {
                                Get.snackbar(
                                  'ข้อมูลโปรโมชันไม่ถูกต้อง',
                                  'กรุณาตรวจสอบส่วนลด จำนวนสิทธิ์ และช่วงเวลา',
                                  backgroundColor: MerchantColors.error,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              final ok = await repository
                                  .createProductDeal(product.id, {
                                    'dealType': dealType,
                                    'discountType': discountType,
                                    'discountValue': discount,
                                    'totalQuantity': totalQuantity,
                                    'startsAt': startsAt.toIso8601String(),
                                    'endsAt': endsAt.toIso8601String(),
                                  });
                              if (ok) {
                                Get.back();
                                Get.snackbar(
                                  'สร้างโปรโมชันสำเร็จ',
                                  'ระบบบันทึกโปรโมชันของสินค้าแล้ว',
                                  backgroundColor: MerchantColors.primary,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'สร้างโปรโมชันไม่สำเร็จ',
                                  'กรุณาตรวจสอบสต็อกและสิทธิ์ที่เหลือ',
                                  backgroundColor: MerchantColors.error,
                                  colorText: Colors.white,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MerchantColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'สร้างโปรโมชัน',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    discountController.dispose();
    quantityController.dispose();
  }

  static String _thaiDate(DateTime? value) {
    if (value == null) return '-';
    final thai = value.toUtc().add(const Duration(hours: 7));
    return '${thai.day}/${thai.month}/${thai.year + 543} ${thai.hour.toString().padLeft(2, '0')}:${thai.minute.toString().padLeft(2, '0')} น.';
  }
}
