import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/controllers/admin_shops_controller.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'admin_shop_status_badge.dart';

class AdminShopCard extends StatelessWidget {
  const AdminShopCard({
    super.key,
    required this.shop,
    required this.controller,
  });

  final ShopModel shop;
  final AdminShopsController controller;

  @override
  Widget build(BuildContext context) {
    final isPending = shop.status.toLowerCase() == 'pending' ||
        shop.status.toLowerCase() == 'pendingapproval';
    final isActive = shop.status.toLowerCase() == 'active' ||
        shop.status.toLowerCase() == 'approved';
    final isSuspended = shop.status.toLowerCase() == 'suspended';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending
              ? const Color(0xFFFDE68A)
              : const Color(0xFFE2E8F0),
          width: isPending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPending
                ? const Color(0xFFF59E0B).withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showShopDetailSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Shop Name + Category + Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Avatar / Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AdminColors.primaryDark.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: shop.coverImageUrl != null &&
                                shop.coverImageUrl!.isNotEmpty
                            ? Image.network(
                                shop.coverImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => const Icon(
                                  Icons.storefront_rounded,
                                  color: AdminColors.primary,
                                  size: 26,
                                ),
                              )
                            : const Icon(
                                Icons.storefront_rounded,
                                color: AdminColors.primary,
                                size: 26,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),


                    // Shop Name & Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.shopName,
                            style: GoogleFonts.krub(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.category_outlined,
                                      size: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 3),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 120),
                                      child: Text(
                                        shop.categoryName ?? 'หมวดทั่วไป',
                                        style: GoogleFonts.krub(
                                          fontSize: 11,
                                          color: const Color(0xFF475569),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (shop.openingTime != null &&
                                  shop.closingTime != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: shop.isOpenNow
                                        ? const Color(0xFFECFDF5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    shop.isOpenNow ? 'เปิดอยู่' : 'ปิดอยู่',
                                    style: GoogleFonts.krub(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: shop.isOpenNow
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Status Badge
                    AdminShopStatusBadge(status: shop.status, isCompact: true),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                // Location Row
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _buildLocationString(),
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Contact Row (Phone & Email with Wrap to prevent overflow)
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop.phone ?? 'ไม่ระบุเบอร์',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        if (shop.phone != null && shop.phone!.isNotEmpty) ...[
                          const SizedBox(width: 3),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: shop.phone!));
                              Get.snackbar(
                                'คัดลอกแล้ว',
                                'คัดลอกเบอร์โทร ${shop.phone} แล้ว',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (shop.email != null && shop.email!.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.mail_outline_rounded,
                            size: 13,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              shop.email!,
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                color: const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Bank Account Info Badge (If exists)
                if ((shop.bankName != null && shop.bankAccountNumber != null) ||
                    shop.promptPay != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 13,
                          color: AdminColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            shop.bankName != null
                                ? '${shop.bankName} ${shop.bankAccountNumber ?? ''}${shop.bankAccountName != null && shop.bankAccountName!.isNotEmpty ? " (${shop.bankAccountName})" : ""}'
                                : 'พร้อมเพย์: ${shop.promptPay ?? ''}',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],


                const SizedBox(height: 12),

                // Action Buttons Row
                Row(
                  children: [
                    // Pending State: Direct Approve / Suspend
                    if (isPending) ...[
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmChangeStatus(
                            context,
                            newStatus: 'Active',
                            title: 'อนุมัติเปิดใช้งานร้านค้า',
                            message: 'คุณต้องการอนุมัติร้าน "${shop.shopName}" เพื่อเปิดให้บริการใช่หรือไม่?',
                            confirmColor: const Color(0xFF059669),
                            confirmIcon: Icons.check_circle_rounded,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
                          label: Text(
                            'อนุมัติร้าน',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmChangeStatus(
                            context,
                            newStatus: 'Suspended',
                            title: 'ปฏิเสธ / ระงับร้านค้า',
                            message: 'คุณต้องการระงับร้าน "${shop.shopName}" ใช่หรือไม่?',
                            confirmColor: const Color(0xFFDC2626),
                            confirmIcon: Icons.cancel_rounded,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.cancel_outlined, size: 15),
                          label: Text(
                            'ปฏิเสธ',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ] else ...[
                      // Active or Suspended State
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.toNamed(AppRoutes.adminShopProducts, arguments: shop);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AdminColors.primary,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.inventory_2_outlined, size: 15),
                          label: Text(
                            'สินค้าในร้าน',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      if (isActive)
                        OutlinedButton.icon(
                          onPressed: () => _confirmChangeStatus(
                            context,
                            newStatus: 'Suspended',
                            title: 'ระงับการใช้งานร้านค้า',
                            message: 'ร้านค้าจะไม่สามารถขายสินค้าได้ชั่วคราว คุณแน่ใจหรือไม่?',
                            confirmColor: const Color(0xFFDC2626),
                            confirmIcon: Icons.block_rounded,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.block_rounded, size: 14),
                          label: Text(
                            'ระงับ',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (isSuspended)
                        ElevatedButton.icon(
                          onPressed: () => _confirmChangeStatus(
                            context,
                            newStatus: 'Active',
                            title: 'ปลดระงับและเปิดใช้งาน',
                            message: 'เปิดให้บริการร้านค้า "${shop.shopName}" อีกครั้ง?',
                            confirmColor: const Color(0xFF059669),
                            confirmIcon: Icons.lock_open_rounded,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.lock_open_rounded, size: 14),
                          label: Text(
                            'ปลดระงับ',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],


                    const SizedBox(width: 6),

                    // More Menu Button (Change Status to any or view details)
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                          color: Color(0xFF475569),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'detail') {
                          _showShopDetailSheet(context);
                        } else {
                          _confirmChangeStatus(
                            context,
                            newStatus: value,
                            title: 'เปลี่ยนสถานะเป็น ${AdminShopsController.getStatusThai(value)}',
                            message: 'คุณต้องการเปลี่ยนสถานะร้าน "${shop.shopName}" เป็น ${AdminShopsController.getStatusThai(value)} ใช่หรือไม่?',
                            confirmColor: value == 'Active'
                                ? const Color(0xFF059669)
                                : value == 'Suspended'
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFF475569),
                            confirmIcon: Icons.sync_rounded,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'detail',
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 18, color: AdminColors.primary),
                              const SizedBox(width: 8),
                              Text('ดูรายละเอียดทั้งหมด', style: GoogleFonts.krub(fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'Active',
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF059669)),
                              const SizedBox(width: 8),
                              Text('ตั้งเป็น เปิดใช้งาน (Active)', style: GoogleFonts.krub(fontSize: 13)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Suspended',
                          child: Row(
                            children: [
                              const Icon(Icons.block_rounded, size: 18, color: Color(0xFFDC2626)),
                              const SizedBox(width: 8),
                              Text('ตั้งเป็น ระงับ (Suspended)', style: GoogleFonts.krub(fontSize: 13)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Closed',
                          child: Row(
                            children: [
                              const Icon(Icons.lock_clock_rounded, size: 18, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Text('ตั้งเป็น ปิดบริการ (Closed)', style: GoogleFonts.krub(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildLocationString() {
    final parts = <String>[];
    if (shop.subDistrictName != null && shop.subDistrictName!.isNotEmpty) {
      parts.add(shop.subDistrictName!);
    }
    if (shop.districtName != null && shop.districtName!.isNotEmpty) {
      parts.add(shop.districtName!);
    }
    if (parts.isEmpty && shop.address != null && shop.address!.isNotEmpty) {
      return shop.address!;
    }
    return parts.isEmpty ? 'ไม่ระบุสถานที่' : parts.join(', ');
  }

  void _confirmChangeStatus(
    BuildContext context, {
    required String newStatus,
    required String title,
    required String message,
    required Color confirmColor,
    required IconData confirmIcon,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: confirmColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(confirmIcon, color: confirmColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.krub(
            fontSize: 14,
            color: const Color(0xFF475569),
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              controller.changeShopStatus(shop.shopId, newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'ยืนยัน',
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShopDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AdminColors.primaryDark.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: shop.coverImageUrl != null &&
                              shop.coverImageUrl!.isNotEmpty
                          ? Image.network(
                              shop.coverImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.storefront_rounded,
                                color: AdminColors.primary,
                                size: 30,
                              ),
                            )
                          : const Icon(
                              Icons.storefront_rounded,
                              color: AdminColors.primary,
                              size: 30,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.shopName,
                          style: GoogleFonts.krub(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            AdminShopStatusBadge(status: shop.status, isCompact: true),
                            const SizedBox(width: 8),
                            Text(
                              shop.categoryName ?? 'หมวดหมู่ทั่วไป',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              // Section: Description
              if (shop.description != null && shop.description!.isNotEmpty) ...[
                _buildSectionHeader('รายละเอียดร้านค้า'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    shop.description!,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Section: Contact & Location
              _buildSectionHeader('ข้อมูลการติดต่อและสถานที่'),
              const SizedBox(height: 8),
              _buildInfoTile(
                Icons.phone_rounded,
                'เบอร์โทรศัพท์',
                shop.phone ?? 'ไม่ระบุ',
                canCopy: shop.phone != null && shop.phone!.isNotEmpty,
              ),
              _buildInfoTile(
                Icons.email_rounded,
                'อีเมล',
                shop.email ?? 'ไม่ระบุ',
                canCopy: shop.email != null && shop.email!.isNotEmpty,
              ),
              _buildInfoTile(
                Icons.location_on_rounded,
                'ที่อยู่ร้านค้า',
                shop.address ?? 'ไม่ระบุที่อยู่',
              ),
              _buildInfoTile(
                Icons.map_rounded,
                'ตำบล / อำเภอ',
                '${shop.subDistrictName ?? '-'} / ${shop.districtName ?? '-'}',
              ),
              if (shop.openingTime != null && shop.closingTime != null)
                _buildInfoTile(
                  Icons.access_time_filled_rounded,
                  'เวลาทำการ',
                  '${shop.openingTime} - ${shop.closingTime} น. (${shop.isOpenNow ? "เปิดอยู่" : "ปิดอยู่"})',
                ),

              const SizedBox(height: 16),

              // Section: Financial Info
              _buildSectionHeader('ข้อมูลการรับเงินและบัญชีธนาคาร'),
              const SizedBox(height: 8),
              _buildInfoTile(
                Icons.account_balance_rounded,
                'ธนาคาร',
                shop.bankName ?? 'ไม่ระบุ',
              ),
              _buildInfoTile(
                Icons.person_rounded,
                'ชื่อบัญชี',
                shop.bankAccountName ?? 'ไม่ระบุ',
              ),
              _buildInfoTile(
                Icons.credit_card_rounded,
                'เลขบัญชีธนาคาร',
                shop.bankAccountNumber ?? 'ไม่ระบุ',
                canCopy: shop.bankAccountNumber != null && shop.bankAccountNumber!.isNotEmpty,
              ),
              _buildInfoTile(
                Icons.qr_code_rounded,
                'พร้อมเพย์',
                shop.promptPay ?? 'ไม่ระบุ',
                canCopy: shop.promptPay != null && shop.promptPay!.isNotEmpty,
              ),

              const SizedBox(height: 20),

              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(sheetCtx).pop();
                        Get.toNamed(AppRoutes.adminShopProducts, arguments: shop);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AdminColors.primary,
                        side: const BorderSide(color: AdminColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.inventory_2_outlined, size: 18),
                      label: Text(
                        'ดูสินค้าของร้านนี้',
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.krub(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    bool canCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.krub(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          if (canCopy)
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                Get.snackbar(
                  'คัดลอกสำเร็จ',
                  'คัดลอก $value ไปยังคลิปบอร์ดแล้ว',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.copy_rounded, size: 14, color: Color(0xFF94A3B8)),
              ),
            ),
        ],
      ),
    );
  }
}

