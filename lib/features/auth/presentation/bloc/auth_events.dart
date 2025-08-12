import 'package:uber_clone_x/features/auth/domain/usecases/verify_signin_otp.dart';

abstract class AuthEvent {}

class SignInWithOtpRequested extends AuthEvent {
  final String phoneNumber;

  SignInWithOtpRequested(this.phoneNumber);
}

class VerifySignInOtpRequested extends AuthEvent {
  final VerifySignInOtpParams params;

  VerifySignInOtpRequested({required this.params});
}

class CheckDriverVehicleRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {}
