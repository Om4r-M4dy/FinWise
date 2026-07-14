import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/core/constants/firebase_constants.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
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

  static final CollectionReference userProfile = firestore.collection(
    FirebaseConstants.usersCollection,
  );

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
}
