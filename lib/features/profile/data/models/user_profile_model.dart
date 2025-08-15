import 'package:uber_clone_x/features/profile/domain/entities/user_profile.dart';

/// Data model for user profile that extends the domain entity
/// Handles JSON serialization and deserialization
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    required super.fullName,
    required super.phone,
    required super.email,
    required super.profile,
    required super.gender,
    required super.profileImage,
  });

  /// Creates a UserProfileModel from JSON map
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] ?? json['_id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile'] ?? '',
      gender: json['gender'] ?? '',
      profileImage: json['profile_image'] ?? json['profileImage'] ?? '',
    );
  }

  /// Converts UserProfileModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'profile': profile,
      'gender': gender,
      'profile_image': profileImage,
    };
  }

  /// Creates a UserProfileModel from domain entity
  factory UserProfileModel.fromEntity(UserProfile userProfile) {
    return UserProfileModel(
      userId: userProfile.userId,
      fullName: userProfile.fullName,
      phone: userProfile.phone,
      email: userProfile.email,
      profile: userProfile.profile,
      gender: userProfile.gender,
      profileImage: userProfile.profileImage,
    );
  }

  /// Converts to domain entity
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      fullName: fullName,
      phone: phone,
      email: email,
      profile: profile,
      gender: gender,
      profileImage: profileImage,
    );
  }

  /// Creates a copy with updated fields
  @override
  UserProfileModel copyWith({
    String? userId,
    String? fullName,
    String? phone,
    String? email,
    String? profile,
    String? gender,
    String? profileImage,
  }) {
    return UserProfileModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
