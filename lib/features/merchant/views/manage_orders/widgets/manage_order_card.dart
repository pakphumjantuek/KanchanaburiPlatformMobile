import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/orders/models/order_model.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_order_shipment_sheet.dart';

class ManageOrderCard extends StatelessWidget {
  const ManageOrderCard({
    super.key,
    required this.controller,
    required this.order,
  });

  final ManageOrdersController controller;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF059669),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ออเดอร์ #${order.orderNumber ?? order.id}',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(order.orderStatus),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Customer Info Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: Color(0xFF047857),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ผู้รับ: ${order.receiverName ?? 'ลูกค้าทั่วไป'}',
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (order.receiverPhone != null &&
                              order.receiverPhone!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.phone_rounded,
                                    size: 10,
                                    color: Color(0xFF0284C7),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    order.receiverPhone!,
                                    style: GoogleFonts.krub(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (order.shippingAddress != null &&
                          order.shippingAddress!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                order.shippingAddress!,
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Items List Header
          Text(
            'รายการสินค้าในออเดอร์',
            style: GoogleFonts.krub(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),

          // Items List
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_rounded,
                            size: 20,
                            color: Color(0xFF94A3B8),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'จำนวน: ${item.quantity} ชิ้น',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '฿${item.totalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Total & Shipment Status Info Footer
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shipping Method Badge
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.shippingMethod?.toLowerCase() == 'pickup'
                            ? Icons.store_rounded
                            : Icons.local_shipping_rounded,
                        size: 14,
                        color: const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          order.shippingMethod?.toLowerCase() == 'pickup'
                              ? 'รับที่ร้านค้า (Pickup)'
                              : 'จัดส่งทางพัสดุ (Delivery)',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0369A1),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Total Amount
              Row(
                children: [
                  Text(
                    'ยอดรวม: ',
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '฿${order.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (order.carrierName != null && order.trackingNumber != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_rounded,
                    size: 18,
                    color: Color(0xFF047857),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ขนส่ง: ${order.carrierName} • เลขพัสดุ: ${order.trackingNumber}',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          // Action Button or Unpaid Warning Banner
          if (order.orderStatus.trim().toLowerCase() == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        controller.changeFulfillmentStatus(order, 'Cancelled'),
                    child: Text(
                      'ยกเลิกออเดอร์',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.changeFulfillmentStatus(order, 'Confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF047857),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'ยืนยันออเดอร์',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (order.orderStatus.trim().toLowerCase() == 'confirmed') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    controller.changeFulfillmentStatus(order, 'Processing'),
                icon: const Icon(Icons.inventory_2_rounded),
                label: Text(
                  'เริ่มเตรียมจัดส่ง',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ] else if (order.paymentStatus.trim().toLowerCase() == 'paid' &&
              order.shippingMethod?.toLowerCase() != 'pickup' &&
              order.orderStatus.trim().toLowerCase() == 'processing') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => ManageOrderShipmentSheet.show(
                  context: context,
                  controller: controller,
                  order: order,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.edit_road_rounded, size: 18),
                label: Text(
                  'บันทึกการจัดส่งและเลขพัสดุ',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else if (order.paymentStatus.trim().toLowerCase() == 'paid' &&
              order.shippingMethod?.toLowerCase() == 'pickup' &&
              order.orderStatus.trim().toLowerCase() != 'shipped' &&
              order.orderStatus.trim().toLowerCase() != 'completed' &&
              order.orderStatus.trim().toLowerCase() != 'cancelled') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: Color(0xFF047857),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ลูกค้าระบุรับสินค้าที่ร้าน (ชำระเงินแล้ว)',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (order.paymentStatus != 'Paid') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_rounded,
                    size: 18,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.paymentStatus == 'PendingVerification'
                          ? 'ลูกค้าชำระเงินแล้ว อยู่ระหว่างรอ Admin ตรวจสอบยอด (เมื่ออนุมัติแล้วจะสามารถกดจัดส่งได้)'
                          : 'ลูกค้ายังไม่ได้ชำระเงินในระบบ กรุณารอการชำระเงินสำเร็จก่อนจัดส่งสินค้า',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF475569);
    String label = status;
    IconData icon = Icons.info_outline_rounded;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = const Color(0xFFFFFBEB);
        text = const Color(0xFFD97706);
        label = 'รอยืนยันออเดอร์';
        icon = Icons.access_time_filled_rounded;
        break;
      case 'paid':
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF0284C7);
        label = 'ชำระแล้ว';
        icon = Icons.verified_rounded;
        break;
      case 'processing':
        bg = const Color(0xFFF5F3FF);
        text = const Color(0xFF7C3AED);
        label = 'เตรียมจัดส่ง';
        icon = Icons.inventory_2_rounded;
        break;
      case 'shipped':
        bg = const Color(0xFFEEF2FF);
        text = const Color(0xFF4F46E5);
        label = 'จัดส่งแล้ว';
        icon = Icons.local_shipping_rounded;
        break;
      case 'completed':
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF059669);
        label = 'สำเร็จแล้ว';
        icon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        bg = const Color(0xFFFFF1F2);
        text = const Color(0xFFE11D48);
        label = 'ยกเลิกแล้ว';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
