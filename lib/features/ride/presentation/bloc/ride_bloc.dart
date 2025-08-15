// presentation/ride/bloc/ride_bloc.dart
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request_update.dart';
import 'package:uber_clone_x/features/ride/domain/usecases/accept_ride.dart';
import 'package:uber_clone_x/features/ride/domain/usecases/decline_ride.dart';
import 'package:uber_clone_x/features/ride/domain/usecases/get_active_ride.dart';
import 'package:uber_clone_x/features/ride/domain/usecases/attach_ride_streams.dart';
import 'package:uber_clone_x/features/ride/domain/usecases/detach_ride_streams.dart';
import 'package:uber_clone_x/features/ride/domain/repository/ride_repository.dart';
import 'package:uber_clone_x/features/ride/domain/entities/ride_request.dart';

part 'ride_events.dart';
part 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final GetActiveRide _getActiveRide;
  final AcceptRide _accept;
  final DeclineRide _decline;
  final AttachRideStreams _attach;
  final DetachRideStreams _detach;
  final RideRepository _repo;

  StreamSubscription? _subReq;
  StreamSubscription? _subStatus;

  RideBloc({
    required GetActiveRide getActiveRide,
    required AcceptRide accept,
    required DeclineRide decline,
    required AttachRideStreams attach,
    required DetachRideStreams detach,
    required RideRepository repo,
  })  : _getActiveRide = getActiveRide,
        _accept = accept,
        _decline = decline,
        _attach = attach,
        _detach = detach,
        _repo = repo,
        super(const RideIdle()) {
    on<RideInit>(_onInit);
    on<RideDestroy>(_onDestroy);
    on<RideCmdArrive>(_onArrive);
    on<RideCmdStart>(_onStart);
    on<RideCmdCancel>(_onCancel);
    on<RideCmdComplete>(_onComplete);
    on<RideAcceptPressed>(_onAccept);
    on<RideDeclinePressed>(_onDecline);
    on<_IncomingRequest>(_onIncomingRequest);
    on<_IncomingStatus>(_onIncomingStatus);
  }

  Future<void> _onInit(RideInit e, Emitter<RideState> emit) async {
    emit(const RideLoading());
    // 1) attach socket streams (feature-scoped)
    _attach();
    // 2) subscribe to streams → convert to Bloc events
    await _subReq?.cancel();
    await _subStatus?.cancel();
    _subReq = _repo.rideRequests$().listen((r) {
      debugPrint('onIncomingRequest: $r');
      add(_IncomingRequest(r));
    });
    _subStatus = _repo.statusUpdates$().listen((s) {
      debugPrint('onIncomingStatus: $s');
      add(_IncomingStatus(s));
    });
    debugPrint('subReq: $_subReq');
    debugPrint('subStatus: $_subStatus');

    // 3) initial sync (server truth)
    try {
      final active = await _getActiveRide(null);
      emit(active.fold((failure) => const RideError('Sync failed'),
          (ride) => ride != null ? RideActive(ride) : const RideIdle()));
    } catch (err) {
      debugPrint('Sync failed: $err');
      emit(RideError('Sync failed: $err'));
    }
  }

  Future<void> _onDestroy(RideDestroy e, Emitter<RideState> emit) async {
    await _subReq?.cancel();
    await _subStatus?.cancel();
    _subReq = null;
    _subStatus = null;
    _detach();
    emit(const RideIdle());
  }

  Future<void> _onAccept(RideAcceptPressed e, Emitter<RideState> emit) async {
    final prev = state;
    emit(RideActionInFlight(prev));
    try {
      final result =
          await _accept(e.rideId); // wait for server push to change state
      result.fold((failure) {
        emit(RideError('Accept failed: ${failure.message}'));
      }, (ride) => emit(RideActive(ride)));
    } catch (err) {
      emit(RideError('Accept failed: $err'));
      emit(prev);
    }
  }

  Future<void> _onDecline(RideDeclinePressed e, Emitter<RideState> emit) async {
    final prev = state;
    emit(RideActionInFlight(prev));
    try {
      final result = await _decline(e.rideId);
      result.fold((failure) {
        emit(RideError('Decline failed: ${failure.message}'));
      }, (success) => emit(const RideIdle()));
    } catch (err) {
      emit(RideError('Decline failed: $err'));
      emit(prev);
    }
  }

  // ride actions when ride active.
  Future<void> _onArrive(RideCmdArrive e, Emitter<RideState> emit) async {
    emit(RideActionInFlight(state));
    try {
      final result = await _repo.arrivedAtPickup(e.rideId);
      result.fold((failure) {
        emit(RideError('Arrive failed: ${failure.message}'));
      }, (ride) => emit(RideActive(ride)));
    } catch (err) {
      emit(RideError('Arrive failed: $err'));
      emit(RideActionInFlight(state));
    }
  }

  Future<void> _onStart(RideCmdStart e, Emitter<RideState> emit) async {
    emit(RideActionInFlight(state));
    try {
      final result = await _repo.startRide(e.rideId, e.otp);
      result.fold((failure) {
        emit(RideError('Start failed: ${failure.message}'));
      }, (ride) => emit(RideActive(ride)));
    } catch (err) {
      emit(RideError('Start failed: $err'));
      emit(RideActionInFlight(state));
    }
  }

  Future<void> _onCancel(RideCmdCancel e, Emitter<RideState> emit) async {
    emit(RideActionInFlight(state));
    try {
      final result = await _repo.cancelRide(e.rideId, e.reason);
      result.fold((failure) {
        emit(RideError('Cancel failed: ${failure.message}'));
      }, (success) => emit(const RideIdle()));
    } catch (err) {
      emit(RideError('Cancel failed: $err'));
      emit(RideActionInFlight(state));
    }
  }

  Future<void> _onComplete(RideCmdComplete e, Emitter<RideState> emit) async {
    emit(RideActionInFlight(state));
    try {
      final result = await _repo.completeRide(e.rideId);
      result.fold((failure) {
        emit(RideError('Complete failed: ${failure.message}'));
      }, (success) => emit(RideActive(success)));
    } catch (err) {
      emit(RideError('Complete failed: $err'));
      emit(RideActionInFlight(state));
    }
  }

  void _onIncomingRequest(_IncomingRequest e, Emitter<RideState> emit) {
    debugPrint('onIncomingRequest: ${e.req}');
    emit(RideRequested(e.req));
  }

  void _onIncomingStatus(_IncomingStatus e, Emitter<RideState> emit) {
    switch (e.upd.status) {
      case RideStatus.accepted:
        // emit(RideActive());
        break;
      case RideStatus.completed:
      case RideStatus.canceledByDriver:
      case RideStatus.canceledByRider:
        emit(const RideIdle());
        break;
      default:
        // keep current (or extend states if you want arrived/started UIs)
        break;
    }
  }

  @override
  Future<void> close() async {
    await _subReq?.cancel();
    await _subStatus?.cancel();
    _detach();
    return super.close();
  }
}
