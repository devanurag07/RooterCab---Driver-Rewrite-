import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:uber_clone_x/features/trip/presentation/bloc/trip_events.dart';
import 'package:uber_clone_x/features/trip/presentation/bloc/trip_state.dart';
import 'package:uber_clone_x/injection_container.dart';

/// Example showing how to use TripBloc similar to your original TripsCubit
class TripExampleUsage extends StatefulWidget {
  const TripExampleUsage({super.key});

  @override
  State<TripExampleUsage> createState() => _TripExampleUsageState();
}

class _TripExampleUsageState extends State<TripExampleUsage> {
  late TripBloc tripBloc;

  @override
  void initState() {
    super.initState();
    tripBloc = sl<TripBloc>();
    _fetchTrips();
  }

  @override
  void dispose() {
    tripBloc.close();
    super.dispose();
  }

  /// Equivalent to your original fetchTrips() method
  void _fetchTrips() {
    // Replace with actual driver ID from user preferences/auth
    const driverId = 'your_driver_id_here';
    tripBloc.add(GetDriverTripsRequested(driverId: driverId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Example Usage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTrips,
          ),
        ],
      ),
      body: BlocBuilder<TripBloc, TripState>(
        bloc: tripBloc,
        builder: (context, state) {
          // Similar to your original cubit states
          if (state is TripLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TripLoaded) {
            return ListView.builder(
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                return ListTile(
                  title: Text('Trip ${trip.id}'),
                  subtitle: Text(
                    'From: ${trip.rideDetails.pickupLocation.address}\n'
                    'To: ${trip.rideDetails.dropLocation.address}',
                  ),
                  trailing: Text('₹${trip.rideDetails.price}'),
                  isThreeLine: true,
                );
              },
            );
          } else if (state is TripFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.failure.message}'),
                  ElevatedButton(
                    onPressed: _fetchTrips,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Press refresh to load trips'),
          );
        },
      ),
    );
  }
}
