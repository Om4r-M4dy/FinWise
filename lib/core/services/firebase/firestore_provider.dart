import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/core/constants/firebase_constants.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/profile/data/models/user_model.dart';
import 'package:finwise/features/saving_goals/data/model/goal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProvider {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final FirebaseAuth auth = FirebaseAuth.instance;

  static final CollectionReference transactionsCollection = firestore
      .collection(FirebaseConstants.transactionsCollection);

  static final CollectionReference categoriesCollection = firestore.collection(
    FirebaseConstants.categoriesCollection,
  );

  static final CollectionReference goalsCollection = firestore.collection(
    FirebaseConstants.goalsCollection,
  );

  static final CollectionReference user = firestore.collection('users');

  static Future<void> addUser(UserModel model) async {
    await user.doc(model.uid).set(model.toJson());
  }

  static Future<void> editUser(UserModel model) async {
    await user.doc(model.uid).update(model.toUpdateData());
  }

  static Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await user.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error getting user: $e');
      return null;
    }
  }

  // Transactions Methods

  static Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await transactionsCollection
          .doc(transaction.transactionId)
          .set(transaction.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<TransactionModel>> getTransactionsForRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get(const GetOptions(source: Source.server));
      List<TransactionModel> list = [];
      for (var doc in querySnapshot.docs) {
        list.add(TransactionModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return list;
    } on FirebaseException catch (e) {
      log(
        'FirebaseException in getTransactionsForRange: ${e.code} - ${e.message}',
      );
      log(
        '========================================================================',
      );
      log('FIRESTORE INDEX ERROR: ${e.message}');
      if (e.message != null && e.message!.contains('https://')) {
        log('Create index link: ${e.message}');
      }
      log(
        '========================================================================',
      );
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<QuerySnapshot> getTransactionsPage(
    String userId, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
    String? filterType,
  }) async {
    try {
      Query query = transactionsCollection.where('userId', isEqualTo: userId);
      if (filterType != null) {
        String dbFilterType = filterType;
        if (filterType.toLowerCase() == 'income') dbFilterType = 'Income';
        if (filterType.toLowerCase() == 'expense') dbFilterType = 'Expense';
        query = query.where('type', isEqualTo: dbFilterType);
      }
      query = query.orderBy('date', descending: true);
      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }
      return await query
          .limit(limit)
          .get(const GetOptions(source: Source.server));
    } on FirebaseException catch (e) {
      log('FirebaseException in getTransactionsPage: ${e.code} - ${e.message}');
      log(
        '========================================================================',
      );
      log('FIRESTORE INDEX ERROR: ${e.message}');
      if (e.message != null && e.message!.contains('https://')) {
        log('Create index link: ${e.message}');
      }
      log(
        '========================================================================',
      );
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> deleteTransaction(String transactionId) async {
    try {
      await transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await transactionsCollection
          .doc(transaction.transactionId)
          .update(transaction.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Goals Methods

  static Future<void> addGoal(GoalModel goal) async {
    try {
      await goalsCollection.doc(goal.goalId).set(goal.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<GoalModel>> getGoals(String userId) async {
    try {
      final querySnapshot = await goalsCollection
          .where('userId', isEqualTo: userId)
          .get();
      List<GoalModel> goalsList = [];
      for (var doc in querySnapshot.docs) {
        goalsList.add(GoalModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      goalsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return goalsList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> deleteGoal(String goalId) async {
    try {
      await goalsCollection.doc(goalId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> updateGoal(GoalModel goal) async {
    try {
      await goalsCollection.doc(goal.goalId).update(goal.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Notifications Methods
  static CollectionReference _userNotifications(String userId) {
    return user.doc(userId).collection('notifications');
  }

  static Future<void> addNotification(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _userNotifications(userId).add(data);
    } catch (e) {
      log('Error adding notification: $e');
    }
  }

  static Stream<List<Map<String, dynamic>>> getNotificationsStream(
    String userId,
  ) {
    return _userNotifications(
      userId,
    ).orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  static Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _userNotifications(
        userId,
      ).where('isRead', isEqualTo: false).get();
      final batch = firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      log('Error marking notifications as read: $e');
    }
  }
}
