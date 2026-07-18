import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:finwise/core/functions/format_amount.dart';
import 'package:finwise/features/Home/persentation/widgets/analysis_home.dart';
import 'package:flutter/material.dart';

class LastWeekAnalysis extends StatelessWidget {
  final double revenue;
  final double expenses;
  final double savingsPercent;
  final bool showBackground;

  const LastWeekAnalysis({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.savingsPercent,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final bool useDarkThemeColors = isDarkTheme && !showBackground;

    final Color textColor = useDarkThemeColors
        ? Colors.white
        : AppColors.lettersAndIcons;
    final Color? iconColor = useDarkThemeColors ? Colors.white : null;

    final content = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TargetCard(
            title: "Savings \nOn goals",
            titelStyle: TextStyles.bodyMedium.copyWith(
              fontSize: 12,
              color: textColor,
            ),
            percent: savingsPercent,
            center: CustomSvgPicture(
              path: AppAssets.car,
              width: 37,
              color: iconColor,
            ),
            radius: 34,
            circleBackgroundColor: useDarkThemeColors
                ? AppColors.darkGreen
                : AppColors.background,
          ),
          VerticalDivider(
            width: 15,
            thickness: 1.5,
            color: useDarkThemeColors
                ? AppColors.darkGreen
                : AppColors.background,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnalysisHome(
                  icon: AppAssets.salary,
                  iconW: 31,
                  title: "Revenue Last Week",
                  money: formatAmount(revenue),
                  textColor: textColor,
                  iconColor: iconColor,
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  color: useDarkThemeColors
                      ? AppColors.darkGreen
                      : AppColors.background,
                ),
                AnalysisHome(
                  icon: AppAssets.food,
                  iconW: 19,
                  title: "Expenses Last Week",
                  money: formatAmount(expenses, isExpense: true),
                  moneyColor: useDarkThemeColors ? AppColors.lightBlueButton : AppColors.oceanBlueButton,
                  textColor: textColor,
                  iconColor: iconColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (showBackground) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),
          color: AppColors.mainGreen,
        ),
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: content,
          ),
        ),
      );
    }

    return content;
  }
}
