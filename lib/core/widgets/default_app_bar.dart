import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key, required this.title});

  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mainGreen,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: CustomSvgPicture(path: AppAssets.back),
      ),
      title: Center(
        child: Text(title, style: TextStyles.title_20.copyWith(height: 1.25)),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: CustomSvgPicture(path: AppAssets.appBarNotification),
        ),
      ],
    );
  }
}
