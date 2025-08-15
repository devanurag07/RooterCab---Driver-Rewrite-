// data/ride/dto/ride_dto.dart
class RideDto {
  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  final String status;

  // Optional metadata from backend payload
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

  // Optional coordinates
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? dropLatitude;
  final double? dropLongitude;

  RideDto({
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

  factory RideDto.fromJson(Map<String, dynamic> j) {
    final dynamic pickupLoc = j['pickupLocation'];
    final dynamic dropLoc = j['dropLocation'];
    final dynamic cust = j['customerInfo'];
    final dynamic drv = j['driverInfo'];

    String safeAddress(dynamic loc, String legacyKey) {
      if (loc is Map<String, dynamic>) {
        final addr = loc['address'];
        if (addr is String && addr.isNotEmpty) return addr;
      }
      final legacy = j[legacyKey];
      return legacy is String ? legacy : '';
    }

    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return RideDto(
      id: (j['id'] ?? j['_id']).toString(),
      pickupAddress: safeAddress(pickupLoc, 'pickup'),
      dropoffAddress: safeAddress(dropLoc, 'dropoff'),
      status: j['status']?.toString() ?? '',
      customerId: j['customerId']?.toString(),
      customerName:
          (cust is Map<String, dynamic>) ? cust['fullName']?.toString() : null,
      customerEmail:
          (cust is Map<String, dynamic>) ? cust['email']?.toString() : null,
      customerPhone:
          (cust is Map<String, dynamic>) ? cust['phone']?.toString() : null,
      driverId:
          (drv is Map<String, dynamic>) ? drv['driverId']?.toString() : null,
      driverName:
          (drv is Map<String, dynamic>) ? drv['fullName']?.toString() : null,
      driverEmail:
          (drv is Map<String, dynamic>) ? drv['email']?.toString() : null,
      driverPhone:
          (drv is Map<String, dynamic>) ? drv['phone']?.toString() : null,
      price: toDouble(j['price']),
      otp: j['otp']?.toString(),
      createdAt: j['createdAt'] != null
          ? DateTime.tryParse(j['createdAt'].toString())
          : null,
      updatedAt: j['updatedAt'] != null
          ? DateTime.tryParse(j['updatedAt'].toString())
          : null,
      pickupLatitude: toDouble(
          (pickupLoc is Map<String, dynamic>) ? pickupLoc['latitude'] : null),
      pickupLongitude: toDouble(
          (pickupLoc is Map<String, dynamic>) ? pickupLoc['longitude'] : null),
      dropLatitude: toDouble(
          (dropLoc is Map<String, dynamic>) ? dropLoc['latitude'] : null),
      dropLongitude: toDouble(
          (dropLoc is Map<String, dynamic>) ? dropLoc['longitude'] : null),
    );
  }
}
