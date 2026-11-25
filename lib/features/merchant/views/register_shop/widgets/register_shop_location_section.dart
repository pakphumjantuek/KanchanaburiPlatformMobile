import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/register_shop_controller.dart';
import 'package:projecte/shared/widgets/app_text_field.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_section_card.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_input_decoration.dart';

class RegisterShopLocationSection extends StatelessWidget {
  const RegisterShopLocationSection({super.key, required this.controller});

  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return RegisterShopSectionCard(
      title: 'ที่ตั้งและพื้นที่บริการ',
      icon: Icons.location_on_rounded,
      children: [
        Obx(() {
          final uniqueDistricts = <String, String>{};
          for (final d in controller.districts) {
            if (d.id.isNotEmpty) uniqueDistricts[d.id] = d.name;
          }
          final selectedVal = controller.selectedDistrictId.value;
          final validValue =
              (selectedVal != null && uniqueDistricts.containsKey(selectedVal))
              ? selectedVal
              : null;

          return DropdownButtonFormField<String>(
            initialValue: validValue,
            decoration: RegisterShopInputDecoration.build('อำเภอ *'),
            items: uniqueDistricts.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.onDistrictChanged(val),
            validator: (v) => v == null ? 'กรุณาเลือกอำเภอ' : null,
          );
        }),
        const SizedBox(height: 14),
        Obx(() {
          final uniqueSubDistricts = <String, String>{};
          for (final sd in controller.subDistricts) {
            if (sd.id.isNotEmpty) uniqueSubDistricts[sd.id] = sd.name;
          }
          final selectedVal = controller.selectedSubDistrictId.value;
          final validValue =
              (selectedVal != null &&
                  uniqueSubDistricts.containsKey(selectedVal))
              ? selectedVal
              : null;

          return DropdownButtonFormField<String>(
            initialValue: validValue,
            decoration: RegisterShopInputDecoration.build('ตำบล *'),
            items: uniqueSubDistricts.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.selectedSubDistrictId.value = val,
            validator: (v) => v == null ? 'กรุณาเลือกตำบล' : null,
          );
        }),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'ที่อยู่รายละเอียด',
          hintText: 'บ้านเลขที่ ถนน ซอย',
          controller: controller.addressController,
        ),
      ],
    );
  }
}
