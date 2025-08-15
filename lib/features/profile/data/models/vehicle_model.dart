import 'package:uber_clone_x/features/profile/domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    required super.name,
    required super.make,
    required super.image,
    required super.category,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'],
      name: json['name'],
      make: MakeModel.fromJson(json['make']),
      image: json['image'],
      category: json.containsKey('category')
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }
}

class MakeModel extends Make {
  MakeModel({
    required super.id,
    required super.logo,
    required super.name,
    required super.vehicleType,
  });

  factory MakeModel.fromJson(Map<String, dynamic> json) {
    return MakeModel(
      id: json['_id'],
      logo: json['logo'],
      name: json['name'],
      vehicleType: json['vehicleType'],
    );
  }
}

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.capacity,
    required super.price,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      capacity: json['capacity'],
      price: json['price'],
    );
  }
}
