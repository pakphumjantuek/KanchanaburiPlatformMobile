import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_section_card.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_format_option_tile.dart';

class AdminExportFormatSelector extends StatelessWidget {
  const AdminExportFormatSelector({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdminExportSectionCard(
          stepNumber: '3',
          title: 'รูปแบบไฟล์เอกสาร',
          subtitle: 'เลือกรูปแบบไฟล์ที่ต้องการบันทึก',
          icon: Icons.file_present_rounded,
          children: [
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: AdminExportFormatOptionTile(
                      title: 'เอกสาร PDF',
                      subtitle: 'จัดตารางแนวนอน สวยงาม พิมพ์ง่าย',
                      badge: 'เหมาะสำหรับอ่าน/พิมพ์',
                      value: 'pdf',
                      selectedValue: controller.selectedFormat.value,
                      color: const Color(0xFFE11D48),
                      icon: Icons.picture_as_pdf_rounded,
                      onTap: () => controller.selectedFormat.value = 'pdf',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminExportFormatOptionTile(
                      title: 'ไฟล์ Excel (CSV)',
                      subtitle: 'ข้อมูลตารางดิบ UTF-8 วิเคราะห์ต่อ',
                      badge: 'เหมาะสำหรับ Excel',
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
