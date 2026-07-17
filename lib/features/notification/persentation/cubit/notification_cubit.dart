import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/notification/data/models/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    _init();
  }

  StreamSubscription? _subscription;

  void _init() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      getNotifications(userId);
    }
  }

  void getNotifications(String userId) {
    emit(NotificationLoading());
    _subscription?.cancel();
    _subscription = FirestoreProvider.getNotificationsStream(userId).listen(
      (dataList) {
        final allNotifications = dataList.map((map) {
          final id = map['id'] as String;
          return NotificationModel.fromMap(map, id);
        }).toList();

        final today = <NotificationModel>{};
        final yesterday = <NotificationModel>{};
        final older = <NotificationModel>{};

        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        final yesterdayStart = todayStart.subtract(const Duration(days: 1));

        for (var notify in allNotifications) {
          if (notify.date.isAfter(todayStart)) {
            today.add(notify);
          } else if (notify.date.isAfter(yesterdayStart)) {
            yesterday.add(notify);
          } else {
            older.add(notify);
          }
        }

        final unread = allNotifications.where((n) => !n.isRead).length;

        emit(
          NotificationLoaded(
            todayList: today.toList(),
            yesterdayList: yesterday.toList(),
            olderList: older.toList(),
            unreadCount: unread,
          ),
        );
      },
      onError: (error) {
        emit(NotificationError(error.toString()));
      },
    );
  }

  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirestoreProvider.markAllAsRead(userId);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
