// domain/ride/usecases/accept_ride.dart
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import "package:fpdart/fpdart.dart";
import '../repository/ride_repository.dart';

class AcceptRide extends BaseUsecase<void, String> {
  final RideRepository repo;
  AcceptRide(this.repo);
  @override
  Future<Either<Failure, void>> call(String rideId) => repo.acceptRide(rideId);
}
