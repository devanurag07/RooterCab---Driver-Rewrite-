part of 'ride_bloc.dart';

abstract class RideEvent {
  const RideEvent();
}

class RideStarted extends RideEvent {
  const RideStarted();
}

class RideStopped extends RideEvent {
  const RideStopped();
}

class RideAcceptPressed extends RideEvent {
  final String rideId;
  const RideAcceptPressed(this.rideId);
}

class RideDeclinePressed extends RideEvent {
  final String rideId;
  const RideDeclinePressed(this.rideId);
}

// internal: from repo streams
class _IncomingRequest extends RideEvent {
  final RideRequest req;
  const _IncomingRequest(this.req);
}

class _IncomingStatus extends RideEvent {
  final RideStatusUpdate upd;
  const _IncomingStatus(this.upd);
}
