import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart';

class SignInUser extends BaseUsecase<bool, String> {
  final AuthRepository _authRepository;

  SignInUser(this._authRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return _authRepository.signInWithOtp(params);
  }
}
