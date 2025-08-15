import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/earnings/data/datasources/earnings_remote_datasource.dart';
import 'package:uber_clone_x/features/earnings/domain/entities/earning.dart';
import 'package:uber_clone_x/features/earnings/domain/repository/earnings_repository.dart';

/// Implementation of EarningsRepository
/// Handles data fetching and error conversion
class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsRemoteDataSource remoteDataSource;

  const EarningsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, DriverEarnings>> getDriverEarnings() async {
    try {
      final earnings = await remoteDataSource.getDriverEarnings();
      return right(earnings);
    } catch (e) {
      return left(Failure('Failed to fetch earnings: $e', '500'));
    }
  }
}
