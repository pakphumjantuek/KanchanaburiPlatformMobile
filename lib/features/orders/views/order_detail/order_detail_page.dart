import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_routes.dart';
import '../../models/order_model.dart';
import '../../repositories/order_repository.dart';
import 'widgets/order_detail_actions.dart';
import 'widgets/order_status_section.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/shipping_address_card.dart';
import 'widgets/shop_order_items_card.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Timer? _countdownTimer;
  final OrderRepository _repository = OrderRepository();

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final order = args is OrderModel ? args : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(AppRoutes.initial);
            }
          },
        ),
        title: Text(
          'รายละเอียดคำสั่งซื้อ',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'กลับสู่หน้าหลัก',
            onPressed: () => Get.offAllNamed(AppRoutes.initial),
          ),
        ],
      ),
      body: order == null
          ? Center(
              child: Text(
                'ไม่พบข้อมูลคำสั่งซื้อ',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  color: const Color(0xFF332820),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderStatusBanner(order: order),
                  if (order.isAwaitingPayment || order.isPaymentExpired) ...[
                    const SizedBox(height: 12),
                    PaymentExpiryNotice(order: order),
                  ],
                  const SizedBox(height: 16),
                  ShippingAddressCard(order: order),
                  const SizedBox(height: 16),
                  ShopOrderItemsCard(order: order),
                  const SizedBox(height: 16),
                  PaymentSummaryCard(order: order),
                  const SizedBox(height: 24),
                  OrderDetailActions(
                    order: order,
                    onConfirmReceived: () => _confirmReceived(order),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _confirmReceived(OrderModel order) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'ยืนยันรับสินค้า',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'คุณได้รับสินค้าครบถ้วนแล้วใช่หรือไม่ หลังยืนยันจะสามารถเขียนรีวิวสินค้าได้',
          style: GoogleFonts.krub(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('ยังไม่ยืนยัน'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('ยืนยันรับสินค้า'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await _repository.confirmShipmentReceived(order.orderId);
    if (!success) {
      Get.snackbar(
        'ไม่สามารถยืนยันได้',
        'กรุณาลองใหม่อีกครั้ง',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
      );
      return;
    }
    final updated = await _repository.fetchOrderById(order.orderId);
    Get.snackbar(
      'ยืนยันรับสินค้าแล้ว',
      'ขอบคุณที่สั่งซื้อสินค้า',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
    );
    if (updated != null) {
      Get.offNamed(AppRoutes.orderDetail, arguments: updated);
    }
  }
}
