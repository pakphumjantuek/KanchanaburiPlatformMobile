import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_content_model.dart';

class AdminContentCard extends StatelessWidget {
  const AdminContentCard({
    super.key,
    required this.item,
    required this.controller,
    required this.onBindTags,
  });

  final AdminContentItem item;
  final AdminContentsController controller;
  final VoidCallback onBindTags;

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = [
        '',
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];
      final month = dt.month >= 1 && dt.month <= 12 ? months[dt.month] : '${dt.month}';
      final year = (dt.year + 543) % 100;
      return '${dt.day} $month $year';
    } catch (_) {
      return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  void _confirmToggleVisibility(BuildContext context, bool isClosing) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isClosing ? AdminColors.errorBg : AdminColors.successBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isClosing ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: isClosing ? AdminColors.error : AdminColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isClosing ? 'ยืนยันปิดคอนเทนต์' : 'ยืนยันเปิดคอนเทนต์',
                style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isClosing
              ? 'คุณต้องการปิดการแสดงผลคอนเทนต์ "${item.title}" ใช่หรือไม่? เมื่อปิดแล้ว คอนเทนต์จะไม่แสดงบนแอปผู้ใช้'
              : 'คุณต้องการเปิดการแสดงผลคอนเทนต์ "${item.title}" บนแอปผู้ใช้ใช่หรือไม่?',
          style: GoogleFonts.krub(fontSize: 13.5, color: AdminColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(
                color: AdminColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isClosing ? AdminColors.error : AdminColors.success,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.toggleContentVisibility(item);
            },
            child: Text(
              isClosing ? 'ยืนยันปิดคอนเทนต์' : 'ยืนยันเปิดคอนเทนต์',
              style: GoogleFonts.krub(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArchived = item.status.toLowerCase() == 'archived';
    final hasCategory = item.contentCategoryName != null && item.contentCategoryName!.isNotEmpty;
    final hasShop = item.shopName != null && item.shopName!.isNotEmpty;
    final hasLocation = (item.districtName != null && item.districtName!.isNotEmpty) ||
        (item.subDistrictName != null && item.subDistrictName!.isNotEmpty);
    final locationText = [
      if (item.subDistrictName != null && item.subDistrictName!.isNotEmpty) item.subDistrictName,
      if (item.districtName != null && item.districtName!.isNotEmpty) item.districtName,
    ].join(', ');
    final hasYoutube = item.youtubeUrl != null && item.youtubeUrl!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isArchived ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: isArchived ? 0.02 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasCategory) ...[
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: AdminColors.infoBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFBFDBFE), width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bookmark_outline_rounded, size: 12, color: AdminColors.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.contentCategoryName!,
                                style: GoogleFonts.krub(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (hasYoutube) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_fill, size: 12, color: Color(0xFFDC2626)),
                          const SizedBox(width: 3),
                          Text(
                            'Video',
                            style: GoogleFonts.krub(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const Spacer(),
                  _buildStatusBadge(item.status),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                item.title,
                style: GoogleFonts.krub(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: isArchived ? AdminColors.textSecondary : AdminColors.textPrimary,
                  height: 1.3,
                  decoration: isArchived ? TextDecoration.lineThrough : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Summary
              if (item.summary != null && item.summary!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  item.summary!,
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    color: AdminColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),

              // Metadata Tags Row
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (hasShop)
                    _buildMetaChip(
                      icon: Icons.storefront_outlined,
                      label: item.shopName!,
                      color: const Color(0xFF0284C7),
                    ),
                  if (hasLocation)
                    _buildMetaChip(
                      icon: Icons.location_on_outlined,
                      label: locationText,
                      color: const Color(0xFFD97706),
                    ),
                  _buildMetaChip(
                    icon: Icons.schedule_outlined,
                    label: _formatDate(item.publishedAt ?? item.createdAt),
                    color: AdminColors.textMuted,
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              // Footer Actions: Tag Binding & Toggle Visibility (No Edit)
              Row(
                children: [
                  // Bind Tag Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBindTags,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8338EC).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF8338EC).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.label_outlined,
                              size: 14,
                              color: Color(0xFF8338EC),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ผูกแท็กค้นหา',
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF8338EC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Toggle Visibility Button (Close / Open Content)
                  InkWell(
                    onTap: () => _confirmToggleVisibility(context, !isArchived),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isArchived
                            ? AdminColors.successBg
                            : AdminColors.errorBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isArchived
                              ? AdminColors.success.withValues(alpha: 0.3)
                              : AdminColors.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isArchived
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 15,
                            color: isArchived
                                ? AdminColors.success
                                : AdminColors.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isArchived ? 'เปิดแสดงผล' : 'ปิดคอนเทนต์',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isArchived
                                  ? AdminColors.success
                                  : AdminColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11.5,
            color: AdminColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'published':
        bg = AdminColors.successBg;
        fg = AdminColors.success;
        label = 'เผยแพร่แล้ว (เปิด)';
        icon = Icons.check_circle_rounded;
        break;
      case 'pending':
        bg = AdminColors.warningBg;
        fg = AdminColors.warning;
        label = 'รอตรวจสอบ';
        icon = Icons.access_time_filled_rounded;
        break;
      case 'archived':
        bg = AdminColors.errorBg;
        fg = AdminColors.error;
        label = 'ปิดคอนเทนต์แล้ว';
        icon = Icons.visibility_off_rounded;
        break;
      case 'draft':
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        label = 'แบบร่าง';
        icon = Icons.edit_note_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
