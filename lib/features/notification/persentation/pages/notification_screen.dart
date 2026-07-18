import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/notification/persentation/cubit/notification_cubit.dart';
import 'package:finwise/features/notification/persentation/cubit/notification_state.dart';
import 'package:finwise/features/notification/data/models/notification_model.dart';
import 'package:finwise/features/notification/persentation/widgets/notification_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when entering screen
    context.read<NotificationCubit>().markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: "Notification", noNotify: true),
      body: MyBodyView(
        bottomSection: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.mainGreen),
              );
            } else if (state is NotificationError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is NotificationLoaded) {
              final hasToday = state.todayList.isNotEmpty;
              final hasYesterday = state.yesterdayList.isNotEmpty;
              final hasOlder = state.olderList.isNotEmpty;

              if (!hasToday && !hasYesterday && !hasOlder) {
                return Center(
                  child: Text(
                    "No notifications yet",
                    style: TextStyles.bodyMedium,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (hasToday) ...[
                      CompleteNotifySection(
                        sectionName: "Today",
                        notifyList: state.todayList,
                      ),
                      const Gap(25),
                    ],
                    if (hasYesterday) ...[
                      CompleteNotifySection(
                        sectionName: "Yesterday",
                        notifyList: state.yesterdayList,
                      ),
                      const Gap(25),
                    ],
                    if (hasOlder) ...[
                      CompleteNotifySection(
                        sectionName: "Older",
                        notifyList: state.olderList,
                      ),
                      const Gap(25),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CompleteNotifySection extends StatelessWidget {
  const CompleteNotifySection({
    super.key,
    required this.sectionName,
    required this.notifyList,
  });
  final String sectionName;
  final List<NotificationModel> notifyList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionName,
          style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.w400),
        ),
        const Gap(7),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final model = notifyList[index];
            final formattedDate = DateFormat(
              'HH:mm - MMMM dd',
            ).format(model.date);
            return NotificationElement(
              iconPath: model.iconPath.isEmpty
                  ? 'assets/icons/notification.svg'
                  : model.iconPath,
              title: model.title,
              subTitle: model.subTitle,
              date: formattedDate,
              transactionDetails: model.transactionDetails,
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15, bottom: 25),
              color: AppColors.oceanBlueButton.withValues(alpha: 0.5),
            );
          },
          itemCount: notifyList.length,
        ),
      ],
    );
  }
}
