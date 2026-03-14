import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/on_boarding/data/on_boarding_data.dart';
import 'package:flutter/material.dart';

Widget buildPageContent(int index) {
  return Column(
    children: [
      const Spacer(flex: 4),
      Text(
        onBoardingPages[index].title,
        textAlign: TextAlign.center,
        style: TextStyles.size_30,
      ),
      const Spacer(flex: 5),
      Image.asset(
        onBoardingPages[index].imagePath,
        height: 250,
        cacheHeight: 500,
      ),
      const Spacer(flex: 2),
    ],
  );
}
