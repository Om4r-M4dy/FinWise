import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin {
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Play splash animation
    await _textController.forward();

    if (!mounted) return;

    // ── Check where to navigate ────────────────────────────────────
    // 1. If user is already logged in → go straight to home
    if (FirebaseAuth.instance.currentUser != null) {
      replaceWith(context, Routes.bottomNavBar);
      return;
    }

    // 2. Check if user has seen OnBoarding before
    final prefs = await SharedPreferences.getInstance();
    final bool seenOnBoarding = prefs.getBool('seen_onboarding') ?? false;

    if (!mounted) return;

    if (seenOnBoarding) {
      // Not first time → skip OnBoarding, go to auth choice screen
      replaceWith(context, Routes.authScreen);
    } else {
      // First time ever → show OnBoarding
      replaceWith(context, Routes.onBoarding);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.lettersAndIcons,
                BlendMode.srcIn,
              ),
              child: Lottie.asset(AppAssets.logoJson, repeat: false),
            ),
            const Gap(12),
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Lottie.asset(
                AppAssets.finwiseJson,
                controller: _textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
