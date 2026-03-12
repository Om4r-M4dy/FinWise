import 'package:finwise/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyBodyView extends StatelessWidget {
  const MyBodyView({super.key, this.topSection, required this.bottomSection});

  final Widget? topSection;
  final Widget bottomSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (topSection != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 37.0,
                vertical: 20,
              ),
              child: topSection,
            ),
          ] else
            const Gap(20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.vertical(top: Radius.circular(70.0)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 37.0,
                    vertical: 20,
                  ),
                  child: bottomSection,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
