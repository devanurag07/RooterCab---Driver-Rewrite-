import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/profile/domain/entities/vehicle.dart';

/// Abstract interface for vehicle repository
/// Defines the contract for vehicle data operations
abstract class VehicleRepository {
  /// Fetches driver vehicles from data source
  /// Returns an [Either] a [Failure] on error or [List<Vehicle>] on success
  Future<Either<Failure, List<Vehicle>>> getDriverVehicles();
}
