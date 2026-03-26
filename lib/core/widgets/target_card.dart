import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.title, required this.percent, this.center});
final String title;
final double percent;
final Widget? center;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:center!=null?null :AppColors.lightBlueButton,
        borderRadius: BorderRadius.circular(50),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            backgroundColor: AppColors.background,
                        radius: 45,
                        lineWidth: 5.0,
                        percent: percent/100,
                 center:center?? Text("${(percent ).toInt()}%", style: TextStyles.title_20), 
                        progressColor: AppColors.oceanBlueButton,
                      ),
                    Gap(5),
                      Text(title,maxLines: 2 ,style: TextStyles.body_15.copyWith(color: center!=null?AppColors.dark05:Color(0xffF1FFF3)),),
                       
        ],
      ),
    );
  }
}