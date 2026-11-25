import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductFormImagePicker extends StatelessWidget {
  const ProductFormImagePicker({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final localPath = controller.selectedCoverImagePath.value;
      final existingUrl = controller.editingProduct?.imageUrl;
      final hasImage = (localPath != null && localPath.isNotEmpty) ||
          (existingUrl != null && existingUrl.isNotEmpty);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hasImage ? MerchantColors.primary : MerchantColors.border,
                width: hasImage ? 1.5 : 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: _imagePreview(localPath, existingUrl),
                  ),
                ),
                if (localPath != null && localPath.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.removeSelectedCoverImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      controller.pickCoverImage(ImageSource.gallery),
                  icon: const Icon(
                    Icons.photo_library_rounded,
                    size: 18,
                    color: MerchantColors.primary,
                  ),
                  label: Text(
                    'เลือกจากคลังภาพ',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: MerchantColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: MerchantColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      controller.pickCoverImage(ImageSource.camera),
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Color(0xFF0284C7),
                  ),
                  label: Text(
                    'ถ่ายภาพใหม่',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _imagePreview(String? localPath, String? existingUrl) {
    if (localPath != null && localPath.isNotEmpty) {
      return Image.file(File(localPath), fit: BoxFit.cover);
    }
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return Image.network(
        existingUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image_rounded,
                color: Color(0xFF94A3B8),
                size: 38,
              ),
              const SizedBox(height: 6),
              Text(
                'ไม่สามารถโหลดรูปภาพเดิมได้',
                style: GoogleFonts.krub(
                  color: MerchantColors.error,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MerchantColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_a_photo_outlined,
              size: 36,
              color: MerchantColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'แตะปุ่มด้านล่างเพื่อเลือกรูปภาพสินค้า',
            style: GoogleFonts.krub(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MerchantColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'แนะนำรูปภาพสัดส่วน 1:1 ชัดเจนเพื่อดึงดูดลูกค้า',
            style: GoogleFonts.krub(
              fontSize: 11,
              color: MerchantColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
