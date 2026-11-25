import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_schedules_controller.dart';
import '../../../models/admin_schedule_model.dart';

class AdminScheduleCard extends StatelessWidget {
  const AdminScheduleCard({
    super.key,
    required this.schedule,
    required this.controller,
    required this.onEdit,
  });

  final AdminSchedule schedule;
  final AdminSchedulesController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  schedule.title,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A86EF).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  schedule.status,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3A86EF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AdminColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'เริ่ม: ${schedule.startDateTime}',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: AdminColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (schedule.address != null && schedule.address!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AdminColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    schedule.address!,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AdminColors.error),
                onPressed: () => controller.deleteSchedule(schedule.scheduleId),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
