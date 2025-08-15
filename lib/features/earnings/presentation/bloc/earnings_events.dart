part of 'earnings_bloc.dart';

/// Base class for all earnings events
sealed class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch driver earnings
class FetchEarnings extends EarningsEvent {
  const FetchEarnings();
}

/// Event to refresh earnings data
class RefreshEarnings extends EarningsEvent {
  const RefreshEarnings();
}
