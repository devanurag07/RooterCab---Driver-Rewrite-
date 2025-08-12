import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  final Location _location = Location();

  static const CameraPosition _fallbackCameraPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // Fallback to New Delhi
    zoom: 12,
  );

  CameraPosition _currentCameraPosition = _fallbackCameraPosition;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initAndSetCameraToCurrentLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initAndSetCameraToCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
      }
      if (!serviceEnabled) return;

      final LocationData locationData = await _location.getLocation();
      final double? latitude = locationData.latitude;
      final double? longitude = locationData.longitude;
      if (latitude == null || longitude == null) return;

      final CameraPosition newCameraPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );

      if (!mounted) return;
      setState(() {
        _currentCameraPosition = newCameraPosition;
      });

      final GoogleMapController? mapController = _mapController;
      if (mapController != null) {
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(newCameraPosition),
        );
      }

      _locationSubscription?.cancel();
      _locationSubscription =
          _location.onLocationChanged.listen((LocationData data) {
        // Location stream established to keep my-location dot fresh.
        // Intentionally not forcing camera each update to let user interact with the map.
      });
    } catch (_) {
      // Keep fallback camera if any issue occurs.
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _currentCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          await _mapController?.moveCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition),
          );
        });
      },
    );
  }
}
