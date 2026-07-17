import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String goalId;
  final String userId;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdAt;

  String get iconPath {
    final t = title.toLowerCase().trim();
    if (t.contains('travel') || t.contains('trip') || t.contains('vacation')) {
      return 'assets/icons/Travel.svg';
    } else if (t.contains('house') ||
        t.contains('home') ||
        t.contains('building') ||
        t.contains('flat')) {
      return 'assets/icons/NewHome.svg';
    } else if (t.contains('car') ||
        t.contains('vehicle') ||
        t.contains('automobile')) {
      return 'assets/icons/Car.svg';
    } else if (t.contains('wedding') ||
        t.contains('marriage') ||
        t.contains('weeding')) {
      return 'assets/icons/Wedding.svg';
    } else {
      return 'assets/icons/Saving.svg';
    }
  }

  GoalModel({
    required this.goalId,
    required this.userId,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.createdAt,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();
    final rawDate = map['createdAt'];
    if (rawDate != null) {
      if (rawDate is Timestamp) {
        parsedDate = rawDate.toDate();
      } else if (rawDate is String) {
        parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
      } else if (rawDate is int) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
      }
    }
    return GoalModel(
      goalId: map['goalId'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (map['currentAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalId': goalId,
      'userId': userId,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
