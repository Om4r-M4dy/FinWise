import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/notification/cubit/notification_cubit.dart';
import 'package:finwise/features/notification/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      actions: actions ??
          (noNotify
              ? null
              : [
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      int unreadCount = 0;
                      if (state is NotificationLoaded) {
                        unreadCount = state.unreadCount;
                      }
                      return Stack(
                        children: [
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
                          if (unreadCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  unreadCount > 9 ? '9+' : '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ]),
    );
  }
}
