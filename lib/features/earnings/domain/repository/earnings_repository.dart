import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/earnings/domain/entities/earning.dart';

/// Repository interface for earnings data operations
abstract class EarningsRepository {
  /// Fetches driver earnings data from remote source
  /// Returns Either<Failure, DriverEarnings> for proper error handling
  Future<Either<Failure, DriverEarnings>> getDriverEarnings();
}
