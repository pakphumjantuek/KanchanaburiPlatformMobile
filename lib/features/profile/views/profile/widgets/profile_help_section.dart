import 'package:flutter/material.dart';

import 'profile_navigation_tile.dart';
import 'profile_section_card.dart';

typedef ProfileInfoCallback = void Function(String title, String content);

class ProfileHelpSection extends StatelessWidget {
  const ProfileHelpSection({super.key, required this.onInfo});

  final ProfileInfoCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'อื่น ๆ & ความช่วยเหลือ',
      icon: Icons.help_outline_rounded,
      children: [
        ProfileNavigationTile(
          icon: Icons.quiz_outlined,
          title: 'ช่วยเหลือและคำถามที่พบบ่อย',
          onTap: () => onInfo(
            'ช่วยเหลือ',
            'หากต้องการความช่วยเหลือเพิ่มเติม ติดต่อผู้ดูแลได้ที่ support@kanchanaburi.go.th',
          ),
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.description_outlined,
          title: 'ข้อกำหนดและนโยบายความเป็นส่วนตัว',
          onTap: () => onInfo(
            'ข้อกำหนดและนโยบาย',
            'แพลตฟอร์มนี้ปฏิบัติตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล (PDPA) เพื่อความปลอดภัยสูงสุดของคุณ',
          ),
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.info_outline_rounded,
          title: 'เกี่ยวกับแพลตฟอร์ม',
          subtitle: 'เวอร์ชัน 1.0.0 (KRU Boat API)',
          onTap: () => onInfo(
            'เกี่ยวกับ กาญจนบุรี แพลตฟอร์ม',
            'ระบบส่งเสริมการท่องเที่ยว ชุมชน OTOP และเศรษฐกิจดิจิทัล จังหวัดกาญจนบุรี\nเวอร์ชัน 1.0.0 (KRU Boat API Integration)',
          ),
        ),
      ],
    );
  }
}
