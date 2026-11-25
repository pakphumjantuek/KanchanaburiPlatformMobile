import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../../../shared/widgets/app_view_toggle.dart';
import '../../home/widgets/home_colors.dart';
import '../controllers/content_controller.dart';

/// Search box and view switcher shown as the `bottom` of the app bar.
class ContentSearchBar extends GetView<ContentController>
    implements PreferredSizeWidget {
  const ContentSearchBar({super.key});

  static const double height = 122;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          AppSearchField(
            hintText: 'ค้นหาบทความ สถานที่ หรือคีย์เวิร์ด...',
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            onSubmitted: () =>
                controller.setSearch(controller.searchController.text),
            iconColor: HomeColors.brandPrimary,
          ),
          const SizedBox(height: 10),
          Obx(
            () => AppViewToggle<String>(
              selectedValue: controller.viewMode.value,
              onChanged: controller.setViewMode,
              activeColor: HomeColors.brandPrimary,
              options: const [
                ToggleOption(
                  value: 'grid',
                  label: 'การ์ด',
                  icon: Icons.view_agenda_rounded,
                ),
                ToggleOption(
                  value: 'list',
                  label: 'รายการ',
                  icon: Icons.format_list_bulleted_rounded,
                ),
                ToggleOption(
                  value: 'map',
                  label: 'แผนที่',
                  icon: Icons.map_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Title row of the contents app bar.
class ContentAppBarTitle extends StatelessWidget {
  const ContentAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: HomeColors.brandPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.explore_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'เรื่องราวท่องเที่ยว',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'สถานที่และบทความแนะนำทั่วกาญจนบุรี',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFCC80),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
