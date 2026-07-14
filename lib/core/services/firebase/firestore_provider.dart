
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/features/auth/models/user_model.dart';

class FirestoreProvider {
  static final CollectionReference user = FirebaseFirestore.instance.collection('users');
  

  static Future<void> addUser(UserModel model) async {
    await user.doc(model.uid).set(model.toJson());
  }
  static Future<void> editUser(UserModel model) async {
  await user.doc(model.uid).update(model.toUpdateData());
}

}