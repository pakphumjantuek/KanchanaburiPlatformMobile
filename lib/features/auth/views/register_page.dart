import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_components.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'ข้อกำหนดและนโยบายความเป็นส่วนตัว',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Text(
            'ยินดีต้อนรับสู่แพลตฟอร์มการท่องเที่ยวและสินค้าชุมชนจังหวัดกาญจนบุรี\n\n'
            '1. บัญชีผู้ใช้งาน: ผู้ใช้ต้องให้ข้อมูลที่ถูกต้องและเป็นความจริง\n'
            '2. ความเป็นส่วนตัว: ข้อมูลของคุณจะถูกเก็บรักษาอย่างปลอดภัยเพื่ออำนวยความสะดวกในการสั่งซื้อและท่องเที่ยว\n'
            '3. การใช้งาน: ห้ามมิให้เผยแพร่ข้อมูลหรือเนื้อหาที่ไม่เหมาะสมในระบบ',
            style: GoogleFonts.krub(fontSize: 13.5, height: 1.5, color: Colors.grey[800]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'รับทราบ',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Scenic Hero Banner
            const AuthHeroHeader(
              title: 'สร้างบัญชีสมาชิกใหม่',
              subtitle: 'เริ่มต้นการเดินทางและร่วมสัมผัสเสน่ห์วิถีชีวิตเมืองกาญจน์',
              badgeText: 'JOIN OUR COMMUNITY',
              icon: Icons.person_add_alt_1_rounded,
              showBackButton: true,
            ),

            // Overlapping Form Card
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tab Switcher between Login and Register
                          AuthTabSwitch(
                            isLogin: false,
                            onLoginTap: () {
                              Get.offNamed(AppRoutes.login);
                            },
                            onRegisterTap: () {},
                          ),

                          const SizedBox(height: 24),

                          // Email Field
                          const AuthFieldLabel(
                            label: 'อีเมลของคุณ',
                            icon: Icons.alternate_email_rounded,
                          ),
                          const SizedBox(height: 8),
                          AppTextField(
                            controller: controller.emailController,
                            hintText: 'example@email.com',
                            fillColor: const Color(0xFFF4F8F6),
                            borderColor: const Color(0xFFE0EAE6),
                            focusedBorderColor: AppColors.primary,
                            borderRadius: 16,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.mail_outline_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 18),

                          // Password Field
                          const AuthFieldLabel(
                            label: 'รหัสผ่าน',
                            icon: Icons.lock_outline_rounded,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => AppTextField(
                              controller: controller.passwordController,
                              hintText: 'ตั้งรหัสผ่าน (อย่างน้อย 6 ตัวอักษร)',
                              obscureText: controller.obscurePassword.value,
                              fillColor: const Color(0xFFF4F8F6),
                              borderColor: const Color(0xFFE0EAE6),
                              focusedBorderColor: AppColors.primary,
                              borderRadius: 16,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.key_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF7A978E),
                                  size: 20,
                                ),
                                onPressed: controller.toggleObscurePassword,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Confirm Password Field
                          const AuthFieldLabel(
                            label: 'ยืนยันรหัสผ่าน',
                            icon: Icons.shield_outlined,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => AppTextField(
                              controller: controller.confirmPasswordController,
                              hintText: 'กรอกรหัสผ่านอีกครั้งให้ตรงกัน',
                              obscureText: controller.obscureConfirmPassword.value,
                              fillColor: const Color(0xFFF4F8F6),
                              borderColor: const Color(0xFFE0EAE6),
                              focusedBorderColor: AppColors.primary,
                              borderRadius: 16,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => controller.register(),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.lock_reset_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureConfirmPassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF7A978E),
                                  size: 20,
                                ),
                                onPressed: controller.toggleObscureConfirmPassword,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Live Real-Time Password Feedback Indicators
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F9F7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE0EAE6)),
                            ),
                            child: Column(
                              children: [
                                Obx(
                                  () => PasswordCheckRow(
                                    isValid: controller.isPasswordLongEnough,
                                    text: 'รหัสผ่านความยาวอย่างน้อย 6 ตัวอักษร',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Obx(
                                  () => PasswordCheckRow(
                                    isValid: controller.doPasswordsMatch,
                                    text: 'รหัสผ่านและการยืนยันตรงกัน',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Terms and Conditions checkbox
                          Obx(
                            () => InkWell(
                              onTap: controller.toggleAgreeTerms,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: controller.agreeTerms.value,
                                        onChanged: (_) => controller.toggleAgreeTerms(),
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFFBACBC5),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          Text(
                                            'ฉันยอมรับ ',
                                            style: GoogleFonts.krub(
                                              fontSize: 12.5,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => _showTermsDialog(context),
                                            child: Text(
                                              'ข้อกำหนดการใช้งาน',
                                              style: GoogleFonts.krub(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ' และ ',
                                            style: GoogleFonts.krub(
                                              fontSize: 12.5,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => _showTermsDialog(context),
                                            child: Text(
                                              'นโยบายความเป็นส่วนตัว',
                                              style: GoogleFonts.krub(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Primary Register Button
                          Obx(
                            () => Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1B4D3E),
                                    Color(0xFF266754),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person_add_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'สมัครสมาชิก',
                                            style: GoogleFonts.krub(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Social Sign-up Section
                          const SocialAuthSection(
                            label: 'หรือสมัครสมาชิกด้วย',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Navigation Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'มีบัญชีสมาชิกอยู่แล้ว? ',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(AppRoutes.login);
                          },
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE76F51),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFFE76F51),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Guest explore link
                    OutlinedButton.icon(
                      onPressed: () => Get.offAllNamed(AppRoutes.initial),
                      icon: const Icon(
                        Icons.travel_explore_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'เข้าชมแอปแบบผู้ใช้ทั่วไป (Guest)',
                        style: GoogleFonts.krub(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCCE0D8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                      ),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
