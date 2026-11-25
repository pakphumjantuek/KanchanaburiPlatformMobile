import 'package:get/get.dart';
import '../models/admin_report_model.dart';
import '../repositories/admin_repository.dart';

class AdminReportsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final reports = <AdminReport>[].obs;
  final selectedStatusFilter = ''.obs; // '' | 'Pending' | 'InProgress' | 'Resolved' | 'Dismissed'

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchAdminReports(
        status: selectedStatusFilter.value.isEmpty ? null : selectedStatusFilter.value,
      );
      reports.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateReportStatus(String reportId, String newStatus) async {
    final ok = await _repository.updateReportStatus(reportId, newStatus);
    if (ok) {
      Get.snackbar('สำเร็จ', 'เปลี่ยนสถานะการรายงานเป็น $newStatus สำเร็จ', snackPosition: SnackPosition.TOP);
      loadReports();
    } else {
      Get.snackbar('ข้อผิดพลาด', 'อัปเดตสถานะการรายงานไม่สำเร็จ', snackPosition: SnackPosition.TOP);
    }
  }
}
