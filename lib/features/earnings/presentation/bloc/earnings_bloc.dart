import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/earnings/domain/entities/earning.dart';
import 'package:uber_clone_x/features/earnings/domain/usecases/get_driver_earnings.dart';

part 'earnings_events.dart';
part 'earnings_state.dart';

/// BLoC for managing earnings state and business logic
class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final GetDriverEarnings _getDriverEarnings;

  EarningsBloc({
    required GetDriverEarnings getDriverEarnings,
  })  : _getDriverEarnings = getDriverEarnings,
        super(const EarningsInitial()) {
    // Register event handlers
    on<FetchEarnings>(_onFetchEarnings);
    on<RefreshEarnings>(_onRefreshEarnings);
  }

  /// Handles the FetchEarnings event
  Future<void> _onFetchEarnings(
    FetchEarnings event,
    Emitter<EarningsState> emit,
  ) async {
    emit(const EarningsLoading());

    final result = await _getDriverEarnings();

    result.fold(
      (failure) => emit(EarningsError(message: failure.message)),
      (earnings) => emit(EarningsSuccess(earnings: earnings)),
    );
  }

  /// Handles the RefreshEarnings event
  Future<void> _onRefreshEarnings(
    RefreshEarnings event,
    Emitter<EarningsState> emit,
  ) async {
    // For refresh, we can show loading or keep current state
    // Here we'll show loading for better UX
    emit(const EarningsLoading());

    final result = await _getDriverEarnings();

    result.fold(
      (failure) => emit(EarningsError(message: failure.message)),
      (earnings) => emit(EarningsSuccess(earnings: earnings)),
    );
  }
}
