// here user is used common as driver user.
class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? vehicleType;
  final String? vehicleNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.vehicleType,
    this.vehicleNumber,
  });
}
