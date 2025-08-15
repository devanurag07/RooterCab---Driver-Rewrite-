import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/entities/profile_update_request.dart';
import 'package:uber_clone_x/features/profile/domain/repository/profile_repository.dart';

/// Implementation of the ProfileRepository interface
/// Handles data retrieval from remote data sources and maps to domain entities
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return right(result.toEntity());
    } catch (e) {
      return left(
          Failure('Failed to fetch user profile: ${e.toString()}', '500'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(
      ProfileUpdateRequest request) async {
    try {
      final result = await remoteDataSource.updateUserProfile(request);
      return right(result.toEntity());
    } catch (e) {
      return left(
          Failure('Failed to update user profile: ${e.toString()}', '500'));
    }
  }
}
