import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/content_view_history_model.dart';
import '../repositories/profile_repository.dart';

class BrowsingHistoryController extends GetxController {
  final ProfileRepository _repository = Get.isRegistered<ProfileRepository>()
      ? Get.find<ProfileRepository>()
      : ProfileRepository();

  final RxList<ContentViewHistoryModel> historyList = <ContentViewHistoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final items = await _repository.fetchViewingHistory(take: 24);
      items.sort((a, b) {
        final dtA = a.parsedDateTime;
        final dtB = b.parsedDateTime;
        if (dtA == null && dtB == null) return 0;
        if (dtA == null) return 1;
        if (dtB == null) return -1;
        return dtB.compareTo(dtA);
      });
      historyList.assignAll(items);
    } catch (e) {
      debugPrint('Error loading browsing history: $e');
      historyList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistory() async {
    await fetchHistory();
  }
}
