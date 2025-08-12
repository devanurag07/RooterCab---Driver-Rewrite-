import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/auth/data/models/tokenpair_model.dart';
import 'package:uber_clone_x/features/auth/data/models/user_model.dart';
import 'package:uber_clone_x/features/auth/data/models/user_profile_model.dart';

abstract class AuthRemoteDatasource {
  Future<bool> signInWithOtp(String phoneNumber);
  Future<UserModel> signUp();
  Future<bool> checkDriverVehicle();
  Future<TokenPairModel> verifySignInOtp(String otp, String phoneNumber);
  Future<UserProfileModel> getUserProfile();
}

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final ApiClient apiClient;
  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<bool> signInWithOtp(String phoneNumber) async {
    //sends otp to the phone number and returns true if successful
    await apiClient.post('/auth/send-otp/', body: {
      'phone': phoneNumber,
    });
    return true;
  }

  @override
  Future<UserModel> signUp() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkDriverVehicle() async {
    return true;
  }

  @override
  Future<TokenPairModel> verifySignInOtp(String otp, String phoneNumber) async {
    final response = await apiClient.post('/auth/validate-otp/', body: {
      'otp': otp,
      'phone': phoneNumber,
    });

    final accessToken = response['access_token'];
    final refreshToken = response['refresh_token'];
    return TokenPairModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    return UserProfileModel(id: "1", status: "Approved");
  }
}
