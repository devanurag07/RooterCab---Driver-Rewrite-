import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:uber_clone_x/features/auth/domain/entities/tokenpair.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl(this._authRemoteDatasource);

  @override
  Future<Either<Failure, bool>> signInWithOtp(String phoneNumber) async {
    try {
      final result = await _authRemoteDatasource.signInWithOtp(phoneNumber);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString(), StackTrace.current.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp() async {
    try {
      final result = await _authRemoteDatasource.signUp();
      return Right(result.toEntity());
    } catch (e) {
      return Left(Failure(e.toString(), StackTrace.current.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDriverVehicle() async {
    try {
      final result = await _authRemoteDatasource.checkDriverVehicle();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString(), StackTrace.current.toString()));
    }
  }

  @override
  Future<Either<Failure, TokenPair>> verifySignInOtp(
      String otp, String phoneNumber) async {
    try {
      final result =
          await _authRemoteDatasource.verifySignInOtp(otp, phoneNumber);
      return Right(result.toEntity());
    } catch (e) {
      return Left(Failure(e.toString(), StackTrace.current.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final result = await _authRemoteDatasource.getUserProfile();
      return Right(result.toEntity());
    } catch (e) {
      return Left(Failure(e.toString(), StackTrace.current.toString()));
    }
  }
}
