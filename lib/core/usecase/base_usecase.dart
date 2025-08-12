import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';

abstract class BaseUsecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
