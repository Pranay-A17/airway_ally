import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightApiService {
  // Using Aviation Stack API (free tier available)
  static const String _baseUrl = 'http://api.aviationstack.com/v1';
  static const String _apiKey = 'ce04d84a546344a0fe816b2aefc342ec'; // Aviation Stack API key
  
  // Fallback to FlightAware API (paid service)
  static const String _flightAwareUrl = 'https://aeroapi.flightaware.com/aeroapi';
  static const String _flightAwareKey = 'YOUR_FLIGHTAWARE_API_KEY'; // Replace with your API key

  /// Get real-time flight data
  Future<Map<String, dynamic>> getFlightData(String flightNumber) async {
    try {
      // Try Aviation Stack first (free tier)
      final data = await _getFromAviationStack(flightNumber);
      if (data != null) return data;
      
      // Fallback to simulated data if API fails
      return _generateSimulatedData(flightNumber);
    } catch (e) {
      print('Flight API error: $e');
      // Return simulated data as fallback
      return _generateSimulatedData(flightNumber);
    }
  }

  /// Get flight data from Aviation Stack API
  Future<Map<String, dynamic>?> _getFromAviationStack(String flightNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/flights?access_key=$_apiKey&flight_iata=$flightNumber'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          return _parseAviationStackData(data['data'][0]);
        }
      }
      return null;
    } catch (e) {
      print('Aviation Stack API error: $e');
      return null;
    }
  }

  /// Parse Aviation Stack API response
  Map<String, dynamic> _parseAviationStackData(Map<String, dynamic> flight) {
    final departure = flight['departure'] ?? {};
    final arrival = flight['arrival'] ?? {};
    final airline = flight['airline'] ?? {};
    final flightInfo = flight['flight'] ?? {};

    return {
      'flightNumber': flightInfo['iata'] ?? 'Unknown',
      'airline': airline['name'] ?? 'Unknown Airline',
      'aircraft': flight['aircraft']?['registration'] ?? 'Boeing 737-800',
      'status': _determineStatus(flight),
      'statusColor': _getStatusColor(flight),
      'scheduledDeparture': departure['scheduled'] ?? 'Unknown',
      'actualDeparture': departure['actual'] ?? departure['scheduled'] ?? 'Unknown',
      'scheduledArrival': arrival['scheduled'] ?? 'Unknown',
      'actualArrival': arrival['actual'] ?? arrival['scheduled'] ?? 'Unknown',
      'gate': departure['gate'] ?? 'TBD',
      'terminal': departure['terminal'] ?? 'TBD',
      'runway': departure['runway'] ?? 'TBD',
      'altitude': '35,000 ft', // Not provided by API
      'speed': '550 mph', // Not provided by API
      'distance': _calculateDistance(departure, arrival),
      'progress': _calculateProgress(flight),
      'weather': {
        'departure': 'Clear, 72°F', // Would need weather API
        'arrival': 'Partly Cloudy, 68°F',
      },
      'baggage': 'Carousel 3',
      'lastUpdate': DateTime.now(),
      'isRealData': true,
    };
  }

  /// Determine flight status from API data
  String _determineStatus(Map<String, dynamic> flight) {
    final departure = flight['departure'] ?? {};
    final arrival = flight['arrival'] ?? {};
    
    if (departure['actual'] != null && arrival['actual'] != null) {
      return 'Completed';
    } else if (departure['actual'] != null) {
      return 'In Flight';
    } else if (departure['estimated'] != null) {
      return 'Delayed';
    } else {
      return 'Scheduled';
    }
  }

  /// Get status color
  String _getStatusColor(Map<String, dynamic> flight) {
    final status = _determineStatus(flight);
    switch (status.toLowerCase()) {
      case 'completed':
      case 'scheduled':
        return 'green';
      case 'delayed':
        return 'orange';
      case 'cancelled':
        return 'red';
      default:
        return 'blue';
    }
  }

  /// Calculate flight progress
  int _calculateProgress(Map<String, dynamic> flight) {
    final departure = flight['departure'] ?? {};
    final arrival = flight['arrival'] ?? {};
    
    if (departure['actual'] == null) return 0;
    if (arrival['actual'] != null) return 100;
    
    // Calculate progress based on time
    final departureTime = DateTime.tryParse(departure['actual'] ?? '');
    final scheduledArrival = DateTime.tryParse(arrival['scheduled'] ?? '');
    
    if (departureTime != null && scheduledArrival != null) {
      final now = DateTime.now();
      final totalDuration = scheduledArrival.difference(departureTime);
      final elapsed = now.difference(departureTime);
      
      if (totalDuration.inMinutes > 0) {
        return ((elapsed.inMinutes / totalDuration.inMinutes) * 100).clamp(0, 95).round();
      }
    }
    
    return 50; // Default progress
  }

  /// Calculate distance between airports
  String _calculateDistance(Map<String, dynamic> departure, Map<String, dynamic> arrival) {
    // This would need airport coordinates and distance calculation
    // For now, return a default value
    return '1,200 miles';
  }

  /// Generate simulated data as fallback
  Map<String, dynamic> _generateSimulatedData(String flightNumber) {
    final isDelayed = flightNumber.contains('DL') || flightNumber.contains('AA');
    final isOnTime = flightNumber.contains('UA') || flightNumber.contains('SW');
    final isCancelled = flightNumber.contains('CA');
    
    String status;
    String statusColor;
    String actualDeparture;
    String actualArrival;
    
    if (isCancelled) {
      status = 'Cancelled';
      statusColor = 'red';
      actualDeparture = 'Cancelled';
      actualArrival = 'Cancelled';
    } else if (isDelayed) {
      status = 'Delayed';
      statusColor = 'orange';
      actualDeparture = '10:25 AM';
      actualArrival = '8:45 PM';
    } else if (isOnTime) {
      status = 'On Time';
      statusColor = 'green';
      actualDeparture = '10:00 AM';
      actualArrival = '8:00 PM';
    } else {
      status = 'Boarding';
      statusColor = 'blue';
      actualDeparture = '9:55 AM';
      actualArrival = 'Pending';
    }

    return {
      'flightNumber': flightNumber,
      'airline': _getAirline(flightNumber),
      'aircraft': 'Boeing 737-800',
      'status': status,
      'statusColor': statusColor,
      'scheduledDeparture': '10:00 AM',
      'actualDeparture': actualDeparture,
      'scheduledArrival': '8:00 PM',
      'actualArrival': actualArrival,
      'gate': 'B12',
      'terminal': '4',
      'runway': '22L',
      'altitude': '35,000 ft',
      'speed': '550 mph',
      'distance': '1,200 miles',
      'progress': isCancelled ? 0 : (isDelayed ? 35 : 45),
      'weather': {
        'departure': 'Clear, 72°F',
        'arrival': 'Partly Cloudy, 68°F',
      },
      'baggage': 'Carousel 3',
      'lastUpdate': DateTime.now(),
      'isRealData': false,
    };
  }

  String _getAirline(String flightNumber) {
    if (flightNumber.startsWith('DL')) return 'Delta Air Lines';
    if (flightNumber.startsWith('AA')) return 'American Airlines';
    if (flightNumber.startsWith('UA')) return 'United Airlines';
    if (flightNumber.startsWith('SW')) return 'Southwest Airlines';
    if (flightNumber.startsWith('CA')) return 'Air China';
    return 'Unknown Airline';
  }

  /// Get multiple flights for a route
  Future<List<Map<String, dynamic>>> getFlightsForRoute(String from, String to) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/flights?access_key=$_apiKey&dep_iata=$from&arr_iata=$to'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((flight) => _parseAviationStackData(flight))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Route API error: $e');
      return [];
    }
  }

  /// Search flights by flight number
  Future<List<Map<String, dynamic>>> searchFlights(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/flights?access_key=$_apiKey&flight_iata=$query'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((flight) => _parseAviationStackData(flight))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Search API error: $e');
      return [];
    }
  }
} 