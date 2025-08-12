import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/network/token/token_store.dart';
import 'package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart';
import 'package:uber_clone_x/features/auth/domain/usecases/signin_user.dart';
import 'package:uber_clone_x/features/auth/domain/usecases/signup_user.dart';
import 'package:uber_clone_x/features/auth/domain/usecases/verify_signin_otp.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_events.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_state.dart';
import 'package:uber_clone_x/injection_container.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUser _signInUser;
  final VerifySignInOtp _verifySignInOtp;
  final SignUpUser _signUpUser;
  final AuthRepository _authRepository; // used for checkDriverVehicle

  AuthBloc({
    required SignInUser signInUser,
    required VerifySignInOtp verifySignInOtp,
    required SignUpUser signUpUser,
    required AuthRepository authRepository,
  })  : _signInUser = signInUser,
        _verifySignInOtp = verifySignInOtp,
        _signUpUser = signUpUser,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignInWithOtpRequested>(_onSignInWithOtpRequested);
    on<VerifySignInOtpRequested>(_onVerifySignInOtpRequested);
    on<CheckDriverVehicleRequested>(_onCheckDriverVehicleRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignInWithOtpRequested(
    SignInWithOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signInUser(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (sent) {
        if (sent) {
          emit(OtpSentSuccess(event.phoneNumber));
        } else {
          emit(AuthFailure(Failure('Failed to send OTP', 'OTP_SEND_FAILED')));
        }
      },
    );
  }

  Future<void> _onVerifySignInOtpRequested(
    VerifySignInOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _verifySignInOtp(event.params);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (tokenPair) {
        emit(OtpVerificationSuccess(tokenPair));
        // save token pair to local storage
        sl<TokenStore>().writeTokens(
          access: tokenPair.accessToken,
          refresh: tokenPair.refreshToken,
        );
      },
    );
  }

  Future<void> _onCheckDriverVehicleRequested(
    CheckDriverVehicleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.checkDriverVehicle();
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (hasVehicle) => emit(DriverVehicleStatus(hasVehicle)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // SignUp usecase signature expects a String param, though repository call doesn't use it
    final result = await _signUpUser('');
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}
