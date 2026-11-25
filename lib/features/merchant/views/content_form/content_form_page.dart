import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/content_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_form_section_card.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_form_submit_button.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_status_selector.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/shop_link_banner.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/youtube_thumbnail_preview.dart';

class ContentFormPage extends GetView<ContentFormController> {
  const ContentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            Obx(
              () => Text(
                controller.isEditing.value
                    ? 'แก้ไขเรื่องราวร้านค้า'
                    : 'เขียนเรื่องราวใหม่',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Merchant Story Editor',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'บันทึก',
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
              ),
              onPressed:
                  controller.isSaving.value ? null : controller.saveContent,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingForm.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูลฟอร์ม...');
        }

        final shop = controller.shop.value;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Executive Hero Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                decoration: const BoxDecoration(
                  gradient: MerchantColors.heroGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(26),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFFFDE68A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.isEditing.value
                                ? 'แก้ไขและปรับปรุงเรื่องราว'
                                : 'บอกเล่าเรื่องราวร้านของคุณ',
                            style: GoogleFonts.krub(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'สร้างคอนเทนต์ โปรโมชั่น หรือบรรยากาศร้าน เพื่อสื่อสารกับลูกค้าและชุมชน',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFFA7F3D0).withValues(alpha: 0.95),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (shop != null) ...[
                      ShopLinkBanner(shopName: shop.shopName),
                      const SizedBox(height: 16),
                    ],

                    // Section 1: Basic Info
                    ContentFormSectionCard(
                      title: 'ข้อมูลเรื่องราวและเนื้อหา',
                      subtitle: 'ระบุหัวข้อ หมวดหมู่ และรายละเอียดที่ต้องการสื่อสาร',
                      icon: Icons.article_rounded,
                      children: [
                        // Title
                        TextFormField(
                          controller: controller.titleController,
                          style: GoogleFonts.krub(
                            fontSize: 14.5,
                            color: MerchantColors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            label: 'ชื่อเรื่องราว / หัวข้อข่าวสาร *',
                            hint: 'เช่น ความเป็นมาของร้าน, เมนูแนะนำประจำฤดูกาล...',
                            prefixIcon: Icons.title_rounded,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Dropdown
                        Obx(() {
                          final items = controller.categories;
                          final selectedVal = controller.selectedCategoryId.value;
                          final validVal =
                              items.any(
                                (c) =>
                                    (c['contentCategoryId']?.toString() ??
                                        c['id']?.toString()) ==
                                    selectedVal,
                              )
                              ? selectedVal
                              : (items.isNotEmpty
                                    ? (items.first['contentCategoryId']?.toString() ??
                                          items.first['id']?.toString())
                                    : null);

                          return DropdownButtonFormField<String>(
                            initialValue: validVal,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: MerchantColors.primary,
                            ),
                            style: GoogleFonts.krub(
                              color: MerchantColors.textPrimary,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            decoration: _inputDecoration(
                              label: 'หมวดหมู่บทความ *',
                              prefixIcon: Icons.category_outlined,
                            ),
                            items: items.map((cat) {
                              final id =
                                  cat['contentCategoryId']?.toString() ??
                                  cat['id']?.toString() ??
                                  '';
                              final name =
                                  cat['categoryName']?.toString() ??
                                  cat['name']?.toString() ??
                                  'หมวดหมู่';
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(name, style: GoogleFonts.krub()),
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.selectedCategoryId.value = val;
                            },
                          );
                        }),
                        const SizedBox(height: 16),

                        // Summary
                        TextFormField(
                          controller: controller.summaryController,
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: MerchantColors.textPrimary,
                          ),
                          maxLines: 2,
                          decoration: _inputDecoration(
                            label: 'สรุปย่อเรื่องราว (Summary)',
                            hint: 'ข้อความเกริ่นนำสั้นๆ สำหรับแสดงบนการ์ดและผลการค้นหา...',
                            prefixIcon: Icons.short_text_rounded,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Full Body Content
                        TextFormField(
                          controller: controller.bodyController,
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: MerchantColors.textPrimary,
                            height: 1.4,
                          ),
                          maxLines: 6,
                          decoration: _inputDecoration(
                            label: 'เนื้อหาฉบับเต็ม *',
                            hint: 'เขียนเล่ารายละเอียดเรื่องราว บรรยากาศ หรือข้อมูลที่คุณต้องการแบ่งปัน...',
                            prefixIcon: Icons.notes_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Location & District
                    ContentFormSectionCard(
                      title: 'พื้นที่และตำแหน่งที่ตั้ง',
                      subtitle: 'ระบุตำแหน่งอำเภอและตำบลเพื่อการเข้าถึงในพื้นที่',
                      icon: Icons.location_on_rounded,
                      children: [
                        Obx(() {
                          final dists = controller.districts;
                          final selDist = controller.selectedDistrictId.value;
                          final validDist = dists.any((d) => d.districtId == selDist)
                              ? selDist
                              : null;

                          return DropdownButtonFormField<String>(
                            initialValue: validDist,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: MerchantColors.primary,
                            ),
                            style: GoogleFonts.krub(
                              color: MerchantColors.textPrimary,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            decoration: _inputDecoration(
                              label: 'อำเภอ',
                              prefixIcon: Icons.location_city_rounded,
                            ),
                            items: dists.map((d) {
                              return DropdownMenuItem<String>(
                                value: d.districtId,
                                child: Text(
                                  d.districtName,
                                  style: GoogleFonts.krub(),
                                ),
                              );
                            }).toList(),
                            onChanged: controller.onDistrictChanged,
                          );
                        }),
                        const SizedBox(height: 16),

                        Obx(() {
                          final subs = controller.subDistricts;
                          final selSub = controller.selectedSubDistrictId.value;
                          final validSub = subs.any((s) => s.subDistrictId == selSub)
                              ? selSub
                              : null;

                          return DropdownButtonFormField<String>(
                            initialValue: validSub,
                            icon: controller.isLoadingSubDistricts.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: MerchantColors.primary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: MerchantColors.primary,
                                  ),
                            style: GoogleFonts.krub(
                              color: MerchantColors.textPrimary,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            decoration: _inputDecoration(
                              label: controller.isLoadingSubDistricts.value
                                  ? 'กำลังโหลดตำบล...'
                                  : 'ตำบล',
                              prefixIcon: Icons.place_outlined,
                            ),
                            items: subs.map((s) {
                              return DropdownMenuItem<String>(
                                value: s.subDistrictId,
                                child: Text(
                                  s.subDistrictName,
                                  style: GoogleFonts.krub(),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                controller.selectedSubDistrictId.value = val,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Media & Status
                    ContentFormSectionCard(
                      title: 'สื่อวิดีโอและสถานะการเผยแพร่',
                      subtitle: 'เพิ่มลิงก์ YouTube เพื่อดึงดูดความสนใจและเลือกสถานะ',
                      icon: Icons.video_collection_rounded,
                      children: [
                        // YouTube URL
                        TextFormField(
                          controller: controller.youtubeUrlController,
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: MerchantColors.textPrimary,
                          ),
                          onChanged: (_) => controller.update(),
                          decoration: _inputDecoration(
                            label: 'ลิงก์วิดีโอ YouTube (ถ้ามี)',
                            hint: 'https://www.youtube.com/watch?v=...',
                            prefixIcon: Icons.smart_display_outlined,
                          ),
                        ),
                        const SizedBox(height: 12),

                        YoutubeThumbnailPreview(controller: controller),
                        const SizedBox(height: 8),

                        const ContentStatusSelector(),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bottom Submit CTA
                    const ContentFormSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: MerchantColors.primary, size: 20)
          : null,
      labelStyle: GoogleFonts.krub(
        color: MerchantColors.textSecondary,
        fontSize: 13.5,
      ),
      hintStyle: GoogleFonts.krub(
        color: MerchantColors.textMuted,
        fontSize: 12.5,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MerchantColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MerchantColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MerchantColors.primary, width: 1.6),
      ),
    );
  }
}

