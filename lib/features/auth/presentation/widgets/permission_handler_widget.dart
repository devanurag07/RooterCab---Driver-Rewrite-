import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:uber_clone_x/core/theme/app_colors.dart';
// Do not navigate from this widget; use the provided callback

class PermissionHandlerWidget extends StatefulWidget {
  final VoidCallback onAllPermissionsGranted;

  const PermissionHandlerWidget({
    super.key,
    required this.onAllPermissionsGranted,
  });

  @override
  State<PermissionHandlerWidget> createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  bool locationPermissionGranted = false;
  bool backgroundLocationPermissionGranted = false;
  bool batteryOptimizationPermissionGranted = false;
  bool overlayPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    final locationStatus = await ph.Permission.locationWhenInUse.status;
    final backgroundLocationStatus = await ph.Permission.locationAlways.status;
    final batteryOptimizationStatus = Platform.isAndroid
        ? await ph.Permission.ignoreBatteryOptimizations.status
        : ph.PermissionStatus.granted;
    // Overlay permission (Android only)
    final overlayGranted = Platform.isAndroid
        ? await ph.Permission.systemAlertWindow.status
        : ph.PermissionStatus.granted;

    if (mounted) {
      setState(() {
        locationPermissionGranted = locationStatus.isGranted;
        backgroundLocationPermissionGranted =
            backgroundLocationStatus.isGranted;
        batteryOptimizationPermissionGranted =
            batteryOptimizationStatus.isGranted;
        overlayPermissionGranted = overlayGranted.isGranted;
      });
    }

    _checkAllPermissions();
  }

  void _checkAllPermissions() {
    final coreGrantediOS = locationPermissionGranted;
    final coreGrantedAndroid =
        locationPermissionGranted && backgroundLocationPermissionGranted;

    final canContinue = (Platform.isIOS && coreGrantediOS) ||
        (Platform.isAndroid && coreGrantedAndroid);

    if (canContinue) {
      widget.onAllPermissionsGranted();
    }
  }

  Future<void> _requestLocationPermission() async {
    print('requesting location permission');
    final status = await ph.Permission.locationWhenInUse.request();
    print("requesting location permission status: $status");

    if (status.isPermanentlyDenied) {
      // iOS: user must enable manually in Settings
      await ph.openAppSettings();
    } else {
      setState(() {
        locationPermissionGranted = status.isGranted;
      });
    }

    _checkAllPermissions();
  }

  Future<void> _requestBackgroundLocationPermission() async {
    // iOS requires When-In-Use BEFORE requesting Always
    if (!locationPermissionGranted) {
      final whenInUse = await ph.Permission.locationWhenInUse.request();
      if (!mounted) return;
      setState(() {
        locationPermissionGranted = whenInUse.isGranted;
      });
      if (!whenInUse.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Please allow Location While Using the app first.')),
        );
        return;
      }
    }

    final status = await ph.Permission.locationAlways.request();
    if (!mounted) return;
    setState(() {
      backgroundLocationPermissionGranted = status.isGranted;
    });
    if (!status.isGranted) {
      final open = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Background Location Required'),
              content: Text(
                  'Please allow Always/Background location in App Settings to receive ride requests in background.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Open Settings'),
                ),
              ],
            ),
          ) ??
          false;
      if (open) await ph.openAppSettings();
    }
    _checkAllPermissions();
  }

  Future<void> _requestBatteryOptimizationPermission() async {
    if (!Platform.isAndroid) {
      return;
    }
    final status = await ph.Permission.ignoreBatteryOptimizations.request();
    if (!mounted) return;
    setState(() {
      batteryOptimizationPermissionGranted = status.isGranted;
    });
    if (!status.isGranted && Platform.isAndroid) {
      final open = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Disable Battery Optimizations'),
              content: Text(
                  'Please disable battery optimizations for reliable background updates.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Open Settings'),
                ),
              ],
            ),
          ) ??
          false;
      if (open) await ph.openAppSettings();
    }
    _checkAllPermissions();
  }

  Widget _buildPermissionItem({
    required String title,
    required String description,
    required IconData icon,
    required bool isGranted,
    required VoidCallback onRequest,
    bool isNotification = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: isNotification
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isGranted
                  ? Colors.green.withValues(alpha: 0.1)
                  : isNotification
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: isGranted
                  ? Colors.green
                  : isNotification
                      ? AppColors.primary
                      : Colors.grey,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isGranted)
            TextButton(
              onPressed: onRequest,
              style: TextButton.styleFrom(
                backgroundColor: isNotification
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                isNotification ? 'Enable & Continue' : 'Enable',
                style: TextStyle(
                  color: isNotification ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Required Permissions',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please enable the following permissions to use the app',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildPermissionItem(
                  title: 'Location',
                  description:
                      'Required to show your current location on the map',
                  icon: Icons.location_on_outlined,
                  isGranted: locationPermissionGranted,
                  onRequest: _requestLocationPermission,
                ),
                _buildPermissionItem(
                  title: 'Background Location',
                  description:
                      'Required to receive ride requests when app is in background',
                  icon: Icons.location_searching_outlined,
                  isGranted: backgroundLocationPermissionGranted,
                  onRequest: _requestBackgroundLocationPermission,
                ),
                if (Platform.isAndroid)
                  _buildPermissionItem(
                    title: 'Battery Optimization',
                    description:
                        'Required to keep the app running in background',
                    icon: Icons.battery_charging_full_outlined,
                    isGranted: batteryOptimizationPermissionGranted,
                    onRequest: _requestBatteryOptimizationPermission,
                  ),
                ElevatedButton(
                  onPressed: () {
                    final coreGrantediOS = locationPermissionGranted;
                    final coreGrantedAndroid = locationPermissionGranted &&
                        backgroundLocationPermissionGranted;

                    if ((Platform.isIOS && coreGrantediOS) ||
                        (Platform.isAndroid && coreGrantedAndroid)) {
                      widget.onAllPermissionsGranted();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please enable location and background location to continue.'),
                        ),
                      );
                    }
                  },
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
