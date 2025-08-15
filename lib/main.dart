import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone_x/core/network/socket/i_socket_service.dart';
import 'package:uber_clone_x/core/theme/app_theme.dart';
import 'package:uber_clone_x/features/auth/presentation/cubit/profile_verification_cubit.dart';
import 'package:uber_clone_x/features/earnings/presentation/bloc/earnings_bloc.dart';
import 'package:uber_clone_x/features/home/presentation/home_screen.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_bloc.dart';
import 'package:uber_clone_x/features/ride/presentation/bloc/ride_bloc.dart';
import 'package:uber_clone_x/features/trip/trip.dart';
import 'package:uber_clone_x/injection_container.dart';
import 'package:uber_clone_x/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        BlocProvider(create: (context) => sl.get<EarningsBloc>()),
        BlocProvider(create: (context) => sl.get<ProfileBloc>()),
        BlocProvider(create: (context) => sl.get<VehicleBloc>()),
        BlocProvider(create: (context) => sl.get<TripBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //  global socket connection
    final socketService = sl.get<ISocketService>();
    socketService.onConnect(() => socketService.emit("register", {}));
    socketService.connect();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: "Uber Clone X",
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const HomeScreen(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
