import "package:permission_handler/permission_handler.dart";

Future<bool> checkPermissions() async {
  bool locationPermission = await Permission.location.status.isGranted;
  bool backgroundLocationPermission =
      await Permission.locationAlways.status.isGranted;

  return locationPermission && backgroundLocationPermission;
}
