part of 'ride_bloc.dart';

abstract class RideEvent {
  const RideEvent();
}

class RideInit extends RideEvent {
  const RideInit();
}

class RideDestroy extends RideEvent {
  const RideDestroy();
}

// when user arrives at the pickup location. state -> ridarrived
class RideCmdArrive extends RideEvent {
  final String rideId;
  const RideCmdArrive(this.rideId);
}

// when user starts the ride ... by entering the otp. state -> ridstarts or inprogress
class RideCmdStart extends RideEvent {
  final String rideId;
  final String otp;
  const RideCmdStart(this.rideId, this.otp);
}

// when user cancels the ride ...  state -> ridcancelled
class RideCmdCancel extends RideEvent {
  final String rideId;
  final String reason;
  const RideCmdCancel(this.rideId, this.reason);
}

// when user completes the ride. state -> ridcompleted
class RideCmdComplete extends RideEvent {
  final String rideId;
  const RideCmdComplete(this.rideId);
}

// when user accepts the ride. state -> ridaccepted
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
  final Ride req;
  const _IncomingRequest(this.req);
}

class _IncomingStatus extends RideEvent {
  final RideStatusUpdate upd;
  const _IncomingStatus(this.upd);
}
