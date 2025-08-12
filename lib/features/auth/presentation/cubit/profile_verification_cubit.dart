import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/auth/domain/usecases/get_profile.dart';

sealed class ProfileVerificationState {
  const ProfileVerificationState();
}

class ProfileVerificationLoading extends ProfileVerificationState {
  const ProfileVerificationLoading();
}

class ProfileVerificationVerified extends ProfileVerificationState {
  const ProfileVerificationVerified();
}

class ProfileVerificationNotVerified extends ProfileVerificationState {
  const ProfileVerificationNotVerified();
}

class ProfileVerificationError extends ProfileVerificationState {
  final String msg;
  const ProfileVerificationError(this.msg);
}

class ProfileVerificationCubit extends Cubit<ProfileVerificationState> {
  final GetUserProfile _getProfile; // use case
  ProfileVerificationCubit(this._getProfile)
      : super(const ProfileVerificationLoading());

  Future<void> check() async {
    emit(const ProfileVerificationLoading());
    final res = await _getProfile(null); // Either<Failure, DriverProfile>
    res.match(
      (f) => emit(ProfileVerificationError(f.message)),
      (p) => emit(p.status == 'Approved'
          ? const ProfileVerificationVerified()
          : const ProfileVerificationNotVerified()),
    );
  }
}
