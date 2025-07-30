import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_providers.dart';
import '../../providers/auth_provider.dart';
import '../../models/trip_model.dart';
import 'track_flight_page.dart';

class MyTripsPage extends ConsumerWidget {
  const MyTripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Please log in to view your trips'),
            );
          }
          
          final tripsAsync = ref.watch(userTripsProvider(user.id));
          
          return tripsAsync.when(
            data: (trips) {
              final upcomingTrips = trips.where((trip) => 
                trip.status == 'upcoming' || trip.status == 'in_progress'
              ).toList();
              final pastTrips = trips.where((trip) => 
                trip.status == 'completed' || trip.status == 'cancelled'
              ).toList();
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const Text('Upcoming Trips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    if (upcomingTrips.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No upcoming trips'),
                        ),
                      )
                    else
                      ...upcomingTrips.map((trip) => _buildTripCard(context, trip, true)),
                    const SizedBox(height: 24),
                    const Text('Past Trips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    if (pastTrips.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No past trips'),
                        ),
                      )
                    else
                      ...pastTrips.map((trip) => _buildTripCard(context, trip, false)),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading trips',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading user data',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, TripModel trip, bool isUpcoming) {
    final statusColor = _getStatusColor(trip.status);
    final statusText = _getStatusText(trip.status);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          isUpcoming ? Icons.flight_takeoff : Icons.flight_land,
          color: statusColor,
        ),
        title: Text('${trip.fromAirport} → ${trip.toAirport}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight: ${trip.flightNumber}'),
            Text('Date: ${_formatDate(trip.departureDate)}'),
            if (trip.gate != null) Text('Gate: ${trip.gate}'),
            if (trip.terminal != null) Text('Terminal: ${trip.terminal}'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: isUpcoming
            ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrackFlightPage(
                        flightNumber: trip.flightNumber,
                        from: trip.fromAirport,
                        to: trip.toAirport,
                        date: _formatDate(trip.departureDate),
                      ),
                    ),
                  );
                },
                child: const Text('Track'),
              )
            : null,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'upcoming':
        return 'Upcoming';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 