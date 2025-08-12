import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/auth/domain/entities/tokenpair.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String phoneNumber;

  OtpSentSuccess(this.phoneNumber);
}

class OtpVerificationSuccess extends AuthState {
  final TokenPair tokenPair;

  OtpVerificationSuccess(this.tokenPair);
}

class DriverVehicleStatus extends AuthState {
  final bool hasVehicle;

  DriverVehicleStatus(this.hasVehicle);
}

class SignUpSuccess extends AuthState {
  final User user;

  SignUpSuccess(this.user);
}

class AuthFailure extends AuthState {
  final Failure failure;

  AuthFailure(this.failure);
}
