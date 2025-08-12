enum RideStatus {
  requested,
  accepted,
  arrived,
  started,
  completed,
  canceledByRider,
  canceledByDriver
}

class RideStatusUpdate {
  final String rideId;
  final RideStatus status;
  const RideStatusUpdate(this.rideId, this.status);
}
