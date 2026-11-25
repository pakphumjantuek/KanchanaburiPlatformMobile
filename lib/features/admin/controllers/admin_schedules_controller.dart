import 'package:get/get.dart';
import '../models/admin_schedule_model.dart';
import '../repositories/admin_repository.dart';

class AdminSchedulesController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final schedules = <AdminSchedule>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
  }

  Future<void> loadSchedules({String? contentId}) async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchAdminSchedules(contentId: contentId);
      schedules.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveSchedule({String? id, required ScheduleFormData data}) async {
    if (id != null && id.isNotEmpty) {
      final ok = await _repository.updateSchedule(id, data);
      if (ok) {
        Get.snackbar('สำเร็จ', 'แก้ไขตารางกิจกรรมเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
        loadSchedules();
        return true;
      }
    } else {
      final sch = await _repository.createSchedule(data);
      if (sch != null) {
        Get.snackbar('สำเร็จ', 'สร้างกิจกรรมใหม่เรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
        loadSchedules();
        return true;
      }
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถบันทึกกิจกรรมได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> deleteSchedule(String id) async {
    final ok = await _repository.deleteSchedule(id);
    if (ok) {
      Get.snackbar('สำเร็จ', 'ยกเลิก/ลบกิจกรรมเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadSchedules();
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบกิจกรรมได้', snackPosition: SnackPosition.TOP);
    return false;
  }
}
