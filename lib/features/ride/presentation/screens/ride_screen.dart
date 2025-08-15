import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/ride/presentation/bloc/ride_bloc.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_arrived_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_completed_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_inprogress_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_request_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_accepted_widget.dart';
import 'package:uber_clone_x/features/ride/presentation/widgets/ride_cancelled_widget.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  @override
  void initState() {
    super.initState();
    // No need to call RideInit() here since HomeScreen already initialized the bloc
    // and we want to maintain the existing state when navigating to RideScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('Ride Screen'),
            Expanded(
              child: BlocConsumer<RideBloc, RideState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is RideRequested) {
                    // Placeholder Ride until full ride details are fetched.
                    return RideRequestWidget(ride: state.req);
                  } else if (state is RideActive) {
                    switch (state.ride.status) {
                      case 'accepted':
                        return RideAcceptedWidget(ride: state.ride);
                      case 'arrived':
                        return RideArrivedWidget(ride: state.ride);
                      case 'ongoing':
                        return RideInProgressWidget(ride: state.ride);
                      case 'completed':
                        return RideCompletedWidget(ride: state.ride);
                      case 'canceled_by_driver':
                      case 'canceled_by_rider':
                        return RideCancelledWidget(ride: state.ride);
                      default:
                        debugPrint('Unknown ride status: ${state.ride.status}');
                        return const SizedBox.shrink();
                    }
                  } else if (state is RideError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is RideActionInFlight) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('No ride found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
