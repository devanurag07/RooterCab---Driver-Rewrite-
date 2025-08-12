import 'package:uber_clone_x/features/auth/domain/entities/tokenpair.dart';

class TokenPairModel {
  final String accessToken;
  final String refreshToken;

  TokenPairModel({required this.accessToken, required this.refreshToken});

  factory TokenPairModel.fromJson(Map<String, dynamic> json) {
    return TokenPairModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  TokenPair toEntity() {
    return TokenPair(accessToken: accessToken, refreshToken: refreshToken);
  }
}
