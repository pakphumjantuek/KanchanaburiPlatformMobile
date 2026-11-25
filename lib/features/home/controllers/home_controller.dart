import '../../contents/controllers/content_controller.dart';
import '../widgets/home_section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contents/models/content_model.dart';
import '../../contents/repositories/content_repository.dart';
import '../../shops/models/product_model.dart';
import '../../shops/models/shop_model.dart';
import '../../shops/repositories/shop_repository.dart';

class HomeController extends GetxController {
  final ContentRepository _contentRepository = ContentRepository();
  final ShopRepository _shopRepository = ShopRepository();

  final isLoading = true.obs;
  final carouselIndex = 0.obs;
  late final PageController bannerPageController;

  final categories = <ContentCategory>[].obs;
  final recommendedContents = <ContentModel>[].obs;
  final communityContents = <ContentModel>[].obs;
  final districts = <District>[].obs;
  final shops = <ShopModel>[].obs;
  final products = <ProductModel>[].obs;
  final activeDeals = <ProductModel>[].obs;

  final searchInputController = TextEditingController();
  final popularTags = const [
    'สะพานข้ามแม่น้ำแคว',
    'สังขละบุรี',
    'น้ำตกเอราวัณ',
    'ผ้าทอกะเหรี่ยง',
    'ทองผาภูมิ',
    'แพเปียก',
  ];
  final quickCategories = const [
    {
      'name': 'ทั้งหมด',
      'icon': Icons.explore_rounded,
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'ธรรมชาติ',
      'icon': Icons.landscape_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'คาเฟ่ & อาหาร',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'ที่พัก & แพ',
      'icon': Icons.house_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'วัฒนธรรม',
      'icon': Icons.museum_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'name': 'สินค้า OTOP',
      'icon': Icons.shopping_bag_rounded,
      'color': Color(0xFFEC4899),
    },
  ];
  final stats = const [
    {'value': '13', 'label': 'อำเภอบนเส้นทาง'},
    {'value': '500+', 'label': 'ร้านค้าชุมชน'},
    {'value': '1,000+', 'label': 'เรื่องราวความประทับใจ'},
  ];
  final valuePillars = const [
    {
      'icon': Icons.auto_awesome,
      'title': 'ภูมิปัญญา & วิถีชุมชน',
      'desc':
          'สัมผัสเรื่องราวรากเหง้าวัฒนธรรมเมืองกาญจน์ที่ถ่ายทอดจากรุ่นสู่รุ่น',
    },
    {
      'icon': Icons.storefront,
      'title': 'สินค้าตรงจากชาวบ้าน',
      'desc':
          'สนับสนุนเศรษฐกิจฐานราก ซื้อสินค้าคุณภาพจากผู้ผลิตในพื้นที่โดยตรง',
    },
    {
      'icon': Icons.map,
      'title': 'พิกัดสถานที่อันซีน',
      'desc': 'ค้นพบหมุดหมายท่องเที่ยวลับ แหล่งธรรมชาติต่างๆ ทั่วทั้ง 13 อำเภอ',
    },
    {
      'icon': Icons.verified,
      'title': 'การันตีคุณภาพ',
      'desc':
          'ทุกเรื่องราวและร้านค้าได้รับการคัดสรรเพื่อสร้างความมั่นใจแก่ผู้มาเยือน',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    bannerPageController = PageController(viewportFraction: 0.88);
    fetchHomeData();
  }

  @override
  void onClose() {
    bannerPageController.dispose();
    searchInputController.dispose();
    super.onClose();
  }

  List<ContentModel> get heroBanners {
    if (recommendedContents.isEmpty) return [];
    return recommendedContents.take(4).toList();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _contentRepository.fetchCategories(),
        _contentRepository.fetchContents(pageSize: 12),
        _contentRepository.fetchDistricts(),
        _shopRepository.fetchShops(pageSize: 6),
        _shopRepository.fetchProducts(pageSize: 6),
        _shopRepository.fetchActiveDeals(limit: 12),
      ]);

      categories.value = results[0] as List<ContentCategory>;
      final allContents = results[1] as List<ContentModel>;
      if (allContents.length > 4) {
        recommendedContents.value = allContents.sublist(0, 4);
        communityContents.value = allContents.sublist(4);
      } else {
        recommendedContents.value = allContents;
        communityContents.value = [];
      }
      districts.value = results[2] as List<District>;
      shops.value = results[3] as List<ShopModel>;
      products.value = results[4] as List<ProductModel>;
      activeDeals.value = results[5] as List<ProductModel>;
    } catch (e) {
      debugPrint('Error loading home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onTagTap(String tag) {
    searchInputController.text = tag;
    onSearchSubmit(tag);
  }

  void onSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    final search = query.trim();
    if (!Get.isRegistered<ContentController>()) {
      Get.put(ContentController());
    }
    Get.find<ContentController>().applyFilters(search: search);
    openMainTab(2, '/contents', arguments: {'search': search});
  }
}
