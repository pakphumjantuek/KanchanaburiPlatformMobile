import 'package:get/get.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
    if (!GetUtils.isEmail(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  static String? required(String? value, [String fieldName = 'ข้อมูล']) {
    if (value == null || value.trim().isEmpty) return 'กรุณากรอก$fieldName';
    return null;
  }
}
