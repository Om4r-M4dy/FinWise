import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

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
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && UserPrefs.isLoggedIn()) {
      await context.read<UserCubit>().loadUser(currentUser.uid);
      if (mounted) {
        replaceWith(context, Routes.bottomNavBar);
      }
      return;
    }

    // Check if user has seen OnBoarding before
    final bool seenOnBoarding = UserPrefs.getSeenOnboarding();

    if (!mounted) return;

    if (seenOnBoarding) {
      replaceWith(context, Routes.authScreen);
    } else {
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
