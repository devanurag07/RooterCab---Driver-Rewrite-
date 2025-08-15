import 'package:uber_clone_x/features/trip/domain/entities/trip.dart';

class TripModel {
  final String status;
  final String id;
  final RideDetailsModel rideId;
  final String customerId;
  final bool tripCompleted;
  final String driverId;
  final String startTime;
  final String endTime;
  final String distance;
  final String duration;

  TripModel({
    required this.status,
    required this.id,
    required this.rideId,
    required this.customerId,
    required this.tripCompleted,
    required this.driverId,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.duration,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      status: json['status'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      distance: json['distance'] ?? '',
      duration: json['duration'] ?? '',
      id: json['_id'] ?? '',
      rideId: RideDetailsModel.fromJson(json['rideId'] ?? {}),
      customerId: json['customerId'] ?? '',
      tripCompleted: json['tripCompleted'] ?? false,
      driverId: json['driverId'] ?? '',
    );
  }

  Trip toEntity() {
    return Trip(
      id: id,
      status: status,
      customerId: customerId,
      driverId: driverId,
      tripCompleted: tripCompleted,
      startTime: startTime,
      endTime: endTime,
      distance: distance,
      duration: duration,
      rideDetails: rideId.toEntity(),
    );
  }
}

class RideDetailsModel {
  final LocationModel pickupLocation;
  final LocationModel dropLocation;
  final CustomerInfoModel customerInfo;
  final DriverInfoModel driverInfo;
  final String id;
  final String customerId;
  final double price;
  final String status;
  final String? otp;
  final DateTime createdAt;
  final DateTime updatedAt;

  RideDetailsModel({
    required this.pickupLocation,
    required this.dropLocation,
    required this.customerInfo,
    required this.driverInfo,
    required this.id,
    required this.customerId,
    required this.price,
    required this.status,
    this.otp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideDetailsModel.fromJson(Map<String, dynamic> json) {
    return RideDetailsModel(
      pickupLocation: LocationModel.fromJson(json['pickupLocation'] ?? {}),
      dropLocation: LocationModel.fromJson(json['dropLocation'] ?? {}),
      customerInfo: CustomerInfoModel.fromJson(json['customerInfo'] ?? {}),
      driverInfo: DriverInfoModel.fromJson(json['driverInfo'] ?? {}),
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      otp: json['otp'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  RideDetails toEntity() {
    return RideDetails(
      id: id,
      customerId: customerId,
      price: price,
      status: status,
      otp: otp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pickupLocation: pickupLocation.toEntity(),
      dropLocation: dropLocation.toEntity(),
      customerInfo: customerInfo.toEntity(),
      driverInfo: driverInfo.toEntity(),
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Location toEntity() {
    return Location(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }
}

class CustomerInfoModel {
  final String fullName;
  final String email;
  final String phone;

  CustomerInfoModel({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  CustomerInfo toEntity() {
    return CustomerInfo(
      fullName: fullName,
      email: email,
      phone: phone,
    );
  }
}

class DriverInfoModel {
  final String fullName;
  final String email;
  final String phone;
  final String vehicleName;
  final String vehicleNumber;
  final String driverId;

  DriverInfoModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.driverId,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      driverId: json['driverId'] ?? '',
    );
  }

  DriverInfo toEntity() {
    return DriverInfo(
      fullName: fullName,
      email: email,
      phone: phone,
      vehicleName: vehicleName,
      vehicleNumber: vehicleNumber,
      driverId: driverId,
    );
  }
}
