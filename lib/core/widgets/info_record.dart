import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/app_icon_button.dart';
import 'package:flutter/material.dart';

class InfoRecord extends StatelessWidget {
  const InfoRecord({
    super.key, required this.iconPath, required this.title, required this.date, required this.cat, required this.amount, this.amountColor,
  });
final String iconPath;
final String title;
final String date;
final String cat;
final String amount;
final Color? amountColor;



  @override
  Widget build(BuildContext context) {
    return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppIconButton(path:iconPath,
        iconColor: AppColors.background,
        iconWidth: 23,
        bgWidth: 57,
        bgHeight: 53,
        ),
       //  Gap(18),
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(title,style: TextStyles.body_15.copyWith(
                         fontWeight: FontWeight.w600,
                                      color:AppColors.lettersAndIcons
           ),),
           Text(date,
           style: TextStyles.caption3_12.copyWith(
                 fontWeight: FontWeight.w600,
             color: AppColors.oceanBlueButton),
           
           ),
        
         ],
       ),
       
          Container(
               width: 1,
               height: MediaQuery.of(context).size.width*.08,
               margin: const EdgeInsets.symmetric(vertical: 15),
               color: AppColors.mainGreen,
             ),
          Text(cat,style: TextStyles.caption2_13.copyWith(
                         fontWeight: FontWeight.w300,
                            color:AppColors.lettersAndIcons
           ),),
                          Container(
               width: 1,
               height: MediaQuery.of(context).size.width*.08,
               margin: const EdgeInsets.symmetric(vertical: 15),
               color: AppColors.mainGreen,
             ),
          Text(amount,style: TextStyles.body_15.copyWith(
                         fontWeight: FontWeight.w600,
                         color: amountColor??AppColors.lettersAndIcons
           ),),
      ],
    );
  }
}
