import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone_x/core/theme/app_theme.dart';
import 'package:uber_clone_x/features/auth/presentation/cubit/profile_verification_cubit.dart';
import 'package:uber_clone_x/features/ride/presentation/bloc/ride_bloc.dart';
import 'package:uber_clone_x/features/splash/presentation/splash_screen.dart';
import 'package:uber_clone_x/injection_container.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // request notification permission

  final fln = FlutterLocalNotificationsPlugin();
  await fln.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  ));

  final ios = fln.resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>();
  await ios?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
  // initialize dependencies
  await initDependencies();
  await sl.allReady();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl.get<AuthBloc>()),
        BlocProvider(create: (context) => sl.get<RideBloc>()),
        BlocProvider(create: (context) => sl.get<ProfileVerificationCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: "Uber Clone X",
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
