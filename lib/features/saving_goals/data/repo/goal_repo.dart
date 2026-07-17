import 'package:dartz/dartz.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/saving_goals/data/model/goal_model.dart';

class GoalRepo {
  Future<Either<Failure, List<GoalModel>>> getGoals(String userId) async {
    try {
      final list = await FirestoreProvider.getGoals(userId);
      return Right(list);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> addGoal(GoalModel goal) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.addGoal(goal);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> deleteGoal(String goalId) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.deleteGoal(goalId);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> updateGoal(GoalModel goal) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.updateGoal(goal);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }
}
