import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutShippingSection extends GetView<CheckoutController> {
  const CheckoutShippingSection({super.key});

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

  Widget _buildShippingOption({
    required String title,
    required String subtitle,
    required double fee,
    required String methodKey,
  }) {
    final isSelected = controller.selectedShippingMethod.value == methodKey;

    return InkWell(
      onTap: () => controller.setShippingOption(methodKey, fee),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD96C2C).withValues(alpha: 0.08)
              : const Color(0xFFF7F0E6).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD96C2C)
                : const Color(0xFFEADCCF),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFD96C2C) : Colors.grey,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B1F17),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '฿${fee.toStringAsFixed(0)}',
              style: GoogleFonts.krub(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD96C2C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: 'รูปแบบการจัดส่ง',
      icon: Icons.fire_truck_rounded,
      iconColor: const Color(0xFFC8952F),
      child: Obx(
        () => Column(
          children: [
            _buildShippingOption(
              title: 'จัดส่งพัสดุแบบธรรมดา (Standard Delivery)',
              subtitle: 'ระยะเวลาจัดส่ง 2-3 วันทำการ',
              fee: 40.0,
              methodKey: 'Standard Delivery',
            ),
            const SizedBox(height: 10),
            _buildShippingOption(
              title: 'จัดส่งแบบด่วนพิเศษ (Express Delivery)',
              subtitle: 'ระยะเวลาจัดส่ง 1-2 วันทำการ',
              fee: 60.0,
              methodKey: 'Express Delivery',
            ),
          ],
        ),
      ),
    );
  }
}
