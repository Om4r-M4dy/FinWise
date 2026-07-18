import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/buttons/notification_badge_button.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.noNotify = false,
    this.actions,
  });

  final String title;
  final bool noNotify;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: CustomSvgPicture(
          path: AppAssets.back,
          color: theme.colorScheme.onSurface,
        ),
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      actions: actions ?? (noNotify ? null : [const NotificationBadgeButton()]),
    );
  }
}
