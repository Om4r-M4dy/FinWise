import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.title, required this.percent});
final String title;
final double percent;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlueButton,
        borderRadius: BorderRadius.circular(50),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            backgroundColor: AppColors.background,
                        radius: 45,
                        lineWidth: 5.0,
                        percent: 0.3,
                 center: Text("${(percent * 100).toInt()}%", style: TextStyles.title_20), 
                        progressColor: AppColors.oceanBlueButton,
                      ),
                    Gap(5),
                      Text(title, style: TextStyles.body_15.copyWith(color: Color(0xffF1FFF3)),),
                       
        ],
      ),
    );
  }
}