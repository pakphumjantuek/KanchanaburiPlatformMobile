import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_hero_header.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_basic_fields.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_pricing_fields.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_image_picker.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_description_field.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_section_card.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_status_toggle.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_submit_button.dart';

class ProductFormPage extends GetView<ProductFormController> {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProductFormController>()) {
      Get.put(ProductFormController());
    }

    final isEditing = controller.editingProduct != null;

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
              isEditing ? 'แก้ไขข้อมูลสินค้า' : 'เพิ่มสินค้าใหม่',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              isEditing ? 'Merchant Product Editor' : 'Merchant Product Creator',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูลสินค้า...');
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top Executive Hero Header
              ProductFormHeroHeader(controller: controller),

              // Form Body
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: รูปภาพสินค้า
                      ProductFormSectionCard(
                        title: 'รูปภาพหน้าปกสินค้า',
                        subtitle: 'ภาพถ่ายที่ชัดเจนจะช่วยเพิ่มความน่าสนใจในการสั่งซื้อ',
                        icon: Icons.add_photo_alternate_rounded,
                        child: ProductFormImagePicker(controller: controller),
                      ),

                      // Section 2: ข้อมูลพื้นฐานสินค้า
                      ProductFormSectionCard(
                        title: 'ข้อมูลพื้นฐานของสินค้า',
                        subtitle: 'ระบุชื่อสินค้าและหมวดหมู่ให้ตรงกับสินค้า',
                        icon: Icons.inventory_2_outlined,
                        child: ProductFormBasicFields(controller: controller),
                      ),

                      // Section 3: ราคาและจำนวนสต็อก
                      ProductFormSectionCard(
                        title: 'ราคาและสต็อกสินค้า',
                        subtitle: 'กำหนดราคาขายและจำนวนสินค้าที่พร้อมจัดส่ง',
                        icon: Icons.payments_outlined,
                        child: ProductFormPricingFields(controller: controller),
                      ),

                      // Section 4: รายละเอียดสินค้า
                      ProductFormSectionCard(
                        title: 'รายละเอียดและคุณสมบัติสินค้า',
                        subtitle: 'บอกเล่าจุดเด่น ข้อมูล ขนาด หรือส่วนประกอบสินค้า',
                        icon: Icons.description_outlined,
                        child: ProductFormDescriptionField(controller: controller),
                      ),

                      // Section 5: สถานะการวางจำหน่าย
                      ProductFormSectionCard(
                        title: 'การวางจำหน่ายในร้านค้า',
                        subtitle: 'เปิดหรือปิดการแสดงผลสินค้านี้ในระบบ',
                        icon: Icons.storefront_rounded,
                        child: ProductFormStatusToggle(controller: controller),
                      ),

                      const SizedBox(height: 8),

                      // Submit CTA
                      ProductFormSubmitButton(controller: controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
