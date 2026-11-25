import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_components.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Scenic Hero Banner
            const AuthHeroHeader(
              title: 'เข้าสู่ระบบ',
              subtitle:
                  'เข้าสู่ระบบเพื่อค้นหาที่เที่ยว ร้านค้าชุมชน และสินค้าท้องถิ่น',
              badgeText: 'กาญจนบุรี แพลตฟอร์ม',
              icon: Icons.explore_rounded,
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
                          // Tab switcher between Login and Register
                          AuthTabSwitch(
                            isLogin: true,
                            onLoginTap: () {},
                            onRegisterTap: () {
                              Get.toNamed(AppRoutes.register);
                            },
                          ),

                          const SizedBox(height: 20),

                          // Quick Demo Credentials bar for instant evaluation
                          DemoCredentialsBar(
                            onSelectUser: controller.fillDemoUser,
                            onSelectAdmin: controller.fillDemoAdmin,
                          ),

                          const SizedBox(height: 22),

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
                              hintText: 'กรอกรหัสผ่านของคุณ',
                              obscureText: controller.obscurePassword.value,
                              fillColor: const Color(0xFFF4F8F6),
                              borderColor: const Color(0xFFE0EAE6),
                              focusedBorderColor: AppColors.primary,
                              borderRadius: 16,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => controller.login(),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
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

                          const SizedBox(height: 12),

                          // Remember Me & Forgot Password Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => InkWell(
                                  onTap: controller.toggleRememberMe,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: controller.rememberMe.value,
                                            onChanged: (_) =>
                                                controller.toggleRememberMe(),
                                            activeColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xFFBACBC5),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'จดจำฉันไว้',
                                          style: GoogleFonts.krub(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    showForgotPasswordBottomSheet(context),
                                child: Text(
                                  'ลืมรหัสผ่าน?',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFE76F51),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Primary Login Button
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
                                    color: AppColors.primary.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.login,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.login_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'เข้าสู่ระบบ',
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

                          // Social Logins Section
                          const SocialAuthSection(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register Navigation Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีบัญชีสมาชิก? ',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.register);
                          },
                          child: Text(
                            'สมัครสมาชิกใหม่',
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 11,
                        ),
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
