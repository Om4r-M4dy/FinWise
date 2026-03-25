import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

abstract class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: AppFonts.poppins,
    scaffoldBackgroundColor: AppColors.mainGreen,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mainGreen,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.mainGreen,
      onSurface: AppColors.lettersAndIcons,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightGreen,
      filled: true,
      hintStyle: TextStyles.caption2_13.copyWith(color: AppColors.dark05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
