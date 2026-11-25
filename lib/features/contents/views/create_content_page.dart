import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/create_content_controller.dart';

class CreateContentPage extends StatelessWidget {
  const CreateContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateContentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.isEditing ? 'แก้ไขคอนเทนต์' : 'สร้างคอนเทนต์ใหม่',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingFormOptions.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD96C2C)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Header Banner
              _buildHeroHeader(),

              const SizedBox(height: 18),

              // 2. Section 1: ข้อมูลทั่วไป (Title, Summary, Category, Status)
              _buildGeneralInfoSection(controller),

              const SizedBox(height: 16),

              // 3. Section 2: สื่อและวิดีโอ (YouTube URL & Live Thumbnail Preview)
              _buildMediaSection(controller),

              const SizedBox(height: 16),

              // 4. Section 3: สถานที่และพิกัด (District, SubDistrict, Shop, Lat/Lng)
              _buildLocationSection(controller),

              const SizedBox(height: 24),

              // 5. Submit Button
              _buildSubmitButton(controller),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.post_add_rounded,
              color: Color(0xFFD96C2C),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แบ่งปันเรื่องราวและกิจกรรม',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFF332820),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'เขียนบทความ แนะนำสถานที่ท่องเที่ยว คาเฟ่ หรือกิจกรรมวิถีชุมชนในจังหวัดกาญจนบุรี',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF786B62),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection(CreateContentController controller) {
    return _buildSectionCard(
      title: 'ข้อมูลทั่วไปของคอนเทนต์',
      icon: Icons.edit_note_rounded,
      children: [
        // Title Input
        _buildFieldLabel('ชื่อเรื่อง / หัวข้อบทความ *'),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller.titleController,
          style: GoogleFonts.krub(
            fontSize: 14.5,
            color: const Color(0xFF332820),
          ),
          decoration: _buildInputDecoration(
            hintText: 'เช่น ล่องแพเปียกแม่น้ำแควซอย 5 ชมทิวทัศน์ธรรมชาติ',
            prefixIcon: Icons.title_rounded,
          ),
        ),

        const SizedBox(height: 16),

        // Summary Input
        _buildFieldLabel('เรื่องย่อ / รายละเอียดบทความ'),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller.summaryController,
          maxLines: 4,
          style: GoogleFonts.krub(fontSize: 14, color: const Color(0xFF332820)),
          decoration: _buildInputDecoration(
            hintText:
                'อธิบายรายละเอียด บรรยากาศ จุดเด่น หรือข้อมูลที่น่าสนใจ...',
          ),
        ),

        const SizedBox(height: 16),

        // Category Dropdown
        _buildFieldLabel('หมวดหมู่บทความ *'),
        const SizedBox(height: 6),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedCategoryId.value,
                isExpanded: true,
                hint: Text(
                  'เลือกหมวดหมู่',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: const Color(0xFF786B62),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFD96C2C),
                ),
                items: controller.categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Text(
                      c.name,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        color: const Color(0xFF332820),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => controller.selectedCategoryId.value = val,
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Status Selection (Published vs Draft)
        _buildFieldLabel('สถานะการเผยแพร่'),
        const SizedBox(height: 8),
        Obx(() {
          return Row(
            children: [
              Expanded(
                child: _buildStatusChoiceTile(
                  label: '🟢 เผยแพร่ทันที',
                  value: 'Published',
                  selectedValue: controller.selectedStatus.value,
                  onTap: () => controller.selectedStatus.value = 'Published',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusChoiceTile(
                  label: '📝 บันทึกร่าง',
                  value: 'Draft',
                  selectedValue: controller.selectedStatus.value,
                  onTap: () => controller.selectedStatus.value = 'Draft',
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMediaSection(CreateContentController controller) {
    return _buildSectionCard(
      title: 'สื่อและวิดีโอประกอบ',
      icon: Icons.video_library_outlined,
      children: [
        _buildFieldLabel('ลิงก์วิดีโอ YouTube (URL)'),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller.youtubeUrlController,
          onChanged: (_) => controller.update(),
          style: GoogleFonts.krub(fontSize: 14, color: const Color(0xFF332820)),
          decoration: _buildInputDecoration(
            hintText: 'https://www.youtube.com/watch?v=...',
            prefixIcon: Icons.play_circle_outline_rounded,
          ),
        ),
        const SizedBox(height: 12),

        // YouTube Live Thumbnail Preview
        Obx(() {
          final thumb = controller.youtubeThumbnailUrl;
          if (thumb.isEmpty) return const SizedBox.shrink();

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    thumb,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'พบวิดีโอ YouTube พร้อมแสดงภาพตัวอย่าง',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF059669),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLocationSection(CreateContentController controller) {
    return _buildSectionCard(
      title: 'สถานที่และพิกัดที่ตั้ง',
      icon: Icons.location_on_outlined,
      children: [
        // District Picker
        _buildFieldLabel('อำเภอ'),
        const SizedBox(height: 6),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedDistrictId.value,
                isExpanded: true,
                hint: Text(
                  'เลือกอำเภอ',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: const Color(0xFF786B62),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFD96C2C),
                ),
                items: controller.districts.map((d) {
                  return DropdownMenuItem<String>(
                    value: d.id,
                    child: Text(
                      d.name,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        color: const Color(0xFF332820),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => controller.onDistrictChanged(val),
              ),
            ),
          );
        }),

        const SizedBox(height: 14),

        // SubDistrict Picker
        _buildFieldLabel('ตำบล'),
        const SizedBox(height: 6),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedSubDistrictId.value,
                isExpanded: true,
                hint: Text(
                  controller.subDistricts.isEmpty
                      ? 'กรุณาเลือกอำเภอก่อน'
                      : 'เลือกตำบล',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: const Color(0xFF786B62),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFD96C2C),
                ),
                items: controller.subDistricts.map((s) {
                  return DropdownMenuItem<String>(
                    value: s.id,
                    child: Text(
                      s.name,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        color: const Color(0xFF332820),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: controller.subDistricts.isEmpty
                    ? null
                    : (val) => controller.selectedSubDistrictId.value = val,
              ),
            ),
          );
        }),

        const SizedBox(height: 14),

        // Related Shop Picker (Optional)
        _buildFieldLabel('ร้านค้าที่เกี่ยวข้อง (ถ้ามี)'),
        const SizedBox(height: 6),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedShopId.value,
                isExpanded: true,
                hint: Text(
                  'เลือกร้านค้าชุมชนที่เกี่ยวข้อง (ระบุหรือไม่ก็ได้)',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF786B62),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFD96C2C),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '-- ไม่ระบุร้านค้า --',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ),
                  ...controller.shops.map((sh) {
                    return DropdownMenuItem<String>(
                      value: sh.id,
                      child: Text(
                        sh.name,
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          color: const Color(0xFF332820),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (val) => controller.selectedShopId.value = val,
              ),
            ),
          );
        }),

        const SizedBox(height: 14),

        // Latitude & Longitude Inputs
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('ละติจูด (Latitude)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      color: const Color(0xFF332820),
                    ),
                    decoration: _buildInputDecoration(hintText: '14.0227'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('ลองจิจูด (Longitude)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      color: const Color(0xFF332820),
                    ),
                    decoration: _buildInputDecoration(hintText: '99.5328'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(CreateContentController controller) {
    return Obx(() {
      final isSubmitting = controller.isSubmitting.value;

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: isSubmitting ? null : () => controller.submitContent(),
          icon: isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 20),
          label: Text(
            isSubmitting
                ? 'กำลังบันทึกข้อมูล...'
                : (controller.isEditing ? 'บันทึกการแก้ไข' : 'เผยแพร่คอนเทนต์'),
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD96C2C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
        ),
      );
    });
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD96C2C), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.krub(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF332820),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.krub(
        fontSize: 13.5,
        color: const Color(0xFF786B62),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: const Color(0xFFD96C2C), size: 20)
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD96C2C), width: 1.8),
      ),
    );
  }

  Widget _buildStatusChoiceTile({
    required String label,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedValue == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD96C2C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD96C2C)
                : const Color(0xFFE8D9C9),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF332820),
            ),
          ),
        ),
      ),
    );
  }
}
