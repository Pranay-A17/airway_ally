import '../utils/logger.dart';

class SampleData {
  static final List<Map<String, dynamic>> _airports = [
    {
      'code': 'JFK',
      'name': 'John F. Kennedy International Airport',
      'location': 'New York, NY',
      'description': 'Major international airport serving New York City',
      'terminals': 6,
    },
    {
      'code': 'LAX',
      'name': 'Los Angeles International Airport',
      'location': 'Los Angeles, CA',
      'description': 'Major international airport serving Los Angeles',
      'terminals': 8,
    },
    {
      'code': 'SFO',
      'name': 'San Francisco International Airport',
      'location': 'San Francisco, CA',
      'description': 'Major international airport serving San Francisco',
      'terminals': 4,
    },
    {
      'code': 'ORD',
      'name': 'O\'Hare International Airport',
      'location': 'Chicago, IL',
      'description': 'Major international airport serving Chicago',
      'terminals': 4,
    },
    {
      'code': 'ATL',
      'name': 'Hartsfield-Jackson Atlanta International Airport',
      'location': 'Atlanta, GA',
      'description': 'World\'s busiest airport by passenger traffic',
      'terminals': 2,
    },
  ];

  static final List<Map<String, dynamic>> _trips = [
    {
      'id': '1',
      'title': 'Business Trip to New York',
      'destination': 'New York, NY',
      'departureDate': DateTime.now().add(const Duration(days: 5)),
      'returnDate': DateTime.now().add(const Duration(days: 8)),
      'flightNumber': 'AA123',
      'status': 'Confirmed',
      'type': 'Business',
    },
    {
      'id': '2',
      'title': 'Vacation to Los Angeles',
      'destination': 'Los Angeles, CA',
      'departureDate': DateTime.now().add(const Duration(days: 15)),
      'returnDate': DateTime.now().add(const Duration(days: 22)),
      'flightNumber': 'UA456',
      'status': 'Confirmed',
      'type': 'Leisure',
    },
    {
      'id': '3',
      'title': 'Weekend Trip to Chicago',
      'destination': 'Chicago, IL',
      'departureDate': DateTime.now().add(const Duration(days: 2)),
      'returnDate': DateTime.now().add(const Duration(days: 4)),
      'flightNumber': 'DL789',
      'status': 'Pending',
      'type': 'Leisure',
    },
  ];

  static final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'name': 'Passport',
      'type': 'pdf',
      'size': '2.5 MB',
      'category': 'Travel Documents',
      'uploadDate': DateTime.now().subtract(const Duration(days: 30)),
      'isImportant': true,
    },
    {
      'id': '2',
      'name': 'Flight Ticket - AA123',
      'type': 'pdf',
      'size': '1.2 MB',
      'category': 'Flight Documents',
      'uploadDate': DateTime.now().subtract(const Duration(days: 5)),
      'isImportant': true,
    },
    {
      'id': '3',
      'name': 'Hotel Reservation',
      'type': 'pdf',
      'size': '800 KB',
      'category': 'Accommodation',
      'uploadDate': DateTime.now().subtract(const Duration(days: 3)),
      'isImportant': false,
    },
    {
      'id': '4',
      'name': 'Travel Insurance',
      'type': 'pdf',
      'size': '3.1 MB',
      'category': 'Insurance',
      'uploadDate': DateTime.now().subtract(const Duration(days: 25)),
      'isImportant': true,
    },
    {
      'id': '5',
      'name': 'Visa Application',
      'type': 'docx',
      'size': '1.8 MB',
      'category': 'Travel Documents',
      'uploadDate': DateTime.now().subtract(const Duration(days: 45)),
      'isImportant': true,
    },
  ];

  static final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'Airport Support',
      'last': 'Your gate has been changed to A12',
      'time': '2 min ago',
      'unread': 1,
      'avatar': 'A',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Travel Assistant',
      'last': 'Your flight is on time',
      'time': '15 min ago',
      'unread': 0,
      'avatar': 'T',
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Customer Service',
      'last': 'We\'ve updated your booking',
      'time': '1 hour ago',
      'unread': 2,
      'avatar': 'C',
      'isOnline': true,
    },
  ];

  static final List<Map<String, dynamic>> _helpRequests = [
    {
      'id': '1',
      'seekerName': 'Sarah Johnson',
      'seekerId': 'user1',
      'flightNumber': 'AA123',
      'departureAirport': 'JFK',
      'arrivalAirport': 'LAX',
      'travelDate': DateTime.now().add(const Duration(days: 2)),
      'assistanceType': 'Immigration',
      'languages': ['English', 'Spanish'],
      'description': 'Need help with immigration forms and procedures',
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'seekerName': 'Michael Chen',
      'seekerId': 'user2',
      'flightNumber': 'UA456',
      'departureAirport': 'SFO',
      'arrivalAirport': 'ORD',
      'travelDate': DateTime.now().add(const Duration(days: 1)),
      'assistanceType': 'Airport Navigation',
      'languages': ['English', 'Chinese'],
      'description': 'First time traveling, need help finding gates and facilities',
      'status': 'accepted',
      'navigatorId': 'navigator1',
      'navigatorName': 'Emma Wilson',
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      'acceptedAt': DateTime.now().subtract(const Duration(hours: 4)),
    },
  ];

  static final List<Map<String, dynamic>> _badges = [
    {
      'id': '1',
      'name': 'First Flight',
      'description': 'Completed your first flight with Airway Ally',
      'icon': '✈️',
      'rarity': 'common',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'id': '2',
      'name': 'Helpful Navigator',
      'description': 'Helped 10 travelers successfully',
      'icon': '🤝',
      'rarity': 'rare',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      'id': '3',
      'name': 'World Traveler',
      'description': 'Visited 5 different countries',
      'icon': '🌍',
      'rarity': 'epic',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': '4',
      'name': 'Perfect Helper',
      'description': 'Maintained 5-star rating for 6 months',
      'icon': '⭐',
      'rarity': 'legendary',
      'unlockedAt': null,
    },
  ];

  static final List<Map<String, dynamic>> _stats = [
    {
      'label': 'Trips Completed',
      'value': '12',
      'icon': '✈️',
      'color': 'blue',
    },
    {
      'label': 'People Helped',
      'value': '8',
      'icon': '🤝',
      'color': 'green',
    },
    {
      'label': 'Countries Visited',
      'value': '6',
      'icon': '🌍',
      'color': 'purple',
    },
    {
      'label': 'Average Rating',
      'value': '4.8',
      'icon': '⭐',
      'color': 'orange',
    },
  ];

  // Getters
  static List<Map<String, dynamic>> get airports {
    Logger.debug('Getting sample airports data');
    return _airports;
  }

  static List<Map<String, dynamic>> get trips {
    Logger.debug('Getting sample trips data');
    return _trips;
  }

  static List<Map<String, dynamic>> get documents {
    Logger.debug('Getting sample documents data');
    return _documents;
  }

  static List<Map<String, dynamic>> get conversations {
    Logger.debug('Getting sample conversations data');
    return _conversations;
  }

  static List<Map<String, dynamic>> get helpRequests {
    Logger.debug('Getting sample help requests data');
    return _helpRequests;
  }

  static List<Map<String, dynamic>> get badges {
    Logger.debug('Getting sample badges data');
    return _badges;
  }

  static List<Map<String, dynamic>> get stats {
    Logger.debug('Getting sample stats data');
    return _stats;
  }

  // Helper methods
  static Map<String, dynamic>? getAirportByCode(String code) {
    try {
      Logger.debug('Getting airport by code: $code');
      return _airports.firstWhere((airport) => airport['code'] == code);
    } catch (e) {
      Logger.warning('Airport not found for code: $code');
      return null;
    }
  }

  static List<Map<String, dynamic>> getTripsByStatus(String status) {
    Logger.debug('Getting trips by status: $status');
    return _trips.where((trip) => trip['status'] == status).toList();
  }

  static List<Map<String, dynamic>> getDocumentsByCategory(String category) {
    Logger.debug('Getting documents by category: $category');
    return _documents.where((doc) => doc['category'] == category).toList();
  }

  static List<Map<String, dynamic>> getUnlockedBadges() {
    Logger.debug('Getting unlocked badges');
    return _badges.where((badge) => badge['unlockedAt'] != null).toList();
  }

  static List<Map<String, dynamic>> getLockedBadges() {
    Logger.debug('Getting locked badges');
    return _badges.where((badge) => badge['unlockedAt'] == null).toList();
  }
} 