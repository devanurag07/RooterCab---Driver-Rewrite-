import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/trip/domain/usecases/get_driver_trips.dart';
import 'package:uber_clone_x/features/trip/presentation/bloc/trip_events.dart';
import 'package:uber_clone_x/features/trip/presentation/bloc/trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final GetDriverTrips _getDriverTrips;

  TripBloc({
    required GetDriverTrips getDriverTrips,
  })  : _getDriverTrips = getDriverTrips,
        super(TripInitial()) {
    on<GetDriverTripsRequested>(_onGetDriverTripsRequested);
  }

  Future<void> _onGetDriverTripsRequested(
    GetDriverTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    final result = await _getDriverTrips(event.driverId);

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trips) => emit(TripLoaded(trips)),
    );
  }
}
