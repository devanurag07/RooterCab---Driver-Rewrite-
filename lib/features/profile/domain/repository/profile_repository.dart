import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/entities/profile_update_request.dart';

/// Abstract interface for profile repository
/// Defines the contract for profile data operations
abstract class ProfileRepository {
  /// Fetches the current user profile from data source
  /// Returns an [Either] a [Failure] on error or [UserProfile] on success
  Future<Either<Failure, UserProfile>> getUserProfile();

  /// Updates the user profile with the provided information
  /// Returns an [Either] a [Failure] on error or [UserProfile] on success
  Future<Either<Failure, UserProfile>> updateUserProfile(
      ProfileUpdateRequest request);
}
