/// User profile entity representing the driver's profile information
class UserProfile {
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String profile;
  final String gender;
  final String profileImage;

  const UserProfile({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.profile,
    required this.gender,
    required this.profileImage,
  });

  /// Creates a copy of this UserProfile with the given fields replaced with new values
  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? phone,
    String? email,
    String? profile,
    String? gender,
    String? profileImage,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.profile == profile &&
        other.gender == gender &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        profile.hashCode ^
        gender.hashCode ^
        profileImage.hashCode;
  }

  @override
  String toString() {
    return 'UserProfile(userId: $userId, fullName: $fullName, phone: $phone, email: $email, profile: $profile, gender: $gender, profileImage: $profileImage)';
  }
}
