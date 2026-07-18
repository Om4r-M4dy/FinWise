import 'package:dartz/dartz.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/profile/data/models/user_model.dart';

class UserRepo {
  Future<Either<Failure, UserModel?>> getUser(String uid) async {
    try {
      final user = await FirestoreProvider.getUser(uid);
      return Right(user);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> editUser(UserModel user) async {
    try {
      await FirestoreProvider.editUser(user);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }
}
