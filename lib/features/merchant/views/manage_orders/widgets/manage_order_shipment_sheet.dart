import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/orders/models/order_model.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';

class ManageOrderShipmentSheet {
  const ManageOrderShipmentSheet._();

  static void show({
    required BuildContext context,
    required ManageOrdersController controller,
    required OrderModel order,
  }) {
    final carrierController = TextEditingController(
      text: order.carrierName ?? 'ไปรษณีย์ไทย (EMS)',
    );
    final trackingController = TextEditingController(
      text: order.trackingNumber ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BottomSheet Handle bar
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Color(0xFF047857),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'บันทึกข้อมูลจัดส่งพัสดุ',
                            style: GoogleFonts.krub(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'ออเดอร์ #${order.orderNumber ?? order.id}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: carrierController,
                  style: GoogleFonts.krub(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'บริษัทขนส่ง *',
                    hintText: 'เช่น ไปรษณีย์ไทย, KERRY, Flash Express, J&T',
                    labelStyle: GoogleFonts.krub(
                      color: const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.business_rounded,
                      color: Color(0xFF047857),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF047857),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: trackingController,
                  style: GoogleFonts.krub(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'เลขติดตามพัสดุ (Tracking Number) *',
                    hintText: 'เช่น TH123456789TH',
                    labelStyle: GoogleFonts.krub(
                      color: const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.pin_rounded,
                      color: Color(0xFF047857),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF047857),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.submitShipmentFulfillment(
                        order: order,
                        carrierName: carrierController.text,
                        trackingNumber: trackingController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF047857),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(
                      'บันทึกและเปลี่ยนสถานะเป็น "จัดส่งแล้ว"',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
