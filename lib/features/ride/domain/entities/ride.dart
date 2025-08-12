// domain/ride/entities/ride.dart
class Ride {
  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  const Ride({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
  });
}
