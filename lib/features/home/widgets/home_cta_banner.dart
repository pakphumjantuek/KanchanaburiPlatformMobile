import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../widgets/home_colors.dart';

class HomeCtaBanner extends StatelessWidget {
  const HomeCtaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: HomeColors.darkHeader,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: HomeColors.brandPrimary, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: HomeColors.brandPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'เข้าร่วมชุมชนกาญจนบุรี',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'แบ่งปันเรื่องราว หรือ ลงทะเบียนร้านค้า',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'ร่วมโปรโมตการท่องเที่ยวและสินค้าชุมชนเมืองกาญจน์ไปพร้อมกัน',
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFFCBD5E1),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.createContent),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HomeColors.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'เขียนเรื่องราว',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(AppRoutes.registerShop),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'เปิดร้านค้า',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
