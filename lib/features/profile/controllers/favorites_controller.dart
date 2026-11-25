import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../contents/repositories/content_repository.dart';
import '../models/favorite_content_model.dart';

class FavoritesController extends GetxController {
  final ContentRepository _repository = Get.isRegistered<ContentRepository>()
      ? Get.find<ContentRepository>()
      : ContentRepository();

  final RxList<FavoriteContentModel> favoritesList = <FavoriteContentModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    try {
      final result = await _repository.fetchFavorites();
      favoritesList.assignAll(result);
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      favoritesList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(FavoriteContentModel item) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFFFFF9F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE8D9C9), width: 2),
        ),
        title: Text(
          'นำออกจากรายการโปรด?',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF332820),
          ),
        ),
        content: Text(
          'คุณต้องการนำ "${item.title}" ออกจากรายการโปรดของคุณหรือไม่?',
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
              backgroundColor: const Color(0xFFE76F51),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'นำออก',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      isLoading.value = true;
      try {
        final success = await _repository.removeFavorite(item.contentId);
        if (success) {
          favoritesList.removeWhere((f) => f.contentId == item.contentId);
          Get.snackbar(
            'นำออกแล้ว',
            'ลบรายการออกจากรายการโปรดเรียบร้อยแล้ว',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF2B1F17),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
          );
        } else {
          // Fallback removal if API response differs
          favoritesList.removeWhere((f) => f.contentId == item.contentId);
        }
      } catch (e) {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'เกิดข้อผิดพลาดในการนำออก: $e',
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
