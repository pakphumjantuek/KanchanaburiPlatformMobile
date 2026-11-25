import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_submit_button.dart';

class ProductDealDetailsCard extends StatelessWidget {
  const ProductDealDetailsCard({
    super.key,
    required this.dealType,
    required this.onDealTypeChanged,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountController,
    required this.quantityController,
    required this.startsController,
    required this.endsController,
    required this.onStartTap,
    required this.onEndTap,
    required this.isSaving,
    required this.onSave,
    this.maxStock,
  });

  final String dealType;
  final ValueChanged<String> onDealTypeChanged;
  final String discountType;
  final ValueChanged<String> onDiscountTypeChanged;
  final TextEditingController discountController;
  final TextEditingController quantityController;
  final TextEditingController startsController;
  final TextEditingController endsController;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final bool isSaving;
  final VoidCallback onSave;
  final int? maxStock;

  @override
  Widget build(BuildContext context) {
    final isPercent = discountType == 'Percent';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MerchantColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: MerchantColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MerchantColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: MerchantColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'กำหนดเงื่อนไขโปรโมชัน',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    Text(
                      'เลือกประเภท ส่วนลด จำนวนสิทธิ์ และช่วงเวลา',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: MerchantColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // 1. Deal Type Selector (Flash Deal vs Local Deal)
          Text(
            'ประเภทโปรโมชัน *',
            style: GoogleFonts.krub(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: MerchantColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTypeOption(
                  title: 'Flash Deal',
                  subtitle: 'โปรลดด่วนพิเศษ',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFD97706),
                  isSelected: dealType == 'FlashDeal',
                  onTap: () => onDealTypeChanged('FlashDeal'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTypeOption(
                  title: 'Local Deal',
                  subtitle: 'โปรเด็ดชุมชน',
                  icon: Icons.storefront_rounded,
                  color: const Color(0xFF059669),
                  isSelected: dealType == 'LocalDeal',
                  onTap: () => onDealTypeChanged('LocalDeal'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2. Discount Type (Percent vs Fixed)
          Text(
            'รูปแบบส่วนลด *',
            style: GoogleFonts.krub(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: MerchantColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDiscountTypeChip(
                  label: 'ลดเป็นเปอร์เซ็นต์ (%)',
                  icon: Icons.percent_rounded,
                  isSelected: isPercent,
                  onTap: () => onDiscountTypeChanged('Percent'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDiscountTypeChip(
                  label: 'ลดเป็นจำนวนเงิน (฿)',
                  icon: Icons.payments_outlined,
                  isSelected: !isPercent,
                  onTap: () => onDiscountTypeChanged('FixedAmount'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3. Discount Value & Quota Inputs
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPercent ? 'ส่วนลด (%) *' : 'ส่วนลด (บาท) *',
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: discountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: isPercent ? 'เช่น 15' : 'เช่น 50',
                        prefixIcon: Icon(
                          isPercent ? Icons.percent_rounded : Icons.money_rounded,
                          size: 18,
                          color: MerchantColors.primary,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.primary, width: 1.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'จำนวนสิทธิ์ *',
                      style: GoogleFonts.krub(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: maxStock != null ? 'สูงสุด $maxStock' : 'เช่น 10',
                        prefixIcon: const Icon(
                          Icons.confirmation_number_outlined,
                          size: 18,
                          color: MerchantColors.primary,
                        ),
                        suffixText: 'สิทธิ์',
                        suffixStyle: GoogleFonts.krub(fontSize: 11, color: MerchantColors.textSecondary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MerchantColors.primary, width: 1.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 4. Date & Time Range Pickers
          Text(
            'ช่วงเวลาโปรโมชัน *',
            style: GoogleFonts.krub(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: MerchantColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          _buildDateTimeTile(
            label: 'เวลาเริ่มต้น',
            controller: startsController,
            onTap: onStartTap,
            icon: Icons.calendar_today_rounded,
          ),
          const SizedBox(height: 10),
          _buildDateTimeTile(
            label: 'เวลาสิ้นสุด',
            controller: endsController,
            onTap: onEndTap,
            icon: Icons.event_available_rounded,
          ),

          const SizedBox(height: 22),

          // Submit CTA
          ProductDealSubmitButton(isSaving: isSaving, onPressed: onSave),
        ],
      ),
    );
  }

  Widget _buildTypeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.08) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : MerchantColors.border,
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? color : const Color(0xFF94A3B8), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : MerchantColors.textPrimary,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        color: MerchantColors.textSecondary,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountTypeChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? MerchantColors.primary : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? MerchantColors.primary : MerchantColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : MerchantColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : MerchantColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeTile({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MerchantColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: MerchantColors.primary),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      color: MerchantColors.textSecondary,
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (_, value, _) {
                      return Text(
                        value.text.isNotEmpty ? value.text : 'แตะเพื่อเลือกวันและเวลา',
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: MerchantColors.textPrimary,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.edit_calendar_rounded, size: 16, color: MerchantColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
