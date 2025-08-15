import 'dart:async';
// Import ui library
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:permission_handler/permission_handler.dart" as ph;
import 'package:uber_clone_x/core/network/socket/i_socket_service.dart';
import 'package:uber_clone_x/core/theme/app_colors.dart';
import 'package:uber_clone_x/core/utils/permission_utils.dart';
import 'package:uber_clone_x/features/home/widgets/activeride_widget.dart';
import 'package:uber_clone_x/features/home/widgets/app_drawer.dart';
import 'package:uber_clone_x/features/home/widgets/map_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/bloc/ride_bloc.dart';
import 'package:uber_clone_x/features/ride/presentation/screens/ride_screen.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_request_widget.dart';
import 'package:uber_clone_x/injection_container.dart';

class HomeScreen extends StatefulWidget with WidgetsBindingObserver {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Global app state
  bool isAppPaused = false;
  // main socket connection
  bool _isConnecting = false;
  bool _isOnline = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final socketService = sl.get<ISocketService>();
    socketService.onConnect(() {
      debugPrint("DEBUG : CONNECTED");
      socketService.emit("register", {});
    });
    socketService.connect();

    context.read<RideBloc>().add(const RideInit());
    // check permissions
    checkPermissions().then((value) {
      if (value) {
        // setState(() {
        //   _allPermissionsGranted = true;
        // });
      }
    });
    // Initialize after driverId is available to avoid race conditions
    Future(() async {
      // get earnings
      // context.read<EarningsCubit>().getEarnings();
      await _initializeApp();
    });
  }

  // listen to background service and update things.
  Future<void> updateOnlineStatus() async {
    // bool isConnected = await BackgroundSocketService.isSocketConnected();
    // print("DEBUG : ISCONNECTED ${isConnected}");
    // setState(() {
    //   if (_isOnline != isConnected) {
    //     _isOnline = isConnected;
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Initialization Permissions and Services
  Future<void> _initializeApp() async {
    // Check Permissions
    final locationStatus = await ph.Permission.locationWhenInUse.status;
    final backgroundLocationStatus = await ph.Permission.locationAlways.status;
    final batteryOptimizationStatus =
        await ph.Permission.ignoreBatteryOptimizations.status;
    if (locationStatus.isGranted &&
        backgroundLocationStatus.isGranted &&
        batteryOptimizationStatus.isGranted) {
      // Initialize App Services If All Permissions Are Granted
      // await _initializeAppServices();
    } else {
      // If Not All Permissions Are Granted, show permission handler via build()
    }
  }

  // Callback when all permissions are granted in permission handler

  //sets current location to given location and updates map
  // Toogling Online Status Driver
  void _toggleOnlineStatus(bool value) async {
    if (_isConnecting) return;
    setState(() {
      _isConnecting = true;
    });

    // final bool socketConnected =
    //     await BackgroundSocketService.isSocketConnected();
    // print(
    //     "DEBUG socket value ${value} socket.isConnected : ${socketConnected}");

    try {
      if (value) {
        // RideServices.startNativeLocationService();
        // await BackgroundSocketService.connectSocket();
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('driver_online', true);
        // await prefs.setString('connected_driver_id', driverId);
      } else {
        // await BackgroundSocketService.disconnectSocket();
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('driver_online', false);
        // await prefs.remove('connected_driver_id');
      }
      await updateOnlineStatus();
      setState(() {
        _isOnline = value;
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!_allPermissionsGranted) {
    //   return PermissionHandlerWidget(
    //     onAllPermissionsGranted: _onAllPermissionsGranted,
    //   );
    // }

    return Scaffold(
      drawer: AppDrawer(),
      body: BlocConsumer<RideBloc, RideState>(listener: (context, state) {
        debugPrint('DEBUG : STATE : $state');
        if (state is RideRequested) {
          showModalBottomSheet(
              context: context,
              builder: (context) => RideRequestWidget(ride: state.req));
        } else if (state is RideActive) {
          if (state.ride.status == 'accepted') {
            debugPrint('DEBUG : RideAccepted');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RideScreen()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RideScreen()));
          }
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: MapWidget(),
            ),

            Positioned(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          height: 50.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Icon(Icons.menu, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2) Top overlay (toggle), inside SafeArea
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Switch(
                    value: _isOnline,
                    onChanged: _isConnecting ? null : _toggleOnlineStatus,
                  ),
                ),
              ),
            ),

            // 3) Bottom overlay (active ride card)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ActiveRideWidget(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
