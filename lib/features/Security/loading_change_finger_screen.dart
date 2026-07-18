import 'dart:math';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:flutter/material.dart';

class LoadingchangefingerScreen extends StatefulWidget {
  const LoadingchangefingerScreen({super.key});

  @override
  State<LoadingchangefingerScreen> createState() =>
      _LoadingchangefingerScreenState();
}

class _LoadingchangefingerScreenState extends State<LoadingchangefingerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        replaceWith(context, Routes.fingerprintScreen);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double circleSize = 110;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.voidColor
          : AppColors.mainGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                      ),

                      Transform.rotate(
                        angle: controller.value * 2 * pi,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -45),
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: Color(0xffDDF7E8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "The Fingerprint Has\nBeen Successfully\nAdded.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
