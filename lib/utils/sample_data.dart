import 'package:cloud_firestore/cloud_firestore.dart';

class SampleData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> populateSampleData() async {
    try {
      // Create sample users
      await _createSampleUsers();
      
      // Create sample help requests
      await _createSampleHelpRequests();
      
      // Create sample trips
      await _createSampleTrips();
      
      print('Sample data populated successfully!');
    } catch (e) {
      print('Error populating sample data: $e');
    }
  }

  static Future<void> _createSampleUsers() async {
    final users = [
      {
        'id': 'seeker1',
        'email': 'sarah.johnson@example.com',
        'name': 'Sarah Johnson',
        'role': 'seeker',
        'rating': 4.8,
        'completedTrips': 3,
        'badges': ['First Time Traveler', 'International Explorer'],
        'createdAt': Timestamp.now(),
        'lastActive': Timestamp.now(),
      },
      {
        'id': 'seeker2',
        'email': 'mike.chen@example.com',
        'name': 'Mike Chen',
        'role': 'seeker',
        'rating': 4.5,
        'completedTrips': 1,
        'badges': ['Business Traveler'],
        'createdAt': Timestamp.now(),
        'lastActive': Timestamp.now(),
      },
      {
        'id': 'seeker3',
        'email': 'emma.davis@example.com',
        'name': 'Emma Davis',
        'role': 'seeker',
        'rating': 4.9,
        'completedTrips': 5,
        'badges': ['Family Traveler', 'Accessibility Advocate'],
        'createdAt': Timestamp.now(),
        'lastActive': Timestamp.now(),
      },
      {
        'id': 'navigator1',
        'email': 'john.smith@example.com',
        'name': 'John Smith',
        'role': 'navigator',
        'rating': 4.9,
        'completedTrips': 25,
        'badges': ['Expert Navigator', 'Airport Guru', 'Helpful Hero'],
        'createdAt': Timestamp.now(),
        'lastActive': Timestamp.now(),
      },
      {
        'id': 'navigator2',
        'email': 'maria.garcia@example.com',
        'name': 'Maria Garcia',
        'role': 'navigator',
        'rating': 4.7,
        'completedTrips': 18,
        'badges': ['Language Expert', 'Cultural Guide'],
        'createdAt': Timestamp.now(),
        'lastActive': Timestamp.now(),
      },
    ];

    for (final userData in users) {
      await _firestore.collection('users').doc(userData['id'] as String).set(userData);
    }
  }

  static Future<void> _createSampleHelpRequests() async {
    final helpRequests = [
      {
        'seekerId': 'seeker1',
        'seekerName': 'Sarah Johnson',
        'airport': 'JFK Airport',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
        'time': '14:30',
        'description': 'First time international traveler, need help with customs and finding my gate.',
        'status': 'pending',
        'seekerRating': 4.8,
        'createdAt': Timestamp.now(),
      },
      {
        'seekerId': 'seeker2',
        'seekerName': 'Mike Chen',
        'airport': 'LAX Airport',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
        'time': '09:15',
        'description': 'Need assistance with check-in and security procedures.',
        'status': 'pending',
        'seekerRating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'seekerId': 'seeker3',
        'seekerName': 'Emma Davis',
        'airport': 'ORD Airport',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
        'time': '16:45',
        'description': 'Traveling with elderly parent, need help with wheelchair assistance.',
        'status': 'pending',
        'seekerRating': 4.9,
        'createdAt': Timestamp.now(),
      },
      {
        'seekerId': 'seeker1',
        'seekerName': 'Sarah Johnson',
        'airport': 'SFO Airport',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 10))),
        'time': '11:20',
        'description': 'Need help with international flight connections.',
        'status': 'accepted',
        'navigatorId': 'navigator1',
        'navigatorName': 'John Smith',
        'seekerRating': 4.8,
        'createdAt': Timestamp.now(),
        'acceptedAt': Timestamp.now(),
      },
    ];

    for (final requestData in helpRequests) {
      await _firestore.collection('help_requests').add(requestData);
    }
  }

  static Future<void> _createSampleTrips() async {
    final trips = [
      {
        'userId': 'seeker1',
        'flightNumber': 'AA123',
        'fromAirport': 'JFK',
        'toAirport': 'LHR',
        'departureDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
        'departureTime': '14:30',
        'arrivalTime': '06:30',
        'status': 'upcoming',
        'gate': 'A12',
        'terminal': '8',
        'createdAt': Timestamp.now(),
      },
      {
        'userId': 'seeker2',
        'flightNumber': 'BA456',
        'fromAirport': 'LHR',
        'toAirport': 'CDG',
        'departureDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
        'departureTime': '09:15',
        'arrivalTime': '12:15',
        'status': 'upcoming',
        'gate': 'B8',
        'terminal': '5',
        'createdAt': Timestamp.now(),
      },
      {
        'userId': 'seeker3',
        'flightNumber': 'UA789',
        'fromAirport': 'SFO',
        'toAirport': 'NRT',
        'departureDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))),
        'departureTime': '10:45',
        'arrivalTime': '14:45',
        'status': 'completed',
        'gate': 'C15',
        'terminal': '3',
        'createdAt': Timestamp.now(),
        'completedAt': Timestamp.now(),
      },
      {
        'userId': 'navigator1',
        'flightNumber': 'DL321',
        'fromAirport': 'ATL',
        'toAirport': 'LAX',
        'departureDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 2))),
        'departureTime': '16:20',
        'arrivalTime': '18:45',
        'status': 'upcoming',
        'gate': 'D4',
        'terminal': '1',
        'createdAt': Timestamp.now(),
      },
    ];

    for (final tripData in trips) {
      await _firestore.collection('trips').add(tripData);
    }
  }

  static Future<void> clearSampleData() async {
    try {
      // Clear all collections
      await _clearCollection('users');
      await _clearCollection('help_requests');
      await _clearCollection('trips');
      
      print('Sample data cleared successfully!');
    } catch (e) {
      print('Error clearing sample data: $e');
    }
  }

  static Future<void> _clearCollection(String collectionName) async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    final batch = _firestore.batch();
    
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
} 