import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/navigation/controllers/navigation_controller.dart';

/// Square home button for dashboards: pops back to the main app and
/// selects the home tab.
class BackToHomeButton extends StatelessWidget {
  final Color color;
  final Color borderColor;

  const BackToHomeButton({
    super.key,
    required this.color,
    required this.borderColor,
  });

  static void goHome() {
    Get.until((route) => route.isFirst);
    if (Get.isRegistered<NavigationController>()) {
      Get.find<NavigationController>().changeTab(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'กลับหน้าแรก',
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: goHome,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(Icons.home_rounded, size: 22, color: color),
          ),
        ),
      ),
    );
  }
}
