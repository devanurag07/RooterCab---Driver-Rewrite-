// data/ride/dto/ride_status_dto.dart
class RideStatusDto {
  final String rideId;
  final String status; // "accepted" | "arrived" | ...
  RideStatusDto({required this.rideId, required this.status});
  factory RideStatusDto.fromJson(Map<String, dynamic> j) =>
      RideStatusDto(rideId: j['rideId'], status: j['status']);
}
