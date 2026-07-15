import 'dart:io';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_cubit.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
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

    // البدء بفحص حالة المستخدم فوراً
    context.read<AuthCubit>().checkCurrentUser();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // تشغيل أنيميشن اللوجو بالكامل أولاً لضمان تجربة مستخدم سلسة
    await _textController.forward();
  }

  // دالة موحدة للتعامل مع التوجيه في حالة عدم تسجيل الدخول
  Future<void> _navigateToAuthOrOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final bool seenOnBoarding = prefs.getBool('seen_onboarding') ?? false;

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        // ننتظر انتهاء الأنيميشن أولاً قبل الانتقال لأي شاشة
        if (_textController.status != AnimationStatus.completed) {
          await _textController.forward();
        }

        if (!mounted) return;

        if (state is AuthSuccess) {
          // جلب بيانات المستخدم المسجل حالياً وتخزينها في الـ UserCubit
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            await context.read<UserCubit>().loadUser(currentUser.uid);
          }
          
          if (!mounted) return;
          
          // الانتقال للشاشة الرئيسية أو استكمال الملف الشخصي بناءً على حالة البيانات
          if (UserPrefs.isLoggedIn()) {
            replaceWith(context, Routes.bottomNavBar);
          } else {
            replaceWith(context, Routes.completedProfile);
          }
        } 
        
        else if (state is AuthFailure) {
          // إذا فشل تسجيل الدخول أو كان غير مسجل، نذهب لصفحة تسجيل الدخول أو الـ Onboarding
          await _navigateToAuthOrOnboarding();
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