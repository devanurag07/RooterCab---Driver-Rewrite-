import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/earnings/domain/entities/earning.dart';
import 'package:uber_clone_x/features/earnings/domain/repository/earnings_repository.dart';

/// Use case for fetching driver earnings
/// Follows the clean architecture pattern with single responsibility
class GetDriverEarnings {
  final EarningsRepository repository;

  const GetDriverEarnings(this.repository);

  /// Executes the use case to get driver earnings
  Future<Either<Failure, DriverEarnings>> call() async {
    return await repository.getDriverEarnings();
  }
}
