import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/register_shop_controller.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_header_banner.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_pending_view.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_rejected_banner.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_general_info_section.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_location_section.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_bank_section.dart';
import 'package:projecte/features/merchant/views/register_shop/widgets/register_shop_submit_button.dart';

class RegisterShopPage extends GetView<RegisterShopController> {
  const RegisterShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'สมัครเปิดร้านค้า',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูล...');
        }

        final shopStatus = controller.myShop.value?.status;

        if (shopStatus == 'PendingApproval') {
          return RegisterShopPendingView(
            shopName: controller.myShop.value?.name ?? '',
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegisterShopHeaderBanner(),
                const SizedBox(height: 20),
                if (shopStatus == 'Rejected') ...[
                  const RegisterShopRejectedBanner(),
                  const SizedBox(height: 20),
                ],
                RegisterShopGeneralInfoSection(controller: controller),
                const SizedBox(height: 20),
                RegisterShopLocationSection(controller: controller),
                const SizedBox(height: 20),
                RegisterShopBankSection(controller: controller),
                const SizedBox(height: 28),
                RegisterShopSubmitButton(controller: controller),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}
