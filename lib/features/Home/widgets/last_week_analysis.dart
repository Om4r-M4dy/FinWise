import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:finwise/features/Home/widgets/analysis_home.dart';
import 'package:flutter/material.dart';

class last_week_analysis extends StatelessWidget {
  const last_week_analysis({
    super.key,
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
            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TargetCard(
                  title: "Savings \nOn goals",
                  titelStyle: TextStyles.body_15.copyWith(fontSize: 12),
                  percent: 50,
                  center: CustomSvgPicture(
                    path: AppAssets.car,
                    width: 37,
                  ), radius: 34,
                ),
                VerticalDivider(
                  width: 20,
                  thickness: 1.5,
                  color: AppColors.background,
                ),
                Column(
                  children: [
                    AnalysisHome(
                      icon: AppAssets.salary,
                      iconW: 31,
                      title: "Revenue Last Week",
                      money: "\$4.000.00",
                    ),
                    Container(
                      height: 1,
                      width:
                          MediaQuery.of(context).size.width *
                          .45,
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      color: AppColors.background,
                    ),
                              
                    AnalysisHome(
                      icon: AppAssets.food,
                      iconW: 19,
                      title: "Food Last Week",
                      money: "-\$100.00",
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
