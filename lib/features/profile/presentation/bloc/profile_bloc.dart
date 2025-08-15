import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/entities/profile_update_request.dart';
import 'package:uber_clone_x/features/profile/domain/usecases/get_user_profile.dart';
import 'package:uber_clone_x/features/profile/domain/usecases/update_user_profile.dart'
    as use_cases;

part 'profile_events.dart';
part 'profile_state.dart';

/// BLoC for managing profile state and business logic
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final use_cases.UpdateUserProfile _updateUserProfile;

  // Form controllers (similar to your cubit)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileBloc({
    required GetUserProfile getUserProfile,
    required use_cases.UpdateUserProfile updateUserProfile,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        super(const ProfileInitial()) {
    // Register event handlers
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateFormField>(_onUpdateFormField);
  }

  /// Handles the FetchUserProfile event
  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await _getUserProfile();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (userProfile) {
        // Update form controllers with loaded data
        fullNameController.text = userProfile.fullName;
        phoneController.text = userProfile.phone;
        emailController.text = userProfile.email;

        emit(ProfileLoaded(userProfile));
      },
    );
  }

  /// Handles the UpdateUserProfile event
  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdating());

    final result = await _updateUserProfile(event.request);

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (userProfile) {
        // Update form controllers with updated data
        fullNameController.text = userProfile.fullName;
        phoneController.text = userProfile.phone;
        emailController.text = userProfile.email;

        emit(ProfileUpdated(userProfile, 'Profile updated successfully'));
      },
    );
  }

  /// Handles the UpdateFormField event
  void _onUpdateFormField(
    UpdateFormField event,
    Emitter<ProfileState> emit,
  ) {
    // Update the appropriate controller based on the field
    switch (event.field) {
      case 'fullName':
        fullNameController.text = event.value;
        break;
      case 'phone':
        phoneController.text = event.value;
        break;
      case 'email':
        emailController.text = event.value;
        break;
    }
  }

  /// Get current user profile from state
  UserProfile? get currentUserProfile {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      return currentState.userProfile;
    } else if (currentState is ProfileUpdated) {
      return currentState.userProfile;
    }
    return null;
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    return super.close();
  }
}
