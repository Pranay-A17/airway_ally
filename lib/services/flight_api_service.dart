import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';

class FlightApiService {
  // Aviation Stack API (free tier)
  static const String _baseUrl = 'http://api.aviationstack.com/v1';
  static const String _apiKey = 'ce04d84a5463440fe816b2aefc342ec';

  /// Get real-time flight data
  Future<Map<String, dynamic>> getFlightData(String flightNumber) async {
    try {
      // Try Aviation Stack first (free tier)
      final data = await _getFromAviationStack(flightNumber);
      if (data != null) return data;
      
      // Fallback to simulated data if API fails
      return _generateSimulatedData(flightNumber);
    } catch (e) {
      Logger.error('Flight API error', e);
      // Return simulated data as fallback
      return _generateSimulatedData(flightNumber);
    }
  }

  /// Get flight data from Aviation Stack API
  Future<Map<String, dynamic>?> _getFromAviationStack(String flightNumber) async {
    try {
      Logger.info('Fetching flight data from Aviation Stack API for: $flightNumber');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/flights?access_key=$_apiKey&flight_iata=$flightNumber'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          Logger.success('Flight data retrieved successfully from Aviation Stack API');
          return _parseAviationStackData(data['data'][0]);
        }
      }
      
      Logger.warning('No flight data found in Aviation Stack API response');
      return null;
    } catch (e) {
      Logger.error('Aviation Stack API error', e);
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
      case 'in flight':
        return 'blue';
      default:
        return 'grey';
    }
  }

  /// Calculate flight progress
  double _calculateProgress(Map<String, dynamic> flight) {
    final departure = flight['departure'] ?? {};
    final arrival = flight['arrival'] ?? {};
    
    final departureTime = departure['actual'] ?? departure['scheduled'];
    final arrivalTime = arrival['actual'] ?? arrival['scheduled'];
    
    if (departureTime == null || arrivalTime == null) return 0.0;
    
    final departureDateTime = DateTime.parse(departureTime);
    final arrivalDateTime = DateTime.parse(arrivalTime);
    final now = DateTime.now();
    
    if (now.isBefore(departureDateTime)) return 0.0;
    if (now.isAfter(arrivalDateTime)) return 1.0;
    
    final totalDuration = arrivalDateTime.difference(departureDateTime).inMinutes;
    final elapsed = now.difference(departureDateTime).inMinutes;
    
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  /// Calculate distance between airports
  String _calculateDistance(Map<String, dynamic> departure, Map<String, dynamic> arrival) {
    // Simplified distance calculation
    return '1,200 km';
  }

  /// Generate simulated flight data
  Map<String, dynamic> _generateSimulatedData(String flightNumber) {
    Logger.info('Generating simulated flight data for: $flightNumber');
    
    final now = DateTime.now();
    final departureTime = now.subtract(const Duration(hours: 1));
    final arrivalTime = now.add(const Duration(hours: 2));
    
    return {
      'flightNumber': flightNumber,
      'airline': _getAirline(flightNumber),
      'aircraft': 'Boeing 737-800',
      'status': 'In Flight',
      'statusColor': 'blue',
      'scheduledDeparture': departureTime.toIso8601String(),
      'actualDeparture': departureTime.toIso8601String(),
      'scheduledArrival': arrivalTime.toIso8601String(),
      'actualArrival': null,
      'gate': 'A12',
      'terminal': '1',
      'runway': '09L',
      'altitude': '35,000 ft',
      'speed': '550 mph',
      'distance': '1,200 km',
      'progress': 0.6,
      'weather': {
        'departure': 'Clear, 72°F',
        'arrival': 'Partly Cloudy, 68°F',
      },
      'baggage': 'Carousel 3',
      'lastUpdate': now,
      'isRealData': false,
    };
  }

  /// Get airline name from flight number
  String _getAirline(String flightNumber) {
    if (flightNumber.startsWith('AA')) return 'American Airlines';
    if (flightNumber.startsWith('UA')) return 'United Airlines';
    if (flightNumber.startsWith('DL')) return 'Delta Air Lines';
    if (flightNumber.startsWith('BA')) return 'British Airways';
    if (flightNumber.startsWith('LH')) return 'Lufthansa';
    if (flightNumber.startsWith('AF')) return 'Air France';
    if (flightNumber.startsWith('EK')) return 'Emirates';
    if (flightNumber.startsWith('QR')) return 'Qatar Airways';
    return 'Unknown Airline';
  }

  /// Get flights for a specific route
  Future<List<Map<String, dynamic>>> getFlightsForRoute(String from, String to) async {
    try {
      Logger.info('Searching flights for route: $from to $to');
      
      // This would require a different API endpoint
      // For now, return simulated data
      return [
        _generateSimulatedData('AA123'),
        _generateSimulatedData('UA456'),
        _generateSimulatedData('DL789'),
      ];
    } catch (e) {
      Logger.error('Failed to get flights for route', e);
      return [];
    }
  }

  /// Search flights by number
  Future<List<Map<String, dynamic>>> searchFlights(String query) async {
    try {
      Logger.info('Searching flights with query: $query');
      
      // This would require a different API endpoint
      // For now, return simulated data
      return [
        _generateSimulatedData(query),
        _generateSimulatedData('${query}1'),
        _generateSimulatedData('${query}2'),
      ];
    } catch (e) {
      Logger.error('Failed to search flights', e);
      return [];
    }
  }
} 