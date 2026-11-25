import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_section_card.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_format_option_tile.dart';

class MerchantExportFormatSelector extends StatelessWidget {
  const MerchantExportFormatSelector({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MerchantExportSectionCard(
          stepNumber: '3',
          title: 'รูปแบบไฟล์เอกสาร',
          subtitle: 'เลือกรูปแบบไฟล์ที่ต้องการนำไปใช้งาน',
          icon: Icons.description_outlined,
          children: [
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: MerchantExportFormatOptionTile(
                      title: 'PDF Document',
                      subtitle: 'ตารางขนาด A4 แนวนอน พร้อมพิมพ์หรือส่งต่อ',
                      badge: 'PDF FILE',
                      value: 'pdf',
                      selectedValue: controller.selectedFormat.value,
                      color: const Color(0xFFE11D48),
                      icon: Icons.picture_as_pdf_rounded,
                      onTap: () => controller.selectedFormat.value = 'pdf',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MerchantExportFormatOptionTile(
                      title: 'CSV Spreadsheet',
                      subtitle: 'นำไปคำนวณต่อใน Excel, Google Sheets',
                      badge: 'EXCEL / CSV',
                      value: 'csv',
                      selectedValue: controller.selectedFormat.value,
                      color: const Color(0xFF059669),
                      icon: Icons.table_chart_rounded,
                      onTap: () => controller.selectedFormat.value = 'csv',
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
