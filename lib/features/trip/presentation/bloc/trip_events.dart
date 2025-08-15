abstract class TripEvent {}

class GetDriverTripsRequested extends TripEvent {
  final String driverId;

  GetDriverTripsRequested({required this.driverId});
}
