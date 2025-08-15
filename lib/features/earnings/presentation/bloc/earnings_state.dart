part of 'earnings_bloc.dart';

/// Base class for all earnings states
sealed class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object> get props => [];
}

/// Initial state when the bloc is first created
class EarningsInitial extends EarningsState {
  const EarningsInitial();
}

/// State when earnings are being loaded
class EarningsLoading extends EarningsState {
  const EarningsLoading();
}

/// State when earnings are successfully loaded
class EarningsSuccess extends EarningsState {
  final DriverEarnings earnings;

  const EarningsSuccess({required this.earnings});

  @override
  List<Object> get props => [earnings];
}

/// State when there's an error loading earnings
class EarningsError extends EarningsState {
  final String message;

  const EarningsError({required this.message});

  @override
  List<Object> get props => [message];
}
