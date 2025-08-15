import 'dart:io';

/// Profile update request entity containing all the fields that can be updated
class ProfileUpdateRequest {
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String gender;
  final File? profileImage;

  const ProfileUpdateRequest({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    this.profileImage,
  });

  /// Creates a copy of this ProfileUpdateRequest with the given fields replaced with new values
  ProfileUpdateRequest copyWith({
    String? userId,
    String? fullName,
    String? phone,
    String? email,
    String? gender,
    File? profileImage,
  }) {
    return ProfileUpdateRequest(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUpdateRequest &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.gender == gender &&
        other.profileImage?.path == profileImage?.path;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        (profileImage?.path.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'ProfileUpdateRequest(userId: $userId, fullName: $fullName, phone: $phone, email: $email, gender: $gender, profileImage: ${profileImage?.path})';
  }
}
