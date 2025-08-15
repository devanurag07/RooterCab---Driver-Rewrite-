import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/entities/profile_update_request.dart';
import 'package:uber_clone_x/features/profile/domain/repository/profile_repository.dart';

/// Use case for updating user profile
/// Follows the clean architecture pattern with single responsibility
class UpdateUserProfile {
  final ProfileRepository repository;

  const UpdateUserProfile(this.repository);

  /// Executes the use case to update user profile
  Future<Either<Failure, UserProfile>> call(
      ProfileUpdateRequest request) async {
    return await repository.updateUserProfile(request);
  }
}
