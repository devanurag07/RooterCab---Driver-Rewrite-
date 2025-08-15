part of 'profile_bloc.dart';

/// Abstract base class for all Profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to trigger fetching of user profile
class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile();
}

/// Event to trigger updating of user profile
class UpdateUserProfileEvent extends ProfileEvent {
  final ProfileUpdateRequest request;

  const UpdateUserProfileEvent(this.request);

  @override
  List<Object?> get props => [request];
}

/// Event to update form field values
class UpdateFormField extends ProfileEvent {
  final String field;
  final String value;

  const UpdateFormField(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}
