// domain/ride/usecases/get_active_ride.dart
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride.dart';
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';

class GetActiveRide extends BaseUsecase<Ride?, void> {
  final RideRepository repo;
  GetActiveRide(this.repo);
  @override
  Future<Either<Failure, Ride?>> call(void params) => repo.getActiveRide();
}
