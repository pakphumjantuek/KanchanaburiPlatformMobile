import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_schedules_controller.dart';
import '../../../models/admin_schedule_model.dart';
import 'admin_schedule_card.dart';

class ManageSchedulesList extends StatelessWidget {
  const ManageSchedulesList({
    super.key,
    required this.controller,
    required this.onEdit,
  });

  final AdminSchedulesController controller;
  final ValueChanged<AdminSchedule> onEdit;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AdminColors.primary),
        );
      }
      if (controller.schedules.isEmpty) {
        return Center(
          child: Text(
            'ไม่มีตารางกิจกรรมในระบบ',
            style: GoogleFonts.krub(color: AdminColors.textSecondary),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.schedules.length,
        itemBuilder: (context, index) {
          final schedule = controller.schedules[index];
          return AdminScheduleCard(
            schedule: schedule,
            controller: controller,
            onEdit: () => onEdit(schedule),
          );
        },
      );
    });
  }
}
