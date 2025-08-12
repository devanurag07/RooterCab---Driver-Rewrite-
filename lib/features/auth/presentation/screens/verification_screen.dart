import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone_x/core/theme/app_colors.dart';
import 'package:uber_clone_x/features/auth/domain/usecases/verify_signin_otp.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_events.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_state.dart';
import 'package:uber_clone_x/features/auth/presentation/screens/check_driver_profile.dart';
import 'package:uber_clone_x/injection_container.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _otp = '';
  bool _canResendOtp = false;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timeLeft = 30;
      _canResendOtp = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleResendOtp() {
    if (_canResendOtp) {
      context.read<AuthBloc>().add(SignInWithOtpRequested(widget.phoneNumber));
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CheckDriverProfileScreen()),
            );
            // } else if (state == LoginStatus.otpVerifiedNewUser) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => DriverRegistrationPage(
            //         phone: widget.phoneNumber,
            //       ),
            //     ),
            //   );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred. Please try again.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, size: 20.w),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[50],
                          padding: EdgeInsets.all(12.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        "Verify Your Number",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "We've sent a verification code to",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: AppColors.primary,
                              size: 20.w,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "+91 ${widget.phoneNumber}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                  size: 16.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 56.h,
                          fieldWidth: 48.w,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.grey[50],
                          selectedFillColor:
                              AppColors.primary.withOpacity(0.08),
                          activeColor: AppColors.primary,
                          inactiveColor: Colors.grey[300],
                          selectedColor: AppColors.primary,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        cursorColor: AppColors.primary,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => _otp = value);
                        },
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: GestureDetector(
                          onTap: _canResendOtp ? _handleResendOtp : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: _canResendOtp
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _canResendOtp
                                      ? Icons.refresh_rounded
                                      : Icons.timer_outlined,
                                  size: 18.w,
                                  color: _canResendOtp
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  _canResendOtp
                                      ? "Resend Code"
                                      : "Resend in ${_timeLeft}s",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: _canResendOtp
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _otp.length == 6
                              ? () => context.read<AuthBloc>().add(
                                  VerifySignInOtpRequested(
                                      params: VerifySignInOtpParams(
                                          widget.phoneNumber, _otp)))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Verify & Proceed',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
