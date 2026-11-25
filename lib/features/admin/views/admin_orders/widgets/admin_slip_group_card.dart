import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/orders/views/order_date_format.dart';
import 'package:projecte/features/admin/controllers/admin_orders_controller.dart';
import 'package:projecte/features/admin/models/admin_order_slip_model.dart';
import 'admin_slip_image_viewer.dart';

class AdminSlipGroupCard extends StatelessWidget {
  final AdminOrdersController controller;
  final AdminPendingSlipGroup group;
  final int index;

  const AdminSlipGroupCard({
    super.key,
    required this.controller,
    required this.group,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header: Buyer & Slip Total Bar
          _buildHeader(context),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // 2. Main Content: Slip Picture Preview & Order Breakdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSlipAndOrdersContent(context),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),
                // 3. Action Buttons (Approve & Reject)
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    String formattedTime = '-';
    if (group.uploadDateTime != null) {
      formattedTime = formatOrderDate(group.uploadDateTime!);
    } else if (group.slipUploadedAt != null) {
      formattedTime = group.slipUploadedAt!;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AdminColors.primaryDark,
                  AdminColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AdminColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Buyer identity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        group.buyerName?.isNotEmpty == true
                            ? group.buyerName!
                            : 'ลูกค้าทั่วไป',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AdminColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Color(0xFF92400E),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'รอตรวจสอบ',
                            style: GoogleFonts.krub(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (group.buyerPhone?.isNotEmpty == true) ...[
                      const Icon(
                        Icons.phone_outlined,
                        size: 12,
                        color: AdminColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        group.buyerPhone!,
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: AdminColors.textSecondary,
                        ),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                      ),
                    ],
                    Flexible(
                      child: Text(
                        'โอนเมื่อ: $formattedTime',
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          color: AdminColors.textSecondary,
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

          const SizedBox(width: 8),

          // Total Slip Amount Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AdminColors.primary.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: AdminColors.primary.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ยอดเงินในสลิป',
                  style: GoogleFonts.krub(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textSecondary,
                  ),
                ),
                Text(
                  '฿${group.totalGroupAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AdminColors.primaryDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Content: Slip preview + Included orders ---
  Widget _buildSlipAndOrdersContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 580;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slip Preview Box
              SizedBox(
                width: 170,
                child: _buildSlipImageThumbnail(context, height: 220),
              ),
              const SizedBox(width: 16),
              // Orders list breakdown
              Expanded(
                child: _buildOrdersList(),
              ),
            ],
          );
        }

        // Mobile Layout (Stacked)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slip Thumbnail
                SizedBox(
                  width: 120,
                  child: _buildSlipImageThumbnail(context, height: 160),
                ),
                const SizedBox(width: 14),
                // Summary description & Quick inspection button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AdminColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'รวม ${group.orders.length} ร้านค้าในสลิปนี้',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'กรุณาตรวจสอบยอดเงินและเลขบัญชีในสลิปให้ตรงกับยอดชำระรวมก่อนกดอนุมัติ',
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: AdminColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AdminColors.primaryDark,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.zoom_in_rounded, size: 16),
                        label: Text(
                          'ดูรูปสลิปขยายเต็มจอ',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _openImageViewer(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Orders Breakdown
            _buildOrdersList(),
          ],
        );
      },
    );
  }

  // --- Slip Image Thumbnail ---
  Widget _buildSlipImageThumbnail(BuildContext context, {required double height}) {
    final hasImage = group.slipImageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () => _openImageViewer(context),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Image.network(
                  group.slipImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                        color: AdminColors.primary,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image_rounded,
                          color: Color(0xFF94A3B8),
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'โหลดรูปไม่สำเร็จ',
                          style: GoogleFonts.krub(
                            fontSize: 10,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  color: const Color(0xFFF8FAFC),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_outlined,
                        color: Color(0xFF94A3B8),
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ไม่มีรูปสลิป',
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Overlay Hint
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.zoom_in_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'แตะเพื่อขยาย',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context) {
    if (group.slipImageUrl.isEmpty) {
      Get.snackbar(
        'แจ้งเตือน',
        'ไม่พบไฟล์รูปสลิปในรายการนี้',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    AdminSlipImageViewer.show(
      context: context,
      imageUrl: group.slipImageUrl,
      buyerName: group.buyerName,
      amountText: '฿${group.totalGroupAmount.toStringAsFixed(2)}',
    );
  }

  // --- Orders List in this slip ---
  Widget _buildOrdersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.store_mall_directory_rounded,
              color: AdminColors.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'คำสั่งซื้อในสลิปนี้ (${group.orders.length} ร้านค้า):',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                color: AdminColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Order list cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: group.orders.length,
          separatorBuilder: (context, i) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final ord = group.orders[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order number & Shop badge & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Text(
                              '#${ord.orderNumber ?? ord.orderId.substring(0, 8)}',
                              style: GoogleFonts.krub(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AdminColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AdminColors.primary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                ord.shopName?.isNotEmpty == true
                                    ? ord.shopName!
                                    : 'ร้านค้าชุมชน',
                                style: GoogleFonts.krub(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '฿${ord.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: AdminColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Order items list
                  if (ord.items.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 6),
                    ...ord.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '• ${item.productName} ×${item.quantity}',
                                style: GoogleFonts.krub(
                                  fontSize: 11.5,
                                  color: AdminColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '฿${item.totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Action Buttons ---
  Widget _buildActionButtons(BuildContext context) {
    return Obx(() {
      final isProcessingThisCard = controller.processingSlipIndex.value == index;
      final isAnyProcessing = controller.isProcessingAction.value;

      return Row(
        children: [
          // Reject Button
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE11D48),
                backgroundColor: const Color(0xFFFFF1F2),
                side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(
                'ปฏิเสธสลิป',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onPressed: isAnyProcessing
                  ? null
                  : () => _confirmAction(context, action: 'Reject'),
            ),
          ),

          const SizedBox(width: 12),

          // Approve Button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primary,
                foregroundColor: Colors.white,
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: isAnyProcessing
                  ? null
                  : () => _confirmAction(context, action: 'Approve'),
              child: isProcessingThisCard
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'กำลังดำเนินการ...',
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 19,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'อนุมัติสลิปชำระเงิน',
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }

  // --- Confirmation Bottom Sheet ---
  void _confirmAction(BuildContext context, {required String action}) {
    final isApprove = action == 'Approve';
    final count = group.orders.length;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isApprove
                      ? AdminColors.primary.withValues(alpha: 0.12)
                      : const Color(0xFFFFF1F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isApprove
                      ? Icons.check_circle_rounded
                      : Icons.warning_amber_rounded,
                  color: isApprove ? AdminColors.primary : const Color(0xFFE11D48),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isApprove
                    ? 'ยืนยันอนุมัติสลิปการชำระเงิน?'
                    : 'ยืนยันปฏิเสธสลิปการชำระเงิน?',
                style: GoogleFonts.krub(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                isApprove
                    ? 'ระบบจะเปลี่ยนสถานะการชำระเงินของ $count คำสั่งซื้อในสลิปนี้เป็น "ชำระเงินแล้ว (Paid)" และแจ้งเตือนร้านค้าเตรียมจัดส่งสินค้า'
                    : 'ระบบจะเปลี่ยนสถานะการชำระเงินเป็น "ไม่ผ่านการอนุมัติ (Failed)" ลูกค้าจะต้องชำระเงินหรืออัปโหลดสลิปใหม่',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Summary Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ยอดเงินที่ยืนยัน:',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                    Text(
                      '฿${group.totalGroupAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.krub(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isApprove
                            ? AdminColors.primaryDark
                            : const Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'ยกเลิก',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          color: AdminColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApprove
                            ? AdminColors.primary
                            : const Color(0xFFE11D48),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.verifySlipGroup(
                          group: group,
                          index: index,
                          action: action,
                        );
                      },
                      child: Text(
                        isApprove ? 'ยืนยันอนุมัติ' : 'ยืนยันปฏิเสธ',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
      isScrollControlled: true,
    );
  }
}
