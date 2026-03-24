import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class RowAppBar extends StatelessWidget {
  const RowAppBar({
    super.key, required this.title,
  });
  final String title ;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CustomSvgPicture(path: AppAssets.back),
        ),
        Spacer(),
        Text(title, style: TextStyles.title_20),
        Spacer(),
        IconButton(
      onPressed: () {},
      icon: CustomSvgPicture(path: AppAssets.appBarNotification),
    ),
      ],
    );
  }
}
