part of 'ride_bloc.dart';

abstract class RideState {
  const RideState();
}

class RideIdle extends RideState {
  const RideIdle();
}

class RideLoading extends RideState {
  const RideLoading();
}

class RideRequested extends RideState {
  final RideRequest req;
  const RideRequested(this.req);
}

class RideActive extends RideState {
  final String rideId;
  const RideActive(this.rideId);
}

class RideError extends RideState {
  final String message;
  const RideError(this.message);
}

class RideActionInFlight extends RideState {
  final RideState prev;
  const RideActionInFlight(this.prev);
}
