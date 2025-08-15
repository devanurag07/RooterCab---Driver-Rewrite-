import 'package:uber_clone_x/features/profile/domain/entities/vehicle.dart';

/// Abstract base class for all vehicle states
abstract class VehicleState {}

/// Initial state when BLoC is first created
class VehicleInitial extends VehicleState {}

/// Loading state when fetching vehicles
class VehicleLoading extends VehicleState {}

/// Success state when vehicles are successfully loaded
class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehicleLoaded(this.vehicles);
}

/// Error state when vehicle loading fails
class VehicleError extends VehicleState {
  final String message;

  VehicleError(this.message);
}
