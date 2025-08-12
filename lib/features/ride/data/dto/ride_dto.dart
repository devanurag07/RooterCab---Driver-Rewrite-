// data/ride/dto/ride_dto.dart
class RideDto {
  final String id;
  final String pickup;
  final String dropoff;
  RideDto({required this.id, required this.pickup, required this.dropoff});
  factory RideDto.fromJson(Map<String, dynamic> j) =>
      RideDto(id: j['id'], pickup: j['pickup'], dropoff: j['dropoff']);
}
