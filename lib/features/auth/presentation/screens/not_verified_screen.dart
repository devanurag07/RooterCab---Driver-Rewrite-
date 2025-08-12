import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/login_screen.dart';

class NotVerifiedScreen extends StatelessWidget {
  const NotVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Icon(
            HugeIcons.strokeRoundedIdNotVerified,
            size: 100.sp,
            color: Colors.yellow,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'Your account is not verified',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Rooter Cab is not verified yet. Please wait for verification.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10.h,
          ),
          Spacer(),
          Text(
            "Please contact support if you have any questions.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Container(
                            color: Colors.red,
                            child: Text("Contact Support"),
                          )));
            },
            child: Text(
              "Contact Support",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              // logout
              // FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    )));
  }
}
