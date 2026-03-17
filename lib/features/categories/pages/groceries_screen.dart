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
import 'package:finwise/features/categories/widgets/category_container.dart';
import 'package:finwise/features/categories/widgets/category_details.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GroceriesScreen extends StatelessWidget {
  const GroceriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Groceries"),
      body: MyBodyView(
        topSection: ProgressSection(
          percentage: 30,
          totalAmount: 20000,
          totalExpanse: 5000,
          totalBalance: 7200,
        ),
        bottomSection: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "March",
                    style: TextStyles.body_15.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                  CustomSvgPicture(path: AppAssets.calender),
                ],
              ),
              Gap(5),
              CategoryDetails(
                icon: AppAssets.groceries,
                title: "Pantry",
                subtitle: "18:27 - March 10",
                trailing: "-\$53.59",
                verticalPadding: 8,
                horizontalPadding: 15,
                leadingColor: AppColors.lightBlueButton,
              ),
              Gap(5),
              CategoryDetails(
                icon: AppAssets.groceries,
                title: "Snacks",
                subtitle: "15:00 - March 01",
                trailing: "-\$35.03",
                verticalPadding: 8,
                horizontalPadding: 15,
              ),
              Gap(10),

              Text(
                "February",
                style: TextStyles.body_15.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.lettersAndIcons,
                ),
              ),
              Gap(10),
              CategoryDetails(
                icon: AppAssets.groceries,
                title: "Canned Food",
                subtitle: "10:47 - February 30",
                trailing: "-\$11.82",
                verticalPadding: 8,
                horizontalPadding: 15,
              ),
              Gap(5),
              CategoryDetails(
                icon: AppAssets.groceries,
                title: "Veggies",
                subtitle: "7:30 - February 20",
                trailing: "-\$14.79",
                verticalPadding: 8,
                horizontalPadding: 15,
                leadingColor: AppColors.lightBlueButton,
              ),

              CategoryDetails(
                icon: AppAssets.groceries,
                title: "Groceries",
                subtitle: "18:50 - February 01",
                trailing: "-\$175,35",
                verticalPadding: 8,
                horizontalPadding: 15,
              ),
              Gap(10),
              Center(
                child: MainButton(
                  text: "Add Expenses",
                  onPress: () {
                    pushTo(context, Routes.addExpenses);
                  },
                  textStyle: TextStyles.body_15.copyWith(
                    color: AppColors.lettersAndIcons,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
