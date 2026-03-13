import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/features/launch/build_auth_u_i.dart';
import 'package:flutter/material.dart';
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
  late final AnimationController _slideController;

  late final Animation<Offset> _logoSlide;
  late final Animation<Color?> _logoIconColor;
  late final Animation<Color?> _logoTextColor;
  late final Animation<Color?> _backgroundColor;
  late final Animation<double> _buttonsFade;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final CurvedAnimation slideCurve = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutQuart,
    );

    _logoSlide = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(0, -0.6)
    ).animate(slideCurve);

    _logoIconColor = ColorTween(
      begin: AppColors.lettersAndIcons,
      end: AppColors.mainGreen,
    ).animate(slideCurve);

    _logoTextColor = ColorTween(
      begin: Colors.white,
      end: AppColors.mainGreen,
    ).animate(slideCurve);

    _backgroundColor = ColorTween(
      begin: AppColors.mainGreen,
      end: AppColors.background,
    ).animate(slideCurve);

    _buttonsFade = CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    if (!mounted) return;
    await _textController.forward();
    if (mounted) {
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return Container(
            color: _backgroundColor.value,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    _buildAnimatedBranding(),
                    Align(
                      alignment: const Alignment(0, 0.35),
                      child: FadeTransition(
                        opacity: _buttonsFade,
                        child: BuildAuthUI(),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBranding() {
    return Center(
      child: SlideTransition(
        position: _logoSlide,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _logoIconColor.value ?? Colors.white,
                BlendMode.srcIn,
              ),
              child: Lottie.asset(AppAssets.logoJson, repeat: false),
            ),
            const Gap(12),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _logoTextColor.value ?? Colors.white,
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