import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';

class ResetSuccessBottomSheet extends StatefulWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const ResetSuccessBottomSheet({
    super.key,
    required this.email,
    required this.onBackToLogin,
  });

  @override
  State<ResetSuccessBottomSheet> createState() =>
      _ResetSuccessBottomSheetState();
}

class _ResetSuccessBottomSheetState extends State<ResetSuccessBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated email check icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.mainGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: AppColors.mainGreen,
                  size: 48,
                ),
              ),
            ),
            const Gap(20),
            Text(
              "Check Your Email!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.poppins,
                color: isDark ? Colors.white : AppColors.lettersAndIcons,
              ),
            ),
            const Gap(12),
            Text(
              "We've sent a password reset link to:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white70
                    : AppColors.lettersAndIcons.withValues(alpha: 0.7),
                fontFamily: AppFonts.poppins,
              ),
            ),
            const Gap(6),
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.mainGreen,
                fontFamily: AppFonts.poppins,
              ),
            ),
            const Gap(10),
            Text(
              "Open your email app, tap the link, and follow the instructions to reset your password.\n\nDon't see it? Check your spam folder.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white60
                    : AppColors.lettersAndIcons.withValues(alpha: 0.6),
                fontFamily: AppFonts.poppins,
                height: 1.6,
              ),
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onBackToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Back to Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.voidColor : Colors.white,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
