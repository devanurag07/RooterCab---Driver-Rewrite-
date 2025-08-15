import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/profile/domain/usecases/get_driver_vehicles.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_events.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_state.dart';

/// BLoC for managing vehicle-related state and business logic
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetDriverVehicles _getDriverVehicles;

  VehicleBloc({
    required GetDriverVehicles getDriverVehicles,
  })  : _getDriverVehicles = getDriverVehicles,
        super(VehicleInitial()) {
    // Register event handlers
    on<FetchDriverVehicles>(_onFetchDriverVehicles);
  }

  /// Handles the FetchDriverVehicles event
  Future<void> _onFetchDriverVehicles(
    FetchDriverVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    final result = await _getDriverVehicles(null);

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (vehicles) => emit(VehicleLoaded(vehicles)),
    );
  }
}
