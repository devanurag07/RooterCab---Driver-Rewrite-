import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/features/profile/domain/entities/vehicle.dart';
import 'package:uber_clone_x/features/profile/domain/repository/vehicle_repository.dart';

/// Use case for fetching driver vehicles
/// Follows the clean architecture pattern by extending BaseUsecase
class GetDriverVehicles extends BaseUsecase<List<Vehicle>, void> {
  final VehicleRepository repository;

  GetDriverVehicles(this.repository);

  @override
  Future<Either<Failure, List<Vehicle>>> call(void params) async {
    return await repository.getDriverVehicles();
  }
}
