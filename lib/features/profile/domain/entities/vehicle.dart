class Vehicle {
  final String id;
  final String name;
  final Make make;
  final String image;

  final Category? category;

  Vehicle({
    required this.id,
    required this.name,
    required this.make,
    required this.image,
    this.category,
  });
}

class Make {
  final String id;
  final String logo;
  final String name;
  final String vehicleType;

  Make({
    required this.id,
    required this.logo,
    required this.name,
    required this.vehicleType,
  });
}

class Category {
  final String id;
  final String name;
  final String capacity;
  final String price;

  Category(
      {required this.id,
      required this.name,
      required this.capacity,
      required this.price});
}
