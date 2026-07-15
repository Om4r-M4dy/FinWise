import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  bool _isPasswordConfirmed = false;
  bool get isPasswordConfirmed => _isPasswordConfirmed;

  Future<void> verifyPassword(String password) async {
    if (password.trim().isEmpty) {
      emit(PasswordVerificationFailure("Please enter your password"));
      return;
    }

    emit(PasswordVerificationLoading());

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) {
        emit(PasswordVerificationFailure("No authenticated user found."));
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password.trim(),
      );
      await currentUser.reauthenticateWithCredential(credential);
      _isPasswordConfirmed = true;
      emit(PasswordVerificationSuccess());
    } on FirebaseAuthException catch (e) {
      String msg = 'Authentication failed.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = 'Incorrect password. Please try again.';
      } else {
        msg = e.message ?? msg;
      }
      emit(PasswordVerificationFailure(msg));
    } catch (e) {
      emit(PasswordVerificationFailure("An error occurred. Please try again."));
    }
  }

  Future<void> deleteUserDataAndAccount() async {
    emit(AccountDeletionLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // 1. Delete all transactions of user in firestore
        final txQuery = await FirestoreProvider.transactionsCollection
            .where('userId', isEqualTo: uid)
            .get();
        final batch = FirestoreProvider.firestore.batch();
        for (final doc in txQuery.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        // 2. Delete user doc in firestore
        await FirestoreProvider.user.doc(uid).delete();
      }

      // 3. Delete FirebaseAuth user account
      await FirebaseAuth.instance.currentUser?.delete();

      // 4. Wipe local preferences cache
      await UserPrefs.clearAuthData();

      emit(AccountDeletionSuccess());
    } catch (e) {
      emit(AccountDeletionFailure("Error deleting account: ${e.toString()}"));
    }
  }
}
