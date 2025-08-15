/// Dependency injection setup for profile feature
///
/// This file shows how to wire up all the dependencies for the profile feature.
/// Add this to your main dependency injection container.

import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:uber_clone_x/features/profile/data/repository/profile_repository_impl.dart';
import 'package:uber_clone_x/features/profile/domain/repository/profile_repository.dart';
import 'package:uber_clone_x/features/profile/domain/usecases/get_user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/usecases/update_user_profile.dart'
    as use_cases;
import 'package:uber_clone_x/features/profile/presentation/bloc/profile_bloc.dart';

/// Example of how to set up profile dependencies
///
/// Usage in your dependency injection setup:
/// ```dart
/// // In your service locator or dependency injection
/// final profileInjection = ProfileInjection(apiClient: sl<ApiClient>());
///
/// // Register dependencies
/// sl.registerLazySingleton<ProfileRemoteDataSource>(
///   () => profileInjection.remoteDataSource,
/// );
/// sl.registerLazySingleton<ProfileRepository>(
///   () => profileInjection.repository,
/// );
/// sl.registerLazySingleton<GetUserProfile>(
///   () => profileInjection.getUserProfile,
/// );
/// sl.registerLazySingleton<use_cases.UpdateUserProfile>(
///   () => profileInjection.updateUserProfile,
/// );
///
/// // In your widget tree:
/// BlocProvider(
///   create: (context) => ProfileBloc(
///     getUserProfile: sl<GetUserProfile>(),
///     updateUserProfile: sl<UpdateUserProfile>(),
///   ),
///   child: ProfileScreen(),
/// )
/// ```
class ProfileInjection {
  final ApiClient apiClient;

  // Data source
  late final ProfileRemoteDataSource _remoteDataSource;

  // Repository
  late final ProfileRepository _repository;

  // Use cases
  late final GetUserProfile _getUserProfile;
  late final use_cases.UpdateUserProfile _updateUserProfile;

  ProfileInjection({required this.apiClient}) {
    _setupDependencies();
  }

  void _setupDependencies() {
    // Data sources
    _remoteDataSource = ProfileRemoteDataSourceImpl(apiClient);

    // Repository
    _repository = ProfileRepositoryImpl(
      remoteDataSource: _remoteDataSource,
    );

    // Use cases
    _getUserProfile = GetUserProfile(_repository);
    _updateUserProfile = use_cases.UpdateUserProfile(_repository);
  }

  // Getters for accessing dependencies
  ProfileRemoteDataSource get remoteDataSource => _remoteDataSource;
  ProfileRepository get repository => _repository;
  GetUserProfile get getUserProfile => _getUserProfile;
  use_cases.UpdateUserProfile get updateUserProfile => _updateUserProfile;

  /// Creates a new ProfileBloc instance
  ProfileBloc createProfileBloc() {
    return ProfileBloc(
      getUserProfile: _getUserProfile,
      updateUserProfile: _updateUserProfile,
    );
  }
}
