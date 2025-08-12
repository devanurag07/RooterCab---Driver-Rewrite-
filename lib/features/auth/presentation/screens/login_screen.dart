import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_events.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_state.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/check_driver_profile.dart';
import 'package:uber_clone_x/injection_container.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/verification_screen.dart';
import "package:url_launcher/url_launcher.dart";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: BlocProvider(
              create: (context) => sl.get<AuthBloc>(),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is OtpSentSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VerificationScreen(
                              phoneNumber: _phoneNumberController.text)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(' ${context.read<AuthBloc>().state}'),
                      ),
                    );
                  }

                  if (state is OtpVerificationSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CheckDriverProfileScreen()),
                    );
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred. Please try again.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        // Logo or Image

                        // Welcome Text
                        Text(
                          "Welcome Driver!",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Sign in to continue your journey",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Phone Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: Text(
                                  "+91",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter phone number",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    } else if (value.length < 10) {
                                      return 'Enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Terms Text
                        RichText(
                          text: TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'https://www.rootercab.com/privacy';
                                    final Uri uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'https://www.rootercab.com/cancellation';
                                    final Uri uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                    SignInWithOtpRequested(
                                        _phoneNumberController.text));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
