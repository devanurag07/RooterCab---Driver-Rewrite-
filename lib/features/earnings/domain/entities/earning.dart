/// Simple earnings models matching the backend API response

/// Main driver earnings response from API
class DriverEarnings {
  final EarningsPeriod daily;
  final EarningsPeriod weekly;
  final EarningsPeriod monthly;
  final DateRanges dateRanges;
  final int totalRides;

  const DriverEarnings({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.dateRanges,
    required this.totalRides,
  });

  factory DriverEarnings.fromJson(Map<String, dynamic> json) {
    return DriverEarnings(
      daily: EarningsPeriod.fromJson(json['daily'] ?? {}),
      weekly: EarningsPeriod.fromJson(json['weekly'] ?? {}),
      monthly: EarningsPeriod.fromJson(json['monthly'] ?? {}),
      dateRanges: DateRanges.fromJson(json['dateRanges'] ?? {}),
      totalRides: json['totalRides'] ?? 0,
    );
  }
}

/// Earnings for a specific period (daily/weekly/monthly)
class EarningsPeriod {
  final double earnings;
  final List<RideEarning> rides;
  final int count;

  const EarningsPeriod({
    required this.earnings,
    required this.rides,
    required this.count,
  });

  factory EarningsPeriod.fromJson(Map<String, dynamic> json) {
    return EarningsPeriod(
      earnings: (json['earnings'] ?? 0).toDouble(),
      rides: (json['rides'] as List? ?? [])
          .map((ride) => RideEarning.fromJson(ride))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

/// Individual ride earning - matches backend formatRide function
class RideEarning {
  final String id;
  final String createdAt;
  final double price;
  final String pickupLocation;
  final String dropLocation;
  final String status;

  const RideEarning({
    required this.id,
    required this.createdAt,
    required this.price,
    required this.pickupLocation,
    required this.dropLocation,
    required this.status,
  });

  factory RideEarning.fromJson(Map<String, dynamic> json) {
    return RideEarning(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      pickupLocation: json['pickupLocation'] ?? '',
      dropLocation: json['dropLocation'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Getter aliases for backward compatibility with existing screen
  double get fare => price;
  String get pickupAddress => pickupLocation;
  String get dropoffAddress => dropLocation;
}

/// Date ranges from backend
class DateRanges {
  final String startOfDay;
  final String endOfDay;
  final String startOfWeek;
  final String startOfMonth;

  const DateRanges({
    required this.startOfDay,
    required this.endOfDay,
    required this.startOfWeek,
    required this.startOfMonth,
  });

  factory DateRanges.fromJson(Map<String, dynamic> json) {
    return DateRanges(
      startOfDay: json['startOfDay'] ?? '',
      endOfDay: json['endOfDay'] ?? '',
      startOfWeek: json['startOfWeek'] ?? '',
      startOfMonth: json['startOfMonth'] ?? '',
    );
  }
}
