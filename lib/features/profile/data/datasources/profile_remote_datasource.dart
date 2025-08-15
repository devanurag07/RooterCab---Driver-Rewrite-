import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/profile/data/models/user_profile_model.dart';
import 'package:uber_clone_x/features/profile/domain/entities/profile_update_request.dart';

/// Abstract interface for profile remote data source
abstract class ProfileRemoteDataSource {
  /// Fetches user profile from local storage (SharedPreferences)
  /// Throws an exception if the request fails
  Future<UserProfileModel> getUserProfile();

  /// Updates user profile via API
  /// Throws an exception if the request fails
  Future<UserProfileModel> updateUserProfile(ProfileUpdateRequest request);
}

/// Implementation of profile remote data source
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  const ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      // Fetch user profile from API using ApiClient
      final responseData = await apiClient.get('/user/profile');

      // Check if response has success flag and data
      if (responseData['success'] == true && responseData['data'] != null) {
        final userModel = UserProfileModel.fromJson(responseData['data']);
        debugPrint("userModel: ${userModel.toJson().toString()}");
        return userModel;
      } else {
        throw Exception('Invalid API response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
      ProfileUpdateRequest request) async {
    try {
      // Using the constants from your app
      const baseUrl = 'http://192.168.1.10:5001/api'; // Your actual base URL
      final uri = Uri.parse('$baseUrl/user/update-user');

      final httpRequest = http.MultipartRequest('PUT', uri)
        ..fields['full_name'] = request.fullName
        ..fields['phone'] = request.phone
        ..fields['email'] = request.email
        ..fields['gender'] = request.gender;

      // Add auth token
      final token = await _getToken();
      httpRequest.headers['Authorization'] = 'Bearer $token';

      // Add profile image if provided
      if (request.profileImage != null) {
        var stream = http.ByteStream(request.profileImage!.openRead());
        var length = await request.profileImage!.length();
        var multipartFile = http.MultipartFile(
          'profile_image',
          stream,
          length,
          filename: path.basename(request.profileImage!.path),
          contentType: MediaType('image', 'jpeg'),
        );
        httpRequest.files.add(multipartFile);
      }

      final response = await httpRequest.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> updatedUserData = json.decode(responseBody);

        // Update SharedPreferences with new user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode(updatedUserData));

        return UserProfileModel.fromJson(updatedUserData);
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception(
            'Failed to update user: ${response.statusCode}\n$responseBody');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  /// Helper method to get auth token
  /// This should match your getToken() function
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}
