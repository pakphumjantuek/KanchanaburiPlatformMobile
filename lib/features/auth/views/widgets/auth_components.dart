import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

/// Top scenic hero background with river gradients, atmospheric glow, and branding
class AuthHeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final bool showBackButton;

  const AuthHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText = 'KANCHANABURI EXPERIENCE',
    this.icon = Icons.landscape_rounded,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A241C), // Deepest Forest
            Color(0xFF133E31), // Emerald River Dark
            Color(0xFF1B4D3E), // Emerald River Teal
          ],
        ),
      ),
      child: Stack(
        children: [
          // Ambient decorative circles for organic river feel
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.16),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
              child: Column(
                children: [
                  // Top Row: Back button & Brand pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (showBackButton)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),

                      // Brand Pill Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.spa_rounded,
                              size: 14,
                              color: Color(0xFFE9C46A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              badgeText,
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: const Color(0xFFE0EAE6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacer or Guest explore button
                      TextButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.initial),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          foregroundColor: Colors.white70,
                        ),
                        child: Text(
                          'เข้าชม',
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Brand Emblem Avatar
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2A9D8F),
                            Color(0xFFE9C46A),
                            Color(0xFFE76F51),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0A241C),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            size: 38,
                            color: const Color(0xFFE9C46A),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.krub(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        color: const Color(0xFFCBE2D9),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating container card for auth forms
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE0EAE6),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0D2B22),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x060D2B22),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Interactive Segmented Switch between Login and Register
class AuthTabSwitch extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabSwitch({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EAE6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLoginTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isLogin
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 16,
                        color: isLogin ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'เข้าสู่ระบบ',
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: isLogin ? FontWeight.bold : FontWeight.w600,
                          color: isLogin ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRegisterTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: !isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !isLogin
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 16,
                        color: !isLogin ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: !isLogin ? FontWeight.bold : FontWeight.w600,
                          color: !isLogin ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Field label with micro-icon and high readability
class AuthFieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? optionalText;

  const AuthFieldLabel({
    super.key,
    required this.label,
    required this.icon,
    this.optionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        if (optionalText != null)
          Text(
            optionalText!,
            style: GoogleFonts.krub(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

/// Quick demo credentials pills
class DemoCredentialsBar extends StatelessWidget {
  final VoidCallback onSelectUser;
  final VoidCallback onSelectAdmin;

  const DemoCredentialsBar({
    super.key,
    required this.onSelectUser,
    required this.onSelectAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E4DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 16,
                color: Color(0xFFE76F51),
              ),
              const SizedBox(width: 4),
              Text(
                'ทดลองเข้าใช้งานด่วน (Demo):',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSelectUser,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCCE0D8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_outline_rounded, size: 14, color: Color(0xFF1B4D3E)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'ผู้ใช้ทั่วไป',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B4D3E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSelectAdmin,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCCE0D8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shield_outlined, size: 14, color: Color(0xFFE76F51)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'ผู้ดูแลระบบ',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE76F51),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Social alternative log-in options
class SocialAuthSection extends StatelessWidget {
  final String label;

  const SocialAuthSection({
    super.key,
    this.label = 'หรือดำเนินการต่อด้วย',
  });

  void _showNotice(BuildContext context, String provider) {
    Get.snackbar(
      'เข้าสู่ระบบด้วย $provider',
      'กำลังเตรียมพร้อมเปิดให้บริการเร็วๆ นี้',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Color(0xFFE0EAE6), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                label,
                style: GoogleFonts.krub(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Color(0xFFE0EAE6), thickness: 1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(
              context: context,
              icon: Icons.g_mobiledata_rounded,
              iconSize: 28,
              iconColor: const Color(0xFFEA4335),
              title: 'Google',
              onTap: () => _showNotice(context, 'Google'),
            ),
            const SizedBox(width: 14),
            _socialButton(
              context: context,
              icon: Icons.chat_bubble_rounded,
              iconSize: 20,
              iconColor: const Color(0xFF06C755),
              title: 'LINE',
              onTap: () => _showNotice(context, 'LINE'),
            ),
            const SizedBox(width: 14),
            _socialButton(
              context: context,
              icon: Icons.apple_rounded,
              iconSize: 24,
              iconColor: Colors.black87,
              title: 'Apple',
              onTap: () => _showNotice(context, 'Apple'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({
    required BuildContext context,
    required IconData icon,
    required double iconSize,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 58,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080D2B22),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
        ),
      ),
    );
  }
}

/// Live real-time check item for password rules
class PasswordCheckRow extends StatelessWidget {
  final bool isValid;
  final String text;

  const PasswordCheckRow({
    super.key,
    required this.isValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isValid ? const Color(0xFF2A9D8F) : const Color(0xFFE0EAE6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isValid ? Icons.check : Icons.circle,
            size: isValid ? 11 : 6,
            color: isValid ? Colors.white : const Color(0xFF8BA69D),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.krub(
            fontSize: 12,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
            color: isValid ? const Color(0xFF1B4D3E) : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Forgot Password Bottom Sheet
void showForgotPasswordBottomSheet(BuildContext context) {
  final emailResetController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EAE6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE76F51).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: Color(0xFFE76F51),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ลืมรหัสผ่าน?',
                        style: GoogleFonts.krub(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'ระบุอีเมลที่ลงทะเบียนเพื่อรับลิงก์รีเซ็ตรหัสผ่าน',
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'อีเมลของคุณ',
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: emailResetController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.krub(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'example@email.com',
                hintStyle: GoogleFonts.krub(color: Colors.grey[400], fontSize: 13.5),
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                filled: true,
                fillColor: const Color(0xFFF3F7F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE0EAE6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE0EAE6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                final email = emailResetController.text.trim();
                if (email.isEmpty || !GetUtils.isEmail(email)) {
                  Get.snackbar(
                    'ข้อมูลไม่ถูกต้อง',
                    'กรุณากรอกอีเมลที่ถูกต้อง',
                    backgroundColor: const Color(0xFFC62828),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }
                Navigator.pop(ctx);
                Get.snackbar(
                  'ส่งคำขอรีเซ็ตรหัสผ่านแล้ว',
                  'กรุณาตรวจสอบกล่องข้อความในอีเมล $email',
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'ส่งลิงก์รีเซ็ตรหัสผ่าน',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
