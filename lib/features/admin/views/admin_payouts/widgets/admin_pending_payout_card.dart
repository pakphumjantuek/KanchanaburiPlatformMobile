import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';
import 'package:projecte/features/admin/models/admin_order_slip_model.dart';
import 'admin_confirm_payout_dialog.dart';

class AdminPendingPayoutCard extends StatefulWidget {
  const AdminPendingPayoutCard({
    super.key,
    required this.controller,
    required this.payout,
  });

  final AdminPayoutsController controller;
  final AdminMerchantPayoutGroup payout;

  @override
  State<AdminPendingPayoutCard> createState() => _AdminPendingPayoutCardState();
}

class _AdminPendingPayoutCardState extends State<AdminPendingPayoutCard> {
  bool _isOrdersExpanded = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'คัดลอกสำเร็จ',
      'คัดลอก$label: $text เรียบร้อยแล้ว',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: AdminColors.primaryDark,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final payout = widget.payout;
    final logoUrl = payout.shopLogoUrl != null && payout.shopLogoUrl!.isNotEmpty
        ? AdminPendingSlipGroup.resolveSlipUrl(payout.shopLogoUrl!)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Shop Header & Total Amount
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop Avatar / Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AdminColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AdminColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: logoUrl != null
                        ? Image.network(
                            logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildInitialAvatar(payout.shopName),
                          )
                        : _buildInitialAvatar(payout.shopName),
                  ),
                ),
                const SizedBox(width: 12),

                // Shop Name & Order Count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payout.shopName,
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: AdminColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AdminColors.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ชำระแล้ว ${payout.paidOrdersCount} คำสั่งซื้อ',
                                style: GoogleFonts.krub(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.secondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ยอดรอโอน',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                    Text(
                      '฿${payout.totalSalesAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AdminColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Bank Information Card (Financial card style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AdminColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_rounded,
                          size: 14,
                          color: AdminColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                payout.bankName ?? 'ข้อมูลบัญชีธนาคาร',
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AdminColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (payout.bankAccountName != null && payout.bankAccountName!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '(${payout.bankAccountName})',
                                  style: GoogleFonts.krub(
                                    fontSize: 11.5,
                                    color: AdminColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Account Number with Copy
                  if (payout.bankAccountNumber != null && payout.bankAccountNumber!.isNotEmpty)
                    _buildCopyableRow(
                      label: 'เลขที่บัญชี',
                      value: payout.bankAccountNumber!,
                      onCopy: () => _copyToClipboard(payout.bankAccountNumber!, 'เลขที่บัญชี'),
                    ),

                  // PromptPay with Copy
                  if (payout.promptPay != null && payout.promptPay!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildCopyableRow(
                      label: 'พร้อมเพย์',
                      value: payout.promptPay!,
                      onCopy: () => _copyToClipboard(payout.promptPay!, 'พร้อมเพย์'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 3. Expandable Order Breakdown
          if (payout.orders.isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _isOrdersExpanded = !_isOrdersExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _isOrdersExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AdminColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isOrdersExpanded
                          ? 'ซ่อนรายการคำสั่งซื้อ'
                          : 'ดูรายการคำสั่งซื้อที่รวมอยู่ในยอดนี้ (${payout.orders.length} รายการ)',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isOrdersExpanded)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: payout.orders.map((order) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#${order.orderNumber}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.textPrimary,
                            ),
                          ),
                          Text(
                            '฿${order.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],

          const SizedBox(height: 12),

          // 4. Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(
                  'ดำเนินการโอน & แนบสลิป',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                onPressed: () => AdminConfirmPayoutDialog.show(
                  context: context,
                  controller: widget.controller,
                  payout: payout,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    final initial = name.isNotEmpty ? name[0] : 'S';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.krub(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AdminColors.primary,
        ),
      ),
    );
  }

  Widget _buildCopyableRow({
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                '$label: ',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  color: AdminColors.textSecondary,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AdminColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.copy_rounded, size: 12, color: AdminColors.primary),
                const SizedBox(width: 4),
                Text(
                  'คัดลอก',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
