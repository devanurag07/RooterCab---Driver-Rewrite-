import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import "package:fpdart/fpdart.dart";
import 'package:uber_clone_x/features/auth/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/auth/domain/repository/auth_repostiory.dart';

class GetUserProfile extends BaseUsecase<UserProfile, void> {
  final AuthRepository authRepository;
  GetUserProfile(this.authRepository);

  @override
  Future<Either<Failure, UserProfile>> call(void params) async {
    return await authRepository.getUserProfile();
  }
}
