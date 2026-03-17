import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/categories/widgets/category_container.dart';
import 'package:flutter/material.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.leadingColor = AppColors.blueButton,
    this.verticalPadding = 13,  this.horizontalPadding = 21,
  });
  final String icon;
  final String title;
  final String subtitle;
  final String trailing;
final double verticalPadding;
  final double horizontalPadding;
  final Color leadingColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CategoryContainer(icon: icon, bgColor: leadingColor , verticalPadding: verticalPadding, horizontalPadding: horizontalPadding,),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyles.body_15.copyWith(color: AppColors.lettersAndIcons),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyles.caption3_12.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.blueButton,
        ),
      ),
      trailing: Text(
        trailing,
        style: TextStyles.body_15.copyWith(color: AppColors.blueButton),
      ),
    );
  }
}
