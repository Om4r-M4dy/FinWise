import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationElement extends StatelessWidget {
  const NotificationElement({
    super.key, required this.iconPath, required this.title, required this.subTitle, required this.date, this.transactionDetails,
  });
final String iconPath;
final String title;
final String subTitle;
final String date;
final String? transactionDetails;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Container(
              height: 37,
              width: 37,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.mainGreen,
                borderRadius: BorderRadius.circular(12)
              ), child:  CustomSvgPicture(path: iconPath,width: 21,),),
    Gap(13),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyles.body_15,),
           Gap(3),
          Text(subTitle,style: TextStyles.caption1_14.copyWith(fontWeight: FontWeight.w400),),
          Gap(3),
         transactionDetails!=null? Text(transactionDetails!,style: TextStyles.caption3_12.copyWith(fontWeight: FontWeight.w600,color: AppColors.oceanBlueButton),):SizedBox.shrink(),
          
          Align(
            alignment: Alignment.centerRight,
            child: Text(date,
            textAlign: TextAlign.right,
            style: TextStyles.caption2_13.copyWith(fontWeight: FontWeight.w300,
            color: AppColors.oceanBlueButton),)),
        
        ],
      ),
    ),
           
      ],
    );
  }
}