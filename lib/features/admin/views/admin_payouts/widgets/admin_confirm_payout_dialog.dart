import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';

class AdminConfirmPayoutDialog {
  const AdminConfirmPayoutDialog._();

  static void show({
    required BuildContext context,
    required AdminPayoutsController controller,
    required AdminMerchantPayoutGroup payout,
  }) {
    final shopId = payout.shopId;
    final shopName = payout.shopName;
    final orderIds = payout.orders.map((order) => order.id).toList();
    final amount = payout.totalSalesAmount;
    final refController = TextEditingController();
    final noteController = TextEditingController();
    final selectedFile = Rxn<File>();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dialog Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AdminColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AdminColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยืนยันการโอนเงินให้ร้านค้า',
                          style: GoogleFonts.krub(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        Text(
                          shopName,
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            color: AdminColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: AdminColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 20, color: Color(0xFFF1F5F9)),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Financial Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AdminColors.headerGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AdminColors.primaryDark.withValues(alpha: 0.15),
                            blurRadius: 12,
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
                              Text(
                                'ยอดเงินที่ต้องโอนสุทธิ',
                                style: GoogleFonts.krub(
                                  fontSize: 12.5,
                                  color: const Color(0xFFBAE6FD),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${payout.paidOrdersCount} ออเดอร์',
                                  style: GoogleFonts.krub(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '฿${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.krub(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Bank Account Detail Card with Quick Copy
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_balance_rounded, size: 16, color: AdminColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'บัญชีธนาคารปลายทางของร้านค้า',
                                style: GoogleFonts.krub(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (payout.bankName != null) ...[
                            _infoRow('ธนาคาร', payout.bankName!),
                            const SizedBox(height: 4),
                          ],
                          if (payout.bankAccountName != null) ...[
                            _infoRow('ชื่อบัญชี', payout.bankAccountName!),
                            const SizedBox(height: 4),
                          ],
                          if (payout.bankAccountNumber != null) ...[
                            Row(
                              children: [
                                Text(
                                  'เลขที่บัญชี: ',
                                  style: GoogleFonts.krub(
                                    fontSize: 12,
                                    color: AdminColors.textSecondary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    payout.bankAccountNumber!,
                                    style: GoogleFonts.krub(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AdminColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: payout.bankAccountNumber!));
                                    Get.snackbar(
                                      'คัดลอกแล้ว',
                                      'คัดลอกเลขบัญชี ${payout.bankAccountNumber} เรียบร้อย',
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AdminColors.primaryDark,
                                      colorText: Colors.white,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AdminColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.copy_rounded, size: 12, color: AdminColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          'คัดลอก',
                                          style: GoogleFonts.krub(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AdminColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (payout.promptPay != null) ...[
                            Row(
                              children: [
                                Text(
                                  'พร้อมเพย์ (PromptPay): ',
                                  style: GoogleFonts.krub(
                                    fontSize: 12,
                                    color: AdminColors.textSecondary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    payout.promptPay!,
                                    style: GoogleFonts.krub(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AdminColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: payout.promptPay!));
                                    Get.snackbar(
                                      'คัดลอกแล้ว',
                                      'คัดลอกพร้อมเพย์ ${payout.promptPay} เรียบร้อย',
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AdminColors.primaryDark,
                                      colorText: Colors.white,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AdminColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.copy_rounded, size: 12, color: AdminColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          'คัดลอก',
                                          style: GoogleFonts.krub(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AdminColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Upload Slip Proof Section
                    Text(
                      'แนบหลักฐานสลิปการโอนเงิน (Slip Upload)',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final file = selectedFile.value;
                      if (file != null) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  file,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'แนบสลิปเรียบร้อยแล้ว',
                                      style: GoogleFonts.krub(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AdminColors.secondary,
                                      ),
                                    ),
                                    Text(
                                      file.path.split('/').last,
                                      style: GoogleFonts.krub(
                                        fontSize: 11,
                                        color: AdminColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => selectedFile.value = null,
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                tooltip: 'ลบรูปภาพ',
                              ),
                            ],
                          ),
                        );
                      }

                      return InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                          if (picked != null) {
                            selectedFile.value = File(picked.path);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AdminColors.primary.withValues(alpha: 0.25),
                              style: BorderStyle.solid,
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AdminColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: AdminColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'แตะเพื่อเลือกสลิปหลักฐานการโอนเงิน',
                                style: GoogleFonts.krub(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'รองรับรูปภาพ JPG, PNG (สามารถเลือกจากแกลเลอรี)',
                                style: GoogleFonts.krub(
                                  fontSize: 11,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 18),

                    // Inputs: Transaction Ref and Note
                    Text(
                      'ข้อมูลอ้างอิงธุรกรรม',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: refController,
                      style: GoogleFonts.krub(fontSize: 13.5),
                      decoration: InputDecoration(
                        labelText: 'หมายเลขอ้างอิงธุรกรรม (Transaction Ref / เลขที่สลิป)',
                        labelStyle: GoogleFonts.krub(fontSize: 12.5, color: AdminColors.textSecondary),
                        hintText: 'เช่น KPLUS-12345678',
                        hintStyle: GoogleFonts.krub(fontSize: 12, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.tag_rounded, size: 20, color: AdminColors.textSecondary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AdminColors.primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      style: GoogleFonts.krub(fontSize: 13.5),
                      decoration: InputDecoration(
                        labelText: 'บันทึกช่วยจำ (Note)',
                        labelStyle: GoogleFonts.krub(fontSize: 12.5, color: AdminColors.textSecondary),
                        hintText: 'เช่น โอนยอดรอบประจำสัปดาห์',
                        hintStyle: GoogleFonts.krub(fontSize: 12, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: AdminColors.textSecondary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AdminColors.primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Button
                    Obx(() {
                      final isSubmitting = controller.isSubmitting.value;
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  final ok = await controller.confirmPayout(
                                    shopId: shopId,
                                    orderIds: orderIds,
                                    transactionRef: refController.text.trim(),
                                    note: noteController.text.trim(),
                                    slipFile: selectedFile.value,
                                  );
                                  if (ok) {
                                    Get.back();
                                  }
                                },
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'ยืนยันการโอนเงินให้ร้านค้า',
                                      style: GoogleFonts.krub(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.krub(
            fontSize: 12,
            color: AdminColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.krub(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AdminColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
