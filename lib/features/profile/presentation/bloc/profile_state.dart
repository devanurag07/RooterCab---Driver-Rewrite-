part of 'profile_bloc.dart';

/// Abstract base class for all Profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the Profile BLoC
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// State indicating that profile data is being loaded
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// State indicating successful retrieval of profile data
class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;

  const ProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

/// State indicating that profile is being updated
class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}

/// State indicating successful profile update
class ProfileUpdated extends ProfileState {
  final UserProfile userProfile;
  final String message;

  const ProfileUpdated(this.userProfile, this.message);

  @override
  List<Object?> get props => [userProfile, message];
}

/// State indicating an error occurred
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
