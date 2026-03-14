import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class CategotyItem extends StatelessWidget {
  const CategotyItem({
    super.key,
    this.bgColor = AppColors.oceanBlueButton,
    required this.image,
    required this.label,
    this.ontap,
  });

  final Color bgColor;
  final String image;
  final String label;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ontap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              height: 98,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: CustomSvgPicture(
                color: AppColors.background,
                height: 54,
                width: 30,
                path: image,
              ),
            ),
            SizedBox(height: 3),
            Text(
              label,
              
              style: TextStyles.body_15.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.lettersAndIcons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
