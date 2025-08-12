import 'package:uber_clone_x/features/auth/domain/entities/user_profile.dart';

class UserProfileModel {
  final String id;
  final String status;

  UserProfileModel({required this.id, required this.status});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(id: json['id'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }

  UserProfile toEntity() {
    return UserProfile(id: id, status: status);
  }
}
