// data/ride/ride_repository_impl.dart
import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/core/network/socket/i_socket_service.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_dto.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_request_dto.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_status_dto.dart';
import 'package:uber_clone_x/features/ride/data/mappers/ride_mapper.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request_update.dart';
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';

// api client

class RideRepositoryImpl implements RideRepository {
  final ApiClient apiClient;
  final ISocketService socket;

  RideRepositoryImpl({required this.apiClient, required this.socket});

  // stream controllers exposed as cold streams
  final _reqCtrl = StreamController<RideRequest>.broadcast();
  final _statusCtrl = StreamController<RideStatusUpdate>.broadcast();

  // keep handler refs to detach
  void Function(dynamic)? _hReq;
  void Function(dynamic)? _hStatus;
  @override
  Future<Either<Failure, Ride?>> getActiveRide() async {
    try {
      final res = await apiClient
          .get('/ride/get-active-ride'); // { ride: {...} | null }
      return right(toRide(RideDto.fromJson(res)));
    } catch (e) {
      return left(Failure('Failed to get active ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> acceptRide(String rideId) async {
    // critical → ack
    try {
      await apiClient.post('/ride/accept-ride', body: {'rideId': rideId});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to accept ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> declineRide(String rideId) async {
    try {
      await apiClient.post('/ride/decline-ride', body: {'rideId': rideId});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to decline ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelRide(String rideId, String reason) async {
    try {
      await apiClient.post('/ride/cancel-ride',
          body: {'rideId': rideId, 'cancelReason': reason});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to cancel ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> startRide(String rideId, String otp) async {
    try {
      await apiClient
          .post('/ride/start-ride', body: {'rideId': rideId, 'otp': otp});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to start ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> arrivedAtPickup(String rideId) async {
    try {
      await apiClient
          .post('/ride/arrived-at-pickup-location', body: {'rideId': rideId});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to arrive at pickup', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> completeRide(String rideId) async {
    try {
      await apiClient.post('/ride/complete-ride', body: {'rideId': rideId});
      return right(null);
    } catch (e) {
      return left(Failure('Failed to complete ride', '400'));
    }
  }

  @override
  Stream<RideRequest> rideRequests$() => _reqCtrl.stream;
  @override
  Stream<RideStatusUpdate> statusUpdates$() => _statusCtrl.stream;

  @override
  void attachStreams() {
    detachStreams(); // idempotent

    _hReq = (dynamic raw) {
      try {
        final dto = RideRequestDto.fromJson(Map<String, dynamic>.from(raw));
        _reqCtrl.add(toRideRequest(dto));
      } catch (_) {}
    };
    _hStatus = (dynamic raw) {
      try {
        final dto = RideStatusDto.fromJson(Map<String, dynamic>.from(raw));
        _statusCtrl.add(toStatus(dto));
      } catch (_) {}
    };

    socket.on('ride:request', _hReq!);
    socket.on('ride:status', _hStatus!);
  }

  @override
  void detachStreams() {
    if (_hReq != null) socket.off('ride:request', _hReq);
    if (_hStatus != null) socket.off('ride:status', _hStatus);
    _hReq = null;
    _hStatus = null;
  }
}
