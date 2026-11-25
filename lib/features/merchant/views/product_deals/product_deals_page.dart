import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_product_summary.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_list_card.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_create_button.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ProductDealsPage extends StatefulWidget {
  const ProductDealsPage({super.key});

  @override
  State<ProductDealsPage> createState() => _ProductDealsPageState();
}

class _ProductDealsPageState extends State<ProductDealsPage> {
  final _repository = MerchantRepository();
  ProductModel? product;
  List<dynamic> deals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      _loadDeals();
    } else {
      loading = false;
    }
  }

  Future<void> _loadDeals() async {
    final item = product;
    if (item == null) return;
    setState(() => loading = true);
    try {
      final result = await _repository.fetchProductDeals(item.id);
      if (mounted) {
        setState(() {
          deals = result;
          loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _stopDeal(String id) async {
    final ok = await _repository.stopProductDeal(id);
    if (ok) {
      await _loadDeals();
      Get.snackbar(
        'หยุดดีลสำเร็จ',
        'โปรโมชันถูกระงับการใช้งานเรียบร้อยแล้ว',
        backgroundColor: MerchantColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถหยุดดีลได้ กรุณาลองใหม่อีกครั้ง',
        backgroundColor: MerchantColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = product;

    return Scaffold(
      backgroundColor: MerchantColors.background,
      appBar: AppBar(
        backgroundColor: MerchantColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'จัดการโปรโมชันสินค้า',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Merchant Deals & Promotions',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'สร้างโปรโมชัน',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (item == null) return;
              final result = await Get.toNamed(
                AppRoutes.myShopProductDealForm,
                arguments: item,
              );
              if (result == true) _loadDeals();
            },
          ),
          IconButton(
            tooltip: 'รีเฟรช',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _loadDeals,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: item == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: MerchantColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ไม่พบข้อมูลสินค้าที่ระบุ',
                      style: GoogleFonts.krub(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MerchantColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('กลับไปยังคลังสินค้า'),
                    ),
                  ],
                ),
              ),
            )
          : loading
              ? const LoadingWidget(message: 'กำลังโหลดข้อมูลโปรโมชัน...')
              : RefreshIndicator(
                  onRefresh: _loadDeals,
                  color: MerchantColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Header Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                          decoration: const BoxDecoration(
                            gradient: MerchantColors.heroGradient,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(26),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Color(0xFFFDE68A),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'จัดโปรโมชันเพิ่มยอดขาย',
                                      style: GoogleFonts.krub(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'สร้าง Flash Deal หรือโปรโมชันลดราคาพิเศษเพื่อดึงดูดลูกค้าให้สั่งซื้อทันที',
                                      style: GoogleFonts.krub(
                                        fontSize: 12,
                                        color: const Color(0xFFA7F3D0).withValues(alpha: 0.95),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Main Content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Target Product Summary Card
                              ProductDealsProductSummary(product: item),

                              const SizedBox(height: 16),

                              // Deals List Card
                              ProductDealsListCard(
                                deals: deals,
                                onStopDeal: _stopDeal,
                              ),

                              const SizedBox(height: 20),

                              // Create Deal CTA Button
                              ProductDealsCreateButton(
                                onPressed: () async {
                                  final result = await Get.toNamed(
                                    AppRoutes.myShopProductDealForm,
                                    arguments: item,
                                  );
                                  if (result == true) _loadDeals();
                                },
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
}
