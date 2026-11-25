import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminDashboardQuickAccessHub extends StatefulWidget {
  const AdminDashboardQuickAccessHub({super.key});

  @override
  State<AdminDashboardQuickAccessHub> createState() => _AdminDashboardQuickAccessHubState();
}

class _AdminDashboardQuickAccessHubState extends State<AdminDashboardQuickAccessHub> {
  int _selectedCategoryIndex = 0; // 0: All, 1: Finance, 2: Commerce, 3: Tourism

  final List<String> _categories = [
    'ทั้งหมด',
    '💳 การเงิน',
    '🏪 ร้านค้า',
    '🧭 ท่องเที่ยว',
  ];

  late final List<_HubModuleItem> _allItems = [
    // Finance & Orders
    _HubModuleItem(
      title: 'ตรวจสอบสลิป',
      subtitle: 'ยืนยันยอดชำระเงิน',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFFE76F51),
      bgTint: const Color(0xFFFDF4F1),
      category: 1,
      route: AppRoutes.adminOrders,
    ),
    _HubModuleItem(
      title: 'โอนเงินร้านค้า',
      subtitle: 'จัดการ Payouts รอบโอน',
      icon: Icons.price_check_rounded,
      color: const Color(0xFF2A9D8F),
      bgTint: const Color(0xFFF1F8F6),
      category: 1,
      route: AppRoutes.adminPayouts,
    ),
    _HubModuleItem(
      title: 'ส่งออกรายงาน',
      subtitle: 'ดาวน์โหลดไฟล์ CSV / Excel',
      icon: Icons.analytics_rounded,
      color: AdminColors.primary,
      bgTint: AdminColors.infoBg,
      category: 1,
      route: AppRoutes.adminExports,
    ),

    // Commerce & Shops
    _HubModuleItem(
      title: 'จัดการร้านค้า',
      subtitle: 'ตรวจสอบและอนุมัติร้านค้า',
      icon: Icons.storefront_rounded,
      color: const Color(0xFF3D6B82),
      bgTint: const Color(0xFFF0F5F8),
      category: 2,
      route: AppRoutes.adminShops,
    ),
    _HubModuleItem(
      title: 'หมวดหมู่สินค้า',
      subtitle: 'โครงสร้างประเภทสินค้า',
      icon: Icons.category_rounded,
      color: const Color(0xFFD97724),
      bgTint: const Color(0xFFFDF6EE),
      category: 2,
      route: AppRoutes.adminCategories,
    ),
    _HubModuleItem(
      title: 'จัดการแท็กค้นหา',
      subtitle: 'ป้ายกำกับและ Keyword',
      icon: Icons.label_important_rounded,
      color: const Color(0xFF7C4DFF),
      bgTint: const Color(0xFFF6F2FF),
      category: 2,
      route: AppRoutes.adminTags,
    ),

    // Tourism & Operations
    _HubModuleItem(
      title: 'เนื้อหาท่องเที่ยว',
      subtitle: 'บทความ ที่เที่ยว วิดีโอ',
      icon: Icons.auto_stories_rounded,
      color: const Color(0xFF4A7C59),
      bgTint: const Color(0xFFF2F7F3),
      category: 3,
      route: AppRoutes.adminContents,
    ),
    _HubModuleItem(
      title: 'ตารางกิจกรรม',
      subtitle: 'เทศกาลและตารางทริป',
      icon: Icons.event_note_rounded,
      color: const Color(0xFF2B7DE9),
      bgTint: const Color(0xFFF0F6FD),
      category: 3,
      route: AppRoutes.adminSchedules,
    ),
    _HubModuleItem(
      title: 'รายงานร้องเรียน',
      subtitle: 'ข้อร้องเรียนและปัญหา',
      icon: Icons.report_problem_rounded,
      color: const Color(0xFFE63946),
      bgTint: const Color(0xFFFDF0F1),
      category: 3,
      route: AppRoutes.adminReports,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategoryIndex == 0
        ? _allItems
        : _allItems.where((item) => item.category == _selectedCategoryIndex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Pills Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categories[index]),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AdminColors.primary,
                  labelStyle: GoogleFonts.krub(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AdminColors.textSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? AdminColors.primary : AdminColors.border,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 12),

        // Grid of modules with safe fixed extent
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 112,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return _buildModuleCard(item);
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(_HubModuleItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(item.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0EAE6),
              width: 1.1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x060D2B22),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.bgTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.color.withValues(alpha: 0.22),
                  ),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.krub(
                    fontSize: 9.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgTint;
  final int category;
  final String route;

  _HubModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgTint,
    required this.category,
    required this.route,
  });
}
