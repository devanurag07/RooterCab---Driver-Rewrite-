import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/features/auth/domain/entities/tokenpair.dart';
import 'package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart';

class VerifySignInOtpParams {
  final String phoneNumber;
  final String otp;

  VerifySignInOtpParams(this.phoneNumber, this.otp);
}

class VerifySignInOtp extends BaseUsecase<TokenPair, VerifySignInOtpParams> {
  final AuthRepository _authRepository;

  VerifySignInOtp(this._authRepository);

  @override
  Future<Either<Failure, TokenPair>> call(VerifySignInOtpParams params) async {
    return _authRepository.verifySignInOtp(params.otp, params.phoneNumber);
  }
}
