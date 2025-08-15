// data/ride/ride_repository_impl.dart
import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_x/core/failure/failure.dart';
import 'package:uber_clone_x/core/network/api_client.dart';
import 'package:uber_clone_x/core/network/socket/i_socket_service.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_dto.dart';
import 'package:uber_clone_x/features/ride/data/dto/ride_status_dto.dart';
import 'package:uber_clone_x/features/ride/data/mappers/ride_mapper.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request_update.dart';
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';

// api client

class RideRepositoryImpl implements RideRepository {
  final ApiClient apiClient;
  final ISocketService socket;

  RideRepositoryImpl({required this.apiClient, required this.socket});

  // stream controllers exposed as cold streams
  final _reqCtrl = StreamController<Ride>.broadcast();
  final _statusCtrl = StreamController<RideStatusUpdate>.broadcast();

  // keep handler refs to detach
  void Function(dynamic)? _hReq;
  void Function(dynamic)? _hStatus;

  @override
  Future<Either<Failure, Ride?>> getActiveRide() async {
    try {
      final res = await apiClient
          .get('/ride/get-active-ride'); // { ride: {...} | null }

      final ride = toRide(RideDto.fromJson(res));
      debugPrint('Active ride: $ride');
      return right(ride);
    } catch (e) {
      debugPrint('Failed to get active ride: $e');
      return left(Failure('Failed to get active ride', '400'));
    }
  }

  @override
  Future<Either<Failure, Ride>> acceptRide(String rideId) async {
    // critical → ack
    try {
      final res =
          await apiClient.post('/ride/accept-ride', body: {'rideId': rideId});
      final ride = toRide(RideDto.fromJson(res));
      debugPrint('Accepted ride: $ride');
      return right(ride);
    } catch (e) {
      return left(Failure('Failed to accept ride', '400'));
    }
  }

  @override
  Future<Either<Failure, void>> declineRide(String rideId) async {
    try {
      // decline ride function is not on the backend yet TODO: add it
      await apiClient.post('/ride/decline-ride', body: {'rideId': rideId});
      return right(null);
    } catch (e) {
      debugPrint('Failed to decline ride: ${e.toString()}');
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
  Future<Either<Failure, Ride>> startRide(String rideId, String otp) async {
    try {
      final res = await apiClient
          .post('/ride/start-ride', body: {'rideId': rideId, 'otp': otp});
      final ride = toRide(RideDto.fromJson(res));
      debugPrint('Started ride: $ride');
      return right(ride);
    } catch (e) {
      debugPrint('Failed to start ride: ${e.toString()}');
      return left(Failure('Failed to start ride', '400'));
    }
  }

  @override
  Future<Either<Failure, Ride>> arrivedAtPickup(String rideId) async {
    try {
      final res = await apiClient
          .post('/ride/arrived-at-pickup-location', body: {'rideId': rideId});
      final ride = toRide(RideDto.fromJson(res));
      debugPrint('Arrived at pickup: $ride');
      return right(ride);
    } catch (e) {
      return left(Failure('Failed to arrive at pickup', '400'));
    }
  }

  @override
  Future<Either<Failure, Ride>> completeRide(String rideId) async {
    try {
      final res =
          await apiClient.post('/ride/complete-ride', body: {'rideId': rideId});
      final ride = toRide(RideDto.fromJson(res));
      debugPrint('Completed ride: $ride');
      return right(ride);
    } catch (e) {
      debugPrint('Failed to complete ride: ${e.toString()}');
      return left(Failure('Failed to complete ride', '400'));
    }
  }

  @override
  Stream<Ride> rideRequests$() => _reqCtrl.stream;
  @override
  Stream<RideStatusUpdate> statusUpdates$() => _statusCtrl.stream;

  @override
  void attachStreams() {
    detachStreams(); // idempotent

    _hReq = (dynamic raw) {
      try {
        final dto = RideDto.fromJson(Map<String, dynamic>.from(raw));
        _reqCtrl.add(toRide(dto));
      } catch (_) {
        debugPrint('attachStreams: ride:request: error: $_');
      }
    };
    _hStatus = (dynamic raw) {
      try {
        final dto = RideStatusDto.fromJson(Map<String, dynamic>.from(raw));
        _statusCtrl.add(toStatus(dto));
      } catch (_) {}
    };
    // listner attached
    debugPrint('attachStreams: _hReq: $_hReq');
    debugPrint('attachStreams: _hStatus: $_hStatus');
    socket.on('ride:request', (data) {
      debugPrint('attachStreams: ride:request: $data');
      _hReq!(data);
    });
    socket.on('ride:status-update', (data) {
      debugPrint('attachStreams: ride:status-update: $data');
      _hStatus!(data);
    });
  }

  @override
  void detachStreams() {
    if (_hReq != null) socket.off('ride:request', _hReq);
    if (_hStatus != null) socket.off('ride:status-update', _hStatus);
    _hReq = null;
    _hStatus = null;
  }
}
