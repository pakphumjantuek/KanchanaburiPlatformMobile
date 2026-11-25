import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../contents/models/content_model.dart';
import '../../contents/repositories/content_repository.dart';

class MyContentsController extends GetxController {
  final ContentRepository _repository = Get.isRegistered<ContentRepository>()
      ? Get.find<ContentRepository>()
      : ContentRepository();

  final RxList<ContentModel> contents = <ContentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs; // 'all', 'published', 'pending', 'archived'

  @override
  void onInit() {
    super.onInit();
    fetchMyContents();
  }

  Future<void> fetchMyContents() async {
    isLoading.value = true;
    try {
      final result = await _repository.fetchMyContents();
      contents.assignAll(result);
    } catch (e) {
      debugPrint('Error loading my contents: $e');
      contents.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<ContentModel> get filteredContents {
    if (selectedFilter.value == 'published') {
      return contents.where((c) => (c.status ?? '').toLowerCase() == 'published').toList();
    } else if (selectedFilter.value == 'pending') {
      return contents.where((c) => (c.status ?? '').toLowerCase() == 'pending').toList();
    } else if (selectedFilter.value == 'archived') {
      return contents
          .where((c) =>
              (c.status ?? '').toLowerCase() == 'archived' ||
              (c.status ?? '').toLowerCase() == 'draft')
          .toList();
    }
    return contents;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> archiveContent(ContentModel content) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFFFFF9F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE8D9C9), width: 2),
        ),
        title: Text(
          'ต้องการยกเลิกคอนเทนต์นี้หรือไม่?',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF332820),
          ),
        ),
        content: Text(
          'คุณกำลังจะลบ/เปลี่ยนสถานะ "${content.title}" เป็นเก็บถาวร สามารถเปลี่ยนคืนได้ในภายหลัง',
          style: GoogleFonts.krub(
            fontSize: 14,
            color: const Color(0xFF786B62),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(
                color: const Color(0xFF786B62),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ยืนยันเก็บถาวร',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      isLoading.value = true;
      try {
        final success = await _repository.archiveMyContent(content.id);
        if (success) {
          contents.removeWhere((c) => c.id == content.id);
          Get.snackbar(
            'ดำเนินการสำเร็จ',
            'ลบ/เปลี่ยนสถานะคอนเทนต์เรียบร้อยแล้ว',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF2B1F17),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
          );
        } else {
          Get.snackbar(
            'เกิดข้อผิดพลาด',
            'ไม่สามารถดำเนินการได้ กรุณาลองใหม่อีกครั้ง',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'เกิดข้อผิดพลาด: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
