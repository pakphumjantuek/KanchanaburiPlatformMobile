import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/network/api_client.dart';
import '../repositories/merchant_repository.dart';

class MerchantExportController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final selectedExportType = 'orders'.obs; // 'orders', 'products', 'payouts'
  final datePreset =
      'thisMonth'.obs; // 'today', '7days', '30days', 'thisMonth', 'custom'
  final fromDate = Rx<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  final toDate = Rx<DateTime>(DateTime.now());

  final selectedFormat = 'pdf'.obs; // 'pdf', 'csv'
  final selectedOrderStatus = 'All'.obs;
  final selectedPaymentStatus = 'All'.obs;
  final isExporting = false.obs;

  final exportTypes = [
    {
      'value': 'orders',
      'title': 'รายงานคำสั่งซื้อ (Orders)',
      'subtitle': 'สรุปออเดอร์ รายชื่อผู้รับ ยอดรวม และสถานะจัดส่ง',
      'icon': Icons.assignment_outlined,
      'color': const Color(0xFF2563EB),
    },
    {
      'value': 'products',
      'title': 'รายงานยอดขายรายสินค้า (Product Sales)',
      'subtitle': 'สรุปยอดขายแยกรายสินค้า (เฉพาะออเดอร์ที่ชำระเงินแล้ว)',
      'icon': Icons.inventory_2_outlined,
      'color': const Color(0xFF059669),
    },
    {
      'value': 'payouts',
      'title': 'รายงานประวัติรับเงิน (Payout History)',
      'subtitle': 'ประวัติการโอนเงิน/ยอดขายที่โอนเข้าบัญชีร้านค้า',
      'icon': Icons.account_balance_wallet_outlined,
      'color': const Color(0xFFD97706),
    },
  ];

  final datePresets = [
    {'value': 'today', 'label': 'วันนี้'},
    {'value': '7days', 'label': '7 วันล่าสุด'},
    {'value': '30days', 'label': '30 วันล่าสุด'},
    {'value': 'thisMonth', 'label': 'เดือนนี้'},
    {'value': 'custom', 'label': 'เลือกวันที่เอง'},
  ];

  @override
  void onInit() {
    super.onInit();
    applyDatePreset('thisMonth');
  }

  void applyDatePreset(String preset) {
    datePreset.value = preset;
    final now = DateTime.now();

    switch (preset) {
      case 'today':
        fromDate.value = DateTime(now.year, now.month, now.day);
        toDate.value = now;
        break;
      case '7days':
        fromDate.value = now.subtract(const Duration(days: 7));
        toDate.value = now;
        break;
      case '30days':
        fromDate.value = now.subtract(const Duration(days: 30));
        toDate.value = now;
        break;
      case 'thisMonth':
        fromDate.value = DateTime(now.year, now.month, 1);
        toDate.value = now;
        break;
      case 'custom':
        break;
    }
  }

  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: fromDate.value, end: toDate.value),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF047857),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      fromDate.value = picked.start;
      toDate.value = picked.end;
      datePreset.value = 'custom';
    }
  }

  String formatDateString(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String formatThaiDate(DateTime dt) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    final year = dt.year + 543;
    final month = months[dt.month - 1];
    return '${dt.day} $month $year';
  }

  String get thaiDateRangeLabel {
    return '${formatThaiDate(fromDate.value)} - ${formatThaiDate(toDate.value)}';
  }

  int get dateRangeDays {
    return toDate.value.difference(fromDate.value).inDays + 1;
  }

  Map<String, dynamic> get selectedExportTypeInfo {
    return exportTypes.firstWhere(
      (t) => t['value'] == selectedExportType.value,
      orElse: () => exportTypes.first,
    );
  }

  Future<void> exportReport() async {
    isExporting.value = true;
    try {
      final shop = await _repository.fetchMyShop();
      if (shop == null) {
        Get.snackbar(
          'ไม่พบร้านค้าในระบบ',
          'กรุณาลงทะเบียนและเปิดใช้งานร้านค้าก่อนส่งออกรายงาน',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final fromStr = formatDateString(fromDate.value);
      final toStr = formatDateString(toDate.value);

      final exportUrl = _repository.buildExportUrl(
        exportType: selectedExportType.value,
        fromDate: fromStr,
        toDate: toStr,
        format: selectedFormat.value,
        orderStatus: selectedOrderStatus.value,
        paymentStatus: selectedPaymentStatus.value,
      );

      final token = Get.find<ApiClient>().authToken;
      final uri = Uri.parse(exportUrl);
      bool launched = false;

      try {
        final browser = InAppBrowser();
        await browser.openUrlRequest(
          urlRequest: URLRequest(
            url: WebUri(exportUrl),
            headers: {
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
            },
          ),
          settings: InAppBrowserClassSettings(
            browserSettings: InAppBrowserSettings(
              hideUrlBar: false,
            ),
          ),
        );
        launched = true;
      } catch (e) {
        debugPrint('InAppBrowser failed, fallback to launchUrl: $e');
        try {
          launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        } catch (_) {
          if (await canLaunchUrl(uri)) {
            launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      }

      if (launched) {
        Get.snackbar(
          'เปิดการส่งออกรายงานแล้ว',
          'กำลังเตรียมและดาวน์โหลดไฟล์รายงาน (${selectedFormat.value.toUpperCase()})',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถเปิดลิงก์ดาวน์โหลดรายงานได้',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isExporting.value = false;
    }
  }
}
