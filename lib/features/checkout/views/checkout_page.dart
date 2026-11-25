import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/checkout/checkout_address_section.dart';
import '../widgets/checkout/checkout_bottom_bar.dart';
import '../widgets/checkout/checkout_items_section.dart';
import '../widgets/checkout/checkout_shipping_section.dart';
import '../widgets/checkout/checkout_summary_section.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ยืนยันการสั่งซื้อสินค้า',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Receiver & Address Info
            CheckoutAddressSection(),

            SizedBox(height: 16),

            // Section 2: Order Items Breakdown
            CheckoutItemsSection(),

            SizedBox(height: 16),

            // Section 3: Shipping Method Selection
            CheckoutShippingSection(),

            SizedBox(height: 16),

            // Section 4: Price Summary Breakdown
            CheckoutSummarySection(),

            SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Sticky CTA Bar
      bottomNavigationBar: const CheckoutBottomBar(),
    );
  }
}
