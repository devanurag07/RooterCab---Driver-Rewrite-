class Trip {
  final String id;
  final String status;
  final String customerId;
  final String driverId;
  final bool tripCompleted;
  final String startTime;
  final String endTime;
  final String distance;
  final String duration;
  final RideDetails rideDetails;

  const Trip({
    required this.id,
    required this.status,
    required this.customerId,
    required this.driverId,
    required this.tripCompleted,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.duration,
    required this.rideDetails,
  });
}

class RideDetails {
  final String id;
  final String customerId;
  final double price;
  final String status;
  final String? otp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location pickupLocation;
  final Location dropLocation;
  final CustomerInfo customerInfo;
  final DriverInfo driverInfo;

  const RideDetails({
    required this.id,
    required this.customerId,
    required this.price,
    required this.status,
    this.otp,
    required this.createdAt,
    required this.updatedAt,
    required this.pickupLocation,
    required this.dropLocation,
    required this.customerInfo,
    required this.driverInfo,
  });
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class CustomerInfo {
  final String fullName;
  final String email;
  final String phone;

  const CustomerInfo({
    required this.fullName,
    required this.email,
    required this.phone,
  });
}

class DriverInfo {
  final String fullName;
  final String email;
  final String phone;
  final String vehicleName;
  final String vehicleNumber;
  final String driverId;

  const DriverInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.driverId,
  });
}
