import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';

class MerchantDashboardShopHeader extends StatelessWidget {
  const MerchantDashboardShopHeader({super.key, required this.shop});

  final dynamic shop;

  @override
  Widget build(BuildContext context) {
    final shop = this.shop;
    final shopName = shop?.name ?? 'ยังไม่มีชื่อร้านค้า';
    final categoryName = shop?.categoryName ?? 'ผู้ประกอบการชุมชน';
    final districtName = shop?.districtName ?? 'กาญจนบุรี';
    final status = shop?.status ?? 'None';
    final coverImage = shop?.coverImageUrl ?? shop?.backgroundImageUrl;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative ambient circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Shop Avatar Circle
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        image:
                            (coverImage != null &&
                                coverImage.toString().isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(coverImage.toString()),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (coverImage == null || coverImage.toString().isEmpty)
                          ? const Icon(
                              Icons.storefront_rounded,
                              color: Colors.white,
                              size: 32,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  shopName,
                                  style: GoogleFonts.krub(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusPill(status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFFA7F3D0),
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$categoryName • อ.$districtName',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFD1FAE5),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xFFA7F3D0),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ระบบแดชบอร์ดร้านค้ากาญจนบุรี',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.registerShop),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'แก้ไขร้านค้า',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFA7F3D0),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFA7F3D0),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFF64748B);
    String label = 'ยังไม่ลงทะเบียน';
    IconData icon = Icons.help_outline_rounded;

    if (status == 'Active') {
      bg = const Color(0xFF10B981);
      label = 'เปิดใช้งาน';
      icon = Icons.check_circle_rounded;
    } else if (status == 'PendingApproval') {
      bg = const Color(0xFFF59E0B);
      label = 'รออนุมัติ';
      icon = Icons.access_time_filled_rounded;
    } else if (status == 'Rejected') {
      bg = const Color(0xFFEF4444);
      label = 'ถูกปฏิเสธ';
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
