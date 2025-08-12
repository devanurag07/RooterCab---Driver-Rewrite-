// Middleware screen to check if driver is verified or not
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/not_verified_screen.dart';
import 'package:uber_clone_x/features/home/presentation/home_screen.dart';
import 'package:uber_clone_x/injection_container.dart';
import 'package:uber_clone_x/features/auth/presentation/cubit/profile_verification_cubit.dart';

class CheckDriverProfileScreen extends StatefulWidget {
  const CheckDriverProfileScreen({super.key});

  @override
  State<CheckDriverProfileScreen> createState() =>
      _CheckDriverProfileScreenState();
}

class _CheckDriverProfileScreenState extends State<CheckDriverProfileScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    sl.get<ProfileVerificationCubit>().check();
  }

  void _navigateAfterBuild(Widget page) {
    if (_hasNavigated) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasNavigated) return;
      _hasNavigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<ProfileVerificationCubit>(),
      child: BlocConsumer<ProfileVerificationCubit, ProfileVerificationState>(
        listener: (context, state) {
          if (state is ProfileVerificationVerified) {
            _navigateAfterBuild(const HomeScreen());
          } else if (state is ProfileVerificationNotVerified) {
            _navigateAfterBuild(const NotVerifiedScreen());
          }
        },
        builder: (context, state) {
          if (state is ProfileVerificationLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ProfileVerificationError) {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }
        },
      ),
    );
  }
}
