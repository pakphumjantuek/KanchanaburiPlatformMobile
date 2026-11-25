import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_details_card.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_product_summary.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_preview_card.dart';

class ProductDealFormPage extends StatefulWidget {
  const ProductDealFormPage({super.key});

  @override
  State<ProductDealFormPage> createState() => _ProductDealFormPageState();
}

class _ProductDealFormPageState extends State<ProductDealFormPage> {
  final repository = MerchantRepository();
  final discount = TextEditingController();
  final quantity = TextEditingController();
  final starts = TextEditingController();
  final ends = TextEditingController();
  ProductModel? product;
  DateTime? startDate;
  DateTime? endDate;
  String dealType = 'FlashDeal';
  String discountType = 'Percent';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      quantity.text = args.quantity.toString();
      final now = DateTime.now().toUtc();
      startDate = now;
      endDate = now.add(const Duration(days: 1));
      starts.text = _displayDate(startDate!);
      ends.text = _displayDate(endDate!);
    }
    discount.addListener(() => setState(() {}));
    quantity.addListener(() => setState(() {}));
  }

  Future<void> save() async {
    final item = product;
    if (item == null) return;
    final value = double.tryParse(discount.text.trim()) ?? 0;
    final total = int.tryParse(quantity.text.trim()) ?? 0;
    final start = startDate?.toUtc();
    final end = endDate?.toUtc();

    if (value <= 0) {
      Get.snackbar(
        'ส่วนลดไม่ถูกต้อง',
        'กรุณาระบุส่วนลดที่มากกว่า 0',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (discountType == 'Percent' && value >= 100) {
      Get.snackbar(
        'ส่วนลดเกินกำหนด',
        'ส่วนลดเปอร์เซ็นต์ต้องน้อยกว่า 100%',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (discountType == 'FixedAmount' && value >= item.price) {
      Get.snackbar(
        'ส่วนลดเกินราคาขาย',
        'ส่วนลดต้องน้อยกว่าราคาปกติของสินค้า (฿${item.price.toStringAsFixed(2)})',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (total <= 0) {
      Get.snackbar(
        'จำนวนสิทธิ์ไม่ถูกต้อง',
        'กรุณาระบุจำนวนสิทธิ์โปรโมชันอย่างน้อย 1 สิทธิ์',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (start == null || end == null || !end.isAfter(start)) {
      Get.snackbar(
        'ช่วงเวลาไม่ถูกต้อง',
        'เวลาสิ้นสุดต้องอยู่หลังจากเวลาเริ่มต้นโปรโมชัน',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => saving = true);
    final ok = await repository.createProductDeal(item.id, {
      'dealType': dealType,
      'discountType': discountType,
      'discountValue': value,
      'totalQuantity': total,
      'startsAt': start.toIso8601String(),
      'endsAt': end.toIso8601String(),
    });

    if (!mounted) return;
    setState(() => saving = false);

    if (ok) {
      Get.back(result: true);
      Get.snackbar(
        'สร้างโปรโมชันสำเร็จ',
        'เปิดใช้งานดีลพิเศษสำหรับ "${item.name}" เรียบร้อยแล้ว',
        backgroundColor: MerchantColors.primary,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'สร้างโปรโมชันไม่สำเร็จ',
        'กรุณาตรวจสอบสต็อกสินค้าและสิทธิ์คงเหลือ',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = (isStart ? startDate : endDate) ?? DateTime.now().toUtc();
    final localCurrent = current.toLocal();
    final today = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: localCurrent,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 2, today.month, today.day),
      helpText: isStart
          ? 'เลือกวันที่เริ่มโปรโมชัน'
          : 'เลือกวันที่สิ้นสุดโปรโมชัน',
      cancelText: 'ยกเลิก',
      confirmText: 'เลือกวันที่',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: MerchantColors.primary,
            onPrimary: Colors.white,
            onSurface: Color(0xFF1E293B),
          ),
        ),
        child: child!,
      ),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(localCurrent),
      helpText: isStart ? 'เลือกเวลาเริ่มโปรโมชัน' : 'เลือกเวลาสิ้นสุดโปรโมชัน',
      cancelText: 'ยกเลิก',
      confirmText: 'ยืนยันเวลา',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: MerchantColors.primary,
            onPrimary: Colors.white,
            onSurface: Color(0xFF1E293B),
          ),
        ),
        child: child!,
      ),
    );

    if (time == null || !mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).toUtc();

    setState(() {
      if (isStart) {
        startDate = selected;
        starts.text = _displayDate(selected);
      } else {
        endDate = selected;
        ends.text = _displayDate(selected);
      }
    });
  }

  String _displayDate(DateTime value) {
    final thai = value.toUtc().add(const Duration(hours: 7));
    final day = thai.day.toString().padLeft(2, '0');
    final month = thai.month.toString().padLeft(2, '0');
    final hour = thai.hour.toString().padLeft(2, '0');
    final minute = thai.minute.toString().padLeft(2, '0');
    return '$day/$month/${thai.year + 543} เวลา $hour:$minute น.';
  }

  @override
  void dispose() {
    discount.dispose();
    quantity.dispose();
    starts.dispose();
    ends.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = product;

    return Scaffold(
      backgroundColor: MerchantColors.background,
      appBar: AppBar(
        backgroundColor: MerchantColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สร้างโปรโมชันใหม่',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Merchant Deal Creator',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
      ),
      body: item == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: MerchantColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ไม่พบข้อมูลสินค้าที่ต้องการสร้างโปรโมชัน',
                      style: GoogleFonts.krub(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MerchantColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('กลับไปยังคลังสินค้า'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Hero Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                    decoration: const BoxDecoration(
                      gradient: MerchantColors.heroGradient,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(26),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.local_offer_rounded,
                            color: Color(0xFFFDE68A),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ตั้งค่าดีลส่วนลดพิเศษ',
                                style: GoogleFonts.krub(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'กำหนดราคาพิเศษและช่วงเวลาเพื่อเริ่มแคมเปญโปรโมชัน',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: const Color(0xFFA7F3D0).withValues(alpha: 0.95),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Form Body
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Target Product Summary
                        ProductDealProductSummary(product: item),

                        const SizedBox(height: 14),

                        // Live Preview Card
                        ProductDealPreviewCard(
                          originalPrice: item.price,
                          discountValue: double.tryParse(discount.text.trim()) ?? 0,
                          discountType: discountType,
                          quantity: int.tryParse(quantity.text.trim()) ?? 0,
                        ),

                        const SizedBox(height: 14),

                        // Deal Details & Date Settings Card
                        ProductDealDetailsCard(
                          dealType: dealType,
                          onDealTypeChanged: (value) =>
                              setState(() => dealType = value),
                          discountType: discountType,
                          onDiscountTypeChanged: (value) =>
                              setState(() => discountType = value),
                          discountController: discount,
                          quantityController: quantity,
                          startsController: starts,
                          endsController: ends,
                          onStartTap: () => _pickDateTime(isStart: true),
                          onEndTap: () => _pickDateTime(isStart: false),
                          isSaving: saving,
                          onSave: save,
                          maxStock: item.quantity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
