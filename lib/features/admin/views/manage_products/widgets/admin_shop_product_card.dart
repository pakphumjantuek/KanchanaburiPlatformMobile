import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/controllers/admin_products_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';

class AdminShopProductCard extends StatelessWidget {
  const AdminShopProductCard({
    super.key,
    required this.product,
    required this.controller,
  });

  final ProductModel product;
  final AdminProductsController controller;

  @override
  Widget build(BuildContext context) {
    final isActive = product.status.toLowerCase() == 'active';
    final isOutOfStock = product.quantity <= 0;
    final isLowStock = product.quantity > 0 && product.quantity <= 5;
    final hasDeal = product.activeDeal != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: !isActive
              ? const Color(0xFFFECACA)
              : isOutOfStock
                  ? const Color(0xFFFED7AA)
                  : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showProductDetailSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container with Deal Tag
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: product.imageUrl != null &&
                                product.imageUrl!.isNotEmpty
                            ? Image.network(
                                product.imageUrl!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 26,
                                ),
                              )
                            : const Icon(
                                Icons.inventory_2_outlined,
                                color: Color(0xFF94A3B8),
                                size: 26,
                              ),
                      ),
                    ),
                    if (hasDeal)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(11),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            product.activeDeal!.discountType.toLowerCase() ==
                                    'percent'
                                ? '-${product.activeDeal!.discountValue.toInt()}%'
                                : 'ลด ฿${product.activeDeal!.discountValue.toInt()}',
                            style: GoogleFonts.krub(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Middle: Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            '฿${product.dealPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          if (hasDeal) ...[
                            const SizedBox(width: 6),
                            Text(
                              '฿${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Stock Status & Quantity Badge
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isOutOfStock
                                  ? const Color(0xFFFEF2F2)
                                  : isLowStock
                                      ? const Color(0xFFFFFBEB)
                                      : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isOutOfStock
                                    ? const Color(0xFFFECACA)
                                    : isLowStock
                                        ? const Color(0xFFFDE68A)
                                        : const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isOutOfStock
                                      ? Icons.highlight_off_rounded
                                      : isLowStock
                                          ? Icons.warning_amber_rounded
                                          : Icons.inventory_2_outlined,
                                  size: 11,
                                  color: isOutOfStock
                                      ? const Color(0xFFDC2626)
                                      : isLowStock
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isOutOfStock
                                      ? 'หมดสต็อก (0)'
                                      : isLowStock
                                          ? 'เหลือน้อย (${product.quantity})'
                                          : 'คลัง: ${product.quantity} ชิ้น',
                                  style: GoogleFonts.krub(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isOutOfStock
                                        ? const Color(0xFFDC2626)
                                        : isLowStock
                                            ? const Color(0xFFB45309)
                                            : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Right: Status Switch
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32,
                      child: Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: isActive,
                          activeThumbColor: const Color(0xFF059669),
                          activeTrackColor: const Color(0xFFA7F3D0),
                          inactiveThumbColor: const Color(0xFF94A3B8),
                          inactiveTrackColor: const Color(0xFFE2E8F0),
                          onChanged: (_) => controller.toggleProductStatus(
                            product.id,
                            product.status,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? 'วางขายอยู่' : 'ระงับการขาย',
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                      ),
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

  void _showProductDetailSheet(BuildContext context) {
    final isActive = product.status.toLowerCase() == 'active';
    final hasDeal = product.activeDeal != null;

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

              // Product Image Display
              if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                Center(
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ),

              // Title & Status Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.krub(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '฿${product.dealPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF059669),
                              ),
                            ),
                            if (hasDeal) ...[
                              const SizedBox(width: 8),
                              Text(
                                '฿${product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.krub(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              // Stock & Inventory info
              Text(
                'ข้อมูลสินค้าและคลัง',
                style: GoogleFonts.krub(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('รหัสสินค้า', product.id),
              _buildDetailRow('จำนวนคงเหลือในคลัง', '${product.quantity} ชิ้น'),
              _buildDetailRow('สถานะการวางจำหน่าย',
                  isActive ? 'วางจำหน่ายอยู่ (Active)' : 'ระงับการขาย (Inactive)'),
              if (product.productCategoryId != null)
                _buildDetailRow('รหัสหมวดหมู่', product.productCategoryId!),

              if (product.description != null &&
                  product.description!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'รายละเอียดสินค้า',
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    product.description!,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Action Switch Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    controller.toggleProductStatus(product.id, product.status);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isActive
                        ? 'ระงับการวางจำหน่ายสินค้านี้'
                        : 'เปิดการวางจำหน่ายสินค้านี้',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

