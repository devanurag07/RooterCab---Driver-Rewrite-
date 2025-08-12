// domain/ride/usecases/detach_ride_streams.dart
import '../repository/ride_repository.dart';

class DetachRideStreams {
  final RideRepository repo;
  const DetachRideStreams(this.repo);
  void call() => repo.detachStreams();
}
