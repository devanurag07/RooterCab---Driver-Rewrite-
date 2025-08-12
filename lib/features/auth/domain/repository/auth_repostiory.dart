import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/auth/domain/entities/tokenpair.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signInWithOtp(String phoneNumber);
  Future<Either<Failure, TokenPair>> verifySignInOtp(
      String otp, String phoneNumber);
  Future<Either<Failure, bool>> checkDriverVehicle();
  Future<Either<Failure, User>> signUp(); // register driver.
  Future<Either<Failure, UserProfile>> getUserProfile();
}
