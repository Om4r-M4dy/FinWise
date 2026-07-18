import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String subTitle;
  final String iconPath;
  final DateTime date;
  final String? transactionDetails;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.iconPath,
    required this.date,
    this.transactionDetails,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      iconPath: map['iconPath'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      transactionDetails: map['transactionDetails'],
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'iconPath': iconPath,
      'date': Timestamp.fromDate(date),
      'transactionDetails': transactionDetails,
      'isRead': isRead,
    };
  }
}
