import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contents/controllers/content_controller.dart';
import '../controllers/home_controller.dart';
import 'home_colors.dart';
import 'home_section_header.dart';

class HomeDistrictTransitMap extends GetView<HomeController> {
  const HomeDistrictTransitMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.districts;
      if (list.isEmpty) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        color: const Color(0xFFF7F2EA),
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: HomeColors.brandPrimary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สำรวจตามอำเภอและพื้นที่',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: HomeColors.textBlack,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'เลือกท่องเที่ยวและค้นหาเรื่องราวรายอำเภอทั่วกาญจนบุรี',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: HomeColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => openMainTab(2, '/contents'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'ดูพื้นที่ทั้งหมด',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: HomeColors.brandPrimary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                          color: HomeColors.brandPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Thin Divider Line below header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(height: 1, color: const Color(0xFFE2D6C6)),
            ),
            const SizedBox(height: 18),

            // Transit Line Rail View
            SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Horizontal Route Line running continuously behind dots
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(height: 4, color: const Color(0xFFDECFC0)),
                  ),

                  // Station Nodes Row
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final district = list[index];
                      final isTop = index % 2 == 0;
                      const greenColor = Color(0xFF059669);

                      final textWidget = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            district.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: HomeColors.textBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );

                      final dotWidget = Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: greenColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      );

                      return InkWell(
                        onTap: () {
                          if (!Get.isRegistered<ContentController>()) {
                            Get.put(ContentController());
                          }
                          Get.find<ContentController>().applyFilters(
                            districtId: district.id,
                          );

                          openMainTab(
                            2,
                            '/contents',
                            arguments: {'districtId': district.id},
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 105,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Top Slot
                              SizedBox(
                                height: 48,
                                child: Center(
                                  child: isTop
                                      ? textWidget
                                      : const SizedBox.shrink(),
                                ),
                              ),

                              // Center Station Dot Slot
                              SizedBox(
                                height: 24,
                                child: Center(child: dotWidget),
                              ),

                              // Bottom Slot
                              SizedBox(
                                height: 48,
                                child: Center(
                                  child: !isTop
                                      ? textWidget
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
