import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import '../../controllers/merchant_export_controller.dart';
import 'widgets/merchant_export_hero_header.dart';
import 'widgets/merchant_export_type_selector.dart';
import 'widgets/merchant_export_date_range_selector.dart';
import 'widgets/merchant_export_format_selector.dart';
import 'widgets/merchant_export_order_filters.dart';
import 'widgets/merchant_export_summary_preview.dart';
import 'widgets/merchant_export_submit_button.dart';

class MerchantExportPage extends GetView<MerchantExportController> {
  const MerchantExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MerchantExportController>()) {
      Get.put(MerchantExportController());
    }

    return Scaffold(
      backgroundColor: MerchantColors.background,
      appBar: AppBar(
        backgroundColor: MerchantColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รายงานและส่งออกข้อมูล',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Merchant Export Center',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top Executive Hero Header
              const MerchantExportHeroHeader(),

              // Body Content Form
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MerchantExportTypeSelector(controller: controller),

                    MerchantExportDateRangeSelector(controller: controller),

                    MerchantExportFormatSelector(controller: controller),

                    MerchantExportOrderFilters(controller: controller),

                    MerchantExportSummaryPreview(controller: controller),

                    MerchantExportSubmitButton(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
