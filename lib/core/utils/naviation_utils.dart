import 'package:flutter/material.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/login_screen.dart';
import 'package:uber_clone_x/main.dart';

void navigateToLogin() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      // Use pushAndRemoveUntil to clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false, // Remove all previous routes
      );
    }
  }
