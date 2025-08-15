import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/trip/data/models/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<List<TripModel>> getDriverTrips(String driverId);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final ApiClient _apiClient;

  TripRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<TripModel>> getDriverTrips(String driverId) async {
    final response = await _apiClient.get('/trip/driver-trips/$driverId');

    final trips = (response['trips'] as List)
        .map((trip) => TripModel.fromJson(trip))
        .toList();

    return trips;
  }
}
