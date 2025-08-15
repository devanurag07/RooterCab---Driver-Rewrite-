import 'package:uber_clone_x/features/auth/domain/entities/user_profile.dart';

class UserProfileModel {
  final String id;
  final String status;
  final String fullName;
  final String phone;
  final String email;
  final String profile;
  final String gender;
  final String profileImage;

  UserProfileModel(
      {required this.id,
      required this.status,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.profile,
      required this.gender,
      required this.profileImage});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
        id: json['id'],
        status: json['status'],
        fullName: json['fullName'],
        phone: json['phone'],
        email: json['email'],
        profile: json['profile'],
        gender: json['gender'],
        profileImage: json['profileImage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'profile': profile,
      'gender': gender,
      'profileImage': profileImage,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
        id: id,
        fullName: fullName,
        phone: phone,
        email: email,
        profile: profile,
        gender: gender,
        profileImage: profileImage);
  }
}
