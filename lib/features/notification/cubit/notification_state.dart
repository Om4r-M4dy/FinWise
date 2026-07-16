import 'package:finwise/features/notification/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> todayList;
  final List<NotificationModel> yesterdayList;
  final List<NotificationModel> olderList;
  final int unreadCount;

  NotificationLoaded({
    required this.todayList,
    required this.yesterdayList,
    required this.olderList,
    this.unreadCount = 0,
  });
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
