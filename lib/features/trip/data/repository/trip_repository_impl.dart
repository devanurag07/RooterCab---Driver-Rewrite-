import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:uber_clone_x/features/trip/domain/entities/trip.dart';
import 'package:uber_clone_x/features/trip/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource _remoteDataSource;

  TripRepositoryImpl({required TripRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Trip>>> getDriverTrips(String driverId) async {
    try {
      final tripModels = await _remoteDataSource.getDriverTrips(driverId);
      final trips = tripModels.map((model) => model.toEntity()).toList();
      return Right(trips);
    } catch (e) {
      return Left(Failure('Failed to fetch trips: ${e.toString()}', '400'));
    }
  }
}
