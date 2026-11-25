import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutAddressSection extends GetView<CheckoutController> {
  const CheckoutAddressSection({super.key});

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEADCCF)),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: 'ข้อมูลผู้รับ & ที่อยู่จัดส่ง',
      icon: Icons.local_shipping_rounded,
      iconColor: const Color(0xFFD96C2C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.savedAddresses.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เลือกจากที่อยู่ที่บันทึกไว้:',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.savedAddresses.map((addr) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(
                          backgroundColor: const Color(
                            0xFF1F5F58,
                          ).withValues(alpha: 0.1),
                          label: Text(
                            '${addr.recipientName} (${addr.district ?? "กาญจนบุรี"})',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F5F58),
                            ),
                          ),
                          onPressed: () => controller.applyAddress(addr),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            );
          }),
          AppTextField(
            controller: controller.receiverNameController,
            labelText: 'ชื่อ-นามสกุล ผู้รับสินค้า',
            hintText: 'กรอกชื่อผู้รับ',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFFD96C2C),
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller.receiverPhoneController,
            labelText: 'เบอร์โทรศัพท์ติดต่อ',
            hintText: '08X-XXX-XXXX',
            prefixIcon: const Icon(
              Icons.phone_iphone_rounded,
              color: Color(0xFFD96C2C),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller.addressLineController,
            labelText: 'ที่อยู่ (บ้านเลขที่ / ถนน / ซอย)',
            hintText: '123/45 ถนนแสงชูโต',
            prefixIcon: const Icon(
              Icons.home_outlined,
              color: Color(0xFFD96C2C),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: controller.subDistrictController,
                  labelText: 'ตำบล / แขวง',
                  hintText: 'บ้านเหนือ',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: controller.districtController,
                  labelText: 'อำเภอ / เขต',
                  hintText: 'เมืองกาญจนบุรี',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: controller.provinceController,
                  labelText: 'จังหวัด',
                  hintText: 'กาญจนบุรี',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: controller.postalCodeController,
                  labelText: 'รหัสไปรษณีย์',
                  hintText: '71000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
