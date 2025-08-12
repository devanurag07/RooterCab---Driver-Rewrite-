import 'package:uber_clone_x/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? vehicleType;
  final String? vehicleNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.vehicleType,
    this.vehicleNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
