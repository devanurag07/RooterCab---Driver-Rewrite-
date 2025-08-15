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
  final Ride req;
  const RideRequested(this.req);
}

class RideActive extends RideState {
  final Ride ride;
  const RideActive(this.ride);
}

class RideCompleted extends RideState {
  final Ride ride;
  const RideCompleted(this.ride);
}

class RideError extends RideState {
  final String message;
  const RideError(this.message);
}

class RideActionInFlight extends RideState {
  final RideState prev;
  const RideActionInFlight(this.prev);
}
