import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/categories/widgets/PngCategoryItem.dart';
import 'package:finwise/features/categories/widgets/categoryItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class MainCategories extends StatelessWidget {
  const MainCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Categories"),
      body: MyBodyView(
        topSection: Container(),
        bottomSection: Column(
          children: [
            Row(
              children: [
                CategotyItem(image: AppAssets.food, label: "Food"),
                Gap(21),

                CategotyItem(
                  image: AppAssets.transport,
                  label: "Transport",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),
                CategotyItem(
                  image: AppAssets.medicine,
                  label: "Medicine",
                  bgColor: AppColors.lightBlueButton,
                ),
              ],
            ),
            Gap(38),
            Row(
              children: [
                CategotyItem(
                  image: AppAssets.groceries,
                  label: "Groceries",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),

                CategotyItem(
                  image: AppAssets.rent,
                  label: "Rent",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),
                CategotyItem(
                  image: AppAssets.gift,
                  label: "Gifts",
                  bgColor: AppColors.lightBlueButton,
                ),
              ],
            ),
            Gap(38),
            Row(
              children: [
                CategotyItem(
                  image: AppAssets.saving,
                  label: "Savings",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),

                CategotyItem(
                  image: AppAssets.entertainment,
                  label: "Leisure",
                  bgColor: AppColors.lightBlueButton,
                ),
                Gap(21),
                PngCategotyItem(
                  image: AppAssets.more,
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
