import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/profile/data/models/vehicle_model.dart';

/// Abstract interface for vehicle remote data source
abstract class VehicleRemoteDataSource {
  /// Fetches driver vehicles from API
  /// Throws an exception if the request fails
  Future<List<VehicleModel>> getDriverVehicles();
}

/// Implementation of vehicle remote data source
class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final ApiClient apiClient;

  const VehicleRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<VehicleModel>> getDriverVehicles() async {
    try {
      final responseData = await apiClient.get('/user/driver-vehicles');

      // Check if response has success flag and data
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> vehiclesJson = responseData['data'];
        return vehiclesJson.map((vehicle) {
          // Handle the nested structure where vehicle model is in 'model' field
          final vehicleData = vehicle['model'] ?? vehicle;
          return VehicleModel.fromJson(vehicleData);
        }).toList();
      } else {
        throw Exception('Invalid API response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch driver vehicles: $e');
    }
  }
}
