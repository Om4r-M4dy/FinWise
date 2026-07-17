import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String transactionId;
  final String userId;
  final String title;
  final double amount;
  final String type; // 'balance', 'income' or 'expense'
  final String categoryId;
  final String categoryName;
  final String note;
  final DateTime date;
  final String? goalId;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.note,
    required this.date,
    this.goalId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();
    final rawDate = map['date'];
    if (rawDate != null) {
      if (rawDate is Timestamp) {
        parsedDate = rawDate.toDate();
      } else if (rawDate is String) {
        parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
      } else if (rawDate is int) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
      }
    }
    return TransactionModel(
      transactionId: map['transactionId'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] ?? 'expense',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      note: map['note'] ?? '',
      date: parsedDate,
      goalId: map['goalId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'note': note,
      'date': Timestamp.fromDate(date),
      'goalId': goalId,
    };
  }
}
