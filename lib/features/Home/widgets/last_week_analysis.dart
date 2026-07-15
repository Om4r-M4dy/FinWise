import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:finwise/features/Home/widgets/analysis_home.dart';
import 'package:flutter/material.dart';

class LastWeekAnalysis extends StatelessWidget {
  final double revenue;
  final double expenses;
  final double savingsPercent;

  const LastWeekAnalysis({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.savingsPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        color: AppColors.mainGreen,
      ),
      width: double.infinity,
      child: IntrinsicHeight(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TargetCard(
                  title: "Savings \nOn goals",
                  titelStyle: TextStyles.bodyMedium.copyWith(fontSize: 12),
                  percent: savingsPercent,
                  center: CustomSvgPicture(path: AppAssets.car, width: 37),
                  radius: 34,
                ),
                VerticalDivider(
                  width: 15,
                  thickness: 1.5,
                  color: AppColors.background,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalysisHome(
                      icon: AppAssets.salary,
                      iconW: 31,
                      title: "Revenue Last Week",
                      money: "\$${revenue.toStringAsFixed(2)}",
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * .40,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      color: AppColors.background,
                    ),
                    AnalysisHome(
                      icon: AppAssets.food,
                      iconW: 19,
                      title: "Expenses Last Week",
                      money: "-\$${expenses.toStringAsFixed(2)}",
                      moneyColor: AppColors.oceanBlueButton,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
