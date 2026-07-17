import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class RowAppBar extends StatelessWidget {
  const RowAppBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CustomSvgPicture(
            path: AppAssets.back,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Spacer(),
        Text(
          title,
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            pushTo(context, Routes.notificationScreen);
          },
          icon: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: CustomSvgPicture(
              path: AppAssets.notification,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
