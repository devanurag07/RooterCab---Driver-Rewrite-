// domain/ride/usecases/decline_ride.dart
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';

class DeclineRide extends BaseUsecase<void, String> {
  final RideRepository repo;
  DeclineRide(this.repo);
  @override
  Future<Either<Failure, void>> call(String rideId) => repo.declineRide(rideId);
}
