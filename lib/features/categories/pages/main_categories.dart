import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/categories/pages/foodScreen.dart';
import 'package:finwise/features/categories/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainCategories extends StatelessWidget {
  const MainCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Categories"),
      body: MyBodyView(
        topSection: ProgressSection(
          percentage: 30,
          totalAmount: 20000,
          totalExpanse: 5000,
          totalBalance: 7200,
        ),
        bottomSection: Column(
          children: [
            Gap(13),
            Row(
              children: [
                CategoryItem(
                  icon: AppAssets.food,
                  label: "Food",
                  onTap: () {
                    pushTo(context, Routes.foodScreen);
                  },
                ),
                Gap(21),
                CategoryItem(
                  icon: AppAssets.transport,
                  label: "Transport",
                  bgColor: AppColors.lightBlueButton,
                  onTap: () {
                    pushTo(context, Routes.transportScreen);
                  },
                ),
                Gap(21),
                CategoryItem(
                  icon: AppAssets.medicine,
                  label: "Medicine",
                  bgColor: AppColors.lightBlueButton,
                ),
              ],
            ),
            Gap(38),
            Row(
              children: [
                CategoryItem(
                  icon: AppAssets.groceries,
                  label: "Groceries",
                  bgColor: AppColors.lightBlueButton,
                  onTap: () {
                    pushTo(context, Routes.groceriesScreen);
                  },
                ),
                Gap(21),

                CategoryItem(
                  icon: AppAssets.rent,
                  label: "Rent",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),
                CategoryItem(
                  icon: AppAssets.gift,
                  label: "Gifts",
                  bgColor: AppColors.lightBlueButton,
                ),
              ],
            ),
            Gap(38),
            Row(
              children: [
                CategoryItem(
                  icon: AppAssets.saving,
                  label: "Savings",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),

                CategoryItem(
                  icon: AppAssets.entertainment,
                  label: "Leisure",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),
                CategoryItem(
                  icon: AppAssets.more,
                  label: "More",
                  bgColor: AppColors.lightBlueButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
