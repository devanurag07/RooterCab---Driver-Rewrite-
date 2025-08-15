// domain/ride/entities/ride.dart
class Ride {
  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  final String status;

  // Optional enriched fields
  final String? customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  final String? driverId;
  final String? driverName;
  final String? driverEmail;
  final String? driverPhone;

  final double? price;
  final String? otp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? dropLatitude;
  final double? dropLongitude;

  const Ride({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.status,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.driverId,
    this.driverName,
    this.driverEmail,
    this.driverPhone,
    this.price,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropLatitude,
    this.dropLongitude,
  });
}
