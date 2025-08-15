import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/usecase/base_usecase.dart';
import 'package:uber_clone_x/features/trip/domain/entities/trip.dart';
import 'package:uber_clone_x/features/trip/domain/repository/trip_repository.dart';

class GetDriverTrips implements BaseUsecase<List<Trip>, String> {
  final TripRepository _tripRepository;

  GetDriverTrips(this._tripRepository);

  @override
  Future<Either<Failure, List<Trip>>> call(String driverId) async {
    return await _tripRepository.getDriverTrips(driverId);
  }
}
