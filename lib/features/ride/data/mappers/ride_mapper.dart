import 'package:uber_clone_x/features/ride/data/dto/ride_dto.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_request_dto.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_status_dto.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request_update.dart';

Ride toRide(RideDto d) =>
    Ride(id: d.id, pickupAddress: d.pickup, dropoffAddress: d.dropoff);

RideRequest toRideRequest(RideRequestDto d) =>
    RideRequest(d.rideId, DateTime.parse(d.expiresAt));

RideStatus _phaseFrom(String s) {
  switch (s) {
    case 'accepted':
      return RideStatus.accepted;
    case 'arrived':
      return RideStatus.arrived;
    case 'started':
      return RideStatus.started;
    case 'completed':
      return RideStatus.completed;
    case 'canceled_by_rider':
      return RideStatus.canceledByRider;
    case 'canceled_by_driver':
      return RideStatus.canceledByDriver;
    default:
      return RideStatus.requested;
  }
}

RideStatusUpdate toStatus(RideStatusDto d) =>
    RideStatusUpdate(d.rideId, _phaseFrom(d.status));
