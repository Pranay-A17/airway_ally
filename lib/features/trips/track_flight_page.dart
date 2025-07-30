import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../services/flight_api_service.dart';

class TrackFlightPage extends ConsumerStatefulWidget {
  final String flightNumber;
  final String from;
  final String to;
  final String date;
  
  const TrackFlightPage({
    super.key,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  ConsumerState<TrackFlightPage> createState() => _TrackFlightPageState();
}

class _TrackFlightPageState extends ConsumerState<TrackFlightPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _flightData;
  String? _error;
  Timer? _updateTimer;
  final FlightApiService _flightApiService = FlightApiService();

  @override
  void initState() {
    super.initState();
    _fetchFlightData();
    // Update every 30 seconds
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _fetchFlightData();
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchFlightData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get real-time flight data from API
      final flightData = await _flightApiService.getFlightData(widget.flightNumber);
      
      setState(() {
        _flightData = flightData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch flight data: $e';
        _isLoading = false;
      });
    }
  }

  // Removed _generateFlightData and _getAirline methods as they're now in FlightApiService

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Track Flight ${widget.flightNumber}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Track Flight ${widget.flightNumber}')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchFlightData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_flightData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Track Flight ${widget.flightNumber}')),
        body: const Center(child: Text('No flight data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flight ${widget.flightNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchFlightData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightHeader(),
            const SizedBox(height: 24),
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildFlightDetails(),
            const SizedBox(height: 24),
            _buildProgressSection(),
            const SizedBox(height: 24),
            _buildWeatherSection(),
            const SizedBox(height: 24),
            _buildBaggageSection(),
            const SizedBox(height: 24),
            _buildMapSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.from,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Departure',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.flight, size: 32, color: Colors.blue),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.to,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        'Arrival',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _flightData!['airline'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Aircraft: ${_flightData!['aircraft']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _flightData!['status'] as String;
    final statusColor = _flightData!['statusColor'] as String;
    
    Color color;
    switch (statusColor) {
      case 'green':
        color = Colors.green;
        break;
      case 'orange':
        color = Colors.orange;
        break;
      case 'red':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(status),
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Last updated: ${_formatTime(_flightData!['lastUpdate'] as DateTime)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      if (_flightData!['isRealData'] == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'on time':
        return Icons.check_circle;
      case 'delayed':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel;
      case 'boarding':
        return Icons.airplanemode_active;
      default:
        return Icons.info;
    }
  }

  Widget _buildFlightDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Scheduled Departure', _flightData!['scheduledDeparture']),
            _buildDetailRow('Actual Departure', _flightData!['actualDeparture']),
            _buildDetailRow('Scheduled Arrival', _flightData!['scheduledArrival']),
            _buildDetailRow('Actual Arrival', _flightData!['actualArrival']),
            _buildDetailRow('Gate', _flightData!['gate']),
            _buildDetailRow('Terminal', _flightData!['terminal']),
            _buildDetailRow('Runway', _flightData!['runway']),
            _buildDetailRow('Altitude', _flightData!['altitude']),
            _buildDetailRow('Speed', _flightData!['speed']),
            _buildDetailRow('Distance', _flightData!['distance']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = _flightData!['progress'] as int;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _flightData!['status'] == 'Cancelled' ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$progress% Complete',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressStep('Departure', progress > 0),
                _buildProgressStep('In Flight', progress > 25),
                _buildProgressStep('Approach', progress > 50),
                _buildProgressStep('Arrival', progress > 75),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isCompleted) {
    return Column(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSection() {
    final weather = _flightData!['weather'] as Map<String, dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Departure', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(weather['departure'] as String),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Arrival', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(weather['arrival'] as String),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaggageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Baggage Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.work, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'Claim: ${_flightData!['baggage']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Path',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Interactive map coming soon!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
} 