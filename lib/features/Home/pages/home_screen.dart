import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Home/widgets/last_week_analysis.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 36, right: 36),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, Welcome Back', style: TextStyles.title_20),
                    Text('Good Morning', style: TextStyles.caption1_14),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: CustomSvgPicture(path: AppAssets.notification),
                ),
              ],
            ),
          ),
          Gap(20),
          Expanded(
            child: MyBodyView(
              topSection: ProgressSection(
                percentage: 30,
                totalAmount: 20000.00,
                totalExpanse: 1187.40,
                totalBalance: 7783.00,
              ),
              bottomSection: SingleChildScrollView(
                child: Column(
                  children: [
                    last_week_analysis(),
                    Gap(26),
                    DateHeader(
                      selectedIndex: index,
                      labels: ["Daily", "Weekly", "Monthly"],
                      onUpdate: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                    ),
                    Gap(24),
                    InfoRecord(
                      iconPath: AppAssets.salary,
                      title: "Salary",
                      date: "18:27 - April 30",
                      cat: "Monthly",
                      amount: "\$4.000,00",
                    ),
                    Gap(19),
                    InfoRecord(
                      iconPath: AppAssets.groceries,
                      bgColor: AppColors.blueButton,
                      title: "Groceries",
                      date: "17:00 - April 24",
                      cat: "Pantry",
                      amount: "-\$100,00",
                      amountColor: AppColors.oceanBlueButton,
                    ),
                    Gap(19),
                    InfoRecord(
                      iconPath: AppAssets.salary,
                      bgColor: AppColors.oceanBlueButton,
                      title: "Salary",
                      date: "8:30 - April 15",
                      cat: "Monthly",
                      amount: "\$674,40",
                      amountColor: AppColors.oceanBlueButton,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
