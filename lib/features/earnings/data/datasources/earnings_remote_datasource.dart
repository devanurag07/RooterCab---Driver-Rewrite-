import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/features/earnings/domain/entities/earning.dart';

/// Abstract interface for earnings remote data source
abstract class EarningsRemoteDataSource {
  /// Fetches driver earnings from API
  /// Throws an exception if the request fails
  Future<DriverEarnings> getDriverEarnings();
}

/// Implementation of earnings remote data source
class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  final ApiClient apiClient;
  const EarningsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<DriverEarnings> getDriverEarnings() async {
    try {
      final earnings = await apiClient.get('/earnings/');
      return DriverEarnings.fromJson(earnings);
    } catch (e) {
      throw Exception('Failed to fetch earnings: $e');
    }
  }
}
