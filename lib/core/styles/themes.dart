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
      surface: AppColors.background,
      onSurface: AppColors.lettersAndIcons,
      primaryContainer: AppColors.lightGreen,
      onPrimaryContainer: AppColors.lettersAndIcons,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightGreen,
      filled: true,
      hintStyle: TextStyles.bodySmall.copyWith(color: AppColors.dark05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    fontFamily: AppFonts.poppins,
    scaffoldBackgroundColor: AppColors.voidColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.voidColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.mainGreen,
      brightness: Brightness.dark,
      surface: AppColors.dark05,
      onSurface: Colors.white,
      primaryContainer: AppColors.darkGreen,
      onPrimaryContainer: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.darkGreen,
      filled: true,
      hintStyle: TextStyles.bodySmall.copyWith(color: AppColors.lightGreen),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
