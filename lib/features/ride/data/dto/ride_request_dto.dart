// data/ride/dto/ride_request_dto.dart
class RideRequestDto {
  final String rideId;
  final String expiresAt; // ISO
  RideRequestDto({required this.rideId, required this.expiresAt});
  factory RideRequestDto.fromJson(Map<String, dynamic> j) =>
      RideRequestDto(rideId: j['rideId'], expiresAt: j['expiresAt']);
}
