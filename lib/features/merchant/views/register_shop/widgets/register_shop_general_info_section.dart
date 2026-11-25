import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/register_shop_controller.dart';
import 'package:projecte/shared/widgets/app_text_field.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_section_card.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_input_decoration.dart';

class RegisterShopGeneralInfoSection extends StatelessWidget {
  const RegisterShopGeneralInfoSection({super.key, required this.controller});

  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return RegisterShopSectionCard(
      title: 'ข้อมูลร้านค้าทั่วไป',
      icon: Icons.storefront_rounded,
      children: [
        AppTextField(
          labelText: 'ชื่อร้านค้า *',
          hintText: 'ระบุชื่อร้านค้าของคุณ',
          controller: controller.shopNameController,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'กรุณากรอกชื่อร้านค้า' : null,
        ),
        const SizedBox(height: 14),
        Obx(() {
          final uniqueMap = <String, String>{};
          for (final c in controller.categories) {
            if (c.id.isNotEmpty) uniqueMap[c.id] = c.name;
          }
          final selectedVal = controller.selectedCategoryId.value;
          final validValue =
              (selectedVal != null && uniqueMap.containsKey(selectedVal))
              ? selectedVal
              : null;

          return DropdownButtonFormField<String>(
            initialValue: validValue,
            decoration: RegisterShopInputDecoration.build('หมวดหมู่ร้านค้า *'),
            items: uniqueMap.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.selectedCategoryId.value = val,
            validator: (v) => v == null ? 'กรุณาเลือกหมวดหมู่' : null,
          );
        }),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เบอร์โทรศัพท์',
                hintText: '0812345678',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'อีเมล',
                hintText: 'shop@example.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เวลาเปิดร้าน',
                hintText: '08:00',
                controller: controller.openingTimeController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'เวลาปิดร้าน',
                hintText: '18:00',
                controller: controller.closingTimeController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'รายละเอียดร้านค้า',
          hintText: 'อธิบายเกี่ยวกับสินค้า บริการ หรือจุดเด่นของร้าน',
          controller: controller.descriptionController,
        ),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'URL รูปภาพปกร้านค้า',
          hintText: 'https://example.com/shop-cover.jpg',
          controller: controller.coverImageUrlController,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: controller.coverImageUrlController,
          builder: (context, value, _) {
            if (value.text.trim().isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              height: 160,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  value.text.trim(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      'ไม่สามารถโหลดรูปภาพปกร้านค้าจาก URL นี้ได้',
                      style: GoogleFonts.krub(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
