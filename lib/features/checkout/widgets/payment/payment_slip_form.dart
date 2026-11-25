import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../controllers/payment_controller.dart';

class PaymentSlipForm extends GetView<PaymentController> {
  const PaymentSlipForm({super.key});

  Widget _buildSlipImageWidget(
    String slip, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (slip.startsWith('data:image')) {
      try {
        final base64Data = slip.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, width: width, height: height, fit: fit);
      } catch (_) {}
    }
    if (slip.startsWith('http://') || slip.startsWith('https://')) {
      return Image.network(
        slip,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF059669),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
        ),
      );
    }
    final file = File(slip);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF059669),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
        ),
      );
    }
    return Container(
      color: const Color(0xFF059669),
      child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_2_rounded,
                color: Color(0xFFD96C2C),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'โอนเงินผ่าน PromptPay หรือ ธนาคาร',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // PromptPay QR Frame Showcase
          Container(
            width: 190,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF003865),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003865).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'PromptPay QR',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 110,
                        color: Color(0xFF332820),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'สแกนด้วยแอปธนาคาร',
                        style: GoogleFonts.krub(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bank Details Box with Copy Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ธนาคารกรุงไทย (KTB)',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003865),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(text: '7010982145'),
                        );
                        Get.snackbar(
                          'คัดลอกสำเร็จ',
                          'คัดลอกเลขที่บัญชี 701-0-98214-5 เรียบร้อยแล้ว',
                          backgroundColor: const Color(0xFF2B1F17),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 12,
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003865).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.copy_rounded,
                              size: 13,
                              color: Color(0xFF003865),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'คัดลอกเลขบัญชี',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF003865),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'เลขที่บัญชี: 701-0-98214-5',
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
                Text(
                  'ชื่อบัญชี: กาญจนบุรี แพลตฟอร์ม (KRU Boat API)',
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 16),

          // Slip Upload Box
          Obx(() {
            final slip = controller.uploadedSlipPath.value;
            final uploadTime = controller.slipUploadTime.value;

            if (slip != null) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF059669),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: _buildSlipImageWidget(slip),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'แนบสลิปชำระเงินเรียบร้อยแล้ว',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          if (uploadTime != null)
                            Text(
                              'อัปโหลดเมื่อ: ${uploadTime.hour}:${uploadTime.minute.toString().padLeft(2, "0")} น.',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        controller.uploadedSlipPath.value = null;
                      },
                    ),
                  ],
                ),
              );
            }

            return OutlinedButton.icon(
              onPressed: controller.selectSlipImage,
              icon: const Icon(Icons.cloud_upload_rounded, size: 22),
              label: Text(
                'คลิกเพื่อแนบสลิปชำระเงิน (Upload Slip)',
                style: GoogleFonts.krub(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD96C2C),
                side: const BorderSide(color: Color(0xFFD96C2C), width: 1.8),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          Obx(
            () => AppButton(
              text: 'ยืนยันและส่งสลิปชำระเงิน',
              color: const Color(0xFFD96C2C),
              icon: Icons.check_circle_outline_rounded,
              isLoading: controller.isUploadingSlip.value,
              onPressed: controller.submitSlipPayment,
            ),
          ),
        ],
      ),
    );
  }
}
