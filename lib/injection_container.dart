import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:uber_clone_x/core/network/api_client.dart";
import "package:uber_clone_x/core/network/socket/i_socket_service.dart";
import "package:uber_clone_x/core/network/socket/socket_service.dart";
import "package:uber_clone_x/core/network/token/secure_token_store.dart";
import "package:uber_clone_x/core/network/token/token_store.dart";
import "package:dio/dio.dart";
import "package:uber_clone_x/core/network/interceptors/auth_interceptor.dart";
import "package:uber_clone_x/core/network/dio_api_client.dart";
import "package:uber_clone_x/features/auth/data/datasources/auth_remote_datasource.dart";
import "package:uber_clone_x/features/auth/data/repository/auth_repository_impl.dart";
import "package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart";
import "package:uber_clone_x/core/constants.dart" as constants;
import "package:uber_clone_x/features/auth/domain/usecases/signin_user.dart";
import "package:uber_clone_x/features/auth/domain/usecases/signup_user.dart";
import "package:uber_clone_x/features/auth/domain/usecases/verify_signin_otp.dart";
import "package:uber_clone_x/features/auth/presentation/bloc/auth_bloc.dart";
import "package:uber_clone_x/features/auth/presentation/cubit/profile_verification_cubit.dart";
import "package:uber_clone_x/features/earnings/data/datasources/earnings_remote_datasource.dart";
import "package:uber_clone_x/features/earnings/data/repository/earnings_repository_impl.dart";
import "package:uber_clone_x/features/earnings/domain/repository/earnings_repository.dart";
import "package:uber_clone_x/features/earnings/domain/usecases/get_driver_earnings.dart";
import "package:uber_clone_x/features/earnings/presentation/bloc/earnings_bloc.dart";
import "package:uber_clone_x/features/profile/data/datasources/profile_remote_datasource.dart";
import "package:uber_clone_x/features/profile/data/datasources/vehicle_remote_datasource.dart";
import "package:uber_clone_x/features/profile/data/repository/profile_repository_impl.dart";
import "package:uber_clone_x/features/profile/data/repository/vehicle_repository_impl.dart";
import "package:uber_clone_x/features/profile/domain/repository/profile_repository.dart";
import "package:uber_clone_x/features/profile/domain/repository/vehicle_repository.dart";
import "package:uber_clone_x/features/profile/domain/usecases/get_user_profile.dart";
import "package:uber_clone_x/features/profile/domain/usecases/get_driver_vehicles.dart";
import "package:uber_clone_x/features/profile/domain/usecases/update_user_profile.dart";
import "package:uber_clone_x/features/profile/presentation/bloc/profile_bloc.dart";
import "package:uber_clone_x/features/profile/presentation/bloc/vehicle_bloc.dart";
import "package:uber_clone_x/features/ride/data/repository/ride_repository_impl.dart";
import "package:uber_clone_x/features/ride/presentation/bloc/ride_bloc.dart";
import "package:uber_clone_x/features/ride/domain/repository/ride_repository.dart";
import "package:uber_clone_x/features/ride/domain/usecases/accept_ride.dart";
import "package:uber_clone_x/features/ride/domain/usecases/attach_ride_streams.dart";
import "package:uber_clone_x/features/ride/domain/usecases/decline_ride.dart";
import "package:uber_clone_x/features/ride/domain/usecases/detach_ride_streams.dart";
import "package:uber_clone_x/features/ride/domain/usecases/get_active_ride.dart";
import "package:uber_clone_x/features/trip/data/datasources/trip_remote_datasource.dart";
import "package:uber_clone_x/features/trip/data/repository/trip_repository_impl.dart";
import "package:uber_clone_x/features/trip/domain/repository/trip_repository.dart";
import "package:uber_clone_x/features/trip/domain/usecases/get_driver_trips.dart";
import "package:uber_clone_x/features/trip/presentation/bloc/trip_bloc.dart";

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //socket service singleton
  final socket = SocketService.init(
    baseUri: Uri.parse(constants.kSocketUrl),
    tokenProvider: () async => sl<TokenStore>().readAccessToken(),
  );

  // Register as ISocketService
  sl.registerSingleton<ISocketService>(socket);
  // token store, connectivity, etc...
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<TokenStore>(() => SecureTokenStore(sl()));

  // bare dio for refresh (no auth interceptor)
  final bareDio = Dio(BaseOptions(baseUrl: constants.kBaseUrl));

  // auth interceptor depends on token store + bare dio
  sl.registerLazySingleton<Interceptor>(
      () => AuthInterceptor(tokenStore: sl(), dio: bareDio));

  // api client
  sl.registerLazySingleton<ApiClient>(() => DioApiClient.create(
        baseUrl: constants.kBaseUrl,
        authInterceptor: sl(),
      ));

  // data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(apiClient: sl()));

  // repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton<SignInUser>(() => SignInUser(sl()));
  sl.registerLazySingleton<VerifySignInOtp>(() => VerifySignInOtp(sl()));
  sl.registerLazySingleton<SignUpUser>(() => SignUpUser(sl()));

  // bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        signInUser: sl(),
        verifySignInOtp: sl(),
        signUpUser: sl(),
        authRepository: sl(),
      ));

  // use cases
  sl.registerLazySingleton<GetUserProfile>(() => GetUserProfile(sl()));
  // cubit
  sl.registerLazySingleton<ProfileVerificationCubit>(
      () => ProfileVerificationCubit(sl()));

// ridebloc
  sl.registerLazySingleton<RideRepository>(() => RideRepositoryImpl(
        apiClient: sl<ApiClient>(),
        socket: sl<ISocketService>(),
      ));

// use cases
  sl.registerFactory(() => GetActiveRide(sl<RideRepository>()));
  sl.registerFactory(() => AcceptRide(sl<RideRepository>()));
  sl.registerFactory(() => DeclineRide(sl<RideRepository>()));
  sl.registerFactory(() => AttachRideStreams(sl<RideRepository>()));
  sl.registerFactory(() => DetachRideStreams(sl<RideRepository>()));

// bloc
  sl.registerFactory(() => RideBloc(
        getActiveRide: sl<GetActiveRide>(),
        accept: sl<AcceptRide>(),
        decline: sl<DeclineRide>(),
        attach: sl<AttachRideStreams>(),
        detach: sl<DetachRideStreams>(),
        repo: sl<RideRepository>(),
      ));

  // earnings bloc
  sl.registerLazySingleton<EarningsRemoteDataSource>(
      () => EarningsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<EarningsRepository>(
      () => EarningsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<GetDriverEarnings>(() => GetDriverEarnings(sl()));
  sl.registerFactory(() => EarningsBloc(
        getDriverEarnings: sl<GetDriverEarnings>(),
      ));

  // trip feature dependencies
  sl.registerLazySingleton<TripRemoteDataSource>(
      () => TripRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<TripRepository>(
      () => TripRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<GetDriverTrips>(() => GetDriverTrips(sl()));
  sl.registerFactory(() => TripBloc(
        getDriverTrips: sl<GetDriverTrips>(),
      ));

  // profile feature dependencies
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UpdateUserProfile>(() => UpdateUserProfile(sl()));
  sl.registerFactory(() => ProfileBloc(
        getUserProfile: sl<GetUserProfile>(),
        updateUserProfile: sl<UpdateUserProfile>(),
      ));

  // vehicle feature dependencies
  sl.registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<GetDriverVehicles>(() => GetDriverVehicles(sl()));
  sl.registerFactory(() => VehicleBloc(
        getDriverVehicles: sl<GetDriverVehicles>(),
      ));
}
