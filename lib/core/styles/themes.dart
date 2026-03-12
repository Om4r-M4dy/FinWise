import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
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
  );
}
