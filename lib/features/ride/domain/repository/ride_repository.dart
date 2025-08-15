// domain/ride/repositories/ride_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import '../entities/ride.dart';
import '../entities/ride_request_update.dart';

abstract class RideRepository {
  // Pull once (REST) – source of truth on resume/open
  Future<Either<Failure, Ride?>> getActiveRide();

  // Commands (critical → must be acked or strong REST)
  Future<Either<Failure, Ride>> acceptRide(String rideId);
  Future<Either<Failure, void>> declineRide(String rideId);
  Future<Either<Failure, Ride>> startRide(String rideId, String otp);
  Future<Either<Failure, Ride>> arrivedAtPickup(String rideId);
  Future<Either<Failure, Ride>> completeRide(String rideId);
  Future<Either<Failure, void>> cancelRide(String rideId, String reason);
  // Streams from socket (feature-scoped)
  Stream<Ride> rideRequests$();
  Stream<RideStatusUpdate> statusUpdates$();

  // Lifecycle to attach/detach socket handlers
  void attachStreams();
  void detachStreams();
}
