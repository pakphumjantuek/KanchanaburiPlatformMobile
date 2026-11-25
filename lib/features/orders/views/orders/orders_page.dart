import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../controllers/order_controller.dart';
import 'widgets/order_card.dart';
import 'widgets/order_status_filter_tabs.dart';
import 'widgets/orders_empty_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderController controller = Get.find<OrderController>();
  Timer? _countdownTimer;

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
          'คำสั่งซื้อของฉัน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.loadOrders(),
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'กลับสู่หน้าหลัก',
            onPressed: () => Get.offAllNamed(AppRoutes.initial),
          ),
        ],
      ),
      body: Column(
        children: [
          OrderStatusFilterTabs(controller: controller),
          Expanded(
            child: Obx(() {
              final orders = controller.filteredOrders;
              if (controller.isLoading.value) {
                return const LoadingWidget(
                  message: 'กำลังโหลดคำสั่งซื้อของคุณ...',
                  icon: Icons.receipt_long_rounded,
                );
              }
              if (orders.isEmpty) {
                return OrdersEmptyState(onRefresh: controller.loadOrders);
              }
              return RefreshIndicator(
                onRefresh: controller.loadOrders,
                color: const Color(0xFFD96C2C),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) =>
                      OrderCard(order: orders[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
