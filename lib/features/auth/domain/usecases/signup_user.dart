import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/features/auth/domain/entities/user.dart';
import "package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart";

class SignUpUser extends BaseUsecase<User, String> {
  final AuthRepository _authRepository;

  SignUpUser(this._authRepository);

  @override
  Future<Either<Failure, User>> call(String params) async {
    return _authRepository.signUp();
  }
}
