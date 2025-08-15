import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/trip/domain/entities/trip.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Trip> trips;

  TripLoaded(this.trips);
}

class TripFailure extends TripState {
  final Failure failure;

  TripFailure(this.failure);
}
