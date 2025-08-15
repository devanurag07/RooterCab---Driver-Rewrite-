import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_bloc.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_events.dart';
import 'package:uber_clone_x/features/profile/presentation/bloc/vehicle_state.dart';
import 'package:uber_clone_x/features/profile/presentation/widgets/vehicle_widget.dart';

/// Vehicle screen using BLoC pattern for state management
class VehicleScreenWithBloc extends StatefulWidget {
  const VehicleScreenWithBloc({
    super.key,
  });

  @override
  State<VehicleScreenWithBloc> createState() => _VehicleScreenWithBlocState();
}

class _VehicleScreenWithBlocState extends State<VehicleScreenWithBloc> {
  @override
  void initState() {
    super.initState();
    // Fetch vehicles when screen initializes
    context.read<VehicleBloc>().add(FetchDriverVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VehicleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading vehicles',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VehicleBloc>().add(FetchDriverVehicles());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is VehicleLoaded) {
            if (state.vehicles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Vehicles Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You haven\'t added any vehicles yet.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                return VehicleDetailCard(context, state.vehicles[1]);
              },
            );
          }

          // Initial state
          return const Center(
            child: Text('Initializing...'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh vehicles
          context.read<VehicleBloc>().add(FetchDriverVehicles());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
