// domain/ride/usecases/attach_ride_streams.dart
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';

class AttachRideStreams {
  final RideRepository repo;
  const AttachRideStreams(this.repo);
  void call() => repo.attachStreams();
}
