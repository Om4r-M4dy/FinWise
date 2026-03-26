import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/percentage_bar.dart';
import 'package:finwise/features/categories/widgets/category_details.dart';
import 'package:finwise/features/categories/widgets/savings_item_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Wedding extends StatelessWidget {
  const Wedding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Wedding"),
      body: MyBodyView(
        bottomSection: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SavingsItemHeader(
              goal: "\$649.200",
              amountSaved: "\$261.360",
              savingsIcon: AppAssets.wedding,
              savingsLabel: "House",
              iconHeight: 46,
              iconWidth: 51,
            ),
            Gap(30),
            PercentageBar(percentage: 30, totalAmount: 20000),
            Gap(10),
            Row(
              children: [
                Icon(
                  Icons.check_box_outlined,
                  color: AppColors.dark05,
                  size: 12,
                ),
                const Gap(6),
                Text(
                  "30% of your expenses, looks good.",
                  style: TextStyles.body_15,
                ),
              ],
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "April",
                  style: TextStyles.body_15.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.lettersAndIcons,
                  ),
                ),
                CustomSvgPicture(path: AppAssets.calender),
              ],
            ),
            Gap(3),
            CategoryDetails(
              verticalPadding: 14,
              horizontalPadding: 13,
              leadingColor: AppColors.lightBlueButton,
              icon: AppAssets.wedding,
              title: 'Wedding Deposit',
              subtitle: "19:56 - April 30",
              trailing: '\$217.77',
            ),
            Gap(6),

            CategoryDetails(
              verticalPadding: 14,
              horizontalPadding: 13,
              icon: AppAssets.wedding,
              title: 'Wedding Deposit',
              subtitle: "19:56 - April 15",
              trailing: '\$217.77',
            ),
            Gap(6),

            CategoryDetails(
              verticalPadding: 14,
              horizontalPadding: 13,
              leadingColor: AppColors.lightBlueButton,
              icon: AppAssets.wedding,
              title: 'Wedding Deposit',
              subtitle: "19:56 - April 10",
              trailing: '\$217.77',
            ),
            Gap(10),
            Center(
              child: MainButton(
                textStyle: TextStyles.body_15.copyWith(
                  color: Color(0xff093030),
                ),
                size: ButtonSize.small,
                text: "Add Savings",
                onPress: () {
                  pushTo(context, Routes.addSavings);
                },
                backgroundColor: AppColors.mainGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
