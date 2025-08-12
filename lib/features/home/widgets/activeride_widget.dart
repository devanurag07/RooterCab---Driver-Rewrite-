import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveRideWidget extends StatefulWidget {
  const ActiveRideWidget({super.key});

  @override
  State<ActiveRideWidget> createState() => _ActiveRideWidgetState();
}

class _ActiveRideWidgetState extends State<ActiveRideWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 30.h,
      width: 300.h,
      child: Center(child: Text("Active Ride")),
    );
  }
}
