import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_schedules_controller.dart';
import '../../../models/admin_schedule_model.dart';

class ManageScheduleFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminSchedulesController controller,
    AdminSchedule? schedule,
  }) async {
    final titleCtrl = TextEditingController(text: schedule?.title ?? '');
    final dateCtrl = TextEditingController(
      text:
          schedule?.startDateTime ??
          DateTime.now().toIso8601String().substring(0, 10),
    );
    final addressCtrl = TextEditingController(text: schedule?.address ?? '');
    final descCtrl = TextEditingController(text: schedule?.description ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          schedule == null ? 'สร้างกิจกรรมใหม่' : 'แก้ไขกิจกรรม',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'ชื่อกิจกรรม (Title)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'วันที่เริ่ม (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'สถานที่จัดงาน (Address)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียดกิจกรรม',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.primary),
            onPressed: () async {
              await controller.saveSchedule(
                id: schedule?.scheduleId,
                data: ScheduleFormData(
                  title: titleCtrl.text.trim(),
                  startDateTime: dateCtrl.text.trim(),
                  address: addressCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  status: 'Active',
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
    titleCtrl.dispose();
    dateCtrl.dispose();
    addressCtrl.dispose();
    descCtrl.dispose();
  }
}
