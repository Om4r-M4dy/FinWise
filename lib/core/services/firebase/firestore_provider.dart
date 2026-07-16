import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/core/constants/firebase_constants.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/auth/models/user_model.dart';
import 'package:finwise/features/analysis/data/model/goal_model.dart';
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

  static Future<TransactionModel> getTransaction(String transactionId) async {
    try {
      final docSnapshot = await transactionsCollection.doc(transactionId).get();
      return TransactionModel.fromMap(
        docSnapshot.data() as Map<String, dynamic>,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final querySnapshot = await transactionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      List<TransactionModel> transactionsList = [];
      for (var doc in querySnapshot.docs) {
        transactionsList.add(
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('transactions length: ${transactionsList.length}');
      return transactionsList;
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
        goalsList.add(
          GoalModel.fromMap(doc.data() as Map<String, dynamic>),
        );
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
}
