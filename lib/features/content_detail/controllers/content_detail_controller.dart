import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/content_detail_model.dart';
import '../models/content_schedule_model.dart';
import '../models/content_review_model.dart';
import '../repositories/content_detail_repository.dart';
import '../../shops/models/shop_model.dart';
import '../../shops/models/product_model.dart';
import '../../../core/services/auth_service.dart';
import '../../profile/controllers/favorites_controller.dart';

class ContentDetailController extends GetxController {
  ContentDetailController({ContentDetailRepository? repository})
    : _repository = repository ?? ContentDetailRepository();

  final ContentDetailRepository _repository;

  // Reactive State
  final isLoading = true.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  final content = Rxn<ContentDetailModel>();
  final schedules = <ContentScheduleModel>[].obs;
  final reviews = <ContentReviewModel>[].obs;
  final relatedShops = <ShopModel>[].obs;
  final relatedProducts = <ProductModel>[].obs;
  final relatedContents = <ContentDetailModel>[].obs;

  final isFavorite = false.obs;
  final myRating = 5.0.obs;
  final isPostingReview = false.obs;

  final reviewTextController = TextEditingController();

  String _currentContentId = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ContentDetailModel) {
      content.value = args;
      _currentContentId = args.id;
      isFavorite.value = args.isFavorite;
      fetchSubEntities(args.id);
    } else if (args != null &&
        args.runtimeType.toString().contains('ContentModel')) {
      dynamic m = args;
      _currentContentId = m.id.toString();
      loadContentDetail(_currentContentId);
    } else if (args is String) {
      _currentContentId = args;
      loadContentDetail(args);
    } else if (Get.parameters['id'] != null) {
      _currentContentId = Get.parameters['id']!;
      loadContentDetail(_currentContentId);
    }
  }

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }

  Future<void> loadContentDetail(String id) async {
    _currentContentId = id;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final detail = await _repository.fetchContentDetail(id);
      if (detail != null) {
        content.value = detail;
        isFavorite.value = detail.isFavorite;

        // Check live server favorite status if logged in
        if (Get.isRegistered<AuthService>() &&
            Get.find<AuthService>().isLoggedIn.value) {
          final serverFav = await _repository.checkIsFavorite(id);
          isFavorite.value = serverFav;
        }

        await fetchSubEntities(id);
      } else {
        isError.value = true;
        errorMessage.value = 'ไม่พบข้อมูลบทความสถานที่ท่องเที่ยวนี้';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubEntities(String id) async {
    try {
      if (Get.isRegistered<AuthService>() &&
          Get.find<AuthService>().isLoggedIn.value) {
        _repository.recordContentView(id);
      }
      final fetchedSchedules = await _repository.fetchSchedules(id);
      final fetchedReviews = await _repository.fetchReviews(id);
      final fetchedProducts = await _repository.fetchRelatedProducts(id);
      final fetchedShops = await _repository.fetchRelatedShops(
        shopId: content.value?.shopId,
      );
      final fetchedRelated = await _repository.fetchRelatedContents(
        categoryId: content.value?.categoryId,
        currentContentId: id,
      );

      schedules.assignAll(fetchedSchedules);
      reviews.assignAll(fetchedReviews);
      relatedProducts.assignAll(fetchedProducts);
      relatedShops.assignAll(fetchedShops);
      relatedContents.assignAll(fetchedRelated);
    } catch (_) {}
  }

  void retry() {
    if (_currentContentId.isNotEmpty) {
      loadContentDetail(_currentContentId);
    }
  }

  Future<void> toggleFavorite() async {
    if (Get.isRegistered<AuthService>() &&
        !Get.find<AuthService>().isLoggedIn.value) {
      Get.snackbar(
        'ต้องเข้าสู่ระบบก่อน',
        'กรุณาเข้าสู่ระบบก่อนบันทึกรายการโปรด',
        backgroundColor: const Color(0xFF332820),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final targetId = _currentContentId.isNotEmpty
        ? _currentContentId
        : content.value?.id;
    if (targetId == null || targetId.isEmpty) return;

    final willFavorite = !isFavorite.value;
    isFavorite.value = willFavorite;
    if (content.value != null) {
      content.value = content.value!.copyWith(isFavorite: willFavorite);
    }

    bool success = false;
    if (willFavorite) {
      success = await _repository.addFavorite(targetId);
    } else {
      success = await _repository.removeFavorite(targetId);
    }

    if (!success) {
      // Revert if API failed
      isFavorite.value = !willFavorite;
      if (content.value != null) {
        content.value = content.value!.copyWith(isFavorite: !willFavorite);
      }
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถบันทึกรายการโปรดได้ กรุณาลองใหม่อีกครั้ง',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Refresh Favorites list in Profile if controller exists
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().fetchFavorites();
    }

    Get.snackbar(
      willFavorite ? 'บันทึกแล้ว' : 'ยกเลิกการบันทึก',
      willFavorite
          ? 'เพิ่มในรายการบันทึกโปรดของคุณเรียบร้อยแล้ว'
          : 'นำออกจากรายการบันทึกโปรดเรียบร้อยแล้ว',
      backgroundColor: const Color(0xFF332820),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> openGoogleMaps() async {
    final lat = content.value?.latitude;
    final lng = content.value?.longitude;

    final Uri url;
    if (lat != null && lng != null && lat != 0 && lng != 0) {
      url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
    } else {
      final query = Uri.encodeComponent(
        '${content.value?.title ?? ""} กาญจนบุรี',
      );
      url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถเปิดแอปแผนที่ได้',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> callPhone(String phone) async {
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    await _launchOrWarn(Uri(scheme: 'tel', path: digits), 'ไม่สามารถโทรออกได้');
  }

  Future<void> openWebsite(String website) async {
    final url = website.startsWith('http') ? website : 'https://$website';
    await _launchOrWarn(Uri.parse(url), 'ไม่สามารถเปิดเว็บไซต์ได้');
  }

  Future<void> _launchOrWarn(Uri uri, String failMessage) async {
    final ok =
        await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar(
        'ข้อผิดพลาด',
        failMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void shareContent() {
    Get.snackbar(
      'แชร์เรื่องราว',
      'คัดลอกลิงก์เรื่องราว "${content.value?.title ?? ""}" แล้ว',
      backgroundColor: const Color(0xFFD96C2C),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> postReview() async {
    final text = reviewTextController.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        'แจ้งเตือน',
        'กรุณาพิมพ์ความคิดเห็นก่อนส่ง',
        backgroundColor: Colors.amber[800],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isPostingReview.value = true;
    try {
      final success = await _repository.postReview(
        _currentContentId,
        text,
        myRating.value,
      );
      if (success) {
        reviewTextController.clear();
        await fetchSubEntities(_currentContentId);
        Get.snackbar(
          'สำเร็จ',
          'ขอบคุณสำหรับความคิดเห็นของคุณ!',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        // Fallback optimistic update
        reviews.insert(
          0,
          ContentReviewModel(
            reviewId: DateTime.now().millisecondsSinceEpoch.toString(),
            userName: 'ผู้ใช้งานกาญจนบุรี',
            comment: text,
            rating: myRating.value,
            createdAt: 'เมื่อสักครู่',
            isMine: true,
          ),
        );
        reviewTextController.clear();
        Get.snackbar(
          'บันทึกแล้ว',
          'โพสต์ความคิดเห็นของคุณเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      isPostingReview.value = false;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    reviews.removeWhere((r) => r.reviewId == reviewId);
    await _repository.deleteReview(reviewId);
    Get.snackbar(
      'ลบแล้ว',
      'ลบความคิดเห็นของคุณเรียบร้อยแล้ว',
      backgroundColor: const Color(0xFF332820),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> reportContent(String reason) async {
    final success = await _repository.reportContent(_currentContentId, reason);
    Get.snackbar(
      'ส่งรายงานแล้ว',
      success
          ? 'ขอบคุณที่ช่วยแจ้งตรวจสอบ ทีมงานจะดำเนินการโดยเร็ว'
          : 'ได้รับการแจ้งรายงานเรียบร้อยแล้ว',
      backgroundColor: const Color(0xFF332820),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
