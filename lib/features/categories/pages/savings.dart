import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/categories/widgets/savings_sub_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Savings extends StatelessWidget {
  const Savings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Savings"),
      body: MyBodyView(
        topSection: ProgressSection(
          percentage: 30,
          totalAmount: 20000,
          totalExpanse: 5000,
          totalBalance: 7200,
        ),
        bottomSection: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SavingsSubItem(
                    icon: AppAssets.travel,
                    bgColor: AppColors.oceanBlueButton,
                    label: "Travel",
                    onTap: () {
                      pushTo(context, Routes.travel);
                    },
                  ),
                ),
                Gap(15),
                Expanded(
                  child: SavingsSubItem(
                    icon: AppAssets.newHome,
                    label: "New House",
                    onTap: () {
                      pushTo(context, Routes.newHouse);
                    },
                  ),
                ),
                Gap(15),
                Expanded(
                  child: SavingsSubItem(
                    icon: AppAssets.car,
                    label: "Car",
                    onTap: () {
                      pushTo(context, Routes.car);
                    },
                  ),
                ),
              ],
            ),
            Gap(30),
            SavingsSubItem(
              icon: AppAssets.wedding,
              label: "Wedding",
              width: 100,
              height: 95,
              onTap: () {
                pushTo(context, Routes.wedding);
              },
            ),

            Gap(170),
            Center(
              child: MainButton(
                size: ButtonSize.small,
                text: "Add More",
                textStyle: TextStyles.body_15.copyWith(
                  color: Color(0xff093030),
                ),
                onPress: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
