import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_cubit.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_state.dart';
import 'package:finwise/features/auth/persentation/page/complete_profile_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<AuthCubit>().checkCurrentUser();
    _startSequence();
  }

  Future<void> _startSequence() async {
    // Play splash animation
    await _textController.forward();

    if (!mounted) return;

    // ── Check where to navigate ────────────────────────────────────
    // 1. If user is already logged in → go straight to home
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        // استنى الأنيميشن يخلص

        if (_textController.status != AnimationStatus.completed) {
          await _textController.forward();
        }

        if (!mounted) return;

        if (state is AuthSuccess) {
          replaceWith(context, Routes.completedProfile);
        }

        if (state is AuthFailure && state.errorMessage == 'NOT_LOGGED_IN') {
          final prefs = await SharedPreferences.getInstance();

          final seenOnBoarding = prefs.getBool('seen_onboarding') ?? false;

          if (!mounted) return;

          if (seenOnBoarding) {
            replaceWith(context, Routes.authScreen);
          } else {
            replaceWith(context, Routes.onBoarding);
          }
        }
      },

      child: Scaffold(
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
      ),
    );
  }
}
