import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/data/datasources/vehicle_remote_datasource.dart';
import 'package:uber_clone_x/features/profile/domain/entities/vehicle.dart';
import 'package:uber_clone_x/features/profile/domain/repository/vehicle_repository.dart';

/// Implementation of the VehicleRepository interface
/// Handles data retrieval from remote data sources and maps to domain entities
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  const VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Vehicle>>> getDriverVehicles() async {
    try {
      final result = await remoteDataSource.getDriverVehicles();
      // Convert VehicleModel list to Vehicle entity list
      final vehicles = result.map((model) => model as Vehicle).toList();
      return right(vehicles);
    } catch (e) {
      return left(
          Failure('Failed to fetch driver vehicles: ${e.toString()}', '500'));
    }
  }
}
