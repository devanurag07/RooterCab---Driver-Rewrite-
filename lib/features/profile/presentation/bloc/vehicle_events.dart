/// Abstract base class for all vehicle events
abstract class VehicleEvent {}

/// Event to fetch driver vehicles
class FetchDriverVehicles extends VehicleEvent {
  FetchDriverVehicles();
}
