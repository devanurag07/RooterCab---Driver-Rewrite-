import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/repository/profile_repository.dart';

/// Use case for fetching user profile
/// Follows the clean architecture pattern with single responsibility
class GetUserProfile {
  final ProfileRepository repository;

  const GetUserProfile(this.repository);

  /// Executes the use case to get user profile
  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getUserProfile();
  }
}
