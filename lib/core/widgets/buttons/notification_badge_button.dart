import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/notification/persentation/cubit/notification_cubit.dart';
import 'package:finwise/features/notification/persentation/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBadgeButton extends StatelessWidget {
  const NotificationBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationLoaded) {
          unreadCount = state.unreadCount;
        }
        return Stack(
          alignment: Alignment.center,
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
    );
  }
}
