import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/plot_helper.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/app_icon_button.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/plots_section.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuickAnalysisScreen extends StatelessWidget {
  const QuickAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Quickly Analysis"),
      body: MyBodyView(
        topSection: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TargetCard(
                title: "Savings \nOn goals",
                percent: 50,
                center: CustomSvgPicture(path: AppAssets.car, width: 50),
              ),
              VerticalDivider(
                width: 20,
                thickness: 1.5,
                color: AppColors.background,
              ),
              Column(
                children: [
                  AnalysisRow(
                    icon: AppAssets.salary,
                    iconW: 38,
                    title: "Revenue Last Week",
                    money: "\$4.000.00",
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width*.45,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    color: AppColors.background,
                  ),

                  AnalysisRow(
                    icon: AppAssets.food,
                    iconW: 23,
                    title: "Food Last Week",
                    money: "-\$100.00",
                    moneyColor: AppColors.oceanBlueButton,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSection: Column(
          children: [
PlotsSections( 
  plotTitle: "April Expenses",
  chartData: getCurrentChartData(1),
              maxY: calculateMaxY(1),
         ),
         Gap(26),
         InfoRecord(iconPath:  AppAssets.salary,title:"Salary" ,date:"18:27 - April 30",cat: "Monthly",amount: "\$4.000,00",),
         Gap(19),
         InfoRecord(iconPath:  AppAssets.groceries,title:"Groceries" ,date:"17:00 - April 24",cat: "Pantry",amount:"-\$100,00",amountColor: AppColors.oceanBlueButton,),
           Gap(19),
         InfoRecord(iconPath:  AppAssets.salary,title:"Salary" ,date:"18:27 - April 30",cat: "Monthly",amount: "\$4.000,00",),
           Gap(19),
         InfoRecord(iconPath:  AppAssets.salary,title:"Salary" ,date:"18:27 - April 30",cat: "Monthly",amount: "\$4.000,00",),
           Gap(19),
         InfoRecord(iconPath:  AppAssets.salary,title:"Salary" ,date:"18:27 - April 30",cat: "Monthly",amount: "\$4.000,00",),
         
          ],
        ),
      ),
    );
  }
}

class AnalysisRow extends StatelessWidget {
  const AnalysisRow({
    super.key,
    required this.icon,
    required this.title,
    required this.money,
    this.iconW,
    this.moneyColor,
  });
  final String icon;
  final String title;
  final String money;
  final double? iconW;
  final Color? moneyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgPicture(path: icon, width: iconW, color: AppColors.dark05),
        Gap(17),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.caption3_12.copyWith(
                color: AppColors.lettersAndIcons,
              ),
            ),
            Text(
              money,
              style: TextStyles.body_15.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: moneyColor ?? AppColors.lettersAndIcons,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
